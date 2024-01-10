#!/bin/bash

source colors.sh

echo -e "${ARROW} ${CYAN}SSH keys${NC}"
if ! [[ -f "$SSH_DIR/authorized_keys" ]]; then
    echo -e "   ${RIGHT_ANGLE} ${CYAN}Generating SSH keys...${NC}"
    mkdir -p "$SSH_DIR"
    
    chmod 700 "$SSH_DIR"

    read -p "What is your email? " my_email
    ssh-keygen -t ed25519 -f "$SSH_DIR/id_rsa" -N "" -C "${my_email}"

    cat "$SSH_DIR/id_rsa.pub" >> "$SSH_DIR/authorized_keys"
fi