ARG baseimage
FROM ${baseimage} AS matlab-install-stage

FROM jupyter/base-notebook

# Install MATLAB dependencies
# Reference: https://github.com/mathworks-ref-arch/container-images/tree/master/matlab-deps
USER root
RUN export DEBIAN_FRONTEND=noninteractive && apt-get update && apt-get install --no-install-recommends -y \
        libasound2 \
        libatk1.0-0 \
        libc6 \
        libcairo-gobject2 \
        libcairo2 \
        libcrypt1 \
        libcups2 \
        libdbus-1-3 \
        libfontconfig1 \
        libgdk-pixbuf2.0-0 \
        libgstreamer-plugins-base1.0-0 \
        libgstreamer1.0-0 \
        libgtk-3-0 \
        libnspr4 \
        libnss3 \
        libpam0g \
        libpango-1.0-0 \
        libpangocairo-1.0-0 \
        libpangoft2-1.0-0 \
        libpython2.7 \
        libpython3.8 \
        libselinux1 \
        libsm6 \
        libsndfile1 \
        libtcl8.6 \
        libuuid1 \
        libx11-6 \
        libx11-xcb1 \
        libxcb1 \
        libxcomposite1 \
        libxcursor1 \
        libxdamage1 \
        libxext6 \
        libxfixes3 \
        libxft2 \
        libxi6 \
        libxinerama1 \
        libxrandr2 \
        libxrender1 \
        libxt6 \
        libxtst6 \
        libxxf86vm1 \
        zlib1g \
        xkb-data \
        procps \
        ca-certificates \
        sudo \
        locales locales-all \
    && apt-get clean \
    && apt-get -y autoremove \
    && rm -rf /var/lib/apt/lists/*

# Copy MATLAB install from supplied Docker image
RUN ln -s /usr/local/MATLAB/bin/matlab /usr/local/bin/matlab
COPY --from=matlab-install-stage /usr/local/MATLAB /usr/local/MATLAB
USER $NB_USER

# Downgrade Python to 3.8 - the MatLab for Python API requires this
RUN conda install -c conda-forge python=3.8 && \
    conda clean -a

# Install the Matlab for Python API
USER root
RUN cd /usr/local/MATLAB/extern/engines/python/ && \
    python setup.py install
USER $NB_USER

# Install the Matlab Kernel
RUN python -m pip install matlab_kernel

# Set the correct license server
ARG LICENSE_SERVER
ENV MLM_LICENSE_FILE $LICENSE_SERVER
