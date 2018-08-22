image_name := wzulfikar/go-puller

build-go:
	# you need to have `go` installed to build the binary.
	# disable CGO option so we can have a static binary.
	CGO_ENABLED=0 GOOS=linux go build -a -installsuffix cgo -o ./go-puller .

build:
	docker build -t ${image_name}:latest .

push:
	docker push ${image_name}:latest
