BASE_CONTAINER := nvidia/cuda:11.2.2-cudnn8-runtime-ubuntu20.04
BASE_NOTEBOOKS := base minimal
NOTEBOOKS := r scipy datascience tensorflow
BASE_IMAGES := $(BASE_NOTEBOOKS:%=jupyter-%-notebook-gpu)
PUSH_IMAGES := $(NOTEBOOKS:%=jupyter-%-notebook-gpu)
IMAGES := $(BASE_IMAGES) $(PUSH_IMAGES)
JUPYTER_DOCKER_STACKS := https://raw.githubusercontent.com/jupyter/docker-stacks/master
DOCKER_FILES := $(BASE_NOTEBOOKS:%=Dockerfile.%-notebook) $(NOTEBOOKS:%=Dockerfile.%-notebook)
USER := pbatey
TAGS := latest cuda-11.2.2 cudnn-8 ubuntu-20.04 

.PHONY: all
all: docker-stacks $(IMAGES)

docker-stacks:
	git clone https://github.com/jupyter/docker-stacks.git

.PHONY: docker-files
docker-files: $(DOCKER_FILES)
$(DOCKER_FILES):
	cp docker-stacks/$(subst .,,$(suffix $@))/Dockerfile $@

# images are phony targets that don't end up as files

# dependencies for build order
jupyter-minimal-notebook-gpu: jupyter-base-notebook-gpu
jupyter-r-notebook-gpu: jupyter-minimal-notebook-gpu
jupyter-scipy-notebook-gpu: jupyter-minimal-notebook-gpu
jupyter-datascience-notebook-gpu: jupyter-scipy-notebook-gpu
jupyter-tensorflow-notebook-gpu: jupyter-scipy-notebook-gpu

# base image from cuda base
jupyter-base-notebook-gpu: Dockerfile.base-notebook
	make depends
	@echo Building $@ ...
	docker build --build-arg BASE_CONTAINER=$(BASE_CONTAINER) -f $< -t $(USER)/$@ . > build.log

# other images
jupyter-%-gpu: Dockerfile.%
	make depends
	@echo Building $@ ...
	@echo docker build --build-arg BASE_CONTAINER=$(USER)/$$(awk -F'=' '/ARG BASE_CONTAINER/ {gsub("/","-",$$2); print $$2}' $<)-gpu -f $< -t $(USER)/$@ . \>\> build.log
	@docker build --build-arg BASE_CONTAINER=$(USER)/$$(awk -F'=' '/ARG BASE_CONTAINER/ {gsub("/","-",$$2);print $$2}' $<)-gpu -f $< -t $(USER)/$@ . >> build.log

.PHONY: clean
clean:
	rm -f Dockerfile.*-notebook
	@if [ -f .cleanme ]; then \
    echo "rm -f $$(cat .cleanme) .cleanme"; \
    rm -f $$(cat .cleanme) .cleanme; \
  fi;
	rm -f build.log

# copy any files referenced in an ADD or COPY line
.PHONY: depends
depends:
	@ \
  echo rm -f .cleanme; \
  rm -f .cleanme; \
  awk '/ADD/||/COPY/ {$$1="";$$NF="";print FILENAME, $$0}' Dockerfile.*-notebook | \
    while read docker files; do \
      echo "$$files" | tr ' ' '\n' | while read file; do \
        echo "echo $${file} >> .cleanme"; \
        echo $${file} >> .cleanme; \
        if [ ! -f $$file ]; then \
          echo cp docker-stacks/$${docker##*.}/$${file} $${file}; \
          cp docker-stacks/$${docker##*.}/$${file} $${file}; \
          echo chmod +x $${file}; \
          chmod +x $${file}; \
        fi;\
      done;\
    done

.PHONY: tag
tag:
	@\
  tag=$$(date +%Y%h%d | tr '[:upper:]' '[:lower:]'); \
  for image in $(IMAGES); do \
    echo docker tag $(USER)/$$image $(USER)/$$image:$$tag; \
    docker tag $(USER)/$$image $(USER)/$$image:$$tag; \
  done; \
  echo;echo "Use the following commands to push";echo; \
  for image in $(PUSH_IMAGES); do \
    echo " " docker push $(USER)/$$image:$$tag; \
  done; \
  echo;echo "Use the following commands to update the image descriptions";echo; \
  for image in $(PUSH_IMAGES); do \
    echo " " scripts/docker-doc.sh $(USER)/$$image docker-overview.md; \
  done
