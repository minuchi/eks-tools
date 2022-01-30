#!/bin/bash
# vim: ts=4 sw=4 sts=4 noet
# https://docs.aws.amazon.com/eks/latest/userguide/eksctl.html
set -eu

pkg="eksctl"
pkgname="eksctl"

if [[ ! $(which $pkg) == "" ]]; then
	echo "$pkgname already installed."
	exit
fi


echo "Installing $pkgname..."
if [[ ! $(which brew) == "" ]]; then
	brew tap weaveworks/tap && \
	brew install weaveworks/tap/$pkg
else
	tmpdir=$(mktemp -d)

	curl --silent --location "https://github.com/weaveworks/eksctl/releases/latest/download/eksctl_$(uname -s)_amd64.tar.gz" | tar xz -C $tmpdir
	sudo mv $tmpdir/$eksctl /usr/local/bin

	rm -rf $tmpdir
fi

echo "✅ $pkgname installed."
