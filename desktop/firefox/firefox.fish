# Managed by dotter from dotfiles-dotter/desktop/firefox, edit it there.
# Export this machine's default Firefox profile folder, as recorded in
# Firefox's own installs.ini, so dotter can deploy the firefox package.
# Assumes a single Firefox install, so it takes the first Default= line.
set -l firefox_installs ~/.mozilla/firefox/installs.ini
if test -r $firefox_installs
    set -l firefox_default (string match -rg '^Default=(.+)$' <$firefox_installs)
    if test -n "$firefox_default[1]"
        set -gx FIREFOX_PROFILE $firefox_default[1]
    end
end
