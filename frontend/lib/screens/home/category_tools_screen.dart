import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../constants/app_colors.dart';
import '../../constants/theme_helper.dart';
import '../../models/tool.dart';
import '../../providers/providers.dart';
import '../../widgets/widgets.dart';
import '../tools/tool_detail_screen.dart';

class CategoryToolsScreen extends ConsumerStatefulWidget {
  final String categoryId;
  final String categoryName;

  const CategoryToolsScreen({
    super.key,
    required this.categoryId,
    required this.categoryName,
  });

  @override
  ConsumerState<CategoryToolsScreen> createState() =>
      _CategoryToolsScreenState();
}

class _CategoryToolsScreenState extends ConsumerState<CategoryToolsScreen> {
  String _selectedSort = 'Popular';

  List<Tool> _sortTools(List<Tool> tools) {
    final sorted = List<Tool>.from(tools);
    switch (_selectedSort) {
      case 'Newest':
        sorted.sort((a, b) => b.createdAt.compareTo(a.createdAt));
        break;
      case 'Top Rated':
        sorted.sort((a, b) => b.rating.compareTo(a.rating));
        break;
      case 'Free':
        return sorted.where((t) => t.pricingType == PricingType.free).toList();
      case 'Popular':
      default:
        sorted.sort((a, b) => b.viewCount.compareTo(a.viewCount));
        break;
    }
    return sorted;
  }

  @override
  Widget build(BuildContext context) {
    final toolsAsync = ref.watch(categoryToolsProvider(widget.categoryId));

    return Scaffold(
      backgroundColor: context.scaffoldBg,
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(context),
            _buildSortOptions(context),
            const SizedBox(height: 8),
            Expanded(
              child: toolsAsync.when(
                data: (tools) {
                  final sorted = _sortTools(tools);
                  if (sorted.isEmpty) {
                    return EmptyState(
                      icon: Icons.build_circle_outlined,
                      title: 'No tools yet',
                      message:
                          'Be the first to submit a tool in this category!',
                      actionText: 'Submit Tool',
                      onActionTap: () {},
                    );
                  }
                  return RefreshIndicator(
                      onRefresh: () async {
                        ref.invalidate(categoryToolsProvider(widget.categoryId));
                      },
                      color: AppColors.purplePrimary,
                      backgroundColor: context.cardBg,
                      child: ListView.separated(
                    padding: const EdgeInsets.all(16),
                    itemCount: sorted.length,
                    separatorBuilder: (_, _a) => const SizedBox(height: 12),
                    itemBuilder: (context, index) {
                      final tool = sorted[index];
                      return ToolCard(
                        tool: tool,
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  ToolDetailScreen(toolId: tool.id),
                            ),
                          );
                        },
                      );
                    },
                  ),
                    );
                },
                loading: () =>
                    const Center(child: CircularProgressIndicator()),
                error: (e, _) => Center(
                  child: Text('Error: $e',
                      style: const TextStyle(color: Colors.red)),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          IconButton(
            onPressed: () => Navigator.pop(context),
            icon: Icon(Icons.arrow_back_ios, color: context.textPrimary),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.categoryName,
                  style: GoogleFonts.inter(
                    color: context.textPrimary,
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Text(
                  'Browse all tools',
                  style: GoogleFonts.inter(
                    color: context.textSecondary,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSortOptions(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: [
            _buildSortChip(context, 'Popular'),
            const SizedBox(width: 8),
            _buildSortChip(context, 'Newest'),
            const SizedBox(width: 8),
            _buildSortChip(context, 'Top Rated'),
            const SizedBox(width: 8),
            _buildSortChip(context, 'Free'),
          ],
        ),
      ),
    );
  }

  Widget _buildSortChip(BuildContext context, String label) {
    final isSelected = _selectedSort == label;

    return GestureDetector(
      onTap: () => setState(() => _selectedSort = label),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.purplePrimary : context.cardBgSecondary,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isSelected ? AppColors.purplePrimary : context.borderColor,
            width: 0.5,
          ),
        ),
        child: Text(
          label,
          style: GoogleFonts.inter(
            color: isSelected ? Colors.white : context.textSecondary,
            fontSize: 12,
            fontWeight: isSelected ? FontWeight.w500 : FontWeight.w400,
          ),
        ),
      ),
    );
  }
}
