import 'package:flutter/material.dart';
import 'package:smart_gloves_01/pages/credits.dart';
import 'package:smart_gloves_01/pages/devices.dart';
import 'package:smart_gloves_01/pages/guide.dart';
import 'package:smart_gloves_01/pages/settings.dart';
import 'package:smart_gloves_01/pages/spectrometer.dart';

class Homepage extends StatefulWidget {
  const Homepage({super.key});

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> with SingleTickerProviderStateMixin{
  late final AnimationController _controller; // controller per le animazioni

  int _currentIndex = 0;

  // Lista delle pagine per ciascun tab
  late final List<Widget> _tabs;

  @override
  void initState() {
    super.initState();
    _tabs = [
      HomePageLayout(onNavigate: _navigateToTab),
      const Devices(),
      const Spectrometer(),
      const Settings(),
      const Credits(),
    ];
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
      
    /*
    /// BOTTOM NAVBAR
    */

  // Funzione per navigare tra i tab
  void _navigateToTab(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Smart Gloves v1.1.2+3",
              style: TextStyle(fontWeight: FontWeight.w500),
            ),
            Text(
              "Kujto Fetahi - 4^AEN",
              style: TextStyle(fontSize: 13, fontWeight: FontWeight.w300),
            ),
          ],
        ),
        elevation: 2,
      ),
      body: IndexedStack(
        index: _currentIndex,
        children: _tabs,
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 6)],
          borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: ClipRRect(
          borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
          child: BottomNavigationBar(
            currentIndex: _currentIndex,
            onTap: (index) => setState(() => _currentIndex = index),
            backgroundColor: Colors.white,
            type: BottomNavigationBarType.fixed,
            selectedItemColor: Colors.deepOrangeAccent,
            unselectedItemColor: const Color.fromARGB(255, 44, 44, 44),
            showUnselectedLabels: true,
            selectedLabelStyle: const TextStyle(fontWeight: FontWeight.bold),
            unselectedLabelStyle: const TextStyle(fontWeight: FontWeight.w400),
            items: [
              _navBarItem(Icons.home, "Home", 0),
              _navBarItem(Icons.wifi, "Dispositivi", 1),
              _navBarItem(Icons.graphic_eq, "Audio", 2),
              _navBarItem(Icons.settings, "Impostazioni", 3),
              _navBarItem(Icons.info, "Crediti", 4),
            ],
          ),
        ),
      ),
    );
  }

  BottomNavigationBarItem _navBarItem(IconData icon, String label, int index) {
    return BottomNavigationBarItem(
      icon: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: EdgeInsets.only(top: _currentIndex == index ? 2 : 6),
        child: Icon(
          icon,
          size: _currentIndex == index ? 28 : 24,
          color: _currentIndex == index ? Colors.deepOrangeAccent : const Color.fromARGB(255, 126, 126, 126),
        ),
      ),
      label: label,
    );
  }
}

// ----------------------------
// LAYOUT DELLA HOMEPAGE
// ----------------------------

class HomePageLayout extends StatelessWidget {
  final Function(int) onNavigate;

  const HomePageLayout({super.key, required this.onNavigate});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Expanded(
                flex: 1,
                child: Column(
                  children: [
                    Expanded(
                      child: _AnimatedCard(
                        title: "Connetti Guanto",
                        onTap: () => onNavigate(1),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Expanded(
                      child: _AnimatedCard(
                        title: "Guida all'uso",
                        onTap: () => showModalBottomSheet(
                          context: context,
                          isScrollControlled: true,
                          shape: const RoundedRectangleBorder(
                            borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
                          ),
                          builder: (context) => const Padding(
                            padding: EdgeInsets.all(16.0),
                            child: Guide(),
                          )
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                flex: 2,
                child: _AnimatedCard(
                  title: "Analizza audio",
                  isMain: true,
                  onTap: () => onNavigate(2),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ----------------------------
// CARD ANIMATA PERSONALIZZATA
// ----------------------------

class _AnimatedCard extends StatefulWidget {
  final String title;
  final VoidCallback onTap;
  final bool isMain;

  const _AnimatedCard({
    required this.title,
    required this.onTap,
    this.isMain = false,
  });

  @override
  State<_AnimatedCard> createState() => _AnimatedCardState();
}

class _AnimatedCardState extends State<_AnimatedCard> {
  double _scale = 1.0;

  // Gestione del tocco per l'animazione
  void _onTapDown(_) => setState(() => _scale = 0.97);
  void _onTapUp(_) => setState(() => _scale = 1.0);
  void _onTapCancel() => setState(() => _scale = 1.0);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onTap,
      onTapDown: _onTapDown,
      onTapUp: _onTapUp,
      onTapCancel: _onTapCancel,
      child: AnimatedScale(
        scale: _scale,
        duration: const Duration(milliseconds: 120),
        curve: Curves.easeOut,
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(28),
            border: Border(
              top: BorderSide(
                color: Colors.deepOrangeAccent,
                width: 4,
              ),
            ),
            gradient: LinearGradient(colors: [const Color.fromARGB(214, 216, 216, 216), const Color.fromARGB(220, 255, 248, 248)]),
          ),
          padding: const EdgeInsets.all(24),
          child: Center(
            child: Text(
              widget.title,
              style: TextStyle(
                fontSize: widget.isMain ? 22 : 18,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ),
      ),
    );
  }
}