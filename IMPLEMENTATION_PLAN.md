# Flutter Real Estate App - Implementation Plan
## Sumber Sentuhan Emas (SSF)

---

## 1. Design Analysis

### 1.1 UI Components Identified

#### **Header/Top Bar**
- Background: Dark green (#1B5E20 or similar)
- Left: "Home" text label
- Center: Logo with yellow house icon + "SSF" text + "Sumber Sentuhan Emas" text
- Right: Two icons (envelope/mail, user profile)

#### **Hero Banner Section**
- Full-width image carousel
- Overlay banner with dark green background
- "PREMIUM CLUSTER" badge (top-right)
- SSF logo (large, yellow)
- Title: "SUMBER SENTUHAN EMAS"
- Subtitle: "RUMAH UNTUK SEMUA"
- Feature list (8 items) with icons:
  - Smart Living Concept
  - Play Ground
  - Internet Access
  - Prime Location
  - 24/7 Security
  - One Gate System
  - Free Design
  - Free BPHTB
- Carousel indicator dots (3 dots, white)

#### **Section: "Finding The Right Home For You"**
- Large heading
- Text color: "Finding The Right" (dark green), "Home" (orange), "For You." (dark green)

#### **Section: "Our Projects"**
- Section heading: "Our Projects." (dark green)
- Project cards (3 visible):
  - **Golden Cendrawasih Residence**
  - **Golden Andi Tonro Residence** (note: image shows "Andi Torro")
  - **Golden Bajeng Residence** (note: image shows "Bajeng")
- Each card contains:
  - "Featured" orange tag (top-left)
  - Project image (full-width)
  - Dark green overlay on right side
  - "On Going Project" label (white)
  - Project name (white, bold)
  - Description text (white, multi-line)
  - "See More..." button (orange background, white text)

#### **Bottom Navigation Bar**
- Background: Dark green
- 4 navigation items:
  1. Home (house icon) - ACTIVE (orange)
  2. Projects (building icon) - white
  3. Contact (speech bubble icon) - white
  4. About Us (info icon) - white
- Each item has icon + text label below

### 1.2 Color Scheme
- **Primary Dark Green**: Header, overlays, navigation bar (#1B5E20 or #2E7D32)
- **Yellow**: SSF logo accents (#FFD700 or #FFC107)
- **Orange**: Active states, buttons, "Featured" tags (#FF6B35 or #FF9800)
- **White**: Text, icons on dark backgrounds
- **Light/Neutral**: Background areas (likely white or light gray)

### 1.3 Typography
- Large, bold headings for section titles
- Medium-weight text for project names
- Regular weight for descriptions and labels
- Clear hierarchy with size variations

### 1.4 Interactive Elements
- Carousel/slider with swipe gestures
- "See More..." buttons on project cards
- Bottom navigation with tap interactions
- Header icons (mail, profile) - likely navigate to other screens

---

## 2. Proposed Architecture

### 2.1 Project Structure
```
lib/
├── main.dart
├── core/
│   ├── constants/
│   │   ├── app_colors.dart
│   │   ├── app_text_styles.dart
│   │   └── app_strings.dart
│   ├── theme/
│   │   └── app_theme.dart
│   └── utils/
│       └── extensions.dart
├── data/
│   ├── models/
│   │   ├── project_model.dart
│   │   └── feature_model.dart
│   └── repositories/
│       └── project_repository.dart (mock data for now)
├── presentation/
│   ├── widgets/
│   │   ├── common/
│   │   │   ├── app_header.dart
│   │   │   ├── bottom_nav_bar.dart
│   │   │   └── featured_tag.dart
│   │   ├── home/
│   │   │   ├── hero_carousel.dart
│   │   │   ├── feature_list_item.dart
│   │   │   └── project_card.dart
│   │   └── sections/
│   │       ├── finding_home_section.dart
│   │       └── projects_section.dart
│   ├── screens/
│   │   ├── home/
│   │   │   └── home_screen.dart
│   │   ├── projects/
│   │   │   └── projects_screen.dart
│   │   ├── contact/
│   │   │   └── contact_screen.dart
│   │   └── about_us/
│   │       └── about_us_screen.dart
│   └── providers/ (or bloc/ if using BLoC)
│       ├── navigation_provider.dart
│       └── project_provider.dart
└── assets/
    ├── images/
    ├── icons/
    └── fonts/
```

### 2.2 State Management
**Recommended: Provider** (or Riverpod for more modern approach)
- **Why Provider/Riverpod?**
  - Simple for this app's complexity
  - Good for navigation state
  - Easy to manage project data
  - Well-documented and widely used
- **Alternative**: BLoC if you anticipate complex state interactions later

**State to Manage:**
- Current navigation index (which tab is active)
- Project list data
- Hero carousel current page index
- Future: User preferences, filters, etc.

### 2.3 Navigation Strategy
**Recommended: GoRouter** (Navigator 2.0)
- **Why GoRouter?**
  - Declarative routing
  - Deep linking support
  - Better state management
  - Easier to extend later
- **Alternative**: Traditional Navigator 2.0 or simple IndexedStack with bottom nav

**Route Structure:**
- `/` → Home Screen
- `/projects` → Projects Screen
- `/contact` → Contact Screen
- `/about-us` → About Us Screen

### 2.4 UI Libraries
**Core Dependencies:**
- `flutter_svg` or `flutter_svg` - for custom icons
- `carousel_slider` or `flutter_carousel_widget` - for hero banner carousel
- `provider` or `flutter_riverpod` - state management
- `go_router` - navigation

**Custom Widgets:**
- Build custom project cards (better control over design)
- Custom bottom navigation bar (matches exact design)
- Custom header component

**Optional Enhancements:**
- `cached_network_image` - if images come from network later
- `flutter_staggered_animations` - for smooth list animations
- `shimmer` - loading placeholders

---

## 3. Development Phases

### Phase 1: Foundation & Core Setup (Estimated: 2-3 hours)
**Goal**: Get the project structure and basic theme in place

**Tasks:**
1. Initialize Flutter project
2. Set up folder structure
3. Create color constants and theme
4. Set up typography/text styles
5. Configure dependencies (pubspec.yaml)
6. Create placeholder screens (Home, Projects, Contact, About Us)
7. Implement basic navigation structure

**Deliverables:**
- Project compiles and runs
- Basic navigation between 4 screens works
- Theme and colors defined

### Phase 2: Home Screen Implementation (Estimated: 4-5 hours)
**Goal**: Build the Home screen matching the design

**Tasks:**
1. Create AppHeader widget
2. Build HeroCarousel widget with:
   - Image carousel
   - Overlay banner
   - Feature list
   - Indicator dots
3. Create "Finding The Right Home For You" section
4. Build ProjectCard widget
5. Create "Our Projects" section with project list
6. Implement BottomNavigationBar
7. Connect mock data to UI

**Deliverables:**
- Home screen matches design
- All widgets render correctly
- Carousel is interactive
- Navigation bar works

### Phase 3: Data Models & Polish (Estimated: 2-3 hours)
**Goal**: Clean up code, add data models, polish animations

**Tasks:**
1. Create Project model
2. Create Feature model
3. Set up mock data repository
4. Add smooth animations and transitions
5. Responsive adjustments
6. Code cleanup and comments
7. Test on different screen sizes

**Deliverables:**
- Clean, maintainable code structure
- Smooth animations
- Proper data models
- Well-commented code

### Phase 4: Additional Screens (Future - Not in initial scope)
- Projects screen (full list view)
- Contact screen
- About Us screen
- Project detail screen (when "See More" is clicked)

---

## 4. Required Assets

### 4.1 Images Needed

#### **Hero Carousel Images**
- At least 1-2 high-quality property images (the modern house shown)
- Should be landscape orientation
- Recommended size: 1080x600px or larger

#### **Project Images**
- Image for "Golden Cendrawasih Residence"
- Image for "Golden Andi Tonro Residence"
- Image for "Golden Bajeng Residence"
- Should match the style shown (modern houses)
- Recommended size: 800x600px or larger

#### **Logo Assets**
- SSF logo (yellow house icon + text)
- Can be:
  - SVG (preferred for scalability)
  - PNG with transparent background
  - Or we can create a Flutter widget version

### 4.2 Icons Needed

#### **Header Icons**
- Envelope/mail icon
- User/profile icon

#### **Bottom Navigation Icons**
- Home (house icon)
- Projects (building icon)
- Contact (speech bubble icon)
- About Us (info/circle icon)

#### **Feature Icons** (8 icons for feature list)
- Smart Living Concept
- Play Ground
- Internet Access
- Prime Location
- 24/7 Security
- One Gate System
- Free Design
- Free BPHTB

**Icon Source Options:**
- **Option 1**: Use `flutter_launcher_icons` with Material Icons or Font Awesome
- **Option 2**: Use `flutter_svg` with custom SVG icons
- **Option 3**: Use `cupertino_icons` + `material_icons`
- **Recommendation**: Start with Material Icons (built-in), customize later if needed

### 4.3 Fonts
- **Option 1**: Use system default (Roboto on Android, SF Pro on iOS)
- **Option 2**: Use custom font if brand requires it
- **Initial Approach**: Start with system fonts, can add custom font later

### 4.4 Asset Organization
```
assets/
├── images/
│   ├── hero/
│   │   ├── hero_1.jpg
│   │   └── hero_2.jpg
│   └── projects/
│       ├── cendrawasih.jpg
│       ├── andi_tonro.jpg
│       └── bajeng.jpg
├── icons/
│   ├── logo.svg (or logo.png)
│   └── features/ (if custom SVGs)
└── fonts/ (if custom fonts)
    └── roboto/ (example)
```

---

## 5. Technical Decisions

### 5.1 Responsive Design
**Decision**: Mobile-first, with basic tablet support
- Primary target: Mobile phones (portrait)
- Tablet: Scale up layouts, maybe 2-column grid for projects
- Use `LayoutBuilder` and `MediaQuery` for responsive adjustments

### 5.2 Dark Mode
**Decision**: Not in initial scope
- Design shows light theme only
- Can add dark mode later if needed
- Theme system will be structured to allow easy dark mode addition

### 5.3 Data Management
**Decision**: Mock data initially, structured for backend integration
- Create proper data models from the start
- Use Repository pattern
- Mock data in a separate file/class
- Easy to swap with API calls later

**Mock Data Structure:**
```dart
// Example
Project {
  String id;
  String name;
  String description;
  String imageUrl;
  bool isFeatured;
  String status; // "On Going Project"
  List<String> features;
}
```

### 5.4 Backend Integration Readiness
**Preparation:**
- Use Repository pattern (abstract interface)
- Models should be JSON-serializable
- Consider using `json_serializable` package
- Future HTTP calls can use `dio` or `http` package
- State management ready for async data loading

### 5.5 Platform Support
- **iOS**: Full support
- **Android**: Full support
- **Web**: Not in initial scope (mobile app focus)
- **Desktop**: Not in initial scope

### 5.6 Performance Considerations
- Use `const` constructors wherever possible
- Implement image caching (if using network images)
- Lazy loading for project lists
- Optimize carousel (limit images loaded at once)

---

## 6. Additional Considerations

### 6.1 Code Quality
- Follow Flutter best practices
- Use `dart analyze` and `flutter format`
- Meaningful variable and widget names
- Comprehensive comments for complex logic
- Extract reusable widgets

### 6.2 Accessibility
- Semantic labels for images
- Proper contrast ratios
- Touch target sizes (minimum 48x48)
- Screen reader support (Semantics widgets where needed)

### 6.3 Future Enhancements (Post-MVP)
- Search/filter functionality
- Favorite/bookmark projects
- Share functionality
- Push notifications
- User authentication
- Project detail screens
- Image gallery
- Location maps
- Contact forms

---

## 7. Estimated Timeline

- **Phase 1**: 2-3 hours
- **Phase 2**: 4-5 hours
- **Phase 3**: 2-3 hours
- **Total**: ~8-11 hours of development time

**Note**: This assumes you have all assets (images) ready. If assets need to be created/procured, add additional time.

---

## 8. Open Questions for You

1. **Assets**: Do you have the actual images, or should I use placeholder images initially?
2. **Logo**: Do you have the SSF logo as an image file, or should I create a widget version?
3. **Custom Font**: Do you have a specific brand font, or should we use system fonts?
4. **Project Data**: Are the project names and descriptions in the image final, or do you have updated content?
5. **Navigation**: When users tap "See More" on a project card, what should happen? (Navigate to detail screen? Show modal? etc.)
6. **Other Screens**: Should I also build the Projects, Contact, and About Us screens in Phase 2, or focus only on Home screen first?
7. **State Management**: Do you have a preference between Provider and Riverpod, or any other state management solution?

---

## 9. Next Steps

Once you approve this plan:
1. I'll start with Phase 1 (project setup)
2. We'll proceed phase by phase
3. You can review and provide feedback after each phase
4. We'll iterate until the design is pixel-perfect

**Ready to proceed?** Please review and let me know:
- Any changes you'd like to the architecture
- Answers to the open questions
- Approval to start Phase 1
