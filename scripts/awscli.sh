#!/bin/bash
# vim: ts=4 sw=4 sts=4 noet
# https://docs.aws.amazon.com/cli/latest/userguide/getting-started-install.html
set -eu

pkg="aws"
pkgname="awscli"

if [[ ! $(which $pkg) == "" ]]; then
	echo "$pkgname already installed."
	exit
fi

os=$(uname -s)
tmpdir=$(mktemp -d)
echo "Installing $pkgname..."
if [[ $os == 'Darwin' ]]; then
	curl "https://awscli.amazonaws.com/AWSCLIV2.pkg" -o "$tmpdir/AWSCLIV2.pkg"
	sudo installer -pkg "$tmpdir/AWSCLIV2.pkg" -target /
else
	curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
	unzip awscliv2.zip -d $tmpdir
	sudo $tmpdir/aws/install
fi

rm -rf $tmpdir
echo "✅ $pkgname installed."
