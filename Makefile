GO_SRC = $(wildcard *.go)
IMG    = bsorahan/spatialite

image: .image

.image: Dockerfile $(GO_SRC)
	@docker build -t $(IMG) .
	@touch $@

push: image
	@docker push $(IMG)

test: .image
	@docker run -v $(shell pwd):/root -w /root $(IMG) go test -v

clean:
	@rm -rf .image

.PHONY: clean image push test
