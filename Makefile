image: .image

.image: Dockerfile
	@docker build -t bsorahan/spatialite .
	@touch $@

test: .image
	@docker run -w /go/src/github.com/briansorahan/spatialite bsorahan/spatialite go test

.PHONY: image test
