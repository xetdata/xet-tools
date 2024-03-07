#! /bin/bash

OSTYPE=$( uname )

function install () {
  local DIST=$1
  local URL="https://github.com/xetdata/xet-tools/releases/latest/download/${DIST}.tar.gz"
  echo $URL
  curl -L -o git-xet.tar.gz $URL
  tar -xzf git-xet.tar.gz -C /usr/local/bin/ ; local CODE=$?
  rm git-xet.tar.gz
  return $CODE
}


if [[ $OSTYPE == "Darwin" ]]; then
  # install for macos
  echo "Installing git-xet for mac"
  install "xet-mac-universal"
  exit $?
fi

if [[ $OSTYPE != "Linux" ]]; then
  echo "Could not recognize operating system as Linux or MacOS; failed to install, please see instructions at https://xethub.com/assets/docs/getting-started/install"
  exit 1
fi

ARCH=$( uname -m )
DIST=""
case "$ARCH" in
  "x86_64")
    echo "installing for x86 linux"
    DIST="xet-linux-x86_64"
    ;;
  "arm64" | "aarch64")
    echo "installing for arm linux"
    DIST="xet-linux-aarch_64"
    ;;
  *)
    echo "Unsupported architecture: $ARCH; please see available installation options at https://xethub.com/assets/docs/getting-started/install"
esac

install $DIST
exit $?
