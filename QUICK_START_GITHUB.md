# 🚀 Quick Start: Push to GitHub

## Prerequisites Check

### 1. Install Git (if not installed)

**Download Git for Windows:**
- Go to: https://git-scm.com/download/win
- Download and run installer
- Use default settings
- Restart PowerShell after installation

**Verify installation:**
```powershell
git --version
# Should show: git version 2.x.x
```

### 2. Configure Git (First Time Only)

```powershell
git config --global user.name "Your Name"
git config --global user.email "your.email@example.com"
```

---

## Step-by-Step: Create GitHub Repository

### Step 1: Create Repository on GitHub Website

1. **Go to**: https://github.com/Fundacja-Hospicjum
2. **Click**: "Repositories" → "New"
3. **Settings**:
   - Repository name: `crisis-mesh-messenger`
   - Description: `Infrastructure-free mesh messaging app for crisis communication`
   - Visibility: ✅ Public
   - Initialize: ❌ **Do NOT** check any boxes
4. **Click**: "Create repository"

### Step 2: Copy Commands from GitHub

After creating, GitHub will show commands. **Copy** them, but we'll use ours below.

### Step 3: Push Your Code

**Open PowerShell** in the crisis_mesh folder:

```powershell
# Navigate to project
cd "c:\Users\Hipek\OneDrive\Pulpit\New Network\CascadeProjects\windsurf-project\crisis_mesh"

# Initialize git repository
git init

# Add all files
git add .

# Create first commit
git commit -m "Initial commit: Crisis Mesh Messenger v0.1.0"

# Add remote (REPLACE with your actual repo URL)
git remote add origin https://github.com/Fundacja-Hospicjum/crisis-mesh-messenger.git

# Push to GitHub
git branch -M main
git push -u origin main
```

### Step 4: Enter Credentials

When prompted:
- **Username**: Your GitHub username
- **Password**: Use **Personal Access Token** (not your GitHub password)

**To create Personal Access Token:**
1. GitHub → Settings → Developer settings → Personal access tokens → Tokens (classic)
2. Generate new token
3. Select scopes: `repo` (all)
4. Copy token and use as password

---

## ✅ Verify Success

After pushing, go to:
`https://github.com/Fundacja-Hospicjum/crisis-mesh-messenger`

You should see all your files!

---

## 🎯 What Happens Next?

### 1. Add Repository Description

On GitHub repository page:
1. Click "About" (gear icon on right)
2. Add description: "Infrastructure-free mesh messaging for crisis situations"
3. Add website: (if you have one)
4. Add topics:
   - `flutter` `dart` `mesh-networking` `crisis-communication`
   - `disaster-response` `decentralized` `humanitarian` `offline-first`
5. Click "Save changes"

### 2. Enable Discussions

1. Repository → Settings → General
2. Under "Features", check ✅ **Discussions**
3. Click "Set up discussions"

### 3. Create First Release

1. Repository → Releases → "Create a new release"
2. Tag: `v0.1.0`
3. Title: `Crisis Mesh Messenger v0.1.0 - Initial Release`
4. Description:

```markdown
## 🎉 First Public Release

Crisis Mesh Messenger - Communication when infrastructure fails.

### ✅ What's Working
- Complete Flutter app with beautiful UI
- Message and conversation management
- Local storage with Hive
- Simulated mesh networking
- Android & iOS configurations

### 🚧 What's Next
- Real Bluetooth/WiFi mesh networking
- End-to-end encryption
- Message routing optimization

**Status**: Proof of Concept / Alpha

See [RUN.md](RUN.md) for setup instructions.

**We need contributors!** See [CONTRIBUTING.md](CONTRIBUTING.md)
```

5. Click "Publish release"

---

## 📱 Share Your Project

### Add Badges to README

Edit README.md on GitHub and add at the top:

```markdown
# Crisis Mesh Messenger

![Flutter](https://img.shields.io/badge/Flutter-3.29-blue)
![License](https://img.shields.io/badge/license-MIT-green)
![Platform](https://img.shields.io/badge/platform-Android%20%7C%20iOS-lightgrey)
![Status](https://img.shields.io/badge/status-alpha-orange)
![PRs Welcome](https://img.shields.io/badge/PRs-welcome-brightgreen)

Infrastructure-free mesh messaging for crisis communication.
```

### Share on Social Media

```
🚨 NEW PROJECT: Crisis Mesh Messenger

A decentralized messaging app that works when everything else fails:
❌ No internet needed
❌ No cell towers required
✅ Device-to-device communication
✅ Built for crisis situations

Looking for contributors to help build this life-saving tool!

#Flutter #OpenSource #Humanitarian #MeshNetworking

https://github.com/Fundacja-Hospicjum/crisis-mesh-messenger
```

### Communities to Share In

- r/FlutterDev
- r/opensource
- r/programming
- Flutter Discord
- DEV.to
- Hacker News
- Product Hunt (when more complete)

---

## 🔄 Daily Workflow

### Making Changes

```powershell
# 1. Make changes to code

# 2. Check what changed
git status

# 3. Add changes
git add .

# 4. Commit with message
git commit -m "feat: Add new feature"

# 5. Push to GitHub
git push
```

### Working on Features

```powershell
# Create feature branch
git checkout -b feature/bluetooth-discovery

# Make changes, commit
git add .
git commit -m "feat: Implement Bluetooth discovery"

# Push branch
git push origin feature/bluetooth-discovery

# Create Pull Request on GitHub
# After merge, switch back
git checkout main
git pull
```

---

## 🆘 Common Issues

### "Authentication failed"
**Solution**: Use Personal Access Token instead of password
1. GitHub → Settings → Developer settings → Personal access tokens
2. Generate token with `repo` scope
3. Use token as password when pushing

### "Permission denied"
**Solution**: Check repository URL and permissions
```powershell
git remote -v
# If wrong, update:
git remote set-url origin https://github.com/Fundacja-Hospicjum/crisis-mesh-messenger.git
```

### "Everything up-to-date" but changes not showing
**Solution**: Forgot to commit
```powershell
git status  # Check status
git add .   # Add files
git commit -m "Your message"  # Commit
git push    # Now push
```

### Large files rejected
**Solution**: Remove from git
```powershell
git rm --cached path/to/large/file
echo "path/to/large/file" >> .gitignore
git commit -m "Remove large file"
git push
```

---

## 📊 Repository Health

### Set Up Branch Protection

1. Settings → Branches → Add rule
2. Branch name pattern: `main`
3. Settings:
   - ✅ Require pull request before merging
   - ✅ Require approvals: 1
   - ✅ Require status checks
4. Save changes

### Add CODEOWNERS

Create `.github/CODEOWNERS`:
```
* @yourusername
/docs/ @documentation-team
```

### Set Up Labels

Repository → Issues → Labels

Suggested labels:
- `good first issue` - For beginners
- `help wanted` - Need assistance
- `priority: high` - Urgent
- `priority: low` - Nice to have
- `bug` - Something broken
- `enhancement` - New feature
- `documentation` - Docs updates

---

## 🎯 Next Steps

1. ✅ Push code to GitHub
2. ✅ Create first release
3. ✅ Add description and topics
4. 📝 Create GitHub Project board
5. 📝 Add initial issues for features
6. 📝 Write contribution guide
7. 📝 Set up Discord/Telegram community
8. 📢 Share with Flutter community
9. 🤝 Review first pull requests
10. 🚀 Build something amazing!

---

**Your repository will be at:**
`https://github.com/Fundacja-Hospicjum/crisis-mesh-messenger`

**Ready to change the world!** 🌍💙
