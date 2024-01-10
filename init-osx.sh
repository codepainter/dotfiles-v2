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
    brew update > /dev/null 2>&1
else
    echo -e "   ${RIGHT_ANGLE} ${CYAN}Attempting to install Homebrew${NC}"
    /usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
fi

brew bundle --file=Brewfiles/Brewfile.common
brew cleanup > /dev/null 2>&1

# Clone repository
if ! [[ -d "$DOTFILES_DIR" ]]; then
    echo -e "${ARROW} ${CYAN}Cloning repository: ${YELLOW}github.com/codepainter/dotfiles-v2${NC}"
    git clone --quiet "https://github.com/codepainter/dotfiles-v2.git" "$DOTFILES_DIR" 2>&1 > /dev/null
else
    echo -e "${ARROW} ${CYAN}Updating repository: ${YELLOW}github.com/codepainter/dotfiles-v2${NC}"
    git -C "$DOTFILES_DIR" pull --quiet > /dev/null
fi

# Update Galaxy
echo -e "${ARROW} ${CYAN}Updating Galaxy...${NC}"
ansible-galaxy install -r requirements.yml

# Set fish as default shell
if [[ $(echo $SHELL) != "/opt/homebrew/bin/fish" ]]; then
  echo -e "${ARROW} ${CYAN}Setting fish as default shell...${NC}"
  sudo sh -c "echo '/opt/homebrew/bin/fish' >> /etc/shells"
  chsh -s /opt/homebrew/bin/fish
fi

# Install Oh My Fish if not installed
echo -e "${ARROW} ${CYAN}Oh My Fish...${NC}"
if [[ ! -d "$HOME/.local/share/omf" ]]; then
  echo -e "${ARROW} ${CYAN}Installing Oh My Fish...${NC}"
  curl -L https://get.oh-my.fish | fish
else
  echo -e "   ${RIGHT_ANGLE} ${CYAN}Oh My Fish already installed${NC}"
fi
