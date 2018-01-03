# . $HOME/z.sh
MANPATH="/usr/local/man:$MANPATH"
# Uncomment this to disable bi-weekly auto-update checks
DISABLE_AUTO_UPDATE="true"
# Uncomment following line if you want to disable autosetting terminal title.
DISABLE_AUTO_TITLE="true"
# Uncomment following line if you want to disable command autocorrection
DISABLE_CORRECTION="true"
ZSH_CUSTOM=$HOME/.zsh

#=============================
# User configuration
#=============================
# Which plugins would you like to load? (plugins can be found in ~/.oh-my-zsh/plugins/*)
# Custom plugins may be added to ~/.oh-my-zsh/custom/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
source "${HOME}/.zgen/zgen.zsh"
source '/opt/homebrew-cask/Caskroom/google-cloud-sdk/latest/google-cloud-sdk/path.zsh.inc'
source '/opt/homebrew-cask/Caskroom/google-cloud-sdk/latest/google-cloud-sdk/completion.zsh.inc'
# check if there's no init script
if ! zgen saved; then
    echo "Creating a zgen save"

    zgen oh-my-zsh

    # plugins
    zgen oh-my-zsh plugins/git
    zgen oh-my-zsh plugins/brew
    zgen oh-my-zsh plugins/bundler
    zgen oh-my-zsh plugins/common-aliases
    zgen oh-my-zsh plugins/gem
    zgen oh-my-zsh plugins/golang
    zgen oh-my-zsh plugins/httpie
    zgen oh-my-zsh plugins/kubectl
    zgen oh-my-zsh plugins/ruby
    zgen oh-my-zsh plugins/vagrant
    zgen oh-my-zsh plugins/z
    zgen load skx/sysadmin-util
    zgen load tevren/git-zsh-plugin
    zgen load tevren/gitfast-zsh-plugin
    zgen load tevren/tmux_pane_words
    zgen load Valodim/zsh-curl-completion
    zgen load zsh-users/zsh-syntax-highlighting
    # theme
    zgen load tevren/AnuTheme AnuTheme

    # save all to init script
    zgen save
fi
# zgen init


#******************************
#* Settings
#******************************
setopt always_last_prompt
setopt always_to_end # Completion within a word always moves to the end of the word
setopt append_history # Don't overwrite history, append to it
setopt auto_cd # cd with "DIR" instead of "cd DIR"
setopt auto_list # Automatically list choices on an ambiguous completion
setopt autopushd # Make cd push the old directory onto the directory stack
setopt complete_in_word # Allow tab completion in the middle of a word
setopt extended_glob
setopt glob_complete # Expland regexes with tab
setopt hist_ignore_all_dups # Prevent duplicate commands from occuring in the history
setopt hist_ignore_dups # Don't push multiple copies of the same directory onto the directory stack
setopt hist_ignore_space # Don't put cmds starting with <space> into history
setopt hist_reduce_blanks # Strip extra white space from cmds before adding them to history
setopt hist_save_no_dups
setopt ignore_eof # Do not exit on end-of-file (i.e. when ^D is pressed).
setopt inc_append_history # Write to history file after every command
setopt interactive_comments # Allow comments even in interactive shells
setopt multios # Allow redirecting to multiple files at once
setopt no_beep # Disable beeping noises
setopt nobgnice # Do not change the nice (ie, scheduling priority) of backgrounded commands.
setopt nocheckjobs # Do not warn about closing the shell with background jobs running.
setopt no_share_history # Don't share history between zsh sessions
setopt null_glob # Do not display error when there are no matches to a glob
setopt numeric_glob_sort # Sort filenames numerically when it makes sense.
setopt pushd_ignore_dups # Prevent duplicate dirs pushed onto dir stack
setopt pushd_minus
setopt pushd_silent # No annoying pushd messages
setopt pushd_to_home # Sort filenames numerically when it makes sense.

unsetopt auto_remove_slash
unsetopt case_glob
unsetopt correct_all
unsetopt list_ambiguous
unset MAILCHECK # Don't check for new mail

for file in ~/.{path,exports,aliases,functions,extra}; do
  [ -r "$file" ] && [ -f "$file" ] && source "$file"
done
unset file

#=============================
# zsh-autosuggestions
#=============================
if [ -f ~/.zsh-autosuggestions/autosuggestions.zsh ]; then
    source ~/.zsh-autosuggestions/autosuggestions.zsh
    # Enable autosuggestions automatically
    zle-line-init() {
        zle autosuggest-start
    }
    zle -N zle-line-init
    bindkey '^t' autosuggest-toggle
    bindkey '^F' vi-forward-blank-word
    bindkey '^f' vi-forward-word
fi

autoload -Uz compinit && compinit
autoload -Uz colors && colors

#=============================
# compeletions
#=============================
# Gray out already typed characters of completions
zstyle -e ':completion:*:default' list-colors \
  'reply=("${PREFIX:+=(#bi)($PREFIX:t)(?)*==90=0}:${(s.:.)LS_COLORS}")'
# zstyle ':completion:*' list-colors ${(s.:.)LS_COLORS} # Color completions the same way ls does

# Completion order
zstyle ':completion:*' completer _complete _list _oldlist _expand _ignored _match \
                         _prefix # _correct _approximate TODO approximate causes lag for autocompletion, and _correct makes "~/documents/randomstring<TAB>" to turn into ""

# Allow some spelling errors when completing (more for longer strings)
zstyle -e ':completion:*:approximate:*' max-errors 'reply=( $(( ($#PREFIX+$#SUFFIX)/3 )) numeric )'

zstyle ':completion::prefix-1:*' completer _complete
zstyle ':completion:predict:*' completer _complete
zstyle ':completion:incremental:*' completer _complete # TODO disabled until _correct is enabled in completions_correct

#Order of dirs in autocompletion
zstyle ':completion:*:*:cd:*' tag-order local-directories directory-stack path-directories

#Completion caching
zstyle ':completion::complete:*' use-cache on
zstyle ':completion::complete:*' cache-path .zsh/cache/$HOST

zstyle ':completion:*' expand 'yes' #Expand partial paths
zstyle ':completion:*' squeeze-slashes 'yes' # Removes last slash if you use a directory as an arg
zstyle ':completion:*' insert-tab false
# Case-insensitive, partial-word and then substring completion
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Z}' 'r:|[._-]=* r:|=*' 'l:|=* r:|=*'
#Kill processes
zstyle ':completion:*:*:kill:*:processes' list-colors '=(#b) #([0-9]#)*=0=01;31'
zstyle ':completion:*:kill:*' command 'ps -u $USER -o pid,%cpu,tty,cputime,cmd'
# Don't keep suggesting file / pid if it is on the line already
zstyle ':completion:*:(rm|kill|diff):*' ignore-line yes

# Less users
users=($USER root)
zstyle ':completion:*' users $users

eval "$(pyenv init -)"
eval "$(pyenv virtualenv-init -)"
