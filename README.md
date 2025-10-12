# Crisis Mesh Messenger

A decentralized, infrastructure-free messaging application for crisis situations.

## Overview

Crisis Mesh Messenger enables people to communicate when traditional infrastructure (internet, cell towers) fails due to:
- Natural disasters
- War and conflict
- Censorship
- Remote locations

Messages hop from device to device using Bluetooth and WiFi Direct, creating a resilient mesh network that requires no central infrastructure.

## Key Features

- ✅ No internet or cell towers required
- ✅ Device-to-device messaging (Bluetooth/WiFi)
- ✅ End-to-end encryption
- ✅ Store-and-forward routing
- ✅ Works on Android and iOS
- ✅ Free and open source

## Quick Start

```bash
# Install dependencies
flutter pub get

# Run on Android
flutter run

# Run on iOS
flutter run -d iPhone
```

## Architecture

### Technology Stack
- **Framework:** Flutter 3.29+
- **State Management:** Provider + GetIt (MVVM)
- **Local Storage:** Hive (encrypted)
- **Communication:** 
  - Android: Nearby Connections API, WiFi Direct, Bluetooth LE
  - iOS: Multipeer Connectivity, Bluetooth LE
- **Encryption:** End-to-end using libsodium

### Project Structure

```
lib/
├── core/
│   ├── di/              # Dependency injection setup
│   ├── models/          # Data models
│   ├── services/        # Business logic services
│   └── utils/           # Utilities and constants
├── features/
│   ├── messaging/       # Chat and conversations
│   ├── network/         # Mesh network management
│   └── settings/        # App settings
├── ui/
│   ├── screens/         # Screen widgets
│   ├── widgets/         # Reusable widgets
│   └── theme/           # App theming
└── main.dart
```

## Development Status

### Phase 1: Proof of Concept ✅ READY TO RUN
- [x] Project structure
- [x] Basic UI (Home, Chat, Network Status screens)
- [x] UI components (message bubbles, conversation list)
- [x] Local storage (Hive with models)
- [x] Service architecture (MVVM with Provider/GetIt)
- [x] Platform configurations (Android & iOS)
- [x] Simulated peer discovery
- [ ] Real Bluetooth/WiFi networking (Next phase)

## License

MIT License - Free for humanitarian use

## Contributing

This is a humanitarian project. Contributions welcome!

## Contact

For collaboration or questions, see documentation in `/docs`.
