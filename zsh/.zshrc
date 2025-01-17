#Init secrets and env var for all system
if [ -f ~/.secrets ]; then
    . ~/.secrets
fi

# Create terraformrc with plugin cache directory
cat <<EOF > ~/.terraformrc 
plugin_cache_dir   = "$HOME/.terraform.d/plugin-cache"
EOF

# Add configuration to disable sending usage data to HashiCorp
cat <<EOF >> ~/.terraformrc 
disable_checkpoint = true

EOF

# Add GitLab credentials to terraformrc
cat <<EOF >> ~/.terraformrc 
credentials "$GITLAB_URL" {
  token = "$GITLAB_TOKEN"
}
EOF

#export variables VAULT
export VAULT_ADDR="$VAULT_URL"

#--------ALIASES -----------#
#---------------------------#

#--------ZSH------------#
alias reload-zsh="source ~/.zshrc"
alias edit-zsh="nvim ~/.zshrc"
alias zshconfig="nvim ~/.zshrc"

#----------NAS----------#
alias ssh-nas="ssh -p $NAS_PORT -L 8081:localhost:8081 -L 8086:localhost:8086 -L 5058:localhost:5058 -L 8123:localhost:8123 -L 8080:localhost:8080 -L 4755:localhost:4755 -L 9000:localhost:9000 -L 5000:localhost:5000 -L 3000:localhost:3000 -L 8099:localhost:8099 -L 8999:localhost:8999 $NAS_HOST"

#-----------Vault------#
alias vl="vault list"
alias vr="vault read"

#-------Docker-------#
alias dc="docker-compose"
alias docker="podman"
alias docker-compose="podman compose"
alias dc="docker-compose"


#------Kubernetes------#
alias k="kubectl"
alias kget="kubectl get"
alias kall="kubectl get all --all-namespaces"
alias kw="kubectl -o wide"

#------Terraform----#
alias assume=". assume"
alias tf="terraform"

alias cl="clear"

#------fzf-----#
alias ft="fzf --tmux"

#------Vim------#
# Open nvim with fzf preview
alias inv='nvim $(fzf --preview="bat --color=always {}")'
alias vim="nvim"
alias v="nvim"

# Merge all Brewfiles into one and install them using brew bundle
alias bbic="find ~/.config/brew/ -iname 'Brewfile*' -not -name 'Brewfile.lock.json' -exec cat {} +> /tmp/Brewfile && brew update && brew bundle install --file /tmp/Brewfile --cleanup && brew upgrade"

# Update AWS config with latest profiles configuration
alias awsup="granted sso populate --sso-region eu-west-1 $AWS_SSO_URL "

backup_dotfiles () {
    dotfilesbackupdir="$NAS_HOST:/var/services/homes/marc/backup"
    ssh_cmd="scp -O -P $NAS_PORT"
    scp -O -P $NAS_PORT ~/.bashrc "$dotfilesbackupdir"
    scp -O -P $NAS_PORT ~/.bash_history "$dotfilesbackupdir"
    scp -O -P $NAS_PORT ~/.zshrc "$dotfilesbackupdir"
    scp -O -P $NAS_PORT ~/.zsh_history "$dotfilesbackupdir"
    scp -O -P $NAS_PORT ~/.zshenv "$dotfilesbackupdir"
    scp -O -P $NAS_PORT ~/.terraformrc "$dotfilesbackupdir"
    scp -O -P $NAS_PORT -r ~/.aws "$dotfilesbackupdir"
    scp -O -P $NAS_PORT -r ~/.oh-my-zsh "$dotfilesbackupdir"
    
}

#--- ZSH config-----#
# Path to your oh-my-zsh installation.
export ZSH="/Users/$USER/.oh-my-zsh"

# Would you like to use another custom folder than $ZSH/custom?
ZSH_CUSTOM=~/.oh-my-zsh/custom

# Which plugins would you like to load?
# Standard plugins can be found in ~/.oh-my-zsh/plugins/*
# Custom plugins may be added to ~/.oh-my-zsh/custom/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
# Add wisely, as too many plugins slow down shell startup.
plugins=(git colorize cp zsh-autosuggestions web-search) 

source $ZSH/oh-my-zsh.sh

ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE="fg=cyan"


#---- kubectl auto complete----#
if [ /usr/local/bin/kubectl ]; then source <(kubectl completion zsh); fi

export NVM_DIR="/opt/homebrew/opt/nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

# Setup fzf key bindings and fuzzy completion
eval "$(fzf --zsh)"

# ----TheFuck-----
# thefuck alias
eval $(thefuck --alias)
eval $(thefuck --alias fk)

#-----Zoxide (better cd)----
eval "$(zoxide init zsh)"
#-----Eza better ls----#
alias ls="eza --color=always --long --git --no-filesize --icons=always --no-time --no-user --no-permissions"
alias lt="ls --tree"

#----ASDF----#
echo -e "\n. $(brew --prefix asdf)/libexec/asdf.sh" >> ${ZDOTDIR:-~}/.zshrc

# Should be at the end of the file for starship to work
eval "$(starship init zsh)"

. /opt/homebrew/opt/asdf/libexec/asdf.sh

. /opt/homebrew/opt/asdf/libexec/asdf.sh

. /opt/homebrew/opt/asdf/libexec/asdf.sh

. /opt/homebrew/opt/asdf/libexec/asdf.sh

. /opt/homebrew/opt/asdf/libexec/asdf.sh

. /opt/homebrew/opt/asdf/libexec/asdf.sh

. /opt/homebrew/opt/asdf/libexec/asdf.sh

. /opt/homebrew/opt/asdf/libexec/asdf.sh

. /opt/homebrew/opt/asdf/libexec/asdf.sh
