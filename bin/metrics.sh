#!/usr/bin/env bash

namespace="maxclem/ec2"
InstanceID=$(curl -s http://169.254.169.254/latest/meta-data/instance-id)
region=$(curl -s http://169.254.169.254/latest/meta-data/placement/availability-zone/)
region=${region%?}
processors=$(grep -c processor /proc/cpuinfo)
timestamp=$(date -u +"%Y-%m-%dT%H:%M:%SZ")

aws cloudwatch put-metric-data --metric-name FreeDiskBytes --namespace $namespace --dimensions InstanceID=$InstanceID,Volume="/dev/xvda1" --timestamp $timestamp --region $region --unit Bytes--value $(df /dev/xvda1 --output=avail | awk 'NR==2 { bytes = $0 * 1024; print bytes }')
aws cloudwatch put-metric-data --metric-name FreeMemoryBytes --namespace $namespace --dimensions InstanceID=$InstanceID --timestamp $timestamp --region $region --unit Kilobytes --value $(grep MemAvailable /proc/meminfo | grep -Eo '[0-9]+')
aws cloudwatch put-metric-data --metric-name LoadAverage --namespace $namespace --dimensions InstanceID=$InstanceID --timestamp $timestamp --region $region --value $(awk -v ncpu="$processors" '{normalizedLoadAvg = $1 / ncpu; print normalizedLoadAvg}' /proc/loadavg)
