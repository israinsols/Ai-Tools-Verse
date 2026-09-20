import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../constants/app_colors.dart';
import '../../constants/theme_helper.dart';
import '../../models/tool.dart';
import '../../providers/providers.dart';
import '../../widgets/widgets.dart';
import '../tools/tool_detail_screen.dart';

class BrowseScreen extends ConsumerStatefulWidget {
  const BrowseScreen({super.key});

  @override
  ConsumerState<BrowseScreen> createState() => _BrowseScreenState();
}

class _BrowseScreenState extends ConsumerState<BrowseScreen> {
  String _selectedCategory = 'All';
  String _selectedPricing = 'All';
  String _sortBy = 'Most popular';
  final _searchController = TextEditingController();

  static const _categories = [
    'All',
    'AI Image Generators',
    'AI Video Tools',
    'AI Music Tools',
    'AI Writing Tools',
    'AI Coding Tools',
    'AI Voice Generators',
    'AI Logo Makers',
    'AI Presentation Tools',
    'AI Productivity Tools',
  ];

  static const _pricingOptions = ['All', 'Free', 'Freemium', 'Paid'];
  static const _sortOptions = ['Most popular', 'Highest rated', 'Newest'];

  static const _categoryIds = {
    'AI Image Generators': '1',
    'AI Video Tools': '2',
    'AI Music Tools': '3',
    'AI Writing Tools': '4',
    'AI Coding Tools': '5',
    'AI Voice Generators': '6',
    'AI Logo Makers': '7',
    'AI Presentation Tools': '8',
    'AI Productivity Tools': '9',
  };

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final toolsAsync = ref.watch(toolsProvider);

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(context),
            _buildSearchBar(context),
            _buildFilters(context),
            Expanded(
              child: toolsAsync.when(
                data: (tools) {
                  final filtered = _applyFilters(tools);
                  if (filtered.isEmpty) {
                    return Center(
                      child: Text(
                        'No tools found',
                        style: GoogleFonts.inter(color: context.textMuted, fontSize: 14),
                      ),
                    );
                  }
                  return _buildToolsList(context, filtered);
                },
                loading: () => const Center(child: CircularProgressIndicator()),
                error: (_, __) => Center(
                  child: Text('Error loading tools', style: GoogleFonts.inter(color: context.textMuted)),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  List<Tool> _applyFilters(List<Tool> tools) {
    var filtered = List<Tool>.from(tools);

    // Search
    final query = _searchController.text.toLowerCase();
    if (query.isNotEmpty) {
      filtered = filtered.where((t) => t.name.toLowerCase().contains(query)).toList();
    }

    // Category
    if (_selectedCategory != 'All') {
      final catId = _categoryIds[_selectedCategory];
      if (catId != null) {
        filtered = filtered.where((t) => t.categoryId == catId).toList();
      }
    }

    // Pricing
    if (_selectedPricing != 'All') {
      final pricing = PricingType.values.firstWhere(
        (e) => e.name.toLowerCase() == _selectedPricing.toLowerCase(),
        orElse: () => PricingType.free,
      );
      filtered = filtered.where((t) => t.pricingType == pricing).toList();
    }

    // Sort
    switch (_sortBy) {
      case 'Most popular':
        filtered.sort((a, b) => b.viewCount.compareTo(a.viewCount));
        break;
      case 'Highest rated':
        filtered.sort((a, b) => b.rating.compareTo(a.rating));
        break;
      case 'Newest':
        filtered.sort((a, b) => b.createdAt.compareTo(a.createdAt));
        break;
    }

    return filtered;
  }

  Widget _buildHeader(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Browse AI tools',
                  style: GoogleFonts.inter(
                    color: context.textPrimary,
                    fontSize: 24,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '17 tools across 9 categories',
                  style: GoogleFonts.inter(color: context.textMuted, fontSize: 13),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchBar(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: GestureDetector(
        onTap: () {},
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
          decoration: BoxDecoration(
            color: context.cardBg,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: context.borderColor, width: 0.5),
          ),
          child: Row(
            children: [
              Icon(Icons.search, color: context.textMuted, size: 18),
              const SizedBox(width: 10),
              Expanded(
                child: TextField(
                  controller: _searchController,
                  onChanged: (_) => setState(() {}),
                  style: GoogleFonts.inter(color: context.textPrimary, fontSize: 14),
                  decoration: InputDecoration(
                    hintText: 'Search tools...',
                    hintStyle: GoogleFonts.inter(color: context.textMuted, fontSize: 14),
                    border: InputBorder.none,
                    isDense: true,
                    contentPadding: EdgeInsets.zero,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFilters(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Column(
        children: [
          // Category filter
          SizedBox(
            height: 32,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: _categories.length,
              separatorBuilder: (_, __) => const SizedBox(width: 8),
              itemBuilder: (context, index) {
                final cat = _categories[index];
                final isSelected = _selectedCategory == cat;
                return GestureDetector(
                  onTap: () => setState(() => _selectedCategory = cat),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: isSelected ? AppColors.purplePrimary : context.cardBg,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: isSelected ? AppColors.purplePrimary : context.borderColor,
                        width: 0.5,
                      ),
                    ),
                    child: Text(
                      cat,
                      style: GoogleFonts.inter(
                        color: isSelected ? Colors.white : context.textSecondary,
                        fontSize: 12,
                        fontWeight: isSelected ? FontWeight.w500 : FontWeight.w400,
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: 10),
          // Pricing + Sort row
          Row(
            children: [
              // Pricing dropdown
              Expanded(
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  decoration: BoxDecoration(
                    color: context.cardBg,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: context.borderColor, width: 0.5),
                  ),
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton<String>(
                      value: _selectedPricing,
                      isExpanded: true,
                      isDense: true,
                      style: GoogleFonts.inter(color: context.textPrimary, fontSize: 12),
                      dropdownColor: context.cardBg,
                      icon: Icon(Icons.keyboard_arrow_down, color: context.textMuted, size: 16),
                      items: _pricingOptions.map((p) {
                        return DropdownMenuItem(value: p, child: Text(p));
                      }).toList(),
                      onChanged: (v) {
                        if (v != null) setState(() => _selectedPricing = v);
                      },
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 10),
              // Sort dropdown
              Expanded(
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  decoration: BoxDecoration(
                    color: context.cardBg,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: context.borderColor, width: 0.5),
                  ),
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton<String>(
                      value: _sortBy,
                      isExpanded: true,
                      isDense: true,
                      style: GoogleFonts.inter(color: context.textPrimary, fontSize: 12),
                      dropdownColor: context.cardBg,
                      icon: Icon(Icons.keyboard_arrow_down, color: context.textMuted, size: 16),
                      items: _sortOptions.map((s) {
                        return DropdownMenuItem(value: s, child: Text(s));
                      }).toList(),
                      onChanged: (v) {
                        if (v != null) setState(() => _sortBy = v);
                      },
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildToolsList(BuildContext context, List<Tool> tools) {
    return ListView.separated(
      padding: const EdgeInsets.all(16),
      itemCount: tools.length,
      separatorBuilder: (_, __) => const SizedBox(height: 12),
      itemBuilder: (context, index) {
        final tool = tools[index];
        return _buildToolCard(context, tool);
      },
    );
  }

  Widget _buildToolCard(BuildContext context, Tool tool) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => ToolDetailScreen(toolId: tool.id)),
        );
      },
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: context.cardBg,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: context.borderColor, width: 0.5),
        ),
        child: Row(
          children: [
            AppNetworkImage(
              imageUrl: tool.logoUrl,
              initials: tool.name.length >= 2 ? tool.name.substring(0, 2).toUpperCase() : tool.name.toUpperCase(),
              size: 48,
              borderRadius: 12,
              gradientColors: AppNetworkImage.getGradientForId(tool.id),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Flexible(
                        child: Text(
                          tool.name,
                          style: GoogleFonts.inter(
                            color: context.textPrimary,
                            fontSize: 15,
                            fontWeight: FontWeight.w600,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      if (tool.isVerified) ...[
                        const SizedBox(width: 4),
                        const Icon(Icons.verified, color: AppColors.purplePrimary, size: 14),
                      ],
                      if (tool.isTrending) ...[
                        const SizedBox(width: 4),
                        Icon(Icons.trending_up, color: AppColors.pinkAccent, size: 14),
                      ],
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    tool.description,
                    style: GoogleFonts.inter(color: context.textSecondary, fontSize: 12),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 6),
                  Row(
                    children: [
                      Icon(Icons.star, color: Colors.amber, size: 12),
                      const SizedBox(width: 2),
                      Text(
                        tool.rating.toStringAsFixed(1),
                        style: GoogleFonts.inter(color: context.textMuted, fontSize: 11),
                      ),
                      const SizedBox(width: 8),
                      Icon(Icons.visibility_outlined, color: context.textMuted, size: 12),
                      const SizedBox(width: 2),
                      Text(
                        _formatCount(tool.viewCount),
                        style: GoogleFonts.inter(color: context.textMuted, fontSize: 11),
                      ),
                      const Spacer(),
                      _buildPricingBadge(context, tool.pricingType),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPricingBadge(BuildContext context, PricingType type) {
    Color bgColor;
    Color textColor;
    String text;

    switch (type) {
      case PricingType.free:
        bgColor = context.freeBg;
        textColor = context.freeText;
        text = 'Free';
        break;
      case PricingType.freemium:
        bgColor = context.freemiumBg;
        textColor = context.freemiumText;
        text = 'Freemium';
        break;
      case PricingType.paid:
        bgColor = context.paidBg;
        textColor = context.paidText;
        text = 'Paid';
        break;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(
        text,
        style: GoogleFonts.inter(color: textColor, fontSize: 10, fontWeight: FontWeight.w500),
      ),
    );
  }

  String _formatCount(int count) {
    if (count >= 1000000) return '${(count / 1000000).toStringAsFixed(1)}M';
    if (count >= 1000) return '${(count / 1000).toStringAsFixed(1)}K';
    return count.toString();
  }
}
