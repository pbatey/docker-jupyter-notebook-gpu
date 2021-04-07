# docker-jupyter-notebook-gpu

Makefile that builds [Jupyter](https://jupyter.org/) on top of [nvidia/cuda](https://hub.docker.com/r/nvidia/cuda) to take advantage of GPU accelleration.

It clones [jupyter/docker-stacks](https://github.com/jupyter/docker-stacks), copies Dockerfiles and files referenced by `ADD` or `COPY`, and
overrides the `BASE_CONTAINER` argument in the stack of Dockerfiles.

    make all

These images are available from DockerHub:

- [pbatey/jupyter-r-notebook-gpu](https://cloud.docker.com/repository/docker/pbatey/jupyter-r-notebook-gpu)
- [pbatey/jupyter-scipy-notebook-gpu](https://cloud.docker.com/repository/docker/pbatey/jupyter-scipy-notebook-gpu)
- [pbatey/jupyter-datascience-notebook-gpu](https://cloud.docker.com/repository/docker/pbatey/jupyter-datascience-notebook-gpu)
- [pbatey/jupyter-tensorflow-notebook-gpu](https://cloud.docker.com/repository/docker/pbatey/jupyter-tensorflow-notebook-gpu)

Running these images requires the [NVIDIA Container Toolkit 2.0][1] to be installed. Installalation instructions can be found [here][2].

[1]: https://docs.nvidia.com/datacenter/cloud-native/container-toolkit/overview.html
[2]: https://docs.nvidia.com/datacenter/cloud-native/container-toolkit/install-guide.html

## [jupyter/docker-stacks](https://github.com/jupyter/docker-stacks) Dockerfiles

| Dockerfile (`-f`)                     | Tagged As (`-t`)                        | Base Container (`--build-arg BASE_CONTAINER=`)
|---------------------------------------|-----------------------------------------|------------------------------------------------
| [base-notebook/Dockerfile][1]         | pbatey/jupyter-base-notebook-gpu        | nvidia/cuda:11.2.2-cudnn8-runtime-ubuntu20.04
| [minimal-notebook/Dockerfile][2]      | pbatey/jupyter-minimal-notebook-gpu     | pbatey/jupyter-base-notebook-gpu
| [r-notebook/Dockerfile][3]            | pbatey/jupyter-r-notebook-gpu           | pbatey/jupyter-minimal-notebook-gpu
| [scipy-notebook/Dockerfile][4]        | pbatey/jupyter-scipy-notebook-gpu       | pbatey/jupyter-minimal-notebook-gpu
| [datascience-notebook/Dockerfile][5]  | pbatey/jupyter-datascience-notebook-gpu | pbatey/jupyter-scipy-notebook-gpu
| [tensorflow-notebook/Dockerfile][6]   | pbatey/jupyter-tensorflow-notebook-gpu  | pbatey/jupyter-scipy-notebook-gpu

[1]: https://github.com/jupyter/docker-stacks/blob/master/base-notebook/Dockerfile
[2]: https://github.com/jupyter/docker-stacks/blob/master/minimal-notebook/Dockerfile
[3]: https://github.com/jupyter/docker-stacks/blob/master/r-notebook/Dockerfile
[4]: https://github.com/jupyter/docker-stacks/blob/master/scipy-notebook/Dockerfile
[5]: https://github.com/jupyter/docker-stacks/blob/master/datascience-notebook/Dockerfile
[6]: https://github.com/jupyter/docker-stacks/blob/master/tensorflow-notebook/Dockerfile

## Support scripts

You can generate useful a Readme for updating docker hub:

    scripts/readme.md <type> | pbcopy

Where type is one of `r`, `scipy`, `datascience`, or `tensorflow`.
