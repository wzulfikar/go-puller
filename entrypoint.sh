#!/bin/sh

keypair=${keypair_dir}/id_rsa

# generate ssh keypair if keypair doesn't exist, ie.
# when the container just started. this means that
# every new container will have different keypair.
if ! [ -f "$keypair" ]; then
	echo "generating new ssh keypair.."

	ssh-keygen -t dsa -N "" -C "" -f $keypair > /dev/null
	echo "✔ ssh keypair generated: ${keypair}"
fi

echo ""
echo "here's the public key of this container, shall you need"
echo "to use it as deploy key, repo read access, etc.:"
echo ""
cat ${keypair}.pub
echo ""

# execute command (the `CMD ["/main"]` in Dockerfile)
exec "$@"