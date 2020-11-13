#!/bin/bash

if [ "$(uname -s)" != "Darwin" ]
then
  echo "Only Darwin (macOS) systems are supported with this tool.  Feel free to create a PR!"
  exit -1
fi

if [ "$(which brew)x" == "x" ]
then
  echo "Let's start with a sane homebrew environment, download https://brew.sh"
  exit -2
fi

if [ "$(which git)x" == "x" ]
then
  echo "Looks like there is no git.  Please install it and clone this repo instead of downloading it (we have submodules)"
  exit -3
fi

git submodule update --init --recursive --remote

brew bundle --file=- <<-EOS
brew "automake"
brew "autoconf"
brew "openssl"
brew "pkg-config"
brew "libtool"
brew "libplist"
brew "lzfse"
EOS

export COMMONCRYPTO=1
export PKG_CONFIG_PATH="/usr/local/opt/openssl/lib/pkgconfig"

make -C tools/dt
make -C tools/ldid
make -C tools/img4lib
make -C tools/termz


cp tools/dt/dt bin/
cp tools/ldid/ldid bin/
cp tools/img4lib/img4 bin/
cp tools/termz/termz bin/
