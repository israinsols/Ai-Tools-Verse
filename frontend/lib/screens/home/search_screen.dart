import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../constants/app_colors.dart';
import '../../constants/theme_helper.dart';
import '../../providers/providers.dart';
import '../../widgets/widgets.dart';
import '../tools/tool_detail_screen.dart';

class SearchScreen extends ConsumerStatefulWidget {
  const SearchScreen({super.key});

  @override
  ConsumerState<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends ConsumerState<SearchScreen> {
  final TextEditingController _searchController = TextEditingController();
  final FocusNode _focusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    _focusNode.requestFocus();
  }

  @override
  void dispose() {
    _searchController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    ref.watch(searchDebounceProvider);
    final searchQuery = ref.watch(searchQueryProvider);
    final searchResults = ref.watch(searchResultsProvider);
    final recentSearches = ref.watch(recentSearchesProvider);

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            _buildSearchBar(context),
            Expanded(
              child: searchQuery.isEmpty
                  ? _buildRecentSearches(context, recentSearches)
                  : _buildSearchResults(searchResults),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSearchBar(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          const SizedBox(width: 8),
          Expanded(
            child: TextField(
              controller: _searchController,
              focusNode: _focusNode,
              onChanged: (value) {
                ref.read(searchQueryProvider.notifier).state = value;
              },
              style: GoogleFonts.inter(
                color: context.textPrimary,
                fontSize: 14,
              ),
              decoration: InputDecoration(
                hintText: 'Search AI tools...',
                hintStyle: GoogleFonts.inter(
                  color: context.textMuted,
                  fontSize: 14,
                ),
                prefixIcon: Icon(
                  Icons.search,
                  color: context.textMuted,
                ),
                suffixIcon: _searchController.text.isNotEmpty
                    ? IconButton(
                        onPressed: () {
                          _searchController.clear();
                          ref.read(searchQueryProvider.notifier).state = '';
                        },
                        icon: Icon(
                          Icons.clear,
                          color: context.textMuted,
                        ),
                      )
                    : null,
                filled: true,
                fillColor: context.cardBgSecondary,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
                  borderSide: BorderSide(
                    color: context.borderColor,
                    width: 0.5,
                  ),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
                  borderSide: BorderSide(
                    color: context.borderColor,
                    width: 0.5,
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
                  borderSide: const BorderSide(
                    color: AppColors.purplePrimary,
                    width: 1,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRecentSearches(BuildContext context, List<String> recentSearches) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (recentSearches.isNotEmpty) ...[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Recent Searches',
                  style: GoogleFonts.inter(
                    color: context.textPrimary,
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    ref.read(recentSearchesProvider.notifier).clearSearches();
                  },
                  child: Text(
                    'Clear all',
                    style: GoogleFonts.inter(
                      color: AppColors.purplePrimary,
                      fontSize: 12,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: recentSearches.map((search) {
                return GestureDetector(
                  onTap: () {
                    _searchController.text = search;
                    ref.read(searchQueryProvider.notifier).state = search;
                    ref.read(recentSearchesProvider.notifier).addSearch(search);
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: context.cardBgSecondary,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: context.borderColor,
                        width: 0.5,
                      ),
                    ),
                    child: Text(
                      search,
                      style: GoogleFonts.inter(
                        color: context.textSecondary,
                        fontSize: 12,
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
            const SizedBox(height: 24),
          ]],
      )
    );
  }

  Widget _buildSearchResults(AsyncValue<List<dynamic>> results) {
    return results.when(
      data: (tools) {
        if (tools.isEmpty) {
          return EmptyState(
            icon: Icons.search_off,
            title: 'No results found',
            message: 'Try different keywords or browse categories instead.',
            actionText: 'Browse Categories',
            onActionTap: () {
              Navigator.pop(context);
            },
          );
        }

        return ListView.separated(
          padding: const EdgeInsets.all(16),
          itemCount: tools.length,
          separatorBuilder: (context, index) => const SizedBox(height: 12),
          itemBuilder: (context, index) {
            final tool = tools[index];
            return ToolCard(
              tool: tool,
              onTap: () {
                ref.read(recentSearchesProvider.notifier).addSearch(
                      _searchController.text,
                    );
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ToolDetailScreen(toolId: tool.id),
                  ),
                );
              },
            );
          },
        );
      },
      loading: () => const Center(
        child: CircularProgressIndicator(),
      ),
      error: (error, stack) => Center(
        child: Text(
          'Error: $error',
          style: const TextStyle(color: Colors.red),
        ),
      ),
    );
  }
}
