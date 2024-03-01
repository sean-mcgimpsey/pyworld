### Instructions
All commands should be executed from the base of this directory.  

Start minikube;
```powershell
---snippet---
> minikube start
✨  Using the docker driver based on existing profile
👍  Starting control plane node minikube in cluster minikube
🚜  Pulling base image ...
🏃  Updating the running docker "minikube" container ...
🐳  Preparing Kubernetes v1.28.3 on Docker 24.0.7 ...
🔎  Verifying Kubernetes components...
    ▪ Using image gcr.io/k8s-minikube/storage-provisioner:v5
🌟  Enabled addons: storage-provisioner, default-storageclass
---snippet---
```

Apply kubernetes manifests;
```powershell
> kubectl apply -f .\manifests\ 
deployment.apps/pyworld created
service/pyworld created
serviceaccount/pyworld created
```

Inspect pod status, ensuring `STATUS` changes to running.
```powershell
> kubectl get pods
NAME                       READY   STATUS    RESTARTS   AGE
pyworld-547cd545d7-7p28q   1/1     Running   0          66s
pyworld-547cd545d7-bd9tj   1/1     Running   0          66s
```

Confirm service has been created; 
```powershell
> kubectl get svc 
NAME         TYPE        CLUSTER-IP      EXTERNAL-IP   PORT(S)          AGE
kubernetes   ClusterIP   10.96.0.1       <none>        443/TCP          14m
pyworld      NodePort    10.101.251.69   <none>        8080:30998/TCP   4m22s
PS C:\Users\sean\Documents\repos\pyworld> 
```

Run the minikube service tunnel. Take note of the address returned in output.
```powershell
> minikube service pyworld --url
http://127.0.0.1:56124 
❗  Because you are using a Docker driver on windows, the terminal needs to be open to run it.

```

Open a browser and browse to the url outputted (http://127.0.0.1:56124 in the example above!). Refreshing the page should demonstrate minikube load balancing the deployment, with the hostname returned changing randomly. 

### Scaling
To further scale the pyworld deployment, adding more pods to be balanced; 
```powershell
kubectl scale deployment pyworld --replicas=<desired replicas>
```

For example;
```powershell
> kubectl scale deployment pyworld --replicas=4
deployment.apps/pyworld scaled
```

Inspecting pods, should show kubernetes provisioning new replicas alongside the existing;
```powershell
> kubectl get pods
NAME                       READY   STATUS    RESTARTS   AGE
pyworld-547cd545d7-7p28q   1/1     Running   0          10m
pyworld-547cd545d7-7q4j9   0/1     Running   0          6s
pyworld-547cd545d7-bd9tj   1/1     Running   0          10m
pyworld-547cd545d7-l6jxn   0/1     Running   0          6s
```
After a few seconds, all pods should become ready.
```powershellgit remote add origin git@github.com:sean-mcgimpsey/pyworld.git
> kubectl get pods
NAME                       READY   STATUS    RESTARTS   AGE
pyworld-547cd545d7-7p28q   1/1     Running   0          15m
pyworld-547cd545d7-7q4j9   1/1     Running   0          4m41s
pyworld-547cd545d7-bd9tj   1/1     Running   0          15m
pyworld-547cd545d7-l6jxn   1/1     Running   0          4m41s
```