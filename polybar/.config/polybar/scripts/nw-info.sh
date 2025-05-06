#!/bin/bash

NETWORK_ADDRESS=$(ip -4 addr show dev enp2s0 | grep -oP '(?<=inet\s)\d+(\.\d+){3}')
PUBLIC_IP=$(curl -s ifconfig.me)

echo "enp2s0:$NETWORK_ADDRESS public:$PUBLIC_IP"
