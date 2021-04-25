#FROM nvidia/cuda:10.2-cudnn7-devel-ubuntu18.04
FROM nvidia/cuda:11.2.2-cudnn8-devel-ubuntu18.04
ENV LANG=C.UTF-8 LC_ALL=C.UTF-8
ENV PATH /opt/conda/bin:$PATH
ADD inst.sh /tmp/inst.sh
ADD conda.sh /tmp/conda.sh
RUN chmod +x /tmp/inst.sh && \
chmod +x /tmp/conda.sh && \
apt-get update --fix-missing && apt-get install -y wget bzip2 ca-certificates \
    libglib2.0-0 libxext6 libsm6 libxrender1 \
    git mercurial subversion && \
wget --quiet https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh -O ~/miniconda.sh && \
    /bin/bash ~/miniconda.sh -b -p /opt/conda && \
    rm ~/miniconda.sh && \
    ln -s /opt/conda/etc/profile.d/conda.sh /etc/profile.d/conda.sh && \
    echo ". /opt/conda/etc/profile.d/conda.sh" >> ~/.bashrc && \
    echo "conda activate base" >> ~/.bashrc && \
apt-get install -y curl grep sed dpkg && \
    TINI_VERSION=`curl https://github.com/krallin/tini/releases/latest | grep -o "/v.*\"" | sed 's:^..\(.*\).$:\1:'` && \
    curl -L "https://github.com/krallin/tini/releases/download/v${TINI_VERSION}/tini_${TINI_VERSION}.deb" > tini.deb && \
    dpkg -i tini.deb && \
    rm tini.deb && \
    apt-get clean && \
conda install -y \
  python=3 \
  pip six numpy wheel setuptools mock nomkl \
  && pip install keras_applications --no-deps \
  && pip install keras_preprocessing --no-deps && \
  conda clean -afy
RUN /tmp/inst.sh
RUN /tmp/conda.sh
ENTRYPOINT [ "/usr/bin/tini", "--" ]
CMD [ "/bin/bash" ]
