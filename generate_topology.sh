#!/bin/bash

rm -f heketi-turnkey-config.yaml;

#
# Injecting file Header

cat <<EOF>>heketi-turnkey-config.yaml
#
# Sample configuration.
# You must create your own configurgation.
#
# Note 1: hostnames/manage: must be the hostname of your node as in 'kubectl get node'
# Note 2: hostnames/storage: must be the IP address of your node, not a hostname
# Note 3: the filename under the data section must be topology.json
#
# Alternatively, to create a ConfigMap from topology.json you may use:
# $ kubectl create configmap heketi-turnkey-config --from-file=topology.json --output=yaml --dry-run=true
# Remove --dry-run=true if you actually want to create the object.
#
# For proper function your nodes must have the dm_thin_pool module loaded:
# $ modprobe dm_thin_pool
# $ echo "dm_thin_pool" >>/etc/modules
#
apiVersion: v1
kind: ConfigMap
metadata:
  name: heketi-turnkey-config
data:
  topology.json: |
    {
      "clusters": [
    {
      "nodes": [
EOF

for e in $(gcloud compute instances list | grep -v INTERNAL_IP | awk '{print $1","$4}')
do
nodeip=$(echo $e | cut -d"," -f2)
nodename=$(echo $e | cut -d"," -f1)
cat <<EOF>> heketi-turnkey-config.yaml
        {
          "node": {
            "hostnames": {
              "manage": [
                "${nodename}"
              ],
              "storage": [
                "${nodeip}"
              ]
            },
            "zone": 1
          },
          "devices": [
            "/dev/sdb",
            "/dev/sdc"
          ]
        },
EOF
done
#
# hack to remove last comma
#
truncate -s-2 heketi-turnkey-config.yaml
echo "">> heketi-turnkey-config.yaml
#
# Add footer section for YAML

cat <<EOF>> heketi-turnkey-config.yaml
      ]
      }
      ]
    }
EOF
