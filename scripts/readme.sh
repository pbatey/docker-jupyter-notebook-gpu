#!/bin/sh
# r | scipy | datascience | tensorflow

if [ $# -lt 1 ]; then
  echo "Usage: $(basename $0) <r|scipy|datascience|tensorflow>"
  exit 0
fi

type=$1

if [ $type = "datascience" -o $type = "tensorflow" ]; then
  scipy=scipy
fi

commit=$(cd docker-stacks && git rev-parse HEAD)

cat << EOF
## Overview

[Jupyter](https://jupyter.org/) built on top of [Nvidia/CUDA](https://developer.nvidia.com/cuda-zone) to take advantage of GPU acceleration.
See [jupyter/$type-notebook](https://hub.docker.com/r/jupyter/$type-notebook) and [nvidia/cuda](https://hub.docker.com/r/nvidia/cuda).

Running this image requires the [NVIDIA Container Toolkit 2.0][1] to be installed. Installation instructions can be found [here][2].

[1]: https://docs.nvidia.com/datacenter/cloud-native/container-toolkit/overview.html
[2]: https://docs.nvidia.com/datacenter/cloud-native/container-toolkit/install-guide.html

This image was built using the Dockerfiles from files from [jupyter/docker-stacks](https://github.com/jupyter/docker-stacks)
on GitHub, with the \`BASE_CONTAINER\` argument overridden.
See [GitHub](https://github.com/pbatey/docker-jupyter-notebook-gpu) for the Makefile that built this image.
## Tags and \`Dockerfile\` links

* [\`2021apr07\`,\`latest\`](https://github.com/jupyter/docker-stacks/tree/$commit)
EOF

# previous tags
cat << EOF
* [\`2021apr07\`](https://github.com/jupyter/docker-stacks/tree/6d61708f1747d4fb15e3c0166805ebb5fba41ea1)
* [\`2019jul12\`](https://github.com/jupyter/docker-stacks/tree/1e374527e15a532134f7ad40631c2c9c5f38e73b)

EOF

scripts/versions.sh $scipy $type
