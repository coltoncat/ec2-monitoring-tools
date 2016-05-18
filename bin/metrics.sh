#!/usr/bin/env bash
df /dev/xvda1 --output=avail | awk 'NR==2 { bytes = $0 * 1024; print bytes }' | xargs aws cloudwatch put-metric-data --metric-name FreeDiskBytes --namespace maxclem --dimensions InstanceID=$(curl -s http://169.254.169.254/latest/meta-data/instance-id) --timestamp $(date -u +"%Y-%m-%dT%H:%M:%SZ") --region $(curl -s http://169.254.169.254/latest/meta-data/placement/availability-zone/ | sed 's/.$//') --value
free -bo | awk 'NR==2 {print $4}' | xargs aws cloudwatch put-metric-data --metric-name FreeMemoryBytes --namespace maxclem --dimensions InstanceID=$(curl -s http://169.254.169.254/latest/meta-data/instance-id) --timestamp $(date -u +"%Y-%m-%dT%H:%M:%SZ") --region $(curl -s http://169.254.169.254/latest/meta-data/placement/availability-zone/ | sed 's/.$//') --value

