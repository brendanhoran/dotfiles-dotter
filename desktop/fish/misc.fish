# Start a keychain-managed ssh-agent and load keys, once per boot.
# Runs only in interactive shells, and only when no agent is already running.
# keychain writes SSH_AUTH_SOCK as a fish universal variable, so every other
# fish shell picks it up automatically, no need to re-run it per shell.
# Key names differ between machines: list them all, --ignore-missing skips
# the ones a machine does not have. pgrep -x, not -f, so a process that only
# mentions ssh-agent on its command line is not mistaken for a running agent.
if status is-interactive; and not pgrep -u $USER -x ssh-agent >/dev/null
  set -l ssh_keys_to_autoload ~/.ssh/ed25519-sk ~/.ssh/id_ed25519_sk ~/.ssh/id_ed25519_sk_13339974
  keychain --eval --quiet --ignore-missing $ssh_keys_to_autoload | source
end

# Force GPG-agent to use CLI tools (eg for pinentry)
# See: https://www.gnupg.org/documentation/manuals/gnupg/Invoking-GPG_002dAGENT.html#Invoking-GPG_002dAGENT
if status is-interactive
  set -gx GPG_TTY (tty)
end

fish_add_path -a -g ~/.local/bin ~/.fly/bin
