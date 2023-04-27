#!/bin/bash

# Start container to debug TCP traffic on port 80
sudo docker run --rm -it \
  --cap-add=cap_net_admin \
  --net container:nginx \
  itsthenetwork/alpine-tcpdump \
  -i eth0 port 80 -vv -y EN10MB -A
