#!/bin/bash

sudo groupadd -g 1541 clusterfs
sudo usermod -aG clusterfs stoth
