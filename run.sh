#!/usr/bin/bash

VERSION="${ISTIO_VERSION:-1.13.2}"
CURRENT_DIR=$PWD/istio-${VERSION}

if [ "$1" == "install" ]; then
  echo "Istio version: ${VERSION}"
  if [ -d "istio-${VERSION}" ]; then
    echo "Found istio with ${VERSION} version"
  else
    echo "Did not find istio ${VERSION}"
    echo "Installing ISTIO"
    curl -L https://istio.io/downloadIstio | sh -
    echo "Finished Istio installation"
  fi

  export PATH="$PATH:${CURRENT_DIR}/bin"

  # this will install Istio core and ingress gateways
  yes | istioctl install

  # Enable istio-injector to node label
  kubectl --overwrite=true label namespace default istio-injection=enabled

  # install example application
  kubectl apply -f https://raw.githubusercontent.com/GoogleCloudPlatform/microservices-demo/main/release/kubernetes-manifests.yaml

  # Add monitoring
  sleep 2
  kubectl apply -f istio-"${VERSION}"/samples/addons
elif [ "$1" == "clean" ]; then
  echo "starting cleaning process"
  istioctl manifest generate --set profile=demo | kubectl delete --ignore-not-found=true -f -
	istioctl tag remove default
  kubectl delete --ignore-not-found=true -f https://raw.githubusercontent.com/GoogleCloudPlatform/microservices-demo/main/release/kubernetes-manifests.yaml
	kubectl delete --ignore-not-found=true -f istio-"${VERSION}"/samples/addons
	kubectl delete namespace istio-system
	kubectl label namespaces default istio-injection-
	rm -rf istio-"${VERSION}"
	echo "Done with removing istio installation"
fi


