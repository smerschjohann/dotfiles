# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

export PATH=$PATH:/usr/local/go/bin:~/go/bin:~/bin:~/.dotfiles/bin
# set PATH so it includes user's private bin if it exists
if [ -d "$HOME/.local/bin" ]; then
    PATH="$HOME/.local/bin:$PATH"
fi

# where do you want to store your plugins?
ZPLUGINDIR=${ZPLUGINDIR:-${ZDOTDIR:-$HOME/.config/zsh}/plugins}

# get zsh_unplugged and store it with your other plugins
if [[ ! -d $ZPLUGINDIR/zsh_unplugged ]]; then
  git clone --quiet https://github.com/mattmc3/zsh_unplugged $ZPLUGINDIR/zsh_unplugged
fi
source $ZPLUGINDIR/zsh_unplugged/zsh_unplugged.plugin.zsh
# make list of the Zsh plugins you use
repos=(
  romkatv/powerlevel10k

  zpm-zsh/autoenv
  ChrisPenner/copy-pasta # copy pasta
  reegnz/jq-zsh-plugin
  Tarrasch/zsh-bd
  rupa/z
)
plugin-load $repos

autoload -Uz compinit && compinit
autoload -U bashcompinit && bashcompinit

source <(kubectl completion zsh)
complete -F __start_kubectl k
function kubectlgetall {
  for i in $(kubectl api-resources --verbs=list --namespaced -o name | grep -v "events.events.k8s.io" | grep -v "events" | sort | uniq); do
    echo "Resource:" $i
    kubectl -n ${1} get --ignore-not-found ${i}
  done
}

repos=(
  Aloxaf/fzf-tab
  zsh-users/zsh-completions
  zdharma-continuum/fast-syntax-highlighting
  zsh-users/zsh-history-substring-search
  zsh-users/zsh-autosuggestions
)
plugin-load $repos
unset repos


HISTFILE=~/.zsh_history
HISTSIZE=10000
SAVEHIST=10000
setopt SHARE_HISTORY


### key bindings
bindkey '^[[1;5D' backward-word
bindkey '^[[1;5C' forward-word

### aliases
alias k=kubectl
#alias ls='lsd'
alias ls="ls --color"
alias l='ls -l'
alias la='ls -a'
alias lla='ls -la'
alias lt='ls --tree'

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh
if [ $TILIX_ID ] || [ $VTE_VERSION ]; then
  source /etc/profile.d/vte-2.91.sh
fi

[[ ! -f ~/.zshrc-local ]] || source ~/.zshrc-local
