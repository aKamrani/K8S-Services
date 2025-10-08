#!/bin/bash
NODES=("node-2" "node-3" "node-4")
DISKS=("disk1" "disk2")

OUTPUT_FILE="pvs.yml"
> "$OUTPUT_FILE"  # Truncate the file if it exists

for NODE in "${NODES[@]}"; do
  for DISK in "${DISKS[@]}"; do
    cat <<EOF >> "$OUTPUT_FILE"
apiVersion: v1
kind: PersistentVolume
metadata:
  name: pv-minio-${NODE}-${DISK}
spec:
  capacity:
    storage: 1Gi
  accessModes:
    - ReadWriteOnce
  persistentVolumeReclaimPolicy: Retain
  storageClassName: minio-local-storage
  local:
    path: /var/myservice-minio/${DISK}
  nodeAffinity:
    required:
      nodeSelectorTerms:
        - matchExpressions:
            - key: kubernetes.io/hostname
              operator: In
              values:
                - ${NODE}
---
EOF
  done
done
