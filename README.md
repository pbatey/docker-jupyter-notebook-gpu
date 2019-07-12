# docker-jupyter-notebook-gpu

This Makefile builds the [jupyter/r-notebook](https://hub.docker.com/r/jupyter/r-notebook)
[jupyter/scipy-notebook](https://hub.docker.com/r/jupyter/scipy-notebook), and
[jupyter/datascience-notebook](https://hub.docker.com/r/jupyter/datascience-notebook)
docker images using [nvidia/cuda](https://hub.docker.com/r/nvidia/cuda/) as a base image.

It pulls Dockerfiles and files down from [jupyter/docker-stacks](https://github.com/jupyter/docker-stacks)
on GitHub and overrides the `BASE_CONTAINER` argument.

`make all`

These images are available from DockerHub and were last built using **nvida/cuda:10.1-cudnn7-runtime-ubuntu18.04** as
the base container.

- [pbatey/jupyter-r-notebook-gpu](https://cloud.docker.com/repository/docker/pbatey/jupyter-r-notebook-gpu)
- [pbatey/jupyter-scipy-notebook-gpu](https://cloud.docker.com/repository/docker/pbatey/jupyter-scipy-notebook-gpu)
- [pbatey/jupyter-datascience-notebook-gpu](https://cloud.docker.com/repository/docker/pbatey/jupyter-datascience-notebook-gpu)

Running these images requires **docker-nvidia2** to be installed.
