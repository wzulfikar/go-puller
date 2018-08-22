package main

import (
	"fmt"
	"log"
	"net/http"
	"os"
	"strings"

	git "gopkg.in/src-d/go-git.v4"
	"gopkg.in/src-d/go-git.v4/plumbing/object"
)

func main() {
	port := os.Getenv("PORT")
	if port == "" {
		port = "9999"
	}

	path := os.Getenv("REPO_PATH")
	if path == "" {
		log.Println("using default value '/repo' for env var `REPO_PATH`")
		path = "/repo"
	}

	log.Println("repo path set:", path)
	log.Println("listening at port", port)

	http.HandleFunc("/", pullHandler(path))
	if err := http.ListenAndServe(":"+port, nil); err != nil {
		panic(err)
	}
}

func pullHandler(path string) func(w http.ResponseWriter, r *http.Request) {
	const upToDateMsg = "already up-to-date"

	return func(w http.ResponseWriter, r *http.Request) {
		if r.URL.Path != "/" {
			w.WriteHeader(http.StatusNotFound)
			w.Write([]byte("404 page not found"))
			return
		}

		var msg string

		commit, err := pull(path)

		var hash string
		if commit != nil {
			hash = fmt.Sprintf("%s", commit.Hash)[:8]
		}

		if err != nil {
			if strings.Contains(err.Error(), upToDateMsg) {
				msg = fmt.Sprintf("%s: %s", upToDateMsg, hash)
			} else {
				msg = fmt.Sprintf("pull failed: %s", err)
			}
		} else {
			msg = fmt.Sprintf("pull completed. current commit head: %s", hash)
			log.Println(commit)
		}

		w.Write([]byte(msg))
		log.Println(msg)
	}
}

func pull(path string) (*object.Commit, error) {
	log.Println("pulling repo..")

	// instantiate a new repository targeting the given path (the .git folder)
	r, err := git.PlainOpen(path)
	if err != nil {
		return nil, err
	}

	// Get the working directory for the repository
	w, err := r.Worktree()
	if err != nil {
		return nil, err
	}

	// Pull the latest changes from the origin remote and merge into the current branch
	pullErr := w.Pull(&git.PullOptions{RemoteName: "origin"})

	// Print the latest commit that was just pulled
	ref, err := r.Head()
	if err != nil {
		return nil, err
	}

	commit, err := r.CommitObject(ref.Hash())
	if err != nil {
		return nil, err
	}

	return commit, pullErr
}
