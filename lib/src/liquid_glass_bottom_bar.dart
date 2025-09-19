import 'dart:ui';
import 'package:flutter/material.dart';

/// Defines an item for the [LiquidGlassBottomBar].
class LiquidGlassBottomBarItem {
  /// The icon to display.
  final IconData icon;

  /// An optional icon to display when the item is active. If null, [icon] is used.
  final IconData? activeIcon;

  /// The text label to display below the icon.
  final String label;

  /// An optional badge count to display on the icon.
  final int? badge;

  const LiquidGlassBottomBarItem({
    required this.icon,
    required this.label,
    this.activeIcon,
    this.badge,
  });
}

/// A highly customizable navigation bar with an iOS-inspired "liquid glass"
/// effect. It features a frosted glass background and an animated, blurred
/// pill that highlights the active item.
class LiquidGlassBottomBar extends StatelessWidget {
  /// The list of items to display in the navigation bar. Requires at least 2 items.
  final List<LiquidGlassBottomBarItem> items;

  /// The index of the currently selected item.
  final int currentIndex;

  /// A callback function that is invoked when an item is tapped.
  final ValueChanged<int> onTap;

  /// The height of the navigation bar.
  /// Defaults to 74.0 if labels are shown, or 56.0 otherwise.
  final double? height;

  /// The margin around the navigation bar.
  final EdgeInsetsGeometry margin;

  /// Whether to show text labels for the items.
  final bool showLabels;

  /// The accent color for the active item's icon and label.
  /// Defaults to an iOS blue.
  final Color activeColor;

  /// The blur intensity for the main navigation bar's background.
  final double barBlurSigma;

  /// The blur intensity for the active item's pill.
  final double activeBlurSigma;

  const LiquidGlassBottomBar({
    super.key,
    required this.items,
    required this.currentIndex,
    required this.onTap,
    this.height,
    this.margin = const EdgeInsets.fromLTRB(12, 0, 12, 12),
    this.showLabels = true,
    this.activeColor = const Color(0xFF0A84FF), // Default iOS blue
    this.barBlurSigma = 16,
    this.activeBlurSigma = 24,
  }) : assert(items.length >= 2, 'At least 2 items are required.');

