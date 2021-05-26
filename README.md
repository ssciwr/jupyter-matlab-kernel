# Jupyter Image setup with Matlab Kernel

Documentation of a Docker setup to build and deploy a Jupyter kernel for Matlab.

## Prerequisites

This repository must either be cloned with the `--recursive` flag or you must call `git submodule update --init`.

You need the following tools installed:

* Docker

You should obtain the following files/pieces of information from your institution or your MathWorks account:

* Obtain the Matlab Installer ISO file
* Find out IP and port of your license server
* Obtain your license key

## Building the Image

Before building, you should edit the `matlab_installer_input.txt` file to enable the products
you would like to include into your image. Enabling all products results in an excessively large
Docker image.

To build the image, please do the following:

```
export MATLAB_ISOFILE=<path/to/isofile>
export MATLAB_LICENSE_KEY=<key>
export MATLAB_LICENSE_SERVER=<port>@<IP>

sudo -E ./build-image.sh matlab-jupyter:latest
```

In the above, the resulting image will be tagged `matlab-jupyter:latest` - change as needed.
Be patient, building this takes a while.

## Using the Image

You can run Jupyter from the image locally with this command:

```
docker run -t -p 8888:8888 matlab-jupyter:latest
```

## Deploying the Image

Do not publicly deploy the built image to avoid leaking licensing information!
