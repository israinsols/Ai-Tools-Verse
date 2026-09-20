import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../constants/app_colors.dart';
import '../../constants/theme_helper.dart';
import '../../models/category.dart';
import '../../providers/providers.dart';
import '../../widgets/widgets.dart';
import 'category_tools_screen.dart';

class CategoriesScreen extends ConsumerWidget {
  const CategoriesScreen({super.key});

  static const _categoryMeta = <String, Map<String, dynamic>>{
    '1': {'iconGradient': AppColors.categoryPurpleMagenta, 'icon': Icons.image_outlined},
    '2': {'iconGradient': AppColors.categoryPinkRed, 'icon': Icons.videocam_outlined},
    '3': {'iconGradient': AppColors.categoryBluePurple, 'icon': Icons.music_note_outlined},
    '4': {'iconGradient': AppColors.categoryPurpleMagenta, 'icon': Icons.edit_outlined},
    '5': {'iconGradient': AppColors.categoryBlueCyan, 'icon': Icons.code},
    '6': {'iconGradient': AppColors.categoryPurpleMagenta, 'icon': Icons.mic_outlined},
    '7': {'iconGradient': AppColors.categoryPinkRed, 'icon': Icons.auto_awesome},
    '8': {'iconGradient': AppColors.categoryBluePurple, 'icon': Icons.slideshow_outlined},
    '9': {'iconGradient': AppColors.categoryPurpleMagenta, 'icon': Icons.bolt_outlined},
  };

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final categoriesAsync = ref.watch(categoriesProvider);

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHeader(context),
              const SizedBox(height: 20,),
              _buildSearchBar(),
              const SizedBox(height: 24,),
              _buildCategoriesSection(context, categoriesAsync)
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Text(
      'Categories',
      style: GoogleFonts.inter(
        color: context.textPrimary,
        fontSize: 24,
        fontWeight: FontWeight.w600,
      ),
    );
  }

  Widget _buildSearchBar() {
    return CustomSearchBar(
      hintText: 'Search categories...',
      readOnly: true,
      onTap: () {},
    );
  }

  Widget _buildCategoriesSection(BuildContext context, AsyncValue<List<Category>> categoriesAsync) {
    return categoriesAsync.when(
      data: (categories) => _buildCategoriesGrid(context, categories),
      loading: () => const Center(
        child: Padding(
          padding: EdgeInsets.all(40),
          child: CircularProgressIndicator(),
        ),
      ),
      error: (e, _) => Center(
        child: Padding(
          padding: const EdgeInsets.all(40),
          child: Text(
            'Failed to load categories',
            style: GoogleFonts.inter(color: context.textSecondary),
          ),
        ),
      ),
    );
  }

  Widget _buildCategoriesGrid(BuildContext context, List<Category> categories) {
    return LayoutBuilder(
      builder: (context, constraints) {
        int crossAxisCount = 3;
        if (constraints.maxWidth < 600) {
          crossAxisCount = 1;
        } else if (constraints.maxWidth < 900) {
          crossAxisCount = 2;
        }

        return GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: crossAxisCount,
            crossAxisSpacing: 20,
            mainAxisSpacing: 20,
            childAspectRatio: 1.65,
          ),
          itemCount: categories.length,
          itemBuilder: (context, index) {
            final category = categories[index];
            final meta = _categoryMeta[category.id] ??
                {'iconGradient': AppColors.categoryPurpleMagenta, 'icon': Icons.category_outlined};

            return CategoryCard(
              category: category,
              iconGradient: meta['iconGradient'] as LinearGradient,
              icon: meta['icon'] as IconData,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => CategoryToolsScreen(
                      categoryId: category.id,
                      categoryName: category.name,
                    ),
                  ),
                );
              },
            );
          },
        );
      },
    );
  }
}
