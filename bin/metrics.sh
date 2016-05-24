#!/usr/bin/env bash

namespace="maxclem/ec2"
InstanceID=$(curl -s http://169.254.169.254/latest/meta-data/instance-id)
region=$(curl -s http://169.254.169.254/latest/meta-data/placement/availability-zone/ | sed 's/.$//') 
processors=$(grep -c processor /proc/cpuinfo)

aws cloudwatch put-metric-data --metric-name FreeDiskBytes --namespace $namespace --dimensions InstanceID=$InstanceID,Volume="/dev/xvda1" --timestamp $(date -u +"%Y-%m-%dT%H:%M:%SZ") --region $region --value $(df /dev/xvda1 --output=avail | awk 'NR==2 { bytes = $0 * 1024; print bytes }')
aws cloudwatch put-metric-data --metric-name FreeMemoryBytes --namespace $namespace --dimensions InstanceID=$InstanceID --timestamp $(date -u +"%Y-%m-%dT%H:%M:%SZ") --region $region --value $(free -bo | awk 'NR==2 {print $4}')
aws cloudwatch put-metric-data --metric-name LoadAverage --namespace $namespace --dimensions InstanceID=$InstanceID --timestamp $(date -u +"%Y-%m-%dT%H:%M:%SZ") --region $region --value $(awk -v ncpu="$processors" '{normalizedLoadAvg = $1 / ncpu; print normalizedLoadAvg}' /proc/loadavg)
