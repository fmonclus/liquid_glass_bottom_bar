# Liquid Glass Bottom Bar

[![pub version](https://img.shields.io/pub/v/liquid_glass_bottom_bar.svg)](https://pub.dev/packages/liquid_glass_bottom_bar)
[![license](https://img.shields.io/badge/license-MIT-blue.svg)](https://opensource.org/licenses/MIT)

A beautiful Flutter bottom navigation bar with an iOS‑inspired **“liquid glass”** effect:
a frosted/translucent background and an animated, blurred **pill** that highlights the active item.

---

![Demo](https://github.com/fmonclus/liquid_glass_bottom_bar/blob/main/screenshots/liquid_glass_bottom_bar.gif?raw=true)

## ✨ Features

- **Glassmorphism:** real blur (frosted) background.
- **Liquid pill:** animated, translucent pill for the active tab.
- **Customizable:** colors, height, labels on/off, margins, blur intensity.
- **Badges:** show a counter per item.
- **Simple API:** drop-in `bottomNavigationBar` for your `Scaffold`.

---

## 🚀 Install

Add the dependency in `pubspec.yaml`:

```yaml
dependencies:
  liquid_glass_bottom_bar: ^0.0.5   # use the latest version
```

Then run:

```bash
flutter pub get
```

---

## 🧩 Usage

> **Important:** for the glass effect to be visible, use `Scaffold(extendBody: true)` and make sure there is
> content behind the bar (e.g., your page body, a gradient, an image, etc.).

```dart
import 'package:flutter/material.dart';
import 'package:liquid_glass_bottom_bar/liquid_glass_bottom_bar.dart';

class MyScreen extends StatefulWidget {
  const MyScreen({super.key});

  @override
  State<MyScreen> createState() => _MyScreenState();
}

class _MyScreenState extends State<MyScreen> {
  int _currentIndex = 0;

  final _pages = const [
    Center(child: Text('Home')),
    Center(child: Text('Search')),
    Center(child: Text('Profile')),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true, // <- required for the frosted effect
      appBar: AppBar(title: const Text('Liquid Glass Demo')),
      body: IndexedStack(index: _currentIndex, children: _pages),
      bottomNavigationBar: LiquidGlassBottomBar(
        items: const [
          LiquidGlassBottomBarItem(
            icon: Icons.home_outlined,
            activeIcon: Icons.home,
            label: 'Home',
          ),
          LiquidGlassBottomBarItem(
            icon: Icons.search_outlined,
            label: 'Search',
          ),
          LiquidGlassBottomBarItem(
            icon: Icons.person_outline,
            activeIcon: Icons.person,
            label: 'Profile',
            badge: 5,
          ),
        ],
        currentIndex: _currentIndex,
        onTap: (i) => setState(() => _currentIndex = i),
        // Customize:
        activeColor: const Color(0xFF34C3FF), // iOS-like blue
        barBlurSigma: 16,
        activeBlurSigma: 24,
      ),
    );
  }
}
```

---

## ⚙️ API

### `LiquidGlassBottomBar`

| Property          | Type                             | Default                                | Description                                        |
|-------------------|----------------------------------|----------------------------------------|----------------------------------------------------|
| `items`           | `List<LiquidGlassBottomBarItem>` | — (required)                           | Tabs to render.                                    |
| `currentIndex`    | `int`                            | — (required)                           | Index of the active tab.                           |
| `onTap`           | `ValueChanged<int>`              | — (required)                           | Callback when a tab is tapped.                     |
| `height`          | `double?`                        | `74.0` (labels) / `56.0` (no labels)   | Bar height.                                        |
| `margin`          | `EdgeInsetsGeometry`             | `EdgeInsets.fromLTRB(12,0,12,12)`      | Outer margin of the bar.                           |
| `showLabels`      | `bool`                           | `true`                                 | Whether to show text labels.                       |
| `activeColor`     | `Color`                          | `Color(0xFF0A84FF)`                    | Accent color for active icon/label.                |
| `barBlurSigma`    | `double`                         | `16`                                   | Blur intensity for the bar background.             |
| `activeBlurSigma` | `double`                         | `24`                                   | Additional blur used for the active pill.          |

### `LiquidGlassBottomBarItem`

| Property     | Type       | Description                                             |
|--------------|------------|---------------------------------------------------------|
| `icon`       | `IconData` | Base icon.                                              |
| `activeIcon` | `IconData?`| Optional icon when active (falls back to `icon`).      |
| `label`      | `String`   | Text label.                                             |
| `badge`      | `int?`     | Optional badge counter.                                 |

---

## ✅ Tips

- Use `Scaffold(extendBody: true)` so the body paints *under* the bar.
- Have **something** behind the bar (gradient/image/list) so the blur can sample content.
- Prefer a slight contrast behind the bar to make the frosted effect stand out.

---

## 🐞 Troubleshooting

**Icons appear black** on some devices (Impeller/Android):
- Avoid `ShaderMask` for solid colors. Use plain `Icon(color: ...)` or the package defaults.
- If a parent `IconTheme` forces a dark color, wrap the icon with a local `IconTheme` or set `color:` explicitly.
- Do a **hot restart** after adding the package to clear cached layers.

If you still see issues, open an issue with a small repro, device/OS, and Flutter version.

---

## 📄 License

This project is licensed under the [MIT License](LICENSE).
