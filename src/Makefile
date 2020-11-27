DOCKERFILES=$(shell find * -type f -name Dockerfile)
IMAGES=$(subst /, \:, $(subst /Dockerfile, , $(DOCKERFILES)))

.PHONY: all clean $(IMAGES)

cado: build hwloc openmpi gmp

hwloc: build

openmpi: build hwloc

gmp: build

$(IMAGES): %:
	docker build -t $@ $(subst :, /, $@)
