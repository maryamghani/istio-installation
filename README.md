## Istio Service Mesh setup in Kubernetes


### PreReq:
* Start your local [minikube](https://minikube.sigs.k8s.io/docs/start/)

  * ```minikube start --cpus 6 --memory 8192```
* installing Istio and [example application](https://raw.githubusercontent.com/GoogleCloudPlatform/microservices-demo/main/release/kubernetes-manifests.yaml) run:
  * ``make install``

### How to run:
``sh run.sh install``

### How to uninstall everything:
``sh run.sh clean``

## See Monitoring
This will install Istio and example application with monitoring in place
for accessing monitoring tools:

1. ```kubectl get svc -n istio-system```

2. you can port-forward to any of them for example grafana:
   1. after all pods up and running:

       ``kubectl get pods -n istio-system``
   2. 
   ```kubectl port-forward svc/grafana -n istio-system 3000:3000```
3. and you can access it via: https://localhost:3000
---
References:

https://istio.io/latest/docs/setup/getting-started/#download
https://github.com/GoogleCloudPlatform/microservices-demo/blob/main/release/kubernetes-manifests.yaml

#istio #installation
