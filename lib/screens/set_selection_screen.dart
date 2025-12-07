import 'package:flutter/material.dart';
import '../widgets/category_card.dart';
import '../widgets/general_set_card.dart';
import 'category_detail_screen.dart';
import 'general_set_screen.dart';

class SetSelectionScreen extends StatelessWidget {
  const SetSelectionScreen({super.key});

  static const routeName = '/set-selection';

  // Hardcoded category list - in production, read from assets
  static const List<String> _categories = [
    'sayılar',
    'spor',
    'supermarket',
    'taksi',
    'polis',
    'postane',
    'restoran',
    'trafik_sinyali',
    'tren',
    'otel',
    'havalimanı',
    'doktorda',
    'elektronik_mağaza',
    'gün_ve_ay',
    'kitap_evi',
    'kıyafet_mağazası',
    'kozmetik',
    'kuaför',
    'önemli_fiiller',
    'otobüs_ulaşım',
    'renk_ve_mevsim',
    'tiyatro',
    'tur',
    'yolda',
    'aksesuar',
  ];

  String _formatCategoryName(String name) {
    return name.replaceAll('_', ' ').split(' ').map((word) =>
      word.isNotEmpty ? word[0].toUpperCase() + word.substring(1) : ''
    ).join(' ');
  }

  String _getSetTitle(int setIndex, int wordsPerSet) {
    int startWord = (setIndex - 1) * wordsPerSet + 1;
    int endWord = setIndex * wordsPerSet;
    return 'Genel Set $setIndex ($startWord–$endWord)';
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
          child: CustomScrollView(
            slivers: [
              // App Bar
              SliverAppBar(
                backgroundColor: Colors.transparent,
                elevation: 0,
                pinned: true,
                flexibleSpace: Container(
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
                ),
                title: const Text(
                  'Set Seç',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    shadows: [
                      Shadow(
                        color: Colors.black26,
                        offset: Offset(0, 2),
                        blurRadius: 4,
                      ),
                    ],
                  ),
                ),
                leading: IconButton(
                  icon: const Icon(
                    Icons.arrow_back,
                    color: Colors.white,
                  ),
                  onPressed: () => Navigator.of(context).pop(),
                ),
              ),

              // Content
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Categories Section
                      const Text(
                        'Kategoriler',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          shadows: [
                            Shadow(
                              color: Colors.black26,
                              offset: Offset(0, 2),
                              blurRadius: 4,
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        '${_categories.length} kategori mevcut',
                        style: TextStyle(
                          color: Colors.white.withOpacity(0.7),
                          fontSize: 16,
                        ),
                      ),
                      const SizedBox(height: 20),

                      // Categories Grid
                      GridView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          crossAxisSpacing: 16,
                          mainAxisSpacing: 16,
                          childAspectRatio: 1.2,
                        ),
                        itemCount: _categories.length,
                        itemBuilder: (context, index) {
                          final category = _categories[index];
                          return CategoryCard(
                            categoryName: category,
                            onTap: () {
                              Navigator.pushNamed(
                                context,
                                CategoryDetailScreen.routeName,
                                arguments: {
                                  'categoryKey': category,
                                  'title': _formatCategoryName(category),
                                },
                              );
                            },
                          );
                        },
                      ),

                      const SizedBox(height: 40),

                      // General Sets Section
                      const Text(
                        'Genel Kelime Setleri',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          shadows: [
                            Shadow(
                              color: Colors.black26,
                              offset: Offset(0, 2),
                              blurRadius: 4,
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        'Her set 50 kelime içerir',
                        style: TextStyle(
                          color: Colors.white70,
                          fontSize: 16,
                        ),
                      ),
                      const SizedBox(height: 20),

                      // General Sets List
                      ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: 3, // We have 3 general sets
                        itemBuilder: (context, index) {
                          final setIndex = index + 1;
                          return GeneralSetCard(
                            setIndex: setIndex,
                            wordsPerSet: 50,
                            onTap: () {
                              Navigator.pushNamed(
                                context,
                                GeneralSetScreen.routeName,
                                arguments: {
                                  'setIndex': setIndex,
                                  'title': _getSetTitle(setIndex, 50),
                                },
                              );
                            },
                          );
                        },
                      ),

                      const SizedBox(height: 20),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
