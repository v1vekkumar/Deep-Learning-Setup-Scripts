# From http://caffe.berkeleyvision.org/install_apt.html
# Vivek Kumar - June 2016

# Update/Upgrade dependancies
sudo apt-get -y update
sudo apt-get -y upgrade

sudo apt-get -y install unzip cmake python-pip git python-scipy

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

## Eevrything below should be common for all platforms
git clone https://github.com/BVLC/caffe.git
cd caffe

#install pyhton requirements
for req in $(cat python/requirements.txt); do sudo pip install $req; done
export PYTHONPATH=/home/ubuntu/caffe/python:$PYTHONPATH

# Setup the Makefile config
cp Makefile.config.example Makefile.config

#uncomment CPU_ONLY
sed -i '/CPU_ONLY/s/^#//g' Makefile.config
# Doulble Check the python Path
make -j4 all
make test

# Hack to workaround issue "libdc1394 error: Failed to initialize libdc1394"
# see http://stackoverflow.com/questions/12689304/ctypes-error-libdc1394-error-failed-to-initialize-libdc1394

sudo ln /dev/null /dev/raw1394

make runtest

# Make Swapfile for make pycaffe to run

sudo fallocate -l 4G /swapfile 
sudo chmod 600 /swapfile
sudo mkswap /swapfile
sudo swapon /swapfile
sudo swapon -s
free -m

make pycaffe

# for enabling notebook
pip install jupyter
mkdir ~/certificates
echo "Create a python notebook here https://ipython.org/ipython-doc/3/notebook/public_server.html"

