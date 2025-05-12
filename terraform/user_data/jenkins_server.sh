#!/bin/bash

# Install dependencies
sudo yum install -y gcc openssl-devel bzip2-devel libffi-devel zlib-devel fontconfig

# Download and install Python 3.8.12
cd /usr/src
sudo wget https://www.python.org/ftp/python/3.8.12/Python-3.8.12.tgz
sudo tar xzf Python-3.8.12.tgz
cd Python-3.8.12
sudo ./configure --enable-optimizations
sudo make altinstall