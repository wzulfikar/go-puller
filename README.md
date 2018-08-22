### go-puller

a single-endpoint server that does `git pull` for you.

### Use case:

automatically pull the repo at your vps by sending a webhook request (ie. on git push). 

- add changes to repo
- trigger a request to go-puller endpoint when there's a new push (ie. via github webhook)
- go-puller handles the request and pull your repo

### Usage

#### using binary:

```
# build the binary (you need to have `go` installed):
CGO_ENABLED=0 go build -a -installsuffix cgo -o go-puller .

# run the binary in your repo directory
REPO_PATH=$(pwd) go-puller
```

#### using docker (preferred):

```
docker run --rm -v $(pwd):/repo -p 9999:9999 wzulfikar/go-puller
```

---

above commands will make go-puller available at localhost:9999. once the server is running, you can use simple `curl` to test if the puller can handle the request:

```
curl localhost:9999
```
