# Testing Guide - Crisis Mesh Messenger

## Current Status

✅ **Completed:**
- Git installed
- Repository created on GitHub
- Code pushed successfully
- v0.1.0 released
- Comprehensive project plan created
- All documentation complete

⏳ **Next Step:** Install Flutter to test the app

---

## Install Flutter (Windows)

### Option 1: Official Installer (Recommended)

1. **Download Flutter:**
   - Go to: https://docs.flutter.dev/get-started/install/windows
   - Click "Download Flutter SDK"
   - Extract to: `C:\src\flutter`

2. **Add to PATH:**
   ```powershell
   # Open PowerShell as Administrator
   $env:Path += ";C:\src\flutter\bin"
   [Environment]::SetEnvironmentVariable("Path", $env:Path, "Machine")
   ```

3. **Verify Installation:**
   ```powershell
   flutter doctor
   ```

4. **Accept Android Licenses:**
   ```powershell
   flutter doctor --android-licenses
   ```

### Option 2: Chocolatey

```powershell
# Install Chocolatey first if not installed
choco install flutter
```

### Option 3: Scoop

```powershell
scoop bucket add java
scoop install flutter
```

---

## After Flutter Installation

### 1. Get Dependencies

```powershell
cd "c:\Users\Hipek\OneDrive\Pulpit\New Network\CascadeProjects\windsurf-project\crisis_mesh"
flutter pub get
```

### 2. Check Setup

```powershell
flutter doctor -v
```

**You should see:**
- ✅ Flutter SDK
- ✅ Android toolchain (optional for now)
- ✅ VS Code or Android Studio (optional)

### 3. Run on Windows Desktop (Easiest)

```powershell
# Enable Windows desktop support
flutter config --enable-windows-desktop

# Run the app
flutter run -d windows
```

### 4. Run on Android Emulator

```powershell
# List available devices
flutter devices

# Start emulator (if you have Android Studio)
# Or connect physical device via USB

# Run app
flutter run
```

---

## What You'll See

When the app runs, you'll see:

### Home Screen
- "Crisis Mesh" title
- Network status banner showing "No devices found"
- Empty conversation list
- Floating "+ New Message" button

### Test the UI
1. Click "Network Status" icon → See network details
2. Wait ~10 seconds → Simulated peers will appear
3. Click "+ New Message" → Select a simulated peer
4. Type and send messages → See them in chat
5. Go back → See conversation in list

### Screenshots for Testing

Take screenshots of:
- [ ] Home screen
- [ ] Network status
- [ ] Chat screen
- [ ] Message sending
- [ ] Simulated peers appearing

---

## Known Issues (Expected)

✅ **These are NORMAL for v0.1.0:**
- "No devices found" initially (networking is simulated)
- Peers appear slowly (every 10 seconds)
- Messages don't go to other devices (not implemented yet)
- No real Bluetooth/WiFi (Phase 2)

❌ **These would be BUGS:**
- App crashes on startup
- Can't type messages
- UI elements overlapping
- Navigation not working

---

## Quick Verification Checklist

After running the app, verify:

- [ ] App launches without crashing
- [ ] Home screen displays correctly
- [ ] Can navigate to Network Status screen
- [ ] Can open New Message dialog
- [ ] Can select a simulated peer
- [ ] Can type in message input
- [ ] Can send message (shows in chat)
- [ ] Message appears in conversation list
- [ ] Can go back to home screen
- [ ] App responds smoothly (no freezing)

---

## Development Workflow

### Hot Reload (Fast Development)

While app is running:
```
Press 'r' → Hot reload (instant UI updates)
Press 'R' → Hot restart (full app restart)
Press 'q' → Quit
```

### Making Changes

1. Edit any Dart file
2. Press `r` in terminal
3. See changes instantly!

### Example: Change Theme Color

Edit `lib/ui/theme/app_theme.dart`:
```dart
static const Color primaryColor = Color(0xFFFF5722); // Change to orange
```
Press `r` → See new color!

---

## Troubleshooting

### "flutter: command not found"
- Restart PowerShell after installation
- Check PATH includes Flutter bin directory
- Run: `$env:Path` to verify

### "No devices available"
**Solution:** Run on Windows desktop first
```powershell
flutter config --enable-windows-desktop
flutter run -d windows
```

### "Unable to locate Android SDK"
**Solution:** Either:
1. Install Android Studio, OR
2. Use Windows desktop (easier)

### Build Errors
```powershell
# Clean and rebuild
flutter clean
flutter pub get
flutter run
```

### Package Errors
```powershell
# Update dependencies
flutter pub upgrade
flutter pub get
```

---

## Performance Testing

Once app is running, test:

### Responsiveness
- Resize window (if Windows desktop)
- Scroll conversation list
- Send multiple messages quickly
- Switch between screens rapidly

### Memory Usage
- Open Windows Task Manager
- Find "crisis_mesh.exe"
- Memory should be < 500MB
- CPU should be low when idle

### Battery (Mobile)
- Run on physical device
- Use for 10 minutes
- Check battery drain
- Should be < 5% for 10 min idle

---

## Next Steps After Testing

1. **Document Results:**
   - Take screenshots
   - Note any issues
   - Record performance

2. **Create Issues:**
   - File bugs on GitHub
   - Suggest improvements
   - Document UX feedback

3. **Share Results:**
   - Post screenshots in Discussions
   - Show to potential contributors
   - Get community feedback

4. **Start Phase 2:**
   - Begin Bluetooth implementation
   - Test on real devices
   - Implement actual networking

---

## Advanced Testing

### Test on Physical Devices

**Android:**
1. Enable Developer Mode on phone
2. Enable USB Debugging
3. Connect via USB
4. Run: `flutter run`

**iOS (requires Mac):**
1. Open Xcode
2. Register device
3. Connect via USB
4. Run: `flutter run`

### Performance Profiling

```powershell
# Profile performance
flutter run --profile

# Build release version
flutter build apk --release
flutter build ios --release
flutter build windows --release
```

### Run Tests

```powershell
# Run unit tests
flutter test

# Run integration tests
flutter test integration_test/
```

---

## Success Criteria

App is ready for Phase 2 if:

✅ Launches without errors  
✅ All screens navigable  
✅ Messages can be sent/received (UI)  
✅ No critical bugs  
✅ Performance is smooth  
✅ Memory usage reasonable  
✅ Code passes `flutter analyze`

---

## Getting Help

**If you're stuck:**
1. Check this guide
2. Run: `flutter doctor -v`
3. Search error messages
4. Ask in [GitHub Discussions](https://github.com/FundacjaHospicjum/crisis-mesh-messenger/discussions)

**Common Resources:**
- Flutter docs: https://docs.flutter.dev
- Flutter samples: https://flutter.github.io/samples/
- Stack Overflow: [flutter] tag

---

## Installation Time Estimates

- **Flutter SDK Download:** 5-10 minutes
- **Installation & Setup:** 10-15 minutes
- **First `flutter pub get`:** 2-5 minutes
- **First Build:** 5-10 minutes
- **Subsequent Builds:** 10-30 seconds

**Total First-Time Setup:** ~30-45 minutes

---

**Ready to test your crisis communication app!** 🚀

Once Flutter is installed, just run:
```powershell
cd "c:\Users\Hipek\OneDrive\Pulpit\New Network\CascadeProjects\windsurf-project\crisis_mesh"
flutter pub get
flutter run -d windows
```
