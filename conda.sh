cd /root/git/tensorflow
export PYTHON_BIN_PATH=$(which python)
export PYTHON_LIB_PATH="$($PYTHON_BIN_PATH -c 'import site; print(site.getsitepackages()[0])')"
export PYTHONPATH=${TF_ROOT}/lib
export PYTHON_ARG=${TF_ROOT}/lib

# Compilation parameters
export TF_NEED_CUDA=1
export TF_NEED_GCP=1
export TF_CUDA_COMPUTE_CAPABILITIES=5.2,3.5
export TF_NEED_HDFS=1
export TF_NEED_OPENCL=0
export TF_NEED_JEMALLOC=1  # Need to be disabled on CentOS 6.6
export TF_ENABLE_XLA=1
export TF_NEED_VERBS=0
export TF_CUDA_CLANG=0
export TF_DOWNLOAD_CLANG=0
export TF_NEED_MKL=0
export TF_DOWNLOAD_MKL=0
export TF_NEED_MPI=0
export TF_NEED_S3=1
export TF_NEED_KAFKA=1
export TF_NEED_GDR=0
export TF_NEED_OPENCL_SYCL=0
export TF_SET_ANDROID_WORKSPACE=0
export TF_NEED_AWS=0
export TF_NEED_IGNITE=0
export TF_NEED_ROCM=0
export GCC_HOST_COMPILER_PATH=$(which gcc)

cat > .tf_configure.bazelrc <<- EOM
build --action_env PYTHON_BIN_PATH="/opt/conda/bin/python"
build --action_env PYTHON_LIB_PATH="/opt/conda/lib/python3.8/site-packages"
build --python_path="/opt/conda/bin/python"
build:xla --define with_xla_support=true
build --config=xla
build --action_env CUDA_TOOLKIT_PATH="/usr/local/cuda"
build --action_env TF_CUDA_COMPUTE_CAPABILITIES="3.5"
build --action_env LD_LIBRARY_PATH="/usr/local/nvidia/lib:/usr/local/nvidia/lib64"
build --action_env GCC_HOST_COMPILER_PATH="/usr/bin/x86_64-linux-gnu-gcc-7"
build --config=cuda
build:opt --copt=-march=native
build:opt --copt=-Wno-sign-compare
build:opt --host_copt=-march=native
build:opt --define with_default_optimizations=true
test --flaky_test_attempts=3
test --test_size_filters=small,medium
test:v1 --test_tag_filters=-benchmark-test,-no_oss,-gpu,-oss_serial
test:v1 --build_tag_filters=-benchmark-test,-no_oss,-gpu
test:v2 --test_tag_filters=-benchmark-test,-no_oss,-gpu,-oss_serial,-v1only
test:v2 --build_tag_filters=-benchmark-test,-no_oss,-gpu,-v1only
build --action_env TF_CONFIGURE_IOS="0"
EOM

# Here you can edit this variable to set any optimizations you want.
export CC_OPT_FLAGS="-march=native"
bazel build --config=opt \
            --config=v2 \
            --linkopt="-lrt" \
            --linkopt="-lm" \
	    --local_ram_resources="4096" \
            --host_linkopt="-lrt" \
            --host_linkopt="-lm" \
            --action_env="LD_LIBRARY_PATH=${LD_LIBRARY_PATH}" \
            //tensorflow/tools/pip_package:build_pip_package

PACKAGE_NAME=tensorflow
SUBFOLDER_NAME="${TF_VERSION_GIT_TAG}-py${PYTHON_VERSION}"
