#!/bin/bash

# Errors are fatal
set -e

# Build the Matlab image
pushd matlab-dockerfile
cp ../matlab_installer_input.txt .
sed -i "s/fileInstallationKey=/fileInstallationKey=$MATLAB_LICENSE_KEY/g" matlab_installer_input.txt 
mkdir -p matlab-install
if [ ! -f ./matlab-install/version.txt ]; then
  mount -o loop $MATLAB_ISOFILE ./matlab-install
fi
docker build -t tmp-$1 --build-arg LICENSE_SERVER=$MATLAB_LICENSE_SERVER .
umount ./matlab-install
rm matlab_installer_input.txt
popd

# Build the final Docker image
docker build -t $1 --build-arg baseimage=tmp-$1 --build-arg LICENSE_SERVER=$MATLAB_LICENSE_SERVER .
docker rmi -f tmp-$1
