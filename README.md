# learn-kubernetes

Task	Component Responsible
Create Pod: 	User / Controller (kubectl, Deployment, etc.)
Validate and store Pod: 	API server → etcd
Assign Pod to a Node: 	Kube-scheduler
Store updated Pod with Node info: 	API server → etcd
Watch and run Pod:	Kubelet (on assigned Node)
Report Pod status:	Kubelet → API server → etcd

KMS and autoscaling 
create a pod
configMap and Secret, how to access configMap and secret in pod?
How to retrieve the data from vault

