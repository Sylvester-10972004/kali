#!/bin/bash

# Install dependencies (debootstrap)
sudo apt-get update
sudo apt-get install -y debootstrap

# Fetch the latest Kali debootstrap script from git
curl -o kali-debootstrap "http://git.kali.org/gitweb/?p=packages/debootstrap.git;a=blob_plain;f=scripts/kali;hb=refs/heads/kali/master" && \
sudo debootstrap kali-rolling ./kali-root http://http.kali.org/kali ./kali-debootstrap && \
sudo tar -C kali-root -c . | sudo docker import - linuxkonsult/kali:latest && \
sudo rm -rf ./kali-root && \
TAG=$(sudo docker run -t -i linuxkonsult/kali awk '{print $NF}' /etc/debian_version | sed 's/\r$//') && \
echo "Tagging kali with $TAG" && \
sudo docker tag linuxkonsult/kali:latest linuxkonsult/kali:$TAG && \
echo "Build OK" || echo "Build failed!"
