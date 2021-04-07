#!/bin/sh

if [ $# -gt 0 ]; then
  args=$*
else
  args="r scipy datascience tensorflow"
fi

user=pbatey

base=$(grep BASE_CONTAINER Makefile | awk -F'=' '{gsub(/ /,""); print $2; exit}')
commit=$(cd docker-stacks && git rev-parse HEAD)
short=$(cd docker-stacks && git rev-parse --short HEAD)

notebookver=$(awk -F"'" '/notebook=/ {gsub("notebook=","",$2); print $2}' Dockerfile.base-notebook)
labver=$(awk -F"'" '/jupyterlab=/ {gsub("jupyterlab=","",$2); print $2}' Dockerfile.base-notebook)
hubver=$(awk -F"'" '/jupyterhub=/ {gsub("jupyterhub=","",$2); print $2}' Dockerfile.base-notebook)

pythonver=$(docker run --rm -t $user/jupyter-base-notebook-gpu python --version | tr -d '\r' | awk '{print $2}')
juliaver=$(awk -F'"' '/julia_version=/ {print $2}' Dockerfile.datascience-notebook)
rver=$(awk -F"'" '/r-base=/ {gsub("r-base=","",$2); print $2}' Dockerfile.r-notebook)
tsver=$(awk -F"'" '/tensorflow==/ {gsub("tensorflow==","",$2); print $2}' Dockerfile.tensorflow-notebook)

tag=$(date +%Y%h%d | tr '[:upper:]' '[:lower:]')


cat << EOF
## \`$tag\` Software Versions and \`Dockerfile\` stack

* **Jupyter Hub version** $hubver
* **Jupyter Lab version** $labver
* **Jupyter Notebook version** $notebookver
* **Python version** $pythonver
EOF

for arg in $args; do
  if [ $arg = "r" ]; then echo "* **R version** $rver"; fi
  if [ $arg = "datascience" ]; then echo "* **Julia version** $juliaver"; fi
  if [ $arg = "tensorflow" ]; then echo "* **Tensorflow version** $tsver"; fi
done

cat << EOF

| Dockerfile (\`-f\`)                           | Tagged As (\`-t\`)                        | Base Container (\`--build-arg BASE_CONTAINER=\`)
|-----------------------------------------------|-----------------------------------------|------------------------------------------------
| [base-notebook/Dockerfile][$short-base]       | pbatey/jupyter-base-notebook-gpu        | nvidia/cuda:11.2.2-cudnn8-runtime-ubuntu20.04
| [minimal-notebook/Dockerfile][$short-minimal] | pbatey/jupyter-minimal-notebook-gpu     | pbatey/jupyter-base-notebook-gpu
EOF

for arg in $args; do
  if [ $arg = "r" -o $arg = "scipy" ]; then
    echo "| [$arg-notebook/Dockerfile][$short-$arg] | pbatey/jupyter-$arg-notebook-gpu | pbatey/jupyter-minimal-notebook-gpu"
  else
    echo "| [$arg-notebook/Dockerfile][$short-$arg] | pbatey/jupyter-$arg-notebook-gpu | pbatey/jupyter-scipy-notebook-gpu"
  fi
done

cat << EOF

[$short-base]: https://github.com/jupyter/docker-stacks/tree/$commit/base-notebook/Dockerfile
[$short-minimal]: https://github.com/jupyter/docker-stacks/tree/$commit/minimal-notebook/Dockerfile
EOF

for arg in $args; do
  echo "[$short-$arg]: https://github.com/jupyter/docker-stacks/tree/$commit/$arg-notebook/Dockerfile"
done
