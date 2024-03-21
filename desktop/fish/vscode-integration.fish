# Make vscode use fish, see
# https://code.visualstudio.com/docs/terminal/shell-integration

string match -q "$TERM_PROGRAM" "vscode"
and . (code --locate-shell-integration-path fish)
