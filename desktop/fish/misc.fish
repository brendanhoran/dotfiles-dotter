# Add ssh keys to ssh-agent
# only if ssh-agent is not running and we are using an interactive shell/tty
if not pgrep -f ssh-agent >/dev/null
  set -Ua SSH_KEYS_TO_AUTOLOAD ~/.ssh/ed25519-sk

  if status is-login 
    and status is-interactive
      keychain --eval --quiet --agents ssh,gpg $SSH_KEYS_TO_AUTOLOAD | source
  end
end


# Force GPG-agent to use CLI tools (eg for pinentry)
# See: https://www.gnupg.org/documentation/manuals/gnupg/Invoking-GPG_002dAGENT.html#Invoking-GPG_002dAGENT
if status is-interactive
  set -gx GPG_TTY (tty)
end
