# gt_730_tensorflow
This builds a CUDA-enabled Tensorflow for the Nvidia GeForce GT 730. I use it on my HP Proliant N40L, which uses a [AMD Turion(tm) II Neo N40L Dual-Core Processor](https://browser.geekbench.com/geekbench2/compare/691959/691959), and so I use the [nomkl](https://anaconda.org/conda-forge/nomkl) metapackage in the python environment to skip Intel-oriented performance enhancements.

Part of the project was to see if I could use GPU resources via Docker, so this container uses the [Nvidia Container Toolkit](https://docs.nvidia.com/datacenter/cloud-native/container-toolkit/install-guide.html).

To use:
 * Install GPU drivers (but not CUDNN) on the host
 * Install Docker and the Nvidia Container Toolkit
 * build this container with `docker build . -t build-tf`
 * Wait (it's a 38 hour build on my N40L!)
 * Once the container is finished build the python package and write it to the local FS via volume: 

    docker run --gpus all\
           	-it\
           	-v `pwd`:/tf_out\
           	build-tf\
           	/bin/bash -c "cd /root/git/tensorflow && ./bazel-bin/tensorflow/tools/pip_package/build_pip_package /tf_out/tensorflow_pkg"

