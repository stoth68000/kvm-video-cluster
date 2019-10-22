#!/bin/bash

# References:
#  https://kubernetes.io/docs/tasks/inject-data-application/define-command-argument-container/
#  https://kubernetes.io/docs/reference/kubectl/cheatsheet/#creating-objects

# Start a job that echo's a message then exits.
# We can inspect the logs with:
# kubectl logs pod/hello-world-repeated

kubectl apply -f ./hello-world-repeated.yaml
