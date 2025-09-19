// test/liquid_glass_bottom_bar_test.dart

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:liquid_glass_bottom_bar/liquid_glass_bottom_bar.dart';

// A basic app wrapper to provide context (like MaterialApp) for the widget tests.
Widget createTestApp(Widget child) {
  return MaterialApp(
    home: Scaffold(
      body: child,
    ),
  );
}

void main() {
  group('LiquidGlassBottomBar Tests', () {
    // Define a constant list of items to use across tests.
    const testItems = [
      LiquidGlassBottomBarItem(
        icon: Icons.home_outlined,
        activeIcon: Icons.home,
        label: 'Home',
      ),
      LiquidGlassBottomBarItem(
        icon: Icons.search_outlined,
        activeIcon: Icons.search,
        label: 'Search',
      ),
      LiquidGlassBottomBarItem(
        icon: Icons.person_outline,
        activeIcon: Icons.person,
        label: 'Profile',
        badge: 5,
      ),
    ];

    testWidgets('Renders correctly with minimum required properties',
        (WidgetTester tester) async {
      // CORRECTED: Removed 'const'
      await tester.pumpWidget(createTestApp(
        LiquidGlassBottomBar(
          items: testItems,
          currentIndex: 0,
          onTap: _doNothing,
        ),
      ));

      // Verify that the widget itself is on the screen.
      expect(find.byType(LiquidGlassBottomBar), findsOneWidget);
    });

    testWidgets('Displays the correct number of items',
        (WidgetTester tester) async {
      // CORRECTED: Removed 'const'
      await tester.pumpWidget(createTestApp(
        LiquidGlassBottomBar(
          items: testItems,
          currentIndex: 0,
          onTap: _doNothing,
        ),
      ));

      // Expect to find three labels and three icons corresponding to the items.
      expect(find.text('Home'), findsOneWidget);
      expect(find.text('Search'), findsOneWidget);
      expect(find.text('Profile'), findsOneWidget);
      expect(find.byIcon(Icons.home), findsOneWidget); // Active icon
    });

    testWidgets('Highlights the correct initial item',
        (WidgetTester tester) async {
      // CORRECTED: Removed 'const'
      await tester.pumpWidget(createTestApp(
        LiquidGlassBottomBar(
          items: testItems,
          currentIndex: 1, // Start with the second item active.
          onTap: _doNothing,
        ),
      ));

      // The active icon should be visible.
      expect(find.byIcon(Icons.search), findsOneWidget);

      // The inactive icons should be visible.
      expect(find.byIcon(Icons.home_outlined), findsOneWidget);
      expect(find.byIcon(Icons.person_outline), findsOneWidget);

      // The inactive filled icons should NOT be visible.
      expect(find.byIcon(Icons.home), findsNothing);
      expect(find.byIcon(Icons.person), findsNothing);
    });

    testWidgets('onTap callback is triggered with the correct index',
        (WidgetTester tester) async {
      int? tappedIndex;

      await tester.pumpWidget(createTestApp(
        LiquidGlassBottomBar(
          items: testItems,
          currentIndex: 0,
          onTap: (index) {
            tappedIndex = index;
          },
        ),
      ));

      // Find the tappable area for the 'Profile' item and tap it.
      await tester.tap(find.text('Profile'));
      await tester.pump(); // Rebuild the widget after the tap.

      // Verify that the callback was called with the correct index (2).
      expect(tappedIndex, 2);
    });

    testWidgets('Displays a badge when count is provided',
        (WidgetTester tester) async {
      // CORRECTED: Removed 'const'
      await tester.pumpWidget(createTestApp(
        LiquidGlassBottomBar(
          items: testItems,
          currentIndex: 0,
          onTap: _doNothing,
        ),
      ));

      // Find the badge by its text content.
      expect(find.text('5'), findsOneWidget);
    });
  });
}

// A helper function for callbacks that don't need to do anything in tests.
void _doNothing(int index) {}
