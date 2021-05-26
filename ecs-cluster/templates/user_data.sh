#!/bin/bash

# This script is applicable for Amazon Linux 2, equivalent to RHEL 7

set -x

### SETUP DOCKER MOUNTPOINT ###

# Format and Mount EBS volume /dev/xvdz to /var/lib/docker
mkfs -t xfs -n ftype=1 /dev/xvdz
mount /dev/xvdz /var/lib/docker
lsblk -f > /tmp/docker_volume_details

# Save to fstab
sleep 5
uuid=$(lsblk -no UUID /dev/xvdz)
echo "Docker volume UUID is: $uuid" >> /tmp/docker_volume_details
echo -e "UUID=$uuid \t /var/lib/docker \t xfs \t defaults,nofail \t 0 \t 2" >> /etc/fstab

### ECS CONFIG ###
#     ECS config should be initialized first
{
  echo ''
  echo "ECS_CLUSTER=${ cluster_name }"
  echo 'ECS_ENABLE_SPOT_INSTANCE_DRAINING=true'
  echo 'ECS_IMAGE_PULL_BEHAVIOR=once'
  echo 'ECS_ENGINE_AUTH_TYPE=dockercfg'
  echo 'ECS_ENGINE_AUTH_DATA={"https://index.docker.io/v1/":{"auth":"${ docker_auth_key }","email":"${ docker_auth_email }"}}'
  echo "ECS_INSTANCE_ATTRIBUTES=${ecs_instance_attributes}"
  echo 'ECS_NUM_IMAGES_DELETE_PER_CYCLE=30'
  echo 'ECS_IMAGE_CLEANUP_INTERVAL=10m'
} >> /etc/ecs/ecs.config

### SETUP DOCKER LOG ROTATION ###
cat <<EOF > /etc/docker/daemon.json
{
"log-driver": "json-file",
"log-opts": {
    "max-size": "10m",
    "max-file": "10"
    }
}
EOF

sudo systemctl restart docker

### TAG THE INSTANCE FOLLOW THE CODE ###

# Get instance meta data, will return az code, for example: ap-southeast-1a
az="us-east-1"

# Get region -> ap-southeast-1
region=$(echo $az | sed s'/.$//')

# Last element is the az code, for example: ap-southeast-1a -> 1a
az_code=$(echo $az | awk -F- '{ print $NF }')

# Get region code using first character of each word. For example: ap-southeast-1a -> as1
region_code=$(echo $az | awk -F- '{ print substr($1,0,1) substr($2,0,1) substr($3,0,1) }')

name=${env}-ec2-$region_code-$az_code-ecs-${cluster_name}

# Get instance_id
instance_id="i-08743e1b7e63a7744"

# Install awscli to run tag command
yum install -y awscli

# Tag the instance
aws ec2 create-tags --resource $instance_id --tags "Key=Name,Value=$name" --region=$region

### CONSUL SETUP ###
/opt/consul/bin/run-consul --client --cluster-tag-key consul-servers --cluster-tag-value consuls

### DEEP SECURITY SET BASE POLICY ###

# Wait for DeepSecurity registration completed before send heartbeat for policy id
sleep 10
/opt/ds_agent/dsa_control -m "policyid:1"

# [STG] [UAT] Flush local Consul agent state on ECS instance boot
env=${env}
if [ "$env" = "stg" ] || [ "$env" = "uat" ]; then
cat > /etc/systemd/system/consul-client-reset-state.service <<EOF
[Unit]
Description=ConsulClientResetState
After=network.target
Before=consul.service
[Service]
Type=oneshot
ExecStart=/bin/bash -c "rm -rf /opt/consul/data && mkdir -p /opt/consul/data && chown consul:consul /opt/consul/data;"
[Install]
WantedBy=multi-user.target
EOF

systemctl enable consul-client-reset-state.service
fi

echo "Done"
