PROMPT='%{$fg[blue]%}%n%{$reset_color%} on %{$fg[red]%}%M%{$reset_color%} in %{$fg[blue]%}%~$(git_time_since_commit)%{$reset_color%}$(check_git_prompt_info)
$ '

ZSH_THEME_GIT_PROMPT_PREFIX="%{$fg[white]%}"
ZSH_THEME_GIT_PROMPT_SUFFIX="%{$reset_color%})"

# Text to display if the branch is dirty
ZSH_THEME_GIT_PROMPT_DIRTY="%{$fg[red]%}*%{$reset_color%}" 

# Text to display if the branch is clean
ZSH_THEME_GIT_PROMPT_CLEAN="" 

# Colors vary depending on time lapsed.
ZSH_THEME_GIT_TIME_SINCE_COMMIT_SHORT="%{$fg[green]%}"
ZSH_THEME_GIT_TIME_SHORT_COMMIT_MEDIUM="%{$fg[yellow]%}"
ZSH_THEME_GIT_TIME_SINCE_COMMIT_LONG="%{$fg[red]%}"
ZSH_THEME_GIT_TIME_SINCE_COMMIT_NEUTRAL="%{$fg[cyan]%}"


# Git sometimes goes into a detached head state. git_prompt_info doesn't
# return anything in this case. So wrap it in another function and check
# for an empty string.
function check_git_prompt_info() {
    if git rev-parse --git-dir > /dev/null 2>&1; then
        if [[ -z $(git_prompt_info) ]]; then
            echo "%{$reset_color%}[%{$fg[magenta]%}detached-head%{$reset_color%}]"
        else
            echo "%{$reset_color%}[${$(git_prompt_info)/)/}%{$reset_color%}]"
        fi
    fi
}

# Determine if we are using a gemset.
function gemset() {
    if [[ -f .ruby-gemset ]]; then
        GEMSET=`cat .ruby-gemset`
        echo "%{$reset_color%}[%{$fg[yellow]%}$GEMSET%{$reset_color%}]"
    fi
}

# Determine version of ruby
function  ruby_version() {
    if [[ -f .ruby-version ]]; then
        RUBYVERSION=`cat .ruby-version`
        echo "%{$reset_color%}[%{$fg[yellow]%}$RUBYVERSION%{$reset_color%}]"
    fi
}

# Determine the time since last commit. If branch is clean,
# use a neutral color, otherwise colors will vary according to time.
function git_time_since_commit() {
    COLOR="$ZSH_THEME_GIT_TIME_SINCE_COMMIT_NEUTRAL"
    echo "$(ruby_version)$(gemset)"
}
