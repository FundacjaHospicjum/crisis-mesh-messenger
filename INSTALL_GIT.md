# Install Git for Windows

## Quick Installation

### Step 1: Download Git
1. Go to: **https://git-scm.com/download/win**
2. Click the download link for Windows
3. The installer will download automatically

### Step 2: Run Installer
1. Double-click the downloaded file (e.g., `Git-2.43.0-64-bit.exe`)
2. Click "Next" through the setup wizard
3. **Use default settings** - they're all good!
4. Important screens:
   - Editor: Choose "Use Visual Studio Code" or leave default
   - PATH: **Select "Git from the command line and also from 3rd-party software"** (default)
   - Line endings: Use default
   - Terminal emulator: Use default

### Step 3: Verify Installation
1. **Close and reopen PowerShell** (important!)
2. Type: `git --version`
3. You should see something like: `git version 2.43.0.windows.1`

## After Installing Git

Run the push script:
```powershell
cd "c:\Users\Hipek\OneDrive\Pulpit\New Network\CascadeProjects\windsurf-project\crisis_mesh"
.\PUSH_TO_GITHUB.ps1
```

Or follow manual steps in QUICK_START_GITHUB.md

## Troubleshooting

### "git is not recognized"
- **Solution**: Restart PowerShell after installation
- If still not working, restart your computer

### "Cannot run script"
```powershell
# Enable script execution
Set-ExecutionPolicy -Scope CurrentUser -ExecutionPolicy RemoteSigned
# Then run the script again
```

### Installation Hangs
- Close installer
- Disable antivirus temporarily
- Run installer as Administrator (right-click → Run as administrator)

## Alternative: GitHub Desktop

If you prefer a GUI:
1. Download GitHub Desktop: https://desktop.github.com/
2. Install and sign in with GitHub account
3. Clone the repository
4. Commit and push through the app

But command line (Git) is recommended for this project.
