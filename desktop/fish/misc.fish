# Start a keychain-managed ssh-agent and load keys, once per boot.
# Runs only in interactive shells, and only when no agent is already running.
# keychain writes SSH_AUTH_SOCK as a fish universal variable, so every other
# fish shell picks it up automatically, no need to re-run it per shell.
if status is-interactive; and not pgrep -u $USER -f ssh-agent >/dev/null
  set -l ssh_keys_to_autoload ~/.ssh/ed25519-sk
  keychain --eval --quiet $ssh_keys_to_autoload | source
end

# Force GPG-agent to use CLI tools (eg for pinentry)
# See: https://www.gnupg.org/documentation/manuals/gnupg/Invoking-GPG_002dAGENT.html#Invoking-GPG_002dAGENT
if status is-interactive
  set -gx GPG_TTY (tty)
end

fish_add_path -a -g ~/.local/bin ~/.fly/bin
