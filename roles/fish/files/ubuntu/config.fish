eval (/home/linuxbrew/.linuxbrew/bin/brew shellenv)

if status is-interactive
    # Commands to run in interactive sessions can go here
    source /home/linuxbrew/.linuxbrew/opt/asdf/libexec/asdf.fish
    fish_ssh_agent
end

source /home/linuxbrew/.linuxbrew/opt/asdf/libexec/asdf.fish

starship init fish | source

setenv STARSHIP_CONFIG ~/.config/starship.toml

setenv EDITOR nvim
