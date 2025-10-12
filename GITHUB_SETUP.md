# GitHub Repository Setup Guide

## Step 1: Create Repository on GitHub

1. **Go to GitHub**
   - Navigate to: https://github.com/Fundacja-Hospicjum
   - Click "Repositories" tab
   - Click "New" button

2. **Repository Settings**
   - **Name**: `crisis-mesh-messenger` (or your preferred name)
   - **Description**: `Infrastructure-free mesh messaging app for crisis communication`
   - **Visibility**: Public (recommended for open source)
   - **Initialize**: 
     - ❌ Do NOT add README (we have one)
     - ❌ Do NOT add .gitignore (we have one)
     - ❌ Do NOT add license (we have one)
   - Click "Create repository"

## Step 2: Initialize Local Git Repository

Open PowerShell in the crisis_mesh directory:

```powershell
cd "c:\Users\Hipek\OneDrive\Pulpit\New Network\CascadeProjects\windsurf-project\crisis_mesh"

# Initialize git
git init

# Add all files
git add .

# Create first commit
git commit -m "Initial commit: Crisis Mesh Messenger v0.1.0

- Complete Flutter app structure
- UI implementation (Home, Chat, Network Status)
- Data models and services architecture
- Simulated mesh networking
- Local storage with Hive
- Android and iOS platform configurations
- Comprehensive documentation"
```

## Step 3: Connect to GitHub

```powershell
# Add remote repository (replace with your actual repo URL)
git remote add origin https://github.com/Fundacja-Hospicjum/crisis-mesh-messenger.git

# Verify remote
git remote -v

# Push to GitHub
git branch -M main
git push -u origin main
```

## Step 4: Configure Repository Settings

### A. Add Repository Description and Topics

1. Go to your repository on GitHub
2. Click "About" (gear icon)
3. Add topics:
   - `flutter`
   - `dart`
   - `mesh-networking`
   - `crisis-communication`
   - `disaster-response`
   - `decentralized`
   - `humanitarian`
   - `offline-first`
   - `p2p`
   - `android`
   - `ios`

### B. Enable Issues and Discussions

1. Settings → General
2. Features:
   - ✅ Issues
   - ✅ Discussions (great for community Q&A)
   - ❌ Projects (enable later if needed)
   - ❌ Wiki (documentation is in repo)

### C. Set Up Branch Protection (Optional but Recommended)

1. Settings → Branches
2. Add rule for `main` branch:
   - ✅ Require pull request before merging
   - ✅ Require approvals: 1
   - ✅ Dismiss stale reviews
   - ✅ Require status checks to pass

## Step 5: Add Collaborators (If Applicable)

1. Settings → Collaborators
2. Click "Add people"
3. Enter GitHub usernames
4. Set permission level

## Step 6: Create Initial Release

1. Go to "Releases" on GitHub
2. Click "Create a new release"
3. Tag: `v0.1.0`
4. Title: `Crisis Mesh Messenger v0.1.0 - Initial Release`
5. Description:
```markdown
## 🎉 Initial Release

This is the first public release of Crisis Mesh Messenger - an infrastructure-free messaging app for crisis situations.

### ✅ What's Included

- Complete Flutter application structure
- Beautiful UI with Material Design 3
- Message and conversation management
- Simulated peer discovery
- Local storage with Hive
- Platform configurations for Android and iOS
- Comprehensive documentation

### ⚠️ Current Status

This is a **proof of concept** release. The mesh networking is currently simulated.

**Working:**
- ✅ Full UI/UX
- ✅ Message storage
- ✅ Conversation management
- ✅ Service architecture

**Not Yet Implemented:**
- ❌ Real Bluetooth/WiFi networking
- ❌ Actual device-to-device communication
- ❌ End-to-end encryption

### 📱 How to Use

1. Install Flutter SDK
2. Clone this repository
3. Run `flutter pub get`
4. Run `flutter run`

See [RUN.md](RUN.md) for detailed instructions.

### 🚀 Next Steps

We need contributors to help implement:
1. Real Bluetooth LE discovery
2. WiFi Direct (Android) / Multipeer Connectivity (iOS)
3. Message routing protocols
4. End-to-end encryption

See [CONTRIBUTING.md](CONTRIBUTING.md) to get started!

### 🌟 Vision

This app aims to provide communication when all infrastructure fails - during wars, natural disasters, censorship, or in remote areas.

**Help us build something that saves lives!**
```

