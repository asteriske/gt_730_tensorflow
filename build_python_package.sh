#~/bin/bash
docker run --gpus all\
       	-it\
       	-v `pwd`:/tf_out\
       	build-tf\
       	/bin/bash -c "cd /root/git/tensorflow && ./bazel-bin/tensorflow/tools/pip_package/build_pip_package /tf_out/tensorflow_pkg"
