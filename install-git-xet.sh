#! /bin/bash

OSTYPE=$( uname )

function install () {
  local DIST=$1
  local URL="https://github.com/xetdata/xet-tools/releases/latest/download/${DIST}.tar.gz"
  echo $URL
  curl -L -o git-xet.tar.gz $URL
  tar -xzf git-xet.tar.gz -C /usr/local/bin/ ; local CODE=$?
  rm git-xet.tar.gz
  git xet install
  return $CODE
}

function login() {
  local username=$1
  local email=$2
  local token=$3
  local host=$4
 
  if [ $host ]
  then
    echo "Authenticating with ${host}..."
    git xet login -u $username -e $email -p $token --host $host; local CODE=$?
  else
    echo "Authenticating with XetHub.com..."
    git xet login -u $username -e $email -p $token ; local CODE=$?
  fi
  return $CODE
}

while getopts ":u:e:p:h" opt; do
  case $opt in
    u) username="$OPTARG"
    ;;
    e) email="$OPTARG"
    ;;
    p) token="$OPTARG"
    ;;
    h) host="$OPTARG"
    ;;
    \?) echo "Invalid option -$OPTARG" >&2
    exit 1
    ;;
  esac

  case $OPTARG in
    -*) echo "Option $opt needs a valid argument"
    exit 1
    ;;
  esac
done

echo "$username $email $token $host"


if [[ $OSTYPE == "Darwin" ]]; then
  # install for macos
  echo "Installing git-xet for mac"
  install "xet-mac-universal"
  login $username $email $token $host
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
login $username $email $token $host

exit $?
