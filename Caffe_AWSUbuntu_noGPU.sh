# From http://caffe.berkeleyvision.org/install_apt.html
# Vivek Kumar - June 2016

# Update/Upgrade dependancies
sudo apt-get -y update
sudo apt-get -y upgrade

sudo apt-get -y install unzip cmake python-pip

# 1. Genral Depenancies
sudo apt-get -y install libprotobuf-dev libleveldb-dev libsnappy-dev libopencv-dev libhdf5-serial-dev protobuf-compiler 


sudo apt-get -y update # Another one for sanity
sudo apt-get -y install --no-install-recommends libboost-all-dev

# 2. No need to install Cuda for CPU_ONLY mode (no GPU)

# LAS: install ATLAS by (or install OpenBLAS or MKL for better CPU performance.)
sudo apt-get -y install libatlas-base-dev 

# 3.  package to have the Python headers for building the pycaffe interface.
sudo apt-get -y install the python-dev 

# 4. Remaining dependencies, 14.04 Everything is packaged in 14.04.

sudo apt-get -y install libgflags-dev libgoogle-glog-dev liblmdb-dev

# 5. Remaining dependencies, 12.04
#     These dependencies need manual installation in 12.04.

# glog
wget https://google-glog.googlecode.com/files/glog-0.3.3.tar.gz
tar zxvf glog-0.3.3.tar.gz
cd glog-0.3.3
./configure
make && sudo make install

# gflags
wget https://github.com/schuhschuh/gflags/archive/master.zip
unzip master.zip
cd gflags-master
mkdir build && cd build
export CXXFLAGS="-fPIC" && cmake .. && make VERBOSE=1
make && sudo make install
# lmdb
git clone https://github.com/LMDB/lmdb
cd lmdb/libraries/liblmdb
make && sudo make install

# Note that glog does not compile with the most recent gflags version (2.1), so before that is resolved you will need to build with glog first.

## Eevrything below should be common for all platforms
git clone https://github.com/BVLC/caffe.git
cd caffe

#install pyhton requirements
for req in $(cat python/requirements.txt); do pip install $req; done
export PYTHONPATH=/home/ubuntu/caffe/python:$PYTHONPATH

# Setup the Makefile config
cp Makefile.config.example Makefile.config

#uncomment CPU_ONLY
sed -i '/CPU_ONLY/s/^#//g' Makefile.config
# Doulble Check the python Path
make -j4 all
make test
make runtest
make pycaffe
