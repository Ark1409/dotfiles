#
# ~/.bash_profile
#

[[ "$PATH" != *"$HOME/.local/bin"* ]] && export PATH="~/.local/bin:$PATH"

if [[ -z "$SSH_AGENT_PID" ]]; then
    SSH_AGENT_PID=$(systemctl --user show ssh-agent -p MainPID --value)

    [[ -z "$SSH_AGENT_PID" || "$SSH_AGENT_PID" == 0 ]] && SSH_AGENT_PID=$(pidof -s ssh-agent)
    [[ -n "$SSH_AGENT_PID" ]] && export SSH_AGENT_PID || unset SSH_AGENT_PID
fi

if [[ -n "$SSH_AGENT_PID" && -z "$SSH_AUTH_SOCK" ]]; then
    SSH_AUTH_SOCK="$XDG_RUNTIME_DIR"/ssh-agent.socket
    [[ -S "$SSH_AUTH_SOCK" ]] && export SSH_AUTH_SOCK || unset SSH_AUTH_SOCK;
fi

[[ -f ~/.bashrc ]] && . ~/.bashrc
