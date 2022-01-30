#!/bin/bash
# vim: ts=4 sw=4 sts=4 noet
# https://helm.sh/docs/intro/install/
set -eu

pkg="helm"
pkgname="helm"

if [[ ! $(which $pkg) == "" ]]; then
	echo "$pkgname already installed."
	exit
fi

echo "Installing $pkgname..."
if [[ ! $(which brew) == "" ]]; then
	brew install $pkg
else
	os=$(uname -s | perl -ne 'print lc')
	tmpfile=$(mktemp)
	curl -fsSL -o $tmpfile "https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-3"

	chmod 700 $tmpfile

	$tmpfile

	rm -rf $tmpfile
fi

echo "✅ $pkgname installed."
