import 'package:flutter/material.dart';

class CategoryCard extends StatefulWidget {
  final String categoryName;
  final VoidCallback onTap;

  const CategoryCard({
    super.key,
    required this.categoryName,
    required this.onTap,
  });

  @override
  State<CategoryCard> createState() => _CategoryCardState();
}

class _CategoryCardState extends State<CategoryCard> with TickerProviderStateMixin {
  late AnimationController _scaleController;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _scaleController = AnimationController(
      duration: const Duration(milliseconds: 150),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 0.95,
    ).animate(CurvedAnimation(
      parent: _scaleController,
      curve: Curves.easeInOut,
    ));
  }

  @override
  void dispose() {
    _scaleController.dispose();
    super.dispose();
  }

  void _onTapDown(TapDownDetails details) {
    _scaleController.forward();
  }

  void _onTapUp(TapUpDetails details) {
    _scaleController.reverse();
  }

  void _onTapCancel() {
    _scaleController.reverse();
  }

  IconData _getCategoryIcon(String categoryName) {
    switch (categoryName.toLowerCase()) {
      case 'sayılar':
        return Icons.calculate;
      case 'spor':
        return Icons.sports_soccer;
      case 'supermarket':
        return Icons.shopping_cart;
      case 'taksi':
        return Icons.local_taxi;
      case 'polis':
        return Icons.local_police;
      case 'postane':
        return Icons.local_post_office;
      case 'restoran':
        return Icons.restaurant;
      case 'trafik_sinyali':
        return Icons.traffic;
      case 'tren':
        return Icons.train;
      case 'otel':
        return Icons.hotel;
      case 'havalimanı':
        return Icons.flight;
      case 'doktor':
      case 'doktorda':
        return Icons.local_hospital;
      case 'elektronik_mağaza':
        return Icons.devices;
      case 'gün_ve_ay':
        return Icons.calendar_today;
      case 'kitap_evi':
        return Icons.library_books;
      case 'kıyafet_mağazası':
        return Icons.shopping_bag;
      case 'kozmetik':
        return Icons.spa;
      case 'kuaför':
        return Icons.content_cut;
      case 'önemli_fiiller':
        return Icons.run_circle;
      case 'otobüs_ulaşım':
        return Icons.directions_bus;
      case 'renk_ve_mevsim':
        return Icons.palette;
      case 'tiyatro':
        return Icons.theater_comedy;
      case 'tur':
        return Icons.tour;
      case 'yolda':
        return Icons.directions_walk;
      case 'aksesuar':
        return Icons.watch;
      default:
        return Icons.category;
    }
  }

  String _formatCategoryName(String name) {
    return name.replaceAll('_', ' ').split(' ').map((word) =>
      word.isNotEmpty ? word[0].toUpperCase() + word.substring(1) : ''
    ).join(' ');
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _scaleAnimation,
      builder: (context, child) {
        return Transform.scale(
          scale: _scaleAnimation.value,
          child: GestureDetector(
            onTapDown: _onTapDown,
            onTapUp: _onTapUp,
            onTapCancel: _onTapCancel,
            onTap: widget.onTap,
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.1),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: Colors.white.withOpacity(0.2),
                  width: 1,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.2),
                    blurRadius: 10,
                    offset: const Offset(0, 5),
                  ),
                ],
              ),
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
                      _getCategoryIcon(widget.categoryName),
                      color: Colors.white,
                      size: 32,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    _formatCategoryName(widget.categoryName),
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      shadows: [
                        Shadow(
                          color: Colors.black26,
                          offset: Offset(0, 1),
                          blurRadius: 2,
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
        );
      },
    );
  }
}
