#!/bin/bash

apt update

export RELEASE="3.1.13"
cd /tmp
wget https://github.com/etcd-io/etcd/releases/download/v${RELEASE}/etcd-v${RELEASE}-linux-amd64.tar.gz
tar xvf etcd-v${RELEASE}-linux-amd64.tar.gz
cd etcd-v${RELEASE}-linux-amd64
mv etcd etcdctl /usr/local/bin
cd /tmp
rm -rf etcd-v${RELEASE}-linux-amd64 etcd-v${RELEASE}-linux-amd64.tar.gz
mkdir -p /var/lib/etcd/
mkdir /etc/etcd
groupadd --system etcd
useradd -s /sbin/nologin --system -g etcd etcd
chown -R etcd:etcd /var/lib/etcd/
