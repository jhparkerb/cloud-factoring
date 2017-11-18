#!/bin/bash

set -e
set -o pipefail

echo "Not actually a script you ran run (yet)."
exit 1

ZONE=us-east1-b
PROJECT=${PROJECT}

# After running Build.sh:

docker tag cado-server gcr.io/${PROJECT}/cado-server
gcloud docker -- push gcr.io/${PROJECT}/cado-server

docker tag cado-client gcr.io/${PROJECT}/cado-client
gcloud docker -- push gcr.io/${PROJECT}/cado-client

gcloud compute disks create \
	--size=500GB \
	--zone=${ZONE} \
	cado-server-disk

gcloud container clusters create cado-cluster \
	--image-type=COS \
	--machine-type=n1-standard-8 \
	--num-nodes=5 \
	--zone=${ZONE}

# TODO(jasonp):  Add cado-server-disk to this deployment.
kubectl run cado-server \
	--replicas=1 \
	--image=gcr.io/${PROJECT}/cado-server

kubectl expose deployment cado-server \
	--port=4242 \
	--target-port=4242

# 5 hosts * 8 cpus each == 40 replicas, if the server is negligible.
kubectl run cado-client \
	--image=gcr.io/${PROJECT}/cado-client \
	--replicas=40

# Set up the kubernetes proxy as its console is much improved.
gcloud container clusters get-credentials cado-cluster \
	--zone ${ZONE} \
	--project ${PROJECT}

kubectl proxy
