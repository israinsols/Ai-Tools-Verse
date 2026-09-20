import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../constants/app_colors.dart';
import '../../constants/theme_helper.dart';
import '../../providers/providers.dart';
import '../../widgets/widgets.dart';
import '../tools/tool_detail_screen.dart';

class SavedScreen extends ConsumerStatefulWidget {
  const SavedScreen({super.key});

  @override
  ConsumerState<SavedScreen> createState() => _SavedScreenState();
}

class _SavedScreenState extends ConsumerState<SavedScreen> {
  @override
  Widget build(BuildContext context) {
    final bookmarkIds = ref.watch(bookmarksProvider);

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(context),
            Expanded(
              child: bookmarkIds.isEmpty
                  ? EmptyState(
                      icon: Icons.bookmark_outline,
                      title: 'No saved tools yet',
                      message: 'Start exploring and save tools you love!',
                      actionText: 'Browse Tools',
                      onActionTap: () {},
                    )
                  : _buildBookmarksList(context, ref, bookmarkIds),
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
          Text(
            'Saved Tools',
            style: GoogleFonts.inter(
              color: context.textPrimary,
              fontSize: 24,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBookmarksList(BuildContext context, WidgetRef ref, List<String> bookmarkIds) {
    final toolsAsync = ref.watch(toolsProvider);

    return RefreshIndicator(
        onRefresh: () async {},
        color: AppColors.purplePrimary,
        backgroundColor: context.cardBg,
        child: toolsAsync.when(
          data: (tools) {
            return ListView.separated(
              padding: const EdgeInsets.all(16),
              itemCount: bookmarkIds.length,
              separatorBuilder: (context, index) => const SizedBox(height: 12),
              itemBuilder: (context, index) {
                final toolId = bookmarkIds[index];
                final tool = tools.where((t) => t.id == toolId).isNotEmpty
                    ? tools.firstWhere((t) => t.id == toolId)
                    : null;
                final toolName = tool?.name ?? toolId;

                return Dismissible(
                  key: Key(toolId),
                  direction: DismissDirection.endToStart,
                  onDismissed: (direction) {
                    ref.read(bookmarksProvider.notifier).toggleBookmark(toolId);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          '$toolName removed from saved',
                          style: GoogleFonts.inter(color: Colors.white),
                        ),
                        backgroundColor: AppColors.purplePrimary,
                      ),
                    );
                  },
                  background: Container(
                    alignment: Alignment.centerRight,
                    padding: const EdgeInsets.only(right: 16),
                    decoration: BoxDecoration(
                      color: Colors.redAccent,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: const Icon(Icons.delete, color: Colors.white),
                  ),
                  child: GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ToolDetailScreen(toolId: toolId),
                        ),
                      );
                    },
                    child: Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: context.cardBg,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: context.borderColor, width: 0.5),
                      ),
                      child: Row(
                        children: [
                          AppNetworkImage(
                            imageUrl: tool?.logoUrl,
                            initials: toolName.length >= 2 ? toolName.substring(0, 2).toUpperCase() : toolName.toUpperCase(),
                            size: 40,
                            borderRadius: 10,
                            gradientColors: AppNetworkImage.getGradientForId(toolId),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              toolName,
                              style: GoogleFonts.inter(
                                color: context.textPrimary,
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                          Icon(
                            Icons.chevron_right,
                            color: context.textMuted,
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            );
          },
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (_, __) => const Center(child: Text('Error loading tools')),
        ),
      );
  }
}
