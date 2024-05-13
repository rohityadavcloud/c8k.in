#!/usr/bin/env bash
# c8k.in/stall.sh - Easiest Apache CloudStack Installer
# Author: Rohit Yadav <rohit@apache.org>
# Install with this command (from your Ubuntu host):
#
# curl -sSfL https://c8k.in/stall.sh | bash
#
# Licensed to the Apache Software Foundation (ASF) under one
# or more contributor license agreements.  See the NOTICE file
# distributed with this work for additional information
# regarding copyright ownership.  The ASF licenses this file
# to you under the Apache License, Version 2.0 (the
# "License"); you may not use this file except in compliance
# with the License.  You may obtain a copy of the License at
# 
#   http://www.apache.org/licenses/LICENSE-2.0
# 
# Unless required by applicable law or agreed to in writing,
# software distributed under the License is distributed on an
# "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY
# KIND, either express or implied.  See the License for the
# specific language governing permissions and limitations
# under the License.

set -e
set -o noglob

# --- helper functions for logs ---
info()
{
    echo '[INFO] ' "$@"
}
warn()
{
    echo '[WARN] ' "$@" >&2
}
fatal()
{
    echo '[ERROR] ' "$@" >&2
    exit 1
}

### Intro ###
echo "
░█████╗░░█████╗░██╗░░██╗░░░██╗███╗░░██╗
██╔══██╗██╔══██╗██║░██╔╝░░░██║████╗░██║
██║░░╚═╝╚█████╔╝█████═╝░░░░██║██╔██╗██║
██║░░██╗██╔══██╗██╔═██╗░░░░██║██║╚████║
╚█████╔╝╚█████╔╝██║░╚██╗██╗██║██║░╚███║
░╚════╝░░╚════╝░╚═╝░░╚═╝╚═╝╚═╝╚═╝░░╚══╝
CloudStack Installer By 🅁🄾🄷🄸🅃 🅈🄰🄳🄰🅅
"
info "Installing Apache CloudStack All-In-One-Box"
info "NOTE: this works only on Ubuntu, and run as 'root' user!"

if [[ $EUID -ne 0 ]]; then
   fatal "This script must be run as root"
   exit 1
fi

warn "Work in progress, try again while this is being hacked"

### Setup Prerequisites ###
info "Installing dependencies"
#apt-get update
apt-get install -y openssh-server sudo vim htop tar bridge-utils

### Setup Bridge ###

#FIXME: we want to avoid virtual nics
# ls -l /sys/class/net/ | grep -v virtual

interface=$(ls /sys/class/net/ | grep -v 'lo' | head -1)
gateway=$(ip route show 0.0.0.0/0 dev ens3 | cut -d\  -f3)
hostip=$(ip -f inet addr show $interface | sed -En -e 's/.*inet ([0-9.]+).*/\1/p')

info "Setting up bridge on $interface which has IP $hostip and gateway $gateway"

echo "network:
   version: 2
   renderer: networkd
   ethernets:
     $interface:
       dhcp4: false
       dhcp6: false
       optional: true
   bridges:
     cloudbr0:
       addresses: [$hostip/24]
       routes:
        - to: default
          via: $gateway
       nameservers:
         addresses: [8.8.8.8, 1.1.1.1]
       interfaces: [$interface]
       dhcp4: false
       dhcp6: false
       parameters:
         stp: false
         forward-delay: 0" > /etc/netplan/01-netcfg.yaml

info "Disabling cloud-init netplan config"
rm -f /etc/netplan/50-cloud-init.yaml
echo "network: {config: disabled}" > /etc/cloud/cloud.cfg.d/99-disable-network-config.cfg

netplan generate
netplan apply
