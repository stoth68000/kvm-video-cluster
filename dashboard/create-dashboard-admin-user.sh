#!/bin/bash

kubectl apply -f dashboard-adminuser.yaml
kubectl apply -f binding.xml
kubectl -n kubernetes-dashboard describe secret $(kubectl -n kubernetes-dashboard get secret | grep admin-user | awk '{print $1}')

