default: build

.PHONY: build
build:
	podman build -t ocm-container .

.PHONY: clean
clean:
	podman rmi ocm-container