VERSION:= $(shell istioctl version | awk '{print $$3; exit}')

install:

# Download Istio(https://istio.io/latest/docs/setup/getting-started/#download)
ifneq "$(wildcard istio-$(VERSION) )" ""
	  	# if directory istio exists:
		@echo "istio-$(VERSION) directoy already exists"
else
		curl -L https://istio.io/downloadIstio | sh -
  		export PATH=$PWD/bin:$PATH
endif

	# this will install Istio core and ingress gateways
	yes | istioctl install

	# Enable istio-injector to node label
	kubectl --overwrite=true label namespace default istio-injection=enabled

	# install example application
	kubectl apply -f https://raw.githubusercontent.com/GoogleCloudPlatform/microservices-demo/main/release/kubernetes-manifests.yaml

	# Add monitoring
	sleep 2
	@echo istioctl version is: $(VERSION)
	kubectl apply -f istio-$(VERSION)/samples/addons

clean:
	kubectl delete --ignore-not-found=true -f https://raw.githubusercontent.com/GoogleCloudPlatform/microservices-demo/main/release/kubernetes-manifests.yaml
	kubectl delete --ignore-not-found=true -f istio-$(VERSION)/samples/addons
	istioctl manifest generate --set profile=demo | kubectl delete --ignore-not-found=true -f -
	istioctl tag remove default
	kubectl delete namespace istio-system
	kubectl label namespaces default istio-injection-
	rm -rf istio-$(VERSION)