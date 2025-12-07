import 'package:flutter/material.dart';

class MethodSelectScreen extends StatelessWidget {
  const MethodSelectScreen({super.key});

  static const routeName = '/methods';

  @override
  Widget build(BuildContext context) {
    final methods = [
      _Method(
        title: 'Reflex Quiz',
        subtitle: '4 saniye / soru',
        icon: Icons.flash_on,
        gradient: const LinearGradient(
          colors: [Color(0xFF8E2DE2), Color(0xFF4A00E0)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      _Method(
        title: 'Flashcards',
        subtitle: 'Hızlı tekrar',
        icon: Icons.view_carousel,
        gradient: const LinearGradient(
          colors: [Color(0xFF00B09B), Color(0xFF96C93D)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      _Method(
        title: 'Writing Practice',
        subtitle: 'Yazarak pekiştir',
        icon: Icons.edit_note,
        gradient: const LinearGradient(
          colors: [Color(0xFF4776E6), Color(0xFF8E54E9)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      _Method(
        title: 'Listening Practice',
        subtitle: 'Duy ve cevapla',
        icon: Icons.headphones,
        gradient: const LinearGradient(
          colors: [Color(0xFF11998E), Color(0xFF38EF7D)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
    ];

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF6A11CB), Color(0xFF2575FC)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.arrow_back, color: Colors.white),
                      onPressed: () => Navigator.of(context).maybePop(),
                    ),
                    const SizedBox(width: 8),
                    const Text(
                      'Yöntem Seçimi',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 26,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  'Modunu seç, hemen öğrenmeye başla.',
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.85),
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 24),
                Expanded(
                  child: GridView.builder(
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 16,
                      mainAxisSpacing: 16,
                      childAspectRatio: 1,
                    ),
                    itemCount: methods.length,
                    itemBuilder: (context, index) {
                      final method = methods[index];
                      return _MethodCard(
                        method: method,
                        onTap: () {
                          Navigator.pushNamed(
                            context,
                            '/categories',
                            arguments: {'method': method.title},
                          );
                        },
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _MethodCard extends StatefulWidget {
  const _MethodCard({
    required this.method,
    required this.onTap,
  });

  final _Method method;
  final VoidCallback onTap;

  @override
  State<_MethodCard> createState() => _MethodCardState();
}

class _MethodCardState extends State<_MethodCard> {
  bool _pressed = false;
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    final scale = _pressed ? 0.96 : _hovered ? 1.02 : 1.0;

    return MouseRegion(
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: GestureDetector(
        onTapDown: (_) => setState(() => _pressed = true),
        onTapUp: (_) => setState(() => _pressed = false),
        onTapCancel: () => setState(() => _pressed = false),
        onTap: widget.onTap,
        child: AnimatedScale(
          scale: scale,
          duration: const Duration(milliseconds: 140),
          child: Container(
            decoration: BoxDecoration(
              gradient: widget.method.gradient,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.2),
                  blurRadius: 12,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            padding: const EdgeInsets.all(18),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.15),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    widget.method.icon,
                    color: Colors.white,
                    size: 32,
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.method.title,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      widget.method.subtitle,
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.85),
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _Method {
  final String title;
  final String subtitle;
  final IconData icon;
  final Gradient gradient;

  const _Method({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.gradient,
  });
}
