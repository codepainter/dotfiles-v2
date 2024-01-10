#!/usr/bin/env bash

source colors.sh

echo Configuring mac

set -e

source .cisupport/is_ci.sh

  echo -e "${ARROW} ${CYAN}XCode command tools...${NC}"
if [[ $(xcode-select --version) ]]; then
  echo -e "   ${RIGHT_ANGLE} ${CYAN}Xcode command tools already installed${NC}"
else
  echo -e "${ARROW} ${CYAN}Installing Xcode commandline tools...${NC}"
  $(xcode-select --install)
fi

  echo -e "${ARROW} ${CYAN}Homebrew...${NC}"
if [[ $(brew --version) ]] ; then
    echo -e "   ${RIGHT_ANGLE} ${CYAN}Attempting to update Homebrew${NC}"
    brew update
else
    echo -e "   ${RIGHT_ANGLE} ${CYAN}Attempting to install Homebrew${NC}"
    /usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
fi

brew bundle --file=Brewfiles/Brewfile.common
brew cleanup

