# Crisis Mesh Messenger - Push to GitHub Script
# Run this script to push your code to GitHub

Write-Host "===============================================" -ForegroundColor Cyan
Write-Host "  Crisis Mesh Messenger - GitHub Push Script  " -ForegroundColor Cyan
Write-Host "===============================================" -ForegroundColor Cyan
Write-Host ""

# Check if Git is installed
Write-Host "Checking for Git installation..." -ForegroundColor Yellow
try {
    $gitVersion = git --version
    Write-Host "✓ Git is installed: $gitVersion" -ForegroundColor Green
    Write-Host ""
} catch {
    Write-Host "✗ Git is NOT installed!" -ForegroundColor Red
    Write-Host ""
    Write-Host "Please install Git first:" -ForegroundColor Yellow
    Write-Host "1. Download from: https://git-scm.com/download/win" -ForegroundColor White
    Write-Host "2. Run the installer (use default settings)" -ForegroundColor White
    Write-Host "3. Restart PowerShell" -ForegroundColor White
    Write-Host "4. Run this script again" -ForegroundColor White
    Write-Host ""
    Write-Host "Press any key to open Git download page..."
    $null = $Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")
    Start-Process "https://git-scm.com/download/win"
    exit
}

# Get GitHub details
Write-Host "===============================================" -ForegroundColor Cyan
Write-Host "  GitHub Repository Setup  " -ForegroundColor Cyan
Write-Host "===============================================" -ForegroundColor Cyan
Write-Host ""

# Check if repository exists on GitHub
Write-Host "Before proceeding, make sure you have created the repository on GitHub:" -ForegroundColor Yellow
Write-Host "1. Go to: https://github.com/Fundacja-Hospicjum" -ForegroundColor White
Write-Host "2. Click 'New Repository'" -ForegroundColor White
Write-Host "3. Name: crisis-mesh-messenger" -ForegroundColor White
Write-Host "4. Description: Infrastructure-free mesh messaging for crisis communication" -ForegroundColor White
Write-Host "5. Make it PUBLIC" -ForegroundColor White
Write-Host "6. Do NOT initialize with README, .gitignore, or license" -ForegroundColor White
Write-Host "7. Click 'Create repository'" -ForegroundColor White
Write-Host ""

$continue = Read-Host "Have you created the repository on GitHub? (yes/no)"
if ($continue -ne "yes" -and $continue -ne "y") {
    Write-Host ""
    Write-Host "Opening GitHub in your browser..." -ForegroundColor Yellow
    Start-Process "https://github.com/organizations/Fundacja-Hospicjum/repositories/new"
    Write-Host ""
    Write-Host "After creating the repository, run this script again." -ForegroundColor Yellow
    exit
}

Write-Host ""
Write-Host "Great! Let's configure Git..." -ForegroundColor Green
Write-Host ""

# Configure Git
$userName = Read-Host "Enter your GitHub username"
$userEmail = Read-Host "Enter your email address"

Write-Host ""
Write-Host "Configuring Git..." -ForegroundColor Yellow
git config --global user.name "$userName"
git config --global user.email "$userEmail"
Write-Host "✓ Git configured" -ForegroundColor Green
Write-Host ""

# Initialize repository
Write-Host "Initializing Git repository..." -ForegroundColor Yellow
git init
Write-Host "✓ Repository initialized" -ForegroundColor Green
Write-Host ""

# Add all files
Write-Host "Adding all files..." -ForegroundColor Yellow
git add .
Write-Host "✓ Files added" -ForegroundColor Green
Write-Host ""

# Create initial commit
Write-Host "Creating initial commit..." -ForegroundColor Yellow
git commit -m "Initial commit: Crisis Mesh Messenger v0.1.0

- Complete Flutter app structure
- UI implementation (Home, Chat, Network Status)
- Data models and services architecture
- Simulated mesh networking
- Local storage with Hive
- Android and iOS platform configurations
- Comprehensive documentation"

Write-Host "✓ Initial commit created" -ForegroundColor Green
Write-Host ""

