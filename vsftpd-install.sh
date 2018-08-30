#!/bin/bash
# This is the vsftpd auto installation. Tested on Debian 8.
# Update: 201808301351


apt-get update
echo "======== Installing vsftpd =============="
apt-get install vsftpd -y
echo "======== vsftpd installed =============="
echo "======== Installing db5.3-util =============="
apt-get install db5.3-util -y
echo "======== db5.3-util isntalled =============="


# Backup Files
cp /etc/vsftpd.conf /etc/vsftpd.bak.original
cp /etc/pam.d/vsftpd /etc/pam.d/vsftpd.bak.original

mkdir -p /etc/vsftpd/vuser_conf
useradd vsftpd -s /sbin/
mkdir /home/vsftpd
chown vsftpd:vsftpd /home/vsftpd
cat > /etc/vsftpd.conf<<EOF
listen=YES
anonymous_enable=NO
local_enable=YES
write_enable=YES
dirmessage_enable=YES
use_localtime=YES
xferlog_enable=YES
connect_from_port_20=YES
secure_chroot_dir=/var/run/vsftpd/empty
pam_service_name=vsftpd
rsa_cert_file=/etc/ssl/certs/ssl-cert-snakeoil.pem
rsa_private_key_file=/etc/ssl/private/ssl-cert-snakeoil.key
ssl_enable=NO
guest_enable=YES
guest_username=vsftpd
user_config_dir=/etc/vsftpd/vuser_conf
allow_writeable_chroot=YES
EOF

cat >/etc/pam.d/vsftpd<<EOF
#%PAM-1.0
auth required pam_userdb.so db=/etc/vsftpd/vsftpd 
account required pam_userdb.so db=/etc/vsftpd/vsftpd
EOF


# ================ Custom content begin =========================
cat >/etc/vsftpd/ftplogins.txt<<EOF
test
123456
EOF
mkdir -p /home/test
chown vsftpd:vsftpd /home/test
cat >/etc/vsftpd/vuser_conf/test<<EOF
local_root=/home/test
write_enable=YES
anon_world_readable_only=NO
anon_upload_enable=YES
anon_mkdir_write_enable=YES
anon_other_write_enable=YES
EOF
# ================ Custom content end =========================

db5.3_load -T -t hash -f /etc/vsftpd/ftplogins.txt /etc/vsftpd/vsftpd.db
service vsftpd start
