# Jupyter Image setup with Matlab Kernel

Documentation of a Docker setup to build and deploy a Jupyter kernel for Matlab.
It contains both a Jupyter kernel that runs in the notebook as well as a proxy
kernel that opens the Matlab Web GUI from within JupyterLab.

## Prerequisites

This repository must either be cloned with the `--recursive` flag or you must call `git submodule update --init`.

You need the following tools installed:

* Docker

You should obtain the following files/pieces of information from your institution or your MathWorks account:

* The Matlab Installer ISO file. Tested version: `R2022b`
* Find out IP and port of your license server
* Your license key

You get those from Markus.

## Building the Image

Before building, you should edit the `matlab_installer_input.txt` file to enable the products
you would like to include into your image. Enabling all products results in an excessively large
Docker image.

To build the image, please do the following:

First get a current version of https://github.com/mathworks-ref-arch/matlab-dockerfile, then 

```
export MATLAB_ISOFILE=<path/to/isofile>
export MATLAB_LICENSE_KEY=<key>
export MATLAB_LICENSE_SERVER=<port>@<IP>

sudo -E ./build.sh matlab-jupyter:latest
```

In the above, the resulting image will be tagged `matlab-jupyter:latest` - change as needed.
For the SSC JupyterHub instance, you should tag the image `ssc-jupyter.iwr.uni-heidelberg.de:5000/matlab-jupyter:latest`.
Be patient, building this takes a while.

## Using the Image

You can run Jupyter from the image locally with this command:

```
docker run -t -p 8888:8888 matlab-jupyter:latest
```

## Deploying the Image

Do not publicly deploy the built image to avoid leaking licensing information!
Deploying to a private registry, e.g. `ssc-jupyter.iwr.uni-heidelberg.de:5000` is done with:

```
docker login ssc-jupyter.iwr.uni-heidelberg.de:5000
docker push ssc-jupyter.iwr.uni-heidelberg.de:5000/matlab-jupyter:latest
docker logout
```
