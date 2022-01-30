#!/bin/bash
# vim: ts=4 sw=4 sts=4 noet
# https://docs.aws.amazon.com/eks/latest/userguide/install-kubectl.html
set -eu

pkg="kubectl"
pkgname="kubectl"
version="1.21.2"

if [[ ! $(which $pkg) == "" ]]; then
	echo "$pkgname already installed."
	exit
fi

os=$(uname -s | perl -ne 'print lc')
tmpdir=$(mktemp -d)
echo "Installing $pkgname..."
curl -o "$tmpdir/$pkg" "https://amazon-eks.s3.us-west-2.amazonaws.com/$version/2021-07-05/bin/$os/amd64/kubectl"

sudo mv "$tmpdir/$pkg" /usr/local/bin

rm -rf $tmpdir
echo "✅ $pkgname installed."
