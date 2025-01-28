# Install vscode, node, npm
winget install -e --id Microsoft.VisualStudioCode
winget install -e --id Microsoft.Nodejs
winget install -e --id Microsoft.npm

# Check the version of the installed software
winget show --id Microsoft.VisualStudioCode
winget show --id Microsoft.Nodejs
winget show --id Microsoft.npm