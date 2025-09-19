import 'package:flutter/material.dart';
import 'package:liquid_glass_bottom_bar/liquid_glass_bottom_bar.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Liquid Glass Bottom Bar Example',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
      home: const DemoScreen(),
    );
  }
}

class DemoScreen extends StatefulWidget {
  const DemoScreen({super.key});

  @override
  State<DemoScreen> createState() => _DemoScreenState();
}

class _DemoScreenState extends State<DemoScreen> {
  int _currentIndex = 0;
  bool _showLabels = true;

  // Función para cambiar el estado, que pasaremos a las páginas hijas
  void _toggleLabels() {
    setState(() {
      _showLabels = !_showLabels;
    });
  }

  @override
  Widget build(BuildContext context) {
    // Definimos las páginas aquí para que puedan acceder a la función _toggleLabels
    // y al estado _showLabels.
    final List<Widget> pages = [
      _DemoPage(
        title: 'Library',
        icon: Icons.photo_library_outlined,
        showLabels: _showLabels,
        onToggleLabels: _toggleLabels,
      ),
      _DemoPage(
        title: 'Collections',
        icon: Icons.collections_bookmark_outlined,
        showLabels: _showLabels,
        onToggleLabels: _toggleLabels,
      ),
      _DemoPage(
        title: 'Search',
        icon: Icons.search,
        showLabels: _showLabels,
        onToggleLabels: _toggleLabels,
      ),
      _DemoPage(
        title: 'Settings',
        icon: Icons.settings_outlined,
        showLabels: _showLabels,
        onToggleLabels: _toggleLabels,
      ),
    ];

    return Scaffold(
      extendBody: true,
      appBar: AppBar(
        title: const Text('Liquid Glass Bottom Bar'),
        backgroundColor: Colors.blueGrey[900],
        foregroundColor: Colors.white,
      ),
      // El FloatingActionButton ha sido eliminado de aquí
      body: Stack(
        fit: StackFit.expand,
        children: [
          const _LiquidDemoBackground(),
          DefaultTextStyle.merge(
            style: const TextStyle(
              color: Colors.white,
              fontSize: 22,
              fontWeight: FontWeight.w700,
              shadows: [
                Shadow(blurRadius: 8, color: Colors.black54, offset: Offset(0, 2)),
              ],
            ),
            child: IndexedStack(index: _currentIndex, children: pages),
          ),
        ],
      ),
      bottomNavigationBar: LiquidGlassBottomBar(
        items: const [
          LiquidGlassBottomBarItem(
            icon: Icons.photo_library_outlined,
            activeIcon: Icons.photo_library,
            label: 'Library',
          ),
          LiquidGlassBottomBarItem(
            icon: Icons.collections_bookmark_outlined,
            activeIcon: Icons.collections_bookmark,
            label: 'Collections',
          ),
          LiquidGlassBottomBarItem(
            icon: Icons.search,
            label: 'Search',
          ),
          LiquidGlassBottomBarItem(
            icon: Icons.settings_outlined,
            activeIcon: Icons.settings,
            label: 'Settings',
            badge: 3,
          ),
        ],
        currentIndex: _currentIndex,
        onTap: (i) {
          if (_currentIndex != i) setState(() => _currentIndex = i);
        },
        showLabels: _showLabels,
        activeColor: const Color(0xFF34C3FF),
      ),
    );
  }
}

class _DemoPage extends StatelessWidget {
  final String title;
  final IconData icon;
  // Nuevos parámetros para recibir el estado y la función de callback
  final bool showLabels;
  final VoidCallback onToggleLabels;

  const _DemoPage({
    required this.title,
    required this.icon,
    required this.showLabels,
    required this.onToggleLabels,
  });

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 64, color: Colors.white),
          const SizedBox(height: 16),
          Text(title, textAlign: TextAlign.center),
          const SizedBox(height: 48), // Espacio extra
          // === INICIO DEL NUEVO CONTROL ===
          Text(
            'DEMO CONTROL',
            style: textTheme.labelSmall?.copyWith(color: Colors.white54, letterSpacing: 1),
          ),
          const SizedBox(height: 8),
          OutlinedButton(
            onPressed: onToggleLabels,
            style: OutlinedButton.styleFrom(
              foregroundColor: Colors.white,
              side: const BorderSide(color: Colors.white38),
              shape: const StadiumBorder(),
            ),
            child: Text(showLabels ? 'Hide Labels' : 'Show Labels'),
          ),
          // === FIN DEL NUEVO CONTROL ===
        ],
      ),
    );
  }
}

class _LiquidDemoBackground extends StatelessWidget {
  const _LiquidDemoBackground();

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: [
        const DecoratedBox(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Color(0xFF0F172A),
                Color(0xFF111827),
              ],
            ),
          ),
        ),
        Positioned(
          left: -40,
          bottom: 0,
          child: Container(
            width: 220,
            height: 220,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              color: Color(0x8CDA70D6),
            ),
          ),
        ),
        Positioned(
          right: -20,
          bottom: 40,
          child: Container(
            width: 180,
            height: 180,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              color: Color(0x8C20B2AA),
            ),
          ),
        ),
      ],
    );
  }
}