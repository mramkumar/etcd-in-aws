#!/bin/bash

#infra[0-2]
member_name=$1

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
mkdir /var/lib/etcd/data /var/lib/etcd/wals
mkdir /etc/etcd
groupadd --system etcd
useradd -s /sbin/nologin --system -g etcd etcd
chown -R etcd:etcd /var/lib/etcd/

#machine_id=`cat /etc/machine-id`
ip=`ifconfig |grep -w inet|grep -v 127.0.0.1|awk '{print $2}'`

#export the following,
#member_name=
#ip=`ifconfig |grep -w inet|grep -v 127.0.0.1|awk '{print $2}'`
#ip0=
#ip1=
#ip2=

#etcd --name $member_name --initial-advertise-peer-urls http://$ip:2380 \
# --listen-peer-urls http://$ip:2380 \
# --listen-client-urls http://0.0.0.0:2379 \
# --advertise-client-urls http://$ip:2379 \
# --initial-cluster-token etcd-cluster-1 \
# --initial-cluster infra0=http://$ip0:2380,infra1=http://$ip1:2380,infra2=http://$ip2:2380 \
# --initial-cluster-state new --data-dir "/var/lib/etcd/data" --wal-dir "/var/lib/etcd/wals/wal"

cat <<EOF > /etc/systemd/system/etcd.service
[Unit]
Description=etcd cluster
After=network.target

[Service]
Type=notify
User=etcd
Group=etcd
LimitNOFILE=65535
Restart=on-failure

# Make sure log directory exists and owned by syslog

PermissionsStartOnly=true
ExecStartPre=/bin/mkdir -p /var/log/systemd
ExecStartPre=/bin/chown syslog:adm /var/log/systemd
ExecStartPre=/bin/chown -R etcd:etcd /var/lib/etcd
StandardOutput=syslog
StandardError=syslog

ExecStart=/usr/local/bin/etcd --debug --enable-pprof  --name $member_name --data-dir "/var/lib/etcd/data" --wal-dir "/var/lib/etcd/wals/wal" --election-timeout 1500  --heartbeat-interval 300 --snapshot-count 25000 --initial-advertise-peer-urls "http://$ip:2380" --initial-cluster-token etcd-cluster-1 --initial-cluster-state existing --advertise-client-urls "http://$ip:2379"  --listen-client-urls "http://0.0.0.0:2379"  --listen-peer-urls "http://$ip:2380" \

[Install]
WantedBy=multi-user.target
EOF

systemctl daemon-reload
systemctl enable etcd
