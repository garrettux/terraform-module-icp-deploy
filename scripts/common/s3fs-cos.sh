#!/bin/bash

COS_BUCKET=$1
COS_MOUNT=$2
COS_CREDS=$HOME/.cos_creds
COS_ENDPOINT=$3
COS_KEY=$4
COS_SECRET=$5

install() {
  cd /tmp
  apt-get -y update
  apt-get -y install automake autotools-dev g++ git libcurl4-openssl-dev libfuse-dev libssl-dev libxml2-dev make pkg-config
  git clone https://github.com/s3fs-fuse/s3fs-fuse.git
  cd s3fs-fuse
  ./autogen.sh && ./configure
  make && make install
  echo ${COS_KEY}:${COS_SECRET} > ${COS_CREDS}
  chmod 600 $COS_CREDS
}

mount() {
  mkdir -p $COS_MOUNT
  s3fs $COS_BUCKET $COS_MOUNT -o passwd_file=$COS_CREDS -o sigv2 -o use_path_request_style -o url=$COS_ENDPOINT
}

install
mount
