#!/bin/bash


PROJECT_ID=gluster-k8s-18217;
CLUSTER_NAME=gfs-k8s-02;
ZONE=us-central1-a;
NODE_COUNT=4;
#
# Generate k8s cluter

gcloud container --project "${PROJECT_ID}" clusters create "${CLUSTER_NAME}" --zone "${ZONE}" --machine-type "n1-standard-2" --image-type "CONTAINER_VM" --disk-size "100" --scopes "https://www.googleapis.com/auth/compute","https://www.googleapis.com/auth/devstorage.read_write","https://www.googleapis.com/auth/logging.write","https://www.googleapis.com/auth/servicecontrol","https://www.googleapis.com/auth/service.management.readonly","https://www.googleapis.com/auth/trace.append" --num-nodes "${NODE_COUNT}" --network "default" --no-enable-cloud-logging --no-enable-cloud-monitoring

#
# Set context to new cluster

gcloud container clusters get-credentials ${CLUSTER_NAME} --zone ${ZONE} --project ${PROJECT_ID}

#
# Generate 2xN disks and attach them
n=1;
for node in $(kubectl get nodes -o name)
do
node=$(basename $node);
gcloud compute --project "${PROJECT_ID}" disks create "disk-${n}" --size "20" --zone "${ZONE}" --description "gfs-k8s-brick" --type "pd-ssd"
gcloud compute instances attach-disk ${node} --disk=disk-${n} --zone "${ZONE}"
n=$(( $n + 1 ));
gcloud compute --project "${PROJECT_ID}" disks create "disk-${n}" --size "20" --zone "${ZONE}" --description "gfs-k8s-brick" --type "pd-ssd"
gcloud compute instances attach-disk ${node} --disk=disk-${n} --zone "${ZONE}"
n=$(( $n + 1 ));
gcloud compute ssh ${node} --zone "${ZONE}" --command 'sudo modprobe dm_thin_pool' 
gcloud compute ssh ${node} --zone "${ZONE}" --command 'sudo service rpcbind stop; sudo update-rc.d rpcbind disable'
echo "===== Done for node $node ====";
done


echo "======= Generating Topology =============";
./generate_topology.sh
