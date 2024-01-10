#!/usr/bin/env bash
ROOT="$(pwd)"

source colors.sh

set -e

source .cisupport/is_ci.sh

set -e

main (){
    # "$ROOT/symlink-common.sh"

    if [[ $(uname -s) == "Darwin" ]]; then
        echo "Configuring mac"
        sudo -v
        # "$ROOT/config-osx.sh"
        "$ROOT/install-osx-dev-apps.sh"
        # "$ROOT/config-git.sh"
        # "$ROOT/install-osx-desktop-apps.sh"
        # "$ROOT/symlink-osx-dev-apps.sh"
    # elif [[ $(uname -s) == "Linux" ]]; then
    #     "$ROOT/install-linux.sh"
    elif [[ $(grep -i Microsoft /proc/version) ]]; then
        echo "Bash is running on WSL2"
        "$ROOT/init-wsl2-apps.sh"
        # "$ROOT/scripts/omf.sh"
        # "$ROOT/scripts/ssh.sh"
    fi
}

main

echo All Done!
echo Restarting shell
is_azure_devops || exec "$(which $SHELL)" -l