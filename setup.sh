#!/usr/bin/env bash
ROOT="$(pwd)"

source colors.sh

set -e

# Paths
CONFIG_DIR="$HOME/.config/dotfiles"
VAULT_SECRET="$HOME/.ansible-vault/vault.secret"
DOTFILES_DIR="$HOME/.dotfiles"
SSH_DIR="$HOME/.ssh"
IS_FIRST_RUN="$HOME/.dotfiles_run"

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
    fi
}

main

echo All Done!
echo Restarting shell
is_azure_devops || exec "$(which $SHELL)" -l