  @override
  Widget build(BuildContext context) {
    final media = MediaQuery.of(context);
    final double barH = height ?? (showLabels ? 74.0 : 56.0);
    final double bottomSafe = media.padding.bottom * 0.35;

    return SafeArea(
      top: false,
      child: Padding(
        padding: margin.add(EdgeInsets.only(bottom: bottomSafe)),
        child: SizedBox(
          height: barH,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(22),
            child: Stack(
              children: [
                Positioned.fill(
                  child: ClipRect(
                    child: BackdropFilter(
                      filter: ImageFilter.blur(
                        sigmaX: barBlurSigma,
                        sigmaY: barBlurSigma,
                      ),
                      child: Container(
                        color: Colors.white.withAlpha(10),
                      ),
                    ),
                  ),
                ),
                Positioned.fill(
                  child: IgnorePointer(
                    child: DecoratedBox(
                      decoration: BoxDecoration(
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withAlpha(54),
                            blurRadius: 16,
                            offset: const Offset(0, 8),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                _ActivePillRow(
                  items: items,
                  index: currentIndex,
                  barHeight: barH,
                  blurSigma: activeBlurSigma,
                  activeColor: activeColor,
                  showLabels: showLabels,
                ),
                Row(
                  children: List.generate(items.length, (i) {
                    final item = items[i];
                    final bool selected = i == currentIndex;
                    return Expanded(
                      child: _PlainItem(
                        item: item,
                        selected: selected,
                        onTap: () => onTap(i),
                        showLabels: showLabels,
                        activeColor: activeColor,
                      ),
                    );
                  }),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _ActivePillRow extends StatelessWidget {
  final List<LiquidGlassBottomBarItem> items;
  final int index;
  final double barHeight;
  final double blurSigma;
  final Color activeColor;
  final bool showLabels;

  const _ActivePillRow({
    required this.items,
    required this.index,
    required this.barHeight,
    required this.blurSigma,
    required this.activeColor,
    required this.showLabels,
  });

  double _textWidth(String text, double maxWidth) {
    final tp = TextPainter(
      text: TextSpan(
        text: text,
        style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w700),
      ),
      maxLines: 1,
      textDirection: TextDirection.ltr,
    )..layout(maxWidth: maxWidth);
    return tp.width;
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (_, c) {
      final slotWidth = c.maxWidth / items.length;
      final verticalPadding = showLabels ? 8.0 : 6.0;
      final pillHeight = barHeight - verticalPadding * 2;
      final double contentWidth = showLabels
          ? 24 + 6 + _textWidth(items[index].label, slotWidth)
          : 24;
      final double horizontalPadding = showLabels ? 20.0 : 14.0;
      final double pillWidth =
          (contentWidth + horizontalPadding * 2).clamp(48.0, slotWidth - 12.0);
      return Padding(
        padding: EdgeInsets.symmetric(vertical: verticalPadding),
        child: Row(
          children: List.generate(items.length, (i) {
            final bool isActive = i == index;
            return Expanded(
              child: Center(
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 220),
                  curve: Curves.easeOutCubic,
                  width: isActive ? pillWidth : 0,
                  height: pillHeight,
                  child: isActive
                      ? ClipRRect(
                          borderRadius: BorderRadius.circular(18),
                          child: ClipRect(
                            child: Stack(
                              fit: StackFit.expand,
                              children: [
                                BackdropFilter(
                                  filter: ImageFilter.blur(
                                    sigmaX: blurSigma,
                                    sigmaY: blurSigma,
                                  ),
                                  child: const SizedBox.expand(),
                                ),
                                Container(color: Colors.white.withAlpha(8)),
                                IgnorePointer(
                                  child: Stack(
                                    children: [
                                      Positioned.fill(
                                        child: DecoratedBox(
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(18),
                                            gradient: LinearGradient(
                                              begin: Alignment.topCenter,
                                              end: Alignment.bottomCenter,
                                              colors: [
                                                Colors.white.withAlpha(36),
                                                Colors.transparent,
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                      Positioned.fill(
                                        child: DecoratedBox(
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(18),
                                            gradient: RadialGradient(
                                              center:
                                                  const Alignment(0.15, -0.8),
                                              radius: 1.05,
                                              colors: [
                                                activeColor.withAlpha(24),
                                                Colors.transparent,
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        )
                      : const SizedBox.shrink(),
                ),
              ),
            );
          }),
        ),
      );
    });
  }
}

class _PlainItem extends StatelessWidget {
  final LiquidGlassBottomBarItem item;
  final bool selected;
  final VoidCallback onTap;
  final bool showLabels;
  final Color activeColor;

  const _PlainItem({
    required this.item,
    required this.selected,
    required this.onTap,
    required this.showLabels,
    required this.activeColor,
  });

  @override
  Widget build(BuildContext context) {
    final Color iconColor = selected ? activeColor : Colors.white;
    final Color textColor =
        selected ? activeColor : Colors.white.withAlpha(210);

    return InkWell(
      onTap: onTap,
      customBorder: const StadiumBorder(),
      child: Padding(
        padding:
            EdgeInsets.symmetric(horizontal: 10, vertical: showLabels ? 10 : 8),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Stack(
              clipBehavior: Clip.none,
              children: [
                // Use direct Icon color; do not wrap with ShaderMask for solid colors.
                Icon(
                  selected ? (item.activeIcon ?? item.icon) : item.icon,
                  size: 22,
                  color: iconColor,
                ),
                if ((item.badge ?? 0) > 0)
                  Positioned(
                    right: -8,
                    top: -6,
                    child: _Badge(count: item.badge!),
                  ),
              ],
            ),
            if (showLabels) ...[
              const SizedBox(height: 4),
              Text(
                item.label,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: selected ? FontWeight.w700 : FontWeight.w500,
                  color: textColor,
                  letterSpacing: 0.1,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _Badge extends StatelessWidget {
  final int count;
  const _Badge({required this.count});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 2),
      decoration: BoxDecoration(
        color: const Color(0xFFE53935).withAlpha(235), // Red
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.white.withAlpha(200), width: 1),
        boxShadow: [
          BoxShadow(
              color: Colors.black.withAlpha(120),
              blurRadius: 8,
              offset: const Offset(0, 2)),
        ],
      ),
      child: Text(
        count > 99 ? '99+' : '$count',
        style: const TextStyle(
            fontSize: 9,
            fontWeight: FontWeight.w700,
            color: Colors.white,
            height: 1),
      ),
    );
  }
}
