#!/usr/bin/env bash

source colors.sh

echo Configuring WSL2

set -e

source .cisupport/is_ci.sh

  echo -e "${ARROW} ${CYAN}Homebrew...${NC}"
# if [[ $(brew --version) ]] ; then
#     echo -e "   ${RIGHT_ANGLE} ${CYAN}Attempting to update Homebrew${NC}"
#     brew update
# else
#     echo -e "   ${RIGHT_ANGLE} ${CYAN}Attempting to install Homebrew${NC}"
#     /usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
# fi

echo -e "${ARROW} ${CYAN}Installing brew bundles${NC}"
echo -e "   ${RIGHT_ANGLE} ${CYAN}Installing common bundle${NC}"
# brew bundle --file=Brewfiles/Brewfile.common

# echo -e "   ${RIGHT_ANGLE} ${CYAN}Installing WSL2 bundle${NC}"
# brew bundle --file=Brewfiles/Brewfile.wsl2

# Cleanup
echo -e "${ARROW} ${CYAN}Cleaning up Brew${NC}"
# brew cleanup

# Update Galaxy
echo -e "${ARROW} ${CYAN}Updating Galaxy...${NC}"
ansible-galaxy install -r requirements.yml 2>&1 > /dev/null

if ! [[ -f "$IS_FIRST_RUN" ]]; then
    echo -e "${CHECK_MARK} ${GREEN}First run complete!${NC}"
    echo -e "${ARROW} ${CYAN}Please reboot your computer to complete the setup.${NC}"
    touch "$IS_FIRST_RUN"
fi

# Run playbook
echo -e "${ARROW} ${CYAN}Running playbook...${NC}"
if [[ -f $VAULT_SECRET ]]; then
    echo -e "${ARROW} ${CYAN}Using vault config file...${NC}"
    ansible-playbook --vault-password-file $VAULT_SECRET "$DOTFILES_DIR/main.yml" "$@"
else
    echo -e "${WARNING} ${CYAN}Vault config file not found...${NC}"
    ansible-playbook "$DOTFILES_DIR/main.yml" "$@"
fi