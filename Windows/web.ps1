# Install WSL with Ubuntu
Write-Host "Installing WSL with Ubuntu..." -ForegroundColor Cyan
wsl --install -d Ubuntu-20.04

wsl --set-default Ubuntu-20.04
# Wait for installation to complete
Write-Host "Waiting for WSL installation to complete..." -ForegroundColor Yellow
Start-Sleep -Seconds 30

# Verify WSL installation
Write-Host "Verifying WSL installation..." -ForegroundColor Cyan
if (wsl --list --verbose) {
    Write-Host "WSL and Ubuntu installed successfully." -ForegroundColor Green
} else {
    Write-Host "Error: WSL or Ubuntu installation failed. Please check manually." -ForegroundColor Red
    Exit
}

# Set Ubuntu as the default distribution
Write-Host "Setting Ubuntu as the default WSL distribution..." -ForegroundColor Green
wsl --set-default Ubuntu-20.04

# Run Linux commands through WSL
Write-Host "Updating and configuring WSL environment..." -ForegroundColor Green
wsl sudo apt update 
wsl sudo apt upgrade -y
wsl sudo apt install -y build-essential git python3 python3-pip python3-venv
wsl curl https://get.docker.com | sudo sh

# Provide user feedback
Write-Host "WSL setup and configuration completed successfully!" -ForegroundColor Green
Write-Host "You can now use 'wsl' to run Linux commands directly from PowerShell." -ForegroundColor Green

# Ask for restart
Write-Host "Do you want to restart your computer now? (Y/N)" -ForegroundColor Yellow
$restart = Read-Host
if ($restart -eq "Y" -or $restart -eq "y") {
    Restart-Computer -Force
} else {
    Write-Host "Please restart your computer to apply changes." -ForegroundColor Yellow
}
