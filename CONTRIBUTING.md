# Contributing to Crisis Mesh Messenger

Thank you for your interest in contributing to Crisis Mesh Messenger! This is a humanitarian project that aims to provide communication in crisis situations.

## Ways to Contribute

### 1. Code Contributions
- Implement real Bluetooth/WiFi mesh networking
- Add encryption features
- Improve UI/UX
- Fix bugs
- Optimize performance
- Add tests

### 2. Documentation
- Improve setup guides
- Write tutorials
- Translate documentation
- Create video guides

### 3. Testing
- Test on various devices
- Report bugs
- Test in real-world scenarios
- Performance testing

### 4. Design
- UI/UX improvements
- Icon design
- Accessibility improvements
- Internationalization

## Development Process

### Getting Started

1. **Fork the repository**
   ```bash
   # Click "Fork" on GitHub
   ```

2. **Clone your fork**
   ```bash
   git clone https://github.com/YOUR_USERNAME/crisis-mesh-messenger.git
   cd crisis-mesh-messenger
   ```

3. **Set up development environment**
   ```bash
   flutter pub get
   flutter run
   ```

4. **Create a branch**
   ```bash
   git checkout -b feature/your-feature-name
   # or
   git checkout -b fix/bug-description
   ```

### Making Changes

1. **Follow Flutter style guide**
   ```bash
   # Format code
   flutter format .
   
   # Analyze
   flutter analyze
   ```

2. **Write meaningful commit messages**
   ```
   feat: Add Bluetooth discovery for Android
   fix: Resolve message duplication issue
   docs: Update setup guide for iOS
   ```

3. **Test your changes**
   ```bash
   # Run tests
   flutter test
   
   # Test on real device
   flutter run
   ```

4. **Update documentation**
   - Update README if needed
   - Add comments to complex code
   - Update SETUP_GUIDE.md if process changes

### Submitting Changes

1. **Push to your fork**
   ```bash
   git push origin feature/your-feature-name
   ```

2. **Create Pull Request**
   - Go to GitHub
   - Click "New Pull Request"
   - Describe your changes clearly
   - Reference any related issues

3. **PR Description Template**
   ```markdown
   ## Description
   Brief description of changes
   
   ## Type of Change
   - [ ] Bug fix
   - [ ] New feature
   - [ ] Documentation update
   - [ ] Performance improvement
   
   ## Testing
   How was this tested?
   
   ## Checklist
   - [ ] Code follows style guidelines
   - [ ] Self-review completed
   - [ ] Documentation updated
   - [ ] Tests added/updated
   ```

## Code Style Guidelines

### Dart/Flutter

- Use `flutter format` before committing
- Follow [Effective Dart](https://dart.dev/guides/language/effective-dart)
- Prefer `final` over `var` where possible
- Use meaningful variable names
- Add comments for complex logic
- Keep functions small and focused

### File Organization

```
lib/
├── core/           # Business logic, models, services
├── ui/             # User interface
│   ├── screens/    # Full screens
│   ├── widgets/    # Reusable widgets
│   └── theme/      # Theming
└── main.dart       # Entry point
```

### Naming Conventions

- **Files**: `snake_case.dart`
- **Classes**: `PascalCase`
- **Variables/Functions**: `camelCase`
- **Constants**: `camelCase` or `SCREAMING_SNAKE_CASE` for compile-time constants
- **Private members**: `_leadingUnderscore`

## Testing Guidelines

### Unit Tests
```dart
test('Message hop count increments correctly', () {
  final message = Message(/* ... */);
  final forwarded = message.incrementHop('node123');
  expect(forwarded.hopCount, message.hopCount + 1);
});
```

### Widget Tests
```dart
testWidgets('Chat screen displays messages', (tester) async {
  await tester.pumpWidget(ChatScreen(/* ... */));
  expect(find.text('Hello'), findsOneWidget);
});
```

### Integration Tests
- Test real device discovery
- Test message transmission
- Test multi-device scenarios

## Priority Areas

### High Priority (Most Needed)
1. **Real Bluetooth Implementation** - Core functionality
2. **WiFi Direct (Android)** - Better range/speed
3. **Multipeer Connectivity (iOS)** - iOS support
4. **End-to-end Encryption** - Security

### Medium Priority
5. Message routing optimization
6. Battery usage optimization
7. Network visualization
8. Group messaging

### Lower Priority
9. Voice messages
10. File sharing
11. Location sharing

## Community Guidelines

### Be Respectful
- Respect all contributors
- Constructive feedback only
- Patient with new contributors

### Be Collaborative
- Discuss major changes in issues first
- Share knowledge
- Help others learn

### Be Humanitarian
- Remember this is for crisis situations
- Prioritize reliability over features
- Consider users in extreme conditions

## Security

### Reporting Vulnerabilities
- **Do NOT** open public issues for security bugs
- Email: [To be set up]
- Encrypt sensitive info with GPG key [To be provided]

### Security Considerations
- All PR reviews check for security issues
- Encryption implementation requires expert review
- Privacy-first approach always

## Recognition

Contributors will be:
- Listed in CONTRIBUTORS.md
- Mentioned in release notes
- Credited in About screen (for major contributions)

## Questions?

- **General questions**: Open an issue with label `question`
- **Technical discussion**: Open issue with label `discussion`
- **Chat**: [Discord/Telegram to be set up]

## License

By contributing, you agree that your contributions will be licensed under the MIT License (see LICENSE file).

---

**Thank you for helping build Crisis Mesh Messenger!**

Your contributions could literally save lives in crisis situations. 🙏
