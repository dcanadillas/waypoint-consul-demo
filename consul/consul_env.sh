#!/bin/bash

# Script to configure Consul env variables to connect to Consul K8s cluster. It is based on the premise that
# Consul UI is using a LB service type for the kubernetes deployment

CONSUL_NAMESPACE="consul"

if ! hash kubectl; then
  echo "kubectl is not installed"
  exit 1
fi

if [[ "$OSTYPE" == "linux"* ]];then
  echo "Using OS: $OSTYPE"
  BASE64ARG="-d"
else
  # WARNING: Let's assume that if the OS is not Linux, then it is a MacOS
  echo "Using OS: $OSTYPE"
  BASE64ARG="-D"
fi

export CONSUL_HTTP_ADDR="https://$(kubectl get svc/consul-ui -n $CONSUL_NAMESPACE -o jsonpath='{.status.loadBalancer.ingress[].ip}')"
export CONSUL_TLS_SERVER_NAME="consul-server"
CAFILE="$HOME/consul-ca-cert-$(echo "$CONSUL_HTTP_ADDR" | sed "s/https:\\/\\///g").crt"
kubectl get secret/consul-ca-cert -n $CONSUL_NAMESPACE -o jsonpath='{.data.tls\.crt}' | base64 $BASE64ARG > $CAFILE
export CONSUL_CACERT="$CAFILE"