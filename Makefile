GO_SRC			= $(wildcard *.go)

image: .image

.image: Dockerfile $(GO_SRC)
	@docker build -t bsorahan/spatialite .
	@touch $@

test: .image
	@docker run -w /go/src/github.com/briansorahan/spatialite bsorahan/spatialite go test -v

clean:
	@rm -rf .image

.PHONY: clean image test
