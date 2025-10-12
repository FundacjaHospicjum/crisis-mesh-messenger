# 🚀 Run Crisis Mesh Messenger

## Quick Start (Windows)

### Step 1: Check Flutter Installation

Open PowerShell and run:
```powershell
flutter doctor
```

**Expected output:** All checkmarks or at least Flutter SDK and Android toolchain should be ready.

If Flutter is not installed:
1. Download from: https://flutter.dev/docs/get-started/install/windows
2. Extract to `C:\src\flutter`
3. Add to PATH: `C:\src\flutter\bin`
4. Run `flutter doctor` again

---

### Step 2: Install Dependencies

Navigate to project and install packages:
```powershell
cd "c:\Users\Hipek\OneDrive\Pulpit\New Network\CascadeProjects\windsurf-project\crisis_mesh"
flutter pub get
```

**This will:**
- Download all required packages
- Set up dependencies
- Configure the project

---

### Step 3: Choose Your Platform

#### Option A: Android Emulator (Recommended for Quick Test)

**Start Android Studio:**
1. Open Android Studio
2. Tools → Device Manager
3. Click "Create Device" if no emulator exists
4. Select a phone (e.g., Pixel 6)
5. Download system image if needed (API 33+)
6. Click "Start" to launch emulator

**Run the app:**
```powershell
flutter run
```

Flutter will detect the emulator and install the app automatically.

---

#### Option B: Physical Android Device

**Enable Developer Mode:**
1. On your phone: Settings → About Phone
2. Tap "Build Number" 7 times
3. Go back → Developer Options
4. Enable "USB Debugging"

**Connect and Run:**
1. Connect phone via USB
2. Confirm USB debugging prompt on phone
3. Verify connection:
   ```powershell
   flutter devices
   ```
4. Run app:
   ```powershell
   flutter run
   ```

---

#### Option C: iOS Simulator (Mac Only)

```bash
# List available simulators
flutter emulators

# Launch one
open -a Simulator

# Run app
flutter run
```

---

### Step 4: What You'll See

**App launches with:**
1. ✅ **Home Screen** showing "No conversations yet"
2. ✅ **Network Status Banner** at top (likely showing "No devices found")
3. ✅ **Floating Action Button** to start new conversation
4. ✅ **Settings and Info buttons** in app bar

**Try these actions:**
1. **Tap Network Status Banner or Info icon** → See network details
2. **Wait ~10 seconds** → Simulated peers will appear
3. **Tap "+ New Message"** → Select a simulated peer
4. **Type and send messages** → See them appear in chat
5. **Go back** → See conversation in list

---

## Expected Behavior (Current Phase)

### ✅ What Works
- Beautiful, modern UI
- Smooth navigation
- Message sending/receiving (UI only)
- Conversation management
- Simulated peer discovery (new peer every 10 seconds)
- Local message storage

### ⚠️ What's Simulated
- Peer discovery (not real Bluetooth yet)
- Message transmission (stays on your device)
- Network connections (simulated status)

### ❌ Not Yet Working
- Real device-to-device communication
- Actual mesh networking
- Multi-device testing

---

## Troubleshooting

### "Flutter command not found"
```powershell
# Add to PATH or use full path
C:\src\flutter\bin\flutter doctor
```

### "No devices available"
- **Android:** Start emulator first or connect phone with USB debugging
- **Check:** Run `flutter devices` to see available devices

### "Build failed"
```powershell
# Clean and rebuild
flutter clean
flutter pub get
flutter run
```

### "Gradle build errors" (Android)
- Make sure Android Studio is updated
- SDK Platform API 33+ installed
- Give it time on first build (downloads dependencies)

### "App crashes on launch"
```powershell
# Check logs
flutter logs
```

Common issues:
- Hive adapter registration (already handled in code)
- Missing permissions (already configured)
- Dependencies conflict (run `flutter pub upgrade`)

---

## Hot Reload During Development

While app is running:
- Press `r` in terminal → Hot reload (fast UI updates)
- Press `R` in terminal → Hot restart (full restart)
- Press `q` → Quit

**Change something and test:**
1. Open `lib/ui/theme/app_theme.dart`
2. Change `primaryColor` to a different color
3. Press `r` in terminal
4. See instant change!

---

## Viewing Logs

```powershell
# In another terminal, view real-time logs
flutter logs

# Filter for specific messages
flutter logs | Select-String "MeshNetwork"
```

---

## Performance Tips

### First Build
- **Android:** 5-10 minutes (downloads Gradle, dependencies)
- **iOS:** 3-5 minutes
- **Subsequent builds:** 10-30 seconds

### Speed Up Development
```powershell
# Use hot reload instead of full restart
# Keep emulator running between builds
# Close unused apps to free RAM
```

---

## Next Steps After Running

### 1. Explore the UI
- Navigate between screens
- Send messages to simulated peers
- Check network status

### 2. Understand the Code
- `lib/ui/screens/` - All screens
- `lib/core/services/` - Business logic
- `lib/core/models/` - Data structures

### 3. Start Real Development
- Read SETUP_GUIDE.md Phase 2
- Implement Bluetooth discovery
- Test with real devices

---

## Testing with Multiple Devices (Future)

Once real networking is implemented:

**Setup:**
1. Install app on Device A
2. Install app on Device B
3. Make sure both have Bluetooth/WiFi on
4. Keep devices near each other (~10m)

**Test:**
1. Both devices should discover each other
2. Send message from Device A
3. Receive on Device B
4. Test message relay with Device C

---

## Development Workflow

**Typical session:**
```powershell
# 1. Start emulator/device
# 2. Run app
flutter run

# 3. Make changes to code
# 4. Hot reload
# (press 'r' in terminal)

# 5. Check logs
flutter logs

# 6. Debug issues
flutter doctor
flutter analyze
```

---

## Getting Help

**If stuck:**
1. Check this file
2. Read SETUP_GUIDE.md
3. Check Flutter docs: https://flutter.dev/docs
4. Search error messages
5. Check GitHub issues (when repo created)

**Common resources:**
- Flutter docs: https://flutter.dev
- Dart docs: https://dart.dev
- Stack Overflow: tag [flutter]

---

## Success Checklist

After running successfully, you should have:
- [x] App launches without errors
- [x] Can navigate between screens
- [x] Can send/receive messages (UI)
- [x] Simulated peers appear
- [x] Messages saved locally
- [x] Network status displays correctly

**Congratulations! You're ready to build real mesh networking!** 🎉

---

## Quick Reference

```powershell
# Install dependencies
flutter pub get

# Run app
flutter run

# Clean build
flutter clean

# Check setup
flutter doctor

# View devices
flutter devices

# View logs
flutter logs

# Analyze code
flutter analyze

# Format code
flutter format .
```

---

**Ready?** Open PowerShell and run:

```powershell
cd "c:\Users\Hipek\OneDrive\Pulpit\New Network\CascadeProjects\windsurf-project\crisis_mesh"
flutter pub get
flutter run
```

**Let's see it come to life!** 🚀
