# Add ssh keys to ssh-agent
# only if ssh-agent is not running and we are using an interactive shell/tty
if not pgrep -f ssh-agent >/dev/null
  set -Ua SSH_KEYS_TO_AUTOLOAD ~/.ssh/ed25519-sk

  if status is-login 
    and status is-interactive
      keychain -q $SSH_KEYS_TO_AUTOLOAD | source
  end
end