6. Click "Publish release"

## Step 7: Create Project Board (Optional)

1. Go to "Projects" tab
2. Create new project
3. Template: "Board"
4. Columns: "To Do", "In Progress", "Done"
5. Add initial issues/tasks

## Step 8: Set Up GitHub Actions (Future)

Create `.github/workflows/flutter.yml` for CI/CD:

```yaml
name: Flutter CI

on:
  push:
    branches: [ main, develop ]
  pull_request:
    branches: [ main ]

jobs:
  build:
    runs-on: ubuntu-latest
    steps:
    - uses: actions/checkout@v3
    - uses: subosito/flutter-action@v2
      with:
        flutter-version: '3.29.0'
    - run: flutter pub get
    - run: flutter analyze
    - run: flutter test
    - run: flutter build apk
```

## Useful Git Commands

### Daily Workflow
```powershell
# Check status
git status

# Add specific files
git add lib/core/services/new_service.dart

# Add all changes
git add .

# Commit with message
git commit -m "feat: Add Bluetooth discovery"

# Push to GitHub
git push

# Pull latest changes
git pull

# Create new branch
git checkout -b feature/bluetooth-discovery

# Switch branches
git checkout main

# Merge branch
git merge feature/bluetooth-discovery
```

### Branching Strategy

**Main branches:**
- `main` - Production-ready code
- `develop` - Integration branch for features

**Feature branches:**
- `feature/bluetooth-discovery`
- `feature/encryption`
- `fix/message-duplication`

**Workflow:**
```powershell
# Start new feature
git checkout develop
git pull
git checkout -b feature/my-feature

# ... make changes ...
git add .
git commit -m "feat: My awesome feature"
git push origin feature/my-feature

# Create pull request on GitHub
# After approval and merge, delete branch
git checkout develop
git branch -d feature/my-feature
```

## Repository Best Practices

### Commit Message Convention

```
type(scope): subject

body

footer
```

**Types:**
- `feat`: New feature
- `fix`: Bug fix
- `docs`: Documentation
- `style`: Formatting
- `refactor`: Code restructuring
- `test`: Adding tests
- `chore`: Maintenance

**Examples:**
```
feat(network): Add Bluetooth LE discovery for Android

Implemented BLE scanning and advertising using flutter_nearby_connections.
Devices can now discover each other within 100m range.

Closes #15
```

### README Badges

Add these to README.md on GitHub:

```markdown
![Flutter](https://img.shields.io/badge/Flutter-3.29-blue)
![License](https://img.shields.io/badge/license-MIT-green)
![Platform](https://img.shields.io/badge/platform-Android%20%7C%20iOS-lightgrey)
![Status](https://img.shields.io/badge/status-alpha-orange)
```

## Troubleshooting

### "Permission denied"
```powershell
# Set up authentication
git config --global user.name "Your Name"
git config --global user.email "your.email@example.com"

# Use personal access token instead of password
# Generate at: GitHub Settings → Developer settings → Personal access tokens
```

### "Remote already exists"
```powershell
# Remove and re-add
git remote remove origin
git remote add origin https://github.com/Fundacja-Hospicjum/crisis-mesh-messenger.git
```

### Large file issues
```powershell
# Remove from git cache
git rm --cached path/to/large/file
echo "path/to/large/file" >> .gitignore
git commit -m "Remove large file"
```

## Next Steps After GitHub Setup

1. **Share the repository**
   - Post on social media
   - Share in Flutter communities
   - Contact potential contributors

2. **Set up community channels**
   - Discord server
   - Telegram group
   - Twitter/X account

3. **Create project roadmap**
   - GitHub Projects board
   - Milestones for versions
   - Issue labels and prioritization

4. **Start accepting contributions**
   - Review and merge PRs
   - Provide feedback
   - Recognize contributors

---

**Congratulations! Your project is now on GitHub!** 🎉

The repository URL will be:
`https://github.com/Fundacja-Hospicjum/crisis-mesh-messenger`
