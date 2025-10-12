# Crisis Mesh Messenger - Setup Guide

## Prerequisites

### Required Software
1. **Flutter SDK 3.29+**
   - Download: https://flutter.dev/docs/get-started/install
   - Verify: `flutter --version`

2. **Android Studio** (for Android development)
   - Download: https://developer.android.com/studio
   - Install Android SDK and emulator

3. **Xcode** (for iOS development, macOS only)
   - Download from Mac App Store
   - Install iOS simulator

4. **VS Code** or **Android Studio** (IDE)
   - VS Code extensions: Flutter, Dart

### Optional Tools
- Git (for version control)
- Physical Android/iOS devices (for testing mesh functionality)

---

## Project Setup

### 1. Clone/Navigate to Project

```bash
cd crisis_mesh
```

### 2. Install Dependencies

```bash
flutter pub get
```

### 3. Generate Code (for Hive adapters)

```bash
flutter pub run build_runner build
```

Or for continuous generation during development:

```bash
flutter pub run build_runner watch
```

---

## Running the App

### Android

**Using Emulator:**
```bash
# Start Android emulator from Android Studio
# or use command line
flutter emulators --launch <emulator_id>

# Run app
flutter run
```

**Using Physical Device:**
```bash
# Enable USB debugging on Android device
# Connect via USB
# Check device is detected
flutter devices

# Run app
flutter run
```

### iOS (macOS only)

**Using Simulator:**
```bash
# List available simulators
flutter emulators

# Launch simulator
flutter emulators --launch <simulator_id>

# Run app
flutter run
```

**Using Physical Device:**
```bash
# Connect iPhone via USB
# Trust computer on device
# Run app
flutter run
```

---

## Current Status & Limitations

### ✅ What Works

1. **UI Layer**
   - Conversation list screen
   - Chat screen with message bubbles
   - Network status display
   - Peer discovery dialog

2. **Data Layer**
   - Message models
   - Peer models
   - Local storage structure (Hive)
   - Service architecture (GetIt, Provider)

3. **Mock Functionality**
   - Simulated peer discovery
   - Message sending/receiving UI
   - Conversation management

### ⚠️ What's Simulated

1. **Peer Discovery**
   - Currently simulates finding peers every 10 seconds
   - Replace with real Bluetooth/WiFi discovery

2. **Message Transmission**
   - UI shows messages, but they're not actually sent
   - Needs platform-specific networking implementation

3. **Encryption**
   - Not yet implemented
   - End-to-end encryption planned

### ❌ Not Yet Implemented

1. **Real Mesh Networking**
   - Bluetooth LE discovery
   - WiFi Direct (Android)
   - Multipeer Connectivity (iOS)

2. **Message Routing**
   - Epidemic routing algorithm
   - Store-and-forward mechanism
   - TTL and hop count enforcement

3. **Security**
   - End-to-end encryption
   - Key exchange
   - Message signing

4. **Advanced Features**
   - Voice messages
   - Location sharing
   - Group messaging
   - Network visualization

---

## Next Steps for Development

### Phase 1: Real Bluetooth Discovery (CURRENT)

**Android Implementation:**
1. Add permissions to `AndroidManifest.xml`:
```xml
<uses-permission android:name="android.permission.BLUETOOTH"/>
<uses-permission android:name="android.permission.BLUETOOTH_ADMIN"/>
<uses-permission android:name="android.permission.BLUETOOTH_SCAN"/>
<uses-permission android:name="android.permission.BLUETOOTH_ADVERTISE"/>
<uses-permission android:name="android.permission.BLUETOOTH_CONNECT"/>
<uses-permission android:name="android.permission.ACCESS_FINE_LOCATION"/>
<uses-permission android:name="android.permission.ACCESS_COARSE_LOCATION"/>
<uses-permission android:name="android.permission.NEARBY_WIFI_DEVICES"/>
```

2. Implement Bluetooth LE scanning in `mesh_network_service.dart`
3. Use `flutter_nearby_connections` or `nearby_connections` package

