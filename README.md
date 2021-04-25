# gt_730_tensorflow
This builds a CUDA-enabled Tensorflow for the Nvidia GeForce GT 730 (CUDA 3.5), but should serve as inspiration for other legacy GPUs. I use it on my HP Proliant N40L, which uses a [AMD Turion(tm) II Neo N40L Dual-Core Processor](https://browser.geekbench.com/geekbench2/compare/691959/691959), and so I use the [nomkl](https://anaconda.org/conda-forge/nomkl) metapackage in the python environment to skip Intel-oriented performance enhancements.

Part of the project was to see if I could use GPU resources via Docker, so this container uses the [Nvidia Container Toolkit](https://docs.nvidia.com/datacenter/cloud-native/container-toolkit/install-guide.html).

To use:
 * Install GPU drivers (but not CUDNN) on the host
 * Install Docker and the Nvidia Container Toolkit
 * build this container with `docker build . -t build-tf`
 * Wait (it's a 38 hour build on my N40L!)
 * Once the container is finished build the python package and write it to the local FS via volume: 

```
    docker run --gpus all\
           	-it\
           	-v `pwd`:/tf_out\
           	build-tf\
           	/bin/bash -c "cd /root/git/tensorflow && ./bazel-bin/tensorflow/tools/pip_package/build_pip_package /tf_out/tensorflow_pkg"
```

GPU Details:
```
description: VGA compatible controller
product: GK208B [GeForce GT 730]
vendor: NVIDIA Corporation
physical id: 0
bus info: pci@0000:01:00.0
version: a1
width: 64 bits
clock: 33MHz
capabilities: pm msi pciexpress vga_controller bus_master cap_list rom
configuration: driver=nvidia latency=0
resources: irq:28 memory:fd000000-fdffffff memory:f0000000-f7ffffff memory:fa000000-fbffffff ioport:e800(size=128) memory:c0000-dffff
```
```
+-----------------------------------------------------------------------------+
| NVIDIA-SMI 465.19.01    Driver Version: 465.19.01    CUDA Version: 11.3     |
|-------------------------------+----------------------+----------------------+
| GPU  Name        Persistence-M| Bus-Id        Disp.A | Volatile Uncorr. ECC |
| Fan  Temp  Perf  Pwr:Usage/Cap|         Memory-Usage | GPU-Util  Compute M. |
|                               |                      |               MIG M. |
|===============================+======================+======================|
|   0  NVIDIA GeForce ...  On   | 00000000:01:00.0 N/A |                  N/A |
| 30%   33C    P8    N/A /  N/A |     16MiB /   980MiB |     N/A      Default |
|                               |                      |                  N/A |
+-------------------------------+----------------------+----------------------+
```
