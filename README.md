# Sumber Sentuhan Emas (SSF) - Real Estate App

Flutter mobile application for showcasing real estate projects.

## Project Structure

```
lib/
├── main.dart
├── core/
│   ├── constants/        # Colors, text styles, strings
│   └── theme/            # App theme configuration
├── data/
│   ├── models/           # Data models
│   └── repositories/     # Data repositories (mock data)
├── presentation/
│   ├── widgets/          # Reusable widgets
│   ├── screens/          # Screen widgets
│   └── providers/        # State management (Provider)
└── assets/               # Images, icons, fonts
```

## Setup Instructions

1. **Install dependencies:**
   ```bash
   flutter pub get
   ```

2. **Add your images:**
   - Place hero images in: `assets/images/hero/hero_1.jpg`, `hero_2.jpg`
   - Place project images in: `assets/images/projects/cendrawasih.jpg`, `andi_tonro.jpg`, `bajeng.jpg`
   - Update `pubspec.yaml` to include assets (uncomment the assets section)

3. **Add your logo:**
   - Place logo in: `assets/icons/logo.png` or `logo.svg`
   - Update the `AppHeader` widget to use your logo

4. **Run the app:**
   ```bash
   flutter run
   ```

## Features Implemented

- ✅ Home screen with hero carousel
- ✅ Project cards with featured tags
- ✅ Bottom navigation bar
- ✅ Responsive design
- ✅ State management with Provider
- ✅ Mock data repository (ready for backend integration)

## TODO

- [ ] Add actual images (see comments in code)
- [ ] Add logo image
- [ ] Implement other screens (Projects, Contact, About Us)
- [ ] Add project detail screen
- [ ] Connect to backend API (when ready)

## Dependencies

- `provider` - State management
- `carousel_slider` - Hero carousel
- `cupertino_icons` - Icons

## Notes

- Images are currently placeholders - replace with your actual images
- Logo is currently using Material Icons - replace with your logo image
- All TODO comments in code indicate where to add your assets
# SSE
# SSE
# SSE
# SSE
# SSE