**iOS Implementation:**
1. Add permissions to `Info.plist`:
```xml
<key>NSBluetoothAlwaysUsageDescription</key>
<string>We need Bluetooth to connect with nearby devices</string>
<key>NSLocalNetworkUsageDescription</key>
<string>We need local network access for mesh communication</string>
```

2. Implement Multipeer Connectivity framework
3. Create platform channel for native iOS code

### Phase 2: Message Transmission

1. Implement actual Bluetooth data transfer
2. Add WiFi Direct for Android (faster, longer range)
3. Handle connection management
4. Implement retry logic

### Phase 3: Routing & Forwarding

1. Implement epidemic routing
2. Add message deduplication
3. Store-and-forward for offline delivery
4. Hop count and TTL enforcement

### Phase 4: Encryption

1. Integrate libsodium or similar
2. Implement Signal Protocol
3. Key generation and exchange
4. Encrypted message format

### Phase 5: Polish & Testing

1. Battery optimization
2. Stress testing with many devices
3. UI/UX improvements
4. Accessibility features
5. Multi-language support

---

## Testing Strategy

### Unit Testing
```bash
flutter test
```

### Integration Testing
```bash
flutter test integration_test/
```

### Manual Testing Checklist

**Basic Functionality:**
- [ ] App launches successfully
- [ ] Can navigate between screens
- [ ] Can type and send messages (UI)
- [ ] Messages appear in conversation list
- [ ] Conversation updates with new messages

**Mesh Networking (Once Implemented):**
- [ ] Discovers nearby devices
- [ ] Connects to peers
- [ ] Sends messages successfully
- [ ] Receives messages from peers
- [ ] Relays messages for others
- [ ] Works with 2+ devices in mesh

**Edge Cases:**
- [ ] Airplane mode handling
- [ ] App backgrounding
- [ ] Device restart
- [ ] Low battery
- [ ] Network switching

---

## Debugging Tips

### Check Logs

```bash
# View all logs
flutter logs

# Filter for specific tags
flutter logs | grep "MeshNetwork"
```

### Common Issues

**Build Errors:**
```bash
# Clean and rebuild
flutter clean
flutter pub get
flutter pub run build_runner build --delete-conflicting-outputs
```

**Dependency Issues:**
```bash
# Update dependencies
flutter pub upgrade

# Check for issues
flutter doctor
```

**Platform-Specific Issues:**
- Android: Check Android Studio > SDK Manager for updates
- iOS: Check Xcode for updates, clean build folder

---

## Performance Optimization

### Battery Usage
- Adjust Bluetooth scan intervals
- Use BLE advertising efficiently
- Implement smart sleep/wake cycles
- Monitor battery in testing

### Memory Usage
- Limit message history in memory
- Implement pagination for long conversations
- Clean up old peer connections
- Use Hive efficiently

### Network Efficiency
- Compress messages
- Batch transfers when possible
- Implement smart retry logic
- Deduplicate messages

---

## Contributing

### Code Style
- Follow Flutter style guide
- Use `flutter format` before committing
- Pass lint checks: `flutter analyze`
- Write meaningful commit messages

### Pull Request Process
1. Create feature branch
2. Implement changes
3. Add tests
4. Update documentation
5. Submit PR with description

---

## Resources

### Documentation
- Flutter: https://flutter.dev/docs
- Bluetooth LE: https://developer.android.com/guide/topics/connectivity/bluetooth-le
- WiFi Direct: https://developer.android.com/guide/topics/connectivity/wifip2p
- Multipeer Connectivity: https://developer.apple.com/documentation/multipeerconnectivity

### Similar Projects
- Bridgefy: Study their approach
- Briar: Open source, privacy-focused
- Serval Mesh: Academic research project
- Meshtastic: LoRa-based (hardware)

### Communities
- Flutter Discord
- r/FlutterDev
- Stack Overflow (flutter tag)

---

## Support

For questions or issues:
1. Check this documentation
2. Search existing issues
3. Ask in Discord/Telegram (when created)
4. Create GitHub issue (when repository created)

---

**Happy Building! You're creating something that could save lives.** 🚀
