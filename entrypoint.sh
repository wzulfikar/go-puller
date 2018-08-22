#!/bin/sh

echo "here's the public key of this container shall you need"
echo "to use it as deploy key, repo read access, etc.:"
echo ""
cat /root/.ssh/id_rsa.pub
echo ""

# execute command (the `CMD ["/main"]` in Dockerfile)
exec "$@"