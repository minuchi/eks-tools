#!/bin/bash
# vim: ts=4 sw=4 sts=4 noet
# https://docs.aws.amazon.com/eks/latest/userguide/install-aws-iam-authenticator.html
set -eu

pkg="aws-iam-authenticator"
pkgname="aws-iam-authenticator"
version="1.21.2"

if [[ ! $(which $pkg) == "" ]]; then
	echo "$pkgname already installed."
	exit
fi

echo "Installing $pkgname..."
if [[ ! $(which brew) == "" ]]; then
	brew install $pkg
else
	os=$(uname -s | perl -ne 'print lc')
	tmpdir=$(mktemp -d)
	curl --silent -o "$tmpdir/aws-iam-authenticator" "https://amazon-eks.s3.us-west-2.amazonaws.com/$version/2021-07-05/bin/$os/amd64/aws-iam-authenticator"
	chmod +x "$tmpdir/$pkg"
	sudo mv "$tmpdir/$pkg" /usr/local/bin
	rm -rf $tmpdir
fi

echo "✅ $pkgname installed."
