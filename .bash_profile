#
# ~/.bash_profile
#

export PATH=~/.local/bin:$PATH

if [ -z "$SSH_AGENT_PID" ] && ! pidof -q ssh-agent; then
    eval "$(ssh-agent -s)" > /dev/null
fi

[[ -f ~/.bashrc ]] && . ~/.bashrc
