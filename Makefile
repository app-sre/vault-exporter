.PHONY: build clean deps image lint push vet

NAME := vault-exporter
VERSION=$(shell git describe --tags --abbrev=0 2>/dev/null | sed -r "s:^v::g")

IMAGE_NAME := quay.io/app-sre/vault-exporter
IMAGE_TAG := $(shell git rev-parse --short=7 HEAD)

ifneq (,$(wildcard $(CURDIR)/.docker))
    DOCKER_CONF := $(CURDIR)/.docker
else
    DOCKER_CONF := $(HOME)/.docker
endif

all: build

image:
	@docker build -t $(IMAGE_NAME):latest .
	@docker tag $(IMAGE_NAME):latest $(IMAGE_NAME):$(IMAGE_TAG)

image-push:
	@docker --config=$(DOCKER_CONF) push $(IMAGE_NAME):latest
	@docker --config=$(DOCKER_CONF) push $(IMAGE_NAME):$(IMAGE_TAG)

build: deps clean
	go build -ldflags '-d -s -w' -tags netgo -installsuffix netgo -o $(NAME)

clean:
	git clean -Xfd .

deps:
	go mod tidy
	go mod vendor
	go mod verify

vet:
	go vet -v ./...

lint:
	GO111MODULE=off go get -u github.com/golangci/golangci-lint/cmd/golangci-lint 
	$(GOPATH)/bin/golangci-lint run ./.../
