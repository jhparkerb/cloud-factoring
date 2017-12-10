#!/bin/bash

set -e
set -o pipefail

ZONE=us-east1-b
PROJECT=always-be-factoring

### After running Build.sh:
# docker tag cado-server gcr.io/${PROJECT}/cado-server
# gcloud docker -- push gcr.io/${PROJECT}/cado-server
# 
# docker tag cado-client gcr.io/${PROJECT}/cado-client
# gcloud docker -- push gcr.io/${PROJECT}/cado-client

# We have to run on Skylake because that's the platform the binaries are built
# on and for.
gcloud beta container clusters create cado-cluster \
	--image-type=COS \
	--machine-type=n1-standard-8 \
	--min-cpu-platform "Intel Skylake" \
	--num-nodes=5 \
	--zone=${ZONE}

# TODO(jasonp):  Edit/create a namespace to run in with a CPU limit of 1000
# mCPU.
kubectl create -f - --namespace=default <<EOF
apiVersion: v1
kind: LimitRange
metadata:
  name: cpu-limit-range
spec:
  limits:
  - default:
      cpu: 1
    defaultRequest:
      cpu: 0.5
    type: Container
EOF

# gcloud compute disks create \
# 	--size=500GB \
# 	--zone=${ZONE} \
# 	cado-server-disk

# TODO(jasonp):  Add cado-server-disk to this deployment.
kubectl run cado-server \
	--replicas=1 \
	--requests='cpu=1' \
	--image=gcr.io/${PROJECT}/cado-server

kubectl expose deployment cado-server \
	--port=4242 \
	--target-port=4242

# 5 hosts * 8 cpus each == 40 replicas, if the server is negligible.
kubectl run cado-client \
	--image=gcr.io/${PROJECT}/cado-client \
	--limits='cpu=1' \
	--replicas=40

# Set up the kubernetes proxy as its console is much improved.
gcloud container clusters get-credentials cado-cluster \
	--zone ${ZONE} \
	--project ${PROJECT}

kubectl proxy