# Add remote
Write-Host "Adding GitHub remote..." -ForegroundColor Yellow
$repoUrl = "https://github.com/Fundacja-Hospicjum/crisis-mesh-messenger.git"
git remote add origin $repoUrl
Write-Host "✓ Remote added: $repoUrl" -ForegroundColor Green
Write-Host ""

# Rename branch to main
Write-Host "Setting up main branch..." -ForegroundColor Yellow
git branch -M main
Write-Host "✓ Branch set to 'main'" -ForegroundColor Green
Write-Host ""

# Push to GitHub
Write-Host "===============================================" -ForegroundColor Cyan
Write-Host "  Ready to Push to GitHub!  " -ForegroundColor Cyan
Write-Host "===============================================" -ForegroundColor Cyan
Write-Host ""
Write-Host "⚠ IMPORTANT: You'll need to authenticate with GitHub" -ForegroundColor Yellow
Write-Host ""
Write-Host "When prompted:" -ForegroundColor White
Write-Host "  Username: $userName" -ForegroundColor Cyan
Write-Host "  Password: Use a Personal Access Token (NOT your GitHub password)" -ForegroundColor Cyan
Write-Host ""
Write-Host "Don't have a Personal Access Token?" -ForegroundColor Yellow
Write-Host "1. Go to: https://github.com/settings/tokens" -ForegroundColor White
Write-Host "2. Click 'Generate new token (classic)'" -ForegroundColor White
Write-Host "3. Give it a name: 'Crisis Mesh Push'" -ForegroundColor White
Write-Host "4. Select scope: 'repo' (full control)" -ForegroundColor White
Write-Host "5. Click 'Generate token'" -ForegroundColor White
Write-Host "6. COPY the token (you won't see it again!)" -ForegroundColor White
Write-Host "7. Use it as your password when pushing" -ForegroundColor White
Write-Host ""

$ready = Read-Host "Ready to push? (yes/no)"
if ($ready -eq "yes" -or $ready -eq "y") {
    Write-Host ""
    Write-Host "Pushing to GitHub..." -ForegroundColor Yellow
    git push -u origin main
    
    if ($LASTEXITCODE -eq 0) {
        Write-Host ""
        Write-Host "===============================================" -ForegroundColor Green
        Write-Host "  🎉 SUCCESS! Code pushed to GitHub! 🎉  " -ForegroundColor Green
        Write-Host "===============================================" -ForegroundColor Green
        Write-Host ""
        Write-Host "Your repository is now live at:" -ForegroundColor Cyan
        Write-Host "https://github.com/Fundacja-Hospicjum/crisis-mesh-messenger" -ForegroundColor White
        Write-Host ""
        Write-Host "Next steps:" -ForegroundColor Yellow
        Write-Host "1. Visit your repository" -ForegroundColor White
        Write-Host "2. Add description and topics" -ForegroundColor White
        Write-Host "3. Create your first release (v0.1.0)" -ForegroundColor White
        Write-Host "4. Share with the community!" -ForegroundColor White
        Write-Host ""
        Write-Host "Opening repository in browser..." -ForegroundColor Yellow
        Start-Process "https://github.com/Fundacja-Hospicjum/crisis-mesh-messenger"
    } else {
        Write-Host ""
        Write-Host "⚠ Push failed. Common issues:" -ForegroundColor Red
        Write-Host "1. Invalid credentials - Make sure you used Personal Access Token" -ForegroundColor Yellow
        Write-Host "2. Repository doesn't exist - Create it on GitHub first" -ForegroundColor Yellow
        Write-Host "3. No internet connection" -ForegroundColor Yellow
        Write-Host ""
        Write-Host "Try running this script again after fixing the issue." -ForegroundColor White
    }
} else {
    Write-Host ""
    Write-Host "Push cancelled. You can push manually later with:" -ForegroundColor Yellow
    Write-Host "  git push -u origin main" -ForegroundColor Cyan
}

Write-Host ""
Write-Host "Press any key to exit..."
$null = $Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")
