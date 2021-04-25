wget https://github.com/bazelbuild/bazel/releases/download/3.1.0/bazel_3.1.0-linux-x86_64.deb
dpkg -i bazel_3.1.0-linux-x86_64.deb
apt-get install -fy
mkdir /root/git && cd /root/git
git clone https://github.com/tensorflow/tensorflow.git 
cd /root/git/tensorflow
git checkout tags/v2.4.1

