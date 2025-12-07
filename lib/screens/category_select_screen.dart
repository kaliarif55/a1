import 'package:flutter/material.dart';
import '../services/json_loader.dart';

class CategorySelectScreen extends StatefulWidget {
  const CategorySelectScreen({super.key, required this.methodName});

  static const routeName = '/categories';
  final String methodName;

  @override
  State<CategorySelectScreen> createState() => _CategorySelectScreenState();
}

class _CategorySelectScreenState extends State<CategorySelectScreen> {
  List<String> _categories = [];
  bool _isLoading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _loadCategories();
  }

  Future<void> _loadCategories() async {
    try {
      setState(() {
        _isLoading = true;
        _error = null;
      });

      final categories = await JsonLoader.listAllCategories();

      if (categories.isEmpty) {
        throw Exception('Kategori bulunamadı');
      }

      setState(() {
        _categories = categories;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _error = e.toString();
        _isLoading = false;
      });
    }
  }

  String _formatCategoryName(String filename) {
    return filename
        .split('_')
        .map((word) => word.isNotEmpty ? word[0].toUpperCase() + word.substring(1) : '')
        .join(' ')
        .replaceAll('.json', '');
  }

  IconData _getCategoryIcon(String categoryName, int index) {
    final icons = [
      Icons.numbers,
      Icons.sports_soccer,
      Icons.shopping_cart,
      Icons.local_taxi,
      Icons.local_police,
      Icons.local_post_office,
      Icons.restaurant,
      Icons.traffic,
      Icons.train,
      Icons.hotel,
      Icons.flight,
      Icons.local_hospital,
      Icons.devices,
      Icons.calendar_today,
      Icons.library_books,
      Icons.shopping_bag,
      Icons.spa,
      Icons.content_cut,
      Icons.run_circle,
      Icons.directions_bus,
      Icons.palette,
      Icons.theater_comedy,
      Icons.tour,
      Icons.directions_walk,
      Icons.watch,
    ];
    return icons[index % icons.length];
  }

  Color _gradientStart(int index) {
    const palette = [
      Color(0xFF6A11CB),
      Color(0xFF11998E),
      Color(0xFF4776E6),
      Color(0xFF8E2DE2),
      Color(0xFF38EF7D),
      Color(0xFF00B09B),
    ];
    return palette[index % palette.length];
  }

  Color _gradientEnd(int index) {
    const palette = [
      Color(0xFF2575FC),
      Color(0xFF38EF7D),
      Color(0xFF8E54E9),
      Color(0xFF4A00E0),
      Color(0xFF00B4DB),
      Color(0xFF96C93D),
    ];
    return palette[index % palette.length];
  }

  void _openCategory(BuildContext context, String category) {
    // Her zaman süreli quiz (Reflex Quiz) başlat
    Navigator.pushNamed(
      context,
      '/reflex-quiz',
      arguments: {'categoryName': category},
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color(0xFF1C1F26),
              Color(0xFF2A2F3A),
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SafeArea(
          child: _buildContent(),
        ),
      ),
    );
  }

  Widget _buildContent() {
    if (_isLoading) {
      return const Center(
        child: CircularProgressIndicator(
          color: Colors.white,
        ),
      );
    }

    if (_error != null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: Colors.red.withOpacity(0.1),
                shape: BoxShape.circle,
                border: Border.all(
                  color: Colors.red.withOpacity(0.3),
                  width: 2,
                ),
              ),
              child: const Icon(
                Icons.error_outline,
                color: Colors.red,
                size: 48,
              ),
            ),
            const SizedBox(height: 24),
            Text(
              'Kategoriler yüklenemedi',
              style: const TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              _error!,
              style: TextStyle(
                color: Colors.white.withOpacity(0.7),
                fontSize: 16,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: _loadCategories,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                foregroundColor: const Color(0xFF1C1F26),
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Text('Tekrar Dene'),
            ),
          ],
        ),
      );
    }

    if (_categories.isEmpty) {
      return const Center(
        child: Text(
          'Kategori bulunamadı',
          style: TextStyle(color: Colors.white, fontSize: 18),
        ),
      );
    }

    return Column(
      children: [
        // App Bar
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Colors.black.withOpacity(0.3),
                Colors.transparent,
              ],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
          child: Row(
            children: [
              IconButton(
                icon: const Icon(Icons.arrow_back, color: Colors.white),
                onPressed: () => Navigator.of(context).pop(),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Text(
                  '${widget.methodName} - Kategoriler',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    shadows: [
                      Shadow(
                        color: Colors.black26,
                        offset: Offset(0, 1),
                        blurRadius: 2,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),

        // Categories Grid
        Expanded(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
                childAspectRatio: 1.1,
              ),
              itemCount: _categories.length,
              itemBuilder: (context, index) {
                final category = _categories[index];
                return _CategoryCard(
                  categoryName: _formatCategoryName(category),
                  categoryKey: category,
                  gradientStart: _gradientStart(index),
                  gradientEnd: _gradientEnd(index),
                  icon: _getCategoryIcon(category, index),
                  onTap: () => _openCategory(context, category),
                );
              },
            ),
          ),
        ),
      ],
    );
  }
}

class _CategoryCard extends StatefulWidget {
  final String categoryName;
  final String categoryKey;
  final Color gradientStart;
  final Color gradientEnd;
  final IconData icon;
  final VoidCallback onTap;

  const _CategoryCard({
    required this.categoryName,
    required this.categoryKey,
    required this.gradientStart,
    required this.gradientEnd,
    required this.icon,
    required this.onTap,
  });

  @override
  State<_CategoryCard> createState() => _CategoryCardState();
}

class _CategoryCardState extends State<_CategoryCard> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 150),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(begin: 1.0, end: 0.95).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _onTapDown(TapDownDetails details) {
    _controller.forward();
  }

  void _onTapUp(TapUpDetails details) {
    _controller.reverse();
    widget.onTap();
  }

  void _onTapCancel() {
    _controller.reverse();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: _onTapDown,
      onTapUp: _onTapUp,
      onTapCancel: _onTapCancel,
      child: AnimatedBuilder(
        animation: _scaleAnimation,
        builder: (context, child) {
          return Transform.scale(
            scale: _scaleAnimation.value,
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [widget.gradientStart, widget.gradientEnd],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: widget.gradientStart.withOpacity(0.3),
                    blurRadius: 15,
                    spreadRadius: 2,
                    offset: const Offset(0, 8),
                  ),
                ],
              ),
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  borderRadius: BorderRadius.circular(20),
                  onTap: widget.onTap,
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.2),
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            widget.icon,
                            color: Colors.white,
                            size: 32,
                          ),
                        ),
                        const SizedBox(height: 12),
                        Text(
                          widget.categoryName,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            shadows: [
                              Shadow(
                                color: Colors.black26,
                                offset: Offset(0, 2),
                                blurRadius: 4,
                              ),
                            ],
                          ),
                          textAlign: TextAlign.center,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}