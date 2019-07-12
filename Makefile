BASE_CONTAINER := nvidia/cuda:10.1-cudnn7-runtime-ubuntu18.04
NOTEBOOKS := base minimal r scipy datascience
IMAGES := $(NOTEBOOKS:%=jupyter-%-notebook-gpu)
DOCKER_STACKS := https://raw.githubusercontent.com/jupyter/docker-stacks/master
DOCKER_FILES := $(NOTEBOOKS:%=Dockerfile.%-notebook)
USER := pbatey

.PHONY: all
all: $(IMAGES)

$(DOCKER_FILES):
	curl $(DOCKER_STACKS)/$(subst .,,$(suffix $@))/Dockerfile > $@

# images are phony targets that don't end up as files

# dependencies
jupyter-minimal-notebook-gpu: jupyter-base-notebook-gpu
jupyter-r-notebook-gpu: jupyter-minimal-notebook-gpu
jupyter-scipy-notebook-gpu: jupyter-minimal-notebook-gpu
jupyter-datascience-notebook-gpu: jupyter-scipy-notebook-gpu

# base image from cuda base
jupyter-base-notebook-gpu: Dockerfile.base-notebook
	make depends
	@echo Building $@ ...
	docker build --build-arg BASE_CONTAINER=$(BASE_CONTAINER) -f $< -t $(USER)/$@ . > build.log

# other images
jupyter-%-gpu: Dockerfile.%
	make depends
	@echo Building $@ ...
	@echo docker build --build-arg BASE_CONTAINER=$$(awk -F'=' '/ARG BASE_CONTAINER/ {print $$2}' $<)-gpu -f $< -t $(USER)/$@ . \>\> build.log
	@docker build --build-arg BASE_CONTAINER=$$(awk -F'=' '/ARG BASE_CONTAINER/ {print $$2}' $<)-gpu -f $< -t $(USER)/$@ . >> build.log

.PHONY: clean
clean:
	rm Dockerfile.*-notebook

.PHONY: depends
depends:
	@awk '/ADD/||/COPY/ {print FILENAME, $$2}' Dockerfile.*-notebook | \
    while read docker file; do if [ ! -f $$file ]; then \
       echo curl $(DOCKER_STACKS)/$${docker##*.}/$${file} \> $${file}; \
       curl $(DOCKER_STACKS)/$${docker##*.}/$${file} > $${file}; \
       echo chmod +x $${file}; \
       chmod +x $${file}; \
    fi;done
