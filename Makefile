image_name := wzulfikar/go-puller

build:
	# you need to have `go` installed to build the binary.
	# disable CGO option so we can have a static binary.
	CGO_ENABLED=0 GOOS=linux go build -a -installsuffix cgo -o ./go-puller .
	docker build -t ${image_name} .

push:
	docker tag ${image_name} ${image_name}:latest
	docker push ${image_name}:latest
