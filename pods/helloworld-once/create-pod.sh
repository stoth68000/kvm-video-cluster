#!/bin/bash

# Start a job that echo's a message then exits.
# We can inspect the logs with:
# kubectl logs pod/hello-world-once

kubectl apply -f ./hello-world-once.yaml
