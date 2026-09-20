import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../constants/app_colors.dart';
import '../../constants/theme_helper.dart';
import '../../models/models.dart';
import '../../providers/providers.dart';
import 'search_screen.dart';
import 'browse_screen.dart';
import '../tools/tool_detail_screen.dart';
import '../tools/submit_tool_screen.dart';
import 'category_tools_screen.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  String _selectedFilter = 'All';

  static const List<Color> _avatarGradients = [
    Color(0xFF14B8A6), Color(0xFF059669),
    Color(0xFF8B5CF6), Color(0xFF6366F1),
    Color(0xFFF97316), Color(0xFFEA580C),
    Color(0xFF334155), Color(0xFF1E293B),
    Color(0xFFEC4899), Color(0xFFDB2777),
    Color(0xFF22C55E), Color(0xFF16A34A),
    Color(0xFF3B82F6), Color(0xFF2563EB),
  ];

  static const Map<String, IconData> _categoryIcons = {
    'image_outlined': Icons.image_outlined,
    'videocam_outlined': Icons.videocam_outlined,
    'music_note_outlined': Icons.music_note_outlined,
    'edit_outlined': Icons.edit_outlined,
    'code_outlined': Icons.code_outlined,
    'search_outlined': Icons.search_outlined,
    'mic_outlined': Icons.mic_outlined,
    'bolt_outlined': Icons.bolt_outlined,
    'palette_outlined': Icons.palette_outlined,
  };

  static const List<Color> _categoryGradients = [
    Color(0xFF8B5CF6), Color(0xFFEC4899),
    Color(0xFFEC4899), Color(0xFFEF4444),
    Color(0xFF3B82F6), Color(0xFF8B5CF6),
    Color(0xFF06B6D4), Color(0xFF3B82F6),
    Color(0xFF8B5CF6), Color(0xFFEC4899),
  ];

  List<Color> _getAvatarGradient(String id) {
    final index = int.tryParse(id) ?? 0;
    final i = (index - 1) * 2;
    if (i >= 0 && i + 1 < _avatarGradients.length) {
      return [_avatarGradients[i], _avatarGradients[i + 1]];
    }
    return [AppColors.purplePrimary, AppColors.pinkAccent];
  }

  String _getInitials(String name) {
    final words = name.split(' ');
    if (words.length >= 2) {
      return '${words[0][0]}${words[1][0]}'.toUpperCase();
    }
    return name.substring(0, name.length.clamp(0, 2)).toUpperCase();
  }

  String _getTagline(Tool tool) {
    final taglines = {
      'ChatGPT': 'Conversational AI for everything',
      'Midjourney': 'Stunning AI-generated art',
      'Claude': 'Thoughtful AI for long context',
      'Cursor': 'The AI code editor',
      'Suno': 'Make any song you imagine',
      'Runway': 'Next-gen AI video',
      'Flux': 'Open-weight image model',
      'Perplexity': 'AI answer engine',
      'ElevenLabs': 'Lifelike voice AI',
      'Flow': 'AI-powered image generation',
      'v0 by Vercel': 'AI-generated UI',
      'Pika': 'Fun, fast AI video',
    };
    return taglines[tool.name] ?? tool.description;
  }

  String _getPricingLabel(PricingType type) {
    switch (type) {
      case PricingType.free:
        return 'Free';
      case PricingType.freemium:
        return 'Freemium';
      case PricingType.paid:
        return 'Paid';
    }
  }

  @override
  Widget build(BuildContext context) {
    final toolsAsync = ref.watch(toolsProvider);
    final categoriesAsync = ref.watch(categoriesProvider);

    return Scaffold(
      backgroundColor: context.bg,
      body: SafeArea(
        child: toolsAsync.when(
          data: (tools) => categoriesAsync.when(
            data: (categories) => _buildContent(tools, categories),
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (e, _) => _buildError('Categories: $e'),
          ),
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (e, _) => _buildError('Tools: $e'),
        ),
      ),
    );
  }

  Widget _buildError(String msg) {
    return Center(
      child: Text(msg, style: const TextStyle(color: Colors.red)),
    );
  }

  Widget _buildContent(List<Tool> tools, List<Category> categories) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final w = constraints.maxWidth;
        final trending = tools.where((t) => t.isTrending).toList();
        final featured = tools.where((t) => t.isFeatured).toList();
        final newTools = tools.where((t) => t.isNew).toList();

        List<Tool> filteredTools;
        switch (_selectedFilter) {
          case 'Trending':
            filteredTools = trending;
            break;
          case 'Featured':
            filteredTools = featured;
            break;
          case 'New':
            filteredTools = newTools;
            break;
          case 'Free':
            filteredTools = tools.where((t) => t.pricingType == PricingType.free).toList();
            break;
          case 'Freemium':
            filteredTools = tools.where((t) => t.pricingType == PricingType.freemium).toList();
            break;
          case 'Paid':
            filteredTools = tools.where((t) => t.pricingType == PricingType.paid).toList();
            break;
          default:
            filteredTools = tools;
        }

        return RefreshIndicator(
          onRefresh: () async {
            ref.invalidate(toolsProvider);
            ref.invalidate(categoriesProvider);
          },
          color: AppColors.purplePrimary,
          backgroundColor: context.cardBg,
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: const EdgeInsets.only(bottom: 100),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildHeroHeaderSection(w, tools.length, categories.length),
                _buildFilterChipsSection(),
                const SizedBox(height: 24,),
                if(_selectedFilter == 'All')...[
                  if(trending.isNotEmpty) _buildTrendingSection(trending,w),
                  if(featured.isNotEmpty) _buildFeaturedSection(featured, w),
                  if(categories.isNotEmpty) _buildCategoriesSection(categories, w),
                  if(newTools.isNotEmpty) _buildNewToolsSection(newTools, w),
                ]else...[
                  _buildFilteredSection(filteredTools, w),
                ]
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildHeroHeaderSection(double screenWidth, int toolCount, int catCount) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: _buildHeroHeader(screenWidth, toolCount, catCount),
    );
  }

  Widget _buildFilterChipsSection() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: _buildFilterChips(),
    );
  }

  Widget _buildTrendingSection(List<Tool> trending, double screenWidth) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: _buildSectionHeader(
            badge: '🔥 Trending now',
            badgeColor: const Color(0xFF2D1B69),
            title: "What's ",
            highlightedWord: 'hot',
            subtitle: ' this week',
          ),
        ),
        const SizedBox(height: 12),
        _buildHorizontalToolsList(trending, screenWidth),
        const SizedBox(height: 20),
      ],
    );
  }

  Widget _buildFeaturedSection(List<Tool> featured, double screenWidth) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: _buildSectionHeader(
            badge: "✨ Editor's picks",
            badgeColor: const Color(0xFF1E3B2E),
            title: 'Featured ',
            highlightedWord: 'AI tools',
            subtitle: '',
          ),
        ),
        const SizedBox(height: 12),
        _buildHorizontalToolsList(featured, screenWidth),
        const SizedBox(height: 20),
      ],
    );
  }

  Widget _buildCategoriesSection(List<Category> categories, double screenWidth) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: _buildSectionHeader(
            badge: '⚡ Popular categories',
            badgeColor: const Color(0xFF2D1B69),
            title: 'Find tools by ',
            highlightedWord: 'category',
            subtitle: '',
          ),
        ),
        const SizedBox(height: 12),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: _buildCategoriesGrid(categories, screenWidth),
        ),
        const SizedBox(height: 20),
      ],
    );
  }

  Widget _buildNewToolsSection(List<Tool> newTools, double screenWidth) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: _buildSectionHeader(
            badge: 'Fresh',
            badgeColor: const Color(0xFF2D1B69),
            title: 'Latest ',
            highlightedWord: 'additions',
            subtitle: '',
          ),
        ),
        const SizedBox(height: 12),
        _buildHorizontalToolsList(newTools, screenWidth),
      ],
    );
  }

  Widget _buildTestimonialsSection() {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Loved by creators',
            style: GoogleFonts.inter(
              color: context.textPrimary,
              fontSize: 20,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            'Builders, marketers, and engineers rely on AIVerse to stay current.',
            style: GoogleFonts.inter(color: context.textSecondary, fontSize: 13),
          ),
          const SizedBox(height: 16),
          _buildTestimonialCard(
            'Maya R.',
            'Indie designer',
            'I find new tools here every week. The curation is just chef\'s kiss.',
            isDark,
          ),
          const SizedBox(height: 10),
          _buildTestimonialCard(
            'Devon K.',
            'Engineering manager',
            'Replaced three newsletters with AIVerse. Cleanest directory I\'ve used.',
            isDark,
          ),
          const SizedBox(height: 10),
          _buildTestimonialCard(
            'Aria S.',
            'Content lead',
            'The comparison pages alone saved my team hours of evaluation.',
            isDark,
          ),
        ],
      ),
    );
  }

  Widget _buildTestimonialCard(String name, String role, String quote, bool isDark) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: context.cardBg,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: context.borderColor, width: 0.5),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '"$quote"',
            style: GoogleFonts.inter(
              color: context.textSecondary,
              fontSize: 13,
              height: 1.5,
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Container(
                width: 32,
                height: 32,
                decoration: BoxDecoration(
                  gradient: AppColors.gradientLogo,
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: Text(
                    name[0],
                    style: GoogleFonts.inter(color: Colors.white, fontSize: 12, fontWeight: FontWeight.w600),
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    name,
                    style: GoogleFonts.inter(
                      color: context.textPrimary,
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  Text(
                    role,
                    style: GoogleFonts.inter(color: context.textMuted, fontSize: 11),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildNewsletterSection() {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: isDark
                ? [const Color(0xFF2D1B69), const Color(0xFF1A1040)]
                : [const Color(0xFFE8D5F5), const Color(0xFFF0E0F5), const Color(0xFFF5E8F0)],
          ),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isDark ? Colors.white.withValues(alpha: 0.1) : AppColors.purplePrimary.withValues(alpha: 0.15),
            width: 1,
          ),
        ),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                color: isDark ? Colors.white.withValues(alpha: 0.1) : Colors.white.withValues(alpha: 0.6),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.mail_outline, size: 14, color: isDark ? Colors.white70 : const Color(0xFF6B5B8A)),
                  const SizedBox(width: 6),
                  Text(
                    'Weekly newsletter',
                    style: GoogleFonts.inter(
                      color: isDark ? Colors.white70 : const Color(0xFF6B5B8A),
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            RichText(
              textAlign: TextAlign.center,
              text: TextSpan(
                children: [
                  TextSpan(
                    text: 'The best ',
                    style: GoogleFonts.inter(
                      color: isDark ? Colors.white : const Color(0xFF1A1040),
                      fontSize: 22,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  TextSpan(
                    text: 'AI tools',
                    style: GoogleFonts.inter(
                      color: AppColors.purplePrimary,
                      fontSize: 22,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  TextSpan(
                    text: ' in your inbox',
                    style: GoogleFonts.inter(
                      color: isDark ? Colors.white : const Color(0xFF1A1040),
                      fontSize: 22,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Hand-picked tools, launches, and tutorials. No fluff, unsubscribe anytime.',
              textAlign: TextAlign.center,
              style: GoogleFonts.inter(
                color: isDark ? Colors.white70 : const Color(0xFF6B5B8A),
                fontSize: 13,
              ),
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                    decoration: BoxDecoration(
                      color: isDark ? Colors.white.withValues(alpha: 0.1) : Colors.white.withValues(alpha: 0.7),
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(
                        color: isDark ? Colors.white.withValues(alpha: 0.2) : AppColors.purplePrimary.withValues(alpha: 0.2),
                        width: 1,
                      ),
                    ),
                    child: Text(
                      'you@example.com',
                      style: GoogleFonts.inter(
                        color: isDark ? Colors.white54 : const Color(0xFF9B8BB8),
                        fontSize: 13,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
                  decoration: BoxDecoration(
                    gradient: AppColors.gradientLogo,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        'Subscribe',
                        style: GoogleFonts.inter(color: Colors.white, fontSize: 13, fontWeight: FontWeight.w500),
                      ),
                      const SizedBox(width: 4),
                      const Icon(Icons.arrow_forward, color: Colors.white, size: 14),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeroHeader(double screenWidth, int toolCount, int catCount) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: isDark
              ? [const Color(0xFF2D1B69), const Color(0xFF1A1040), const Color(0xFF0D0A14)]
              : [const Color(0xFFE8D5F5), const Color(0xFFF0E0F5), const Color(0xFFF5E8F0)],
          stops: const [0.0, 0.5, 1.0],
        ),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: isDark ? Colors.white.withValues(alpha: 0.15) : AppColors.purplePrimary.withValues(alpha: 0.15),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildLogoRow(isDark),
          const SizedBox(height: 16),
          _buildHeadline(screenWidth, isDark),
          const SizedBox(height: 8),
          _buildSubtitle(isDark),
          const SizedBox(height: 16),
          _buildSearchBar(isDark),
          const SizedBox(height: 16),
          _buildStatsRow(toolCount, catCount, isDark),
          const SizedBox(height: 16),
          _buildHeroButtons(isDark),
        ],
      ),
    );
  }

  Widget _buildHeroButtons(bool isDark) {
    return Row(
      children: [
        Expanded(
          child: GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const BrowseScreen()),
              );
            },
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 12),
              decoration: BoxDecoration(
                color: isDark ? Colors.white.withValues(alpha: 0.15) : Colors.white.withValues(alpha: 0.7),
                borderRadius: BorderRadius.circular(10),
                border: Border.all(
                  color: isDark ? Colors.white.withValues(alpha: 0.2) : AppColors.purplePrimary.withValues(alpha: 0.2),
                  width: 1,
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.explore_outlined,
                    color: isDark ? Colors.white : const Color(0xFF1A1040),
                    size: 16,
                  ),
                  const SizedBox(width: 6),
                  Text(
                    'Browse tools',
                    style: GoogleFonts.inter(
                      color: isDark ? Colors.white : const Color(0xFF1A1040),
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const SubmitToolScreen()),
              );
            },
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 12),
              decoration: BoxDecoration(
                gradient: AppColors.gradientLogo,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.add, color: Colors.white, size: 16),
                  const SizedBox(width: 6),
                  Text(
                    'Submit tool',
                    style: GoogleFonts.inter(
                      color: Colors.white,
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildLogoRow(bool isDark) {
    return Row(
      children: [
        Container(
          width: 36,
          height: 36,
          decoration: BoxDecoration(
            gradient: AppColors.gradientLogo,
            borderRadius: BorderRadius.circular(10),
          ),
          child: const Icon(Icons.auto_awesome, color: Colors.white, size: 20),
        ),
        const SizedBox(width: 10),
        Text(
          'AIVerse',
          style: GoogleFonts.inter(
            color: isDark ? Colors.white : const Color(0xFF1A1040),
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }

  Widget _buildHeadline(double screenWidth, bool isDark) {
    double fontSize = 24;
    if (screenWidth > 600) fontSize = 28;
    if (screenWidth > 900) fontSize = 32;

    return Text(
      'Discover the best AI tools for every task',
      style: GoogleFonts.inter(
        color: isDark ? Colors.white : const Color(0xFF1A1040),
        fontSize: fontSize,
        fontWeight: FontWeight.w700,
        height: 1.2,
      ),
    );
  }

  Widget _buildSubtitle(bool isDark) {
    return Text(
      '1,000+ tools · Updated daily',
      style: GoogleFonts.inter(
        color: isDark ? Colors.white70 : const Color(0xFF6B5B8A),
        fontSize: 13,
        fontWeight: FontWeight.w400,
      ),
    );
  }

  Widget _buildSearchBar(bool isDark) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const SearchScreen()),
        );
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        decoration: BoxDecoration(
          color: isDark ? Colors.white.withValues(alpha: 0.1) : Colors.white.withValues(alpha: 0.7),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isDark ? Colors.white.withValues(alpha: 0.2) : AppColors.purplePrimary.withValues(alpha: 0.2),
            width: 1,
          ),
        ),
        child: Row(
          children: [
            Icon(
              Icons.search,
              color: isDark ? Colors.white54 : const Color(0xFF6B5B8A),
              size: 18,
            ),
            const SizedBox(width: 10),
            Text(
              'Search AI tools...',
              style: TextStyle(
                color: isDark ? Colors.white54 : const Color(0xFF9B8BB8),
                fontSize: 13,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatsRow(int toolCount, int catCount, bool isDark) {
    return Row(
      children: [
        _buildStatBox('$toolCount+', 'AI Tools', isDark),
        const SizedBox(width: 10),
        _buildStatBox('$catCount', 'Categories', isDark),
        const SizedBox(width: 10),
        _buildStatBox('Daily', 'Updates', isDark),
      ],
    );
  }

  Widget _buildStatBox(String number, String label, bool isDark) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 10),
        decoration: BoxDecoration(
          color: isDark ? Colors.white.withValues(alpha: 0.1) : Colors.white.withValues(alpha: 0.6),
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: isDark ? Colors.white.withValues(alpha: 0.2) : AppColors.purplePrimary.withValues(alpha: 0.15),
            width: 1,
          ),
        ),
        child: Column(
          children: [
            Text(
              number,
              style: GoogleFonts.inter(
                color: isDark ? Colors.white : const Color(0xFF1A1040),
                fontSize: 16,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              label,
              style: GoogleFonts.inter(
                color: isDark ? Colors.white70 : const Color(0xFF6B5B8A),
                fontSize: 10,
                fontWeight: FontWeight.w400,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFilterChips() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          _buildChip('All'),
          const SizedBox(width: 8),
          _buildChip('Free'),
          const SizedBox(width: 8),
          _buildChip('Freemium'),
          const SizedBox(width: 8),
          _buildChip('Paid'),
          const SizedBox(width: 8),
          _buildChip('Trending'),
          const SizedBox(width: 8),
          _buildChip('Featured'),
          const SizedBox(width: 8),
          _buildChip('New'),
        ],
      ),
    );
  }

  Widget _buildChip(String label) {
    final isSelected = _selectedFilter == label;

    return GestureDetector(
      onTap: () => setState(() => _selectedFilter = label),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.purplePrimary : context.cardBg,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected ? AppColors.purplePrimary : context.borderColor,
            width: 1,
          ),
        ),
        child: Text(
          label,
          style: GoogleFonts.inter(
            color: isSelected ? Colors.white : context.textSecondary,
            fontSize: 12,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }

  Widget _buildSectionHeader({
    required String badge,
    required Color badgeColor,
    required String title,
    required String highlightedWord,
    required String subtitle,
  }) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final badgeBg = isDark ? badgeColor : badgeColor.withValues(alpha: 0.12);
    final badgeText = isDark ? Colors.white : badgeColor;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
          decoration: BoxDecoration(
            color: badgeBg,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Text(
            badge,
            style: GoogleFonts.inter(
              color: badgeText,
              fontSize: 11,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        const SizedBox(height: 10),
        RichText(
          text: TextSpan(
            children: [
              TextSpan(
                text: title,
                style: GoogleFonts.inter(
                  color: context.textPrimary,
                  fontSize: 22,
                  fontWeight: FontWeight.w700,
                ),
              ),
              TextSpan(
                text: highlightedWord,
                style: GoogleFonts.inter(
                  color: AppColors.purplePrimary,
                  fontSize: 22,
                  fontWeight: FontWeight.w700,
                ),
              ),
              if (subtitle.isNotEmpty)
                TextSpan(
                  text: subtitle,
                  style: GoogleFonts.inter(
                    color: context.textPrimary,
                    fontSize: 22,
                    fontWeight: FontWeight.w700,
                  ),
                ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildHorizontalToolsList(List<Tool> tools, double screenWidth) {
    double cardWidth;
    double cardHeight;

    if (screenWidth > 900) {
      cardWidth = 220;
      cardHeight = 150;
    } else if (screenWidth > 600) {
      cardWidth = 190;
      cardHeight = 135;
    } else if (screenWidth > 400) {
      cardWidth = 160;
      cardHeight = 135;
    } else {
      cardWidth = 140;
      cardHeight = 125;
    }

    return SizedBox(
      height: cardHeight,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: tools.length,
        separatorBuilder: (_, _b) => const SizedBox(width: 10),
        itemBuilder: (context, index) {
          return SizedBox(
            width: cardWidth,
            child: _buildToolCard(tools[index]),
          );
        },
      ),
    );
  }

  Widget _buildToolCard(Tool tool) {
    final gradientColors = _getAvatarGradient(tool.id);
    final initials = _getInitials(tool.name);
    final tagline = _getTagline(tool);

    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ToolDetailScreen(toolId: tool.id),
          ),
        );
      },
      child: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: context.cardBg,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: context.borderColor, width: 1),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              children: [
                Container(
                  width: 32,
                  height: 32,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: gradientColors,
                    ),
                    shape: BoxShape.circle,
                  ),
                  child: Center(
                    child: Text(
                      initials,
                      style: GoogleFonts.inter(
                        color: Colors.white,
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 6),
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
                            const SizedBox(width: 2),
                            const Icon(
                              Icons.verified,
                              color: AppColors.purplePrimary,
                              size: 10,
                            ),
                          ],
                          if (tool.isTrending) ...[
                            const SizedBox(width: 2),
                            const Icon(
                              Icons.trending_up,
                              color: AppColors.pinkAccent,
                              size: 10,
                            ),
                          ],
                        ],
                      ),
                      Text(
                        tagline,
                        style: GoogleFonts.inter(
                          color: context.textSecondary,
                          fontSize: 10,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 5),
            Text(
              tool.description,
              style: GoogleFonts.inter(
                color: context.textSecondary,
                fontSize: 11,
                height: 1.2,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 5),
            SizedBox(
              height: 16,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                itemCount: tool.tags.take(2).length,
                separatorBuilder: (_, __) => const SizedBox(width: 3),
                itemBuilder: (context, index) {
                  final tag = tool.tags[index];
                  return Container(
                    padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 2),
                    decoration: BoxDecoration(
                      color: context.cardBgSecondary,
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(
                      '#$tag',
                      style: GoogleFonts.inter(
                        color: context.textMuted,
                        fontSize: 9,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 6),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    const Icon(
                      Icons.star,
                      color: AppColors.starGold,
                      size: 10,
                    ),
                    const SizedBox(width: 2),
                    Text(
                      tool.rating.toString(),
                      style: GoogleFonts.inter(
                        color: context.textPrimary,
                        fontSize: 10,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
                _buildSmallBadge(_getPricingLabel(tool.pricingType)),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSmallBadge(String type) {
    Color bgColor;
    Color textColor;

    switch (type) {
      case 'Free':
        bgColor = context.freeBg;
        textColor = context.freeText;
        break;
      case 'Paid':
        bgColor = context.paidBg;
        textColor = context.paidText;
        break;
      default:
        bgColor = context.freemiumBg;
        textColor = context.freemiumText;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(
        type,
        style: GoogleFonts.inter(
          color: textColor,
          fontSize: 10,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  Widget _buildCategoriesGrid(List<Category> categories, double screenWidth) {
    int crossAxisCount = 3;
    if (screenWidth < 500) crossAxisCount = 2;
    if (screenWidth > 900) crossAxisCount = 4;

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: crossAxisCount,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
        childAspectRatio: 1.7,
      ),
      itemCount: categories.length,
      itemBuilder: (context, index) {
        return _buildCategoryCard(categories[index], index);
      },
    );
  }

  Widget _buildCategoryCard(Category category, int index) {
    final ci = index * 2;
    final gradientColors = ci + 1 < _categoryGradients.length
        ? [_categoryGradients[ci], _categoryGradients[ci + 1]]
        : [AppColors.purplePrimary, AppColors.pinkAccent];

    final iconData = _categoryIcons[category.icon] ?? Icons.category_outlined;

    return GestureDetector(
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
      child: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: context.cardBg,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: context.borderColor, width: 1),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: gradientColors,
                ),
                shape: BoxShape.circle,
              ),
              child: Icon(iconData, color: Colors.white, size: 16),
            ),
            const Spacer(),
            Text(
              category.name,
              style: GoogleFonts.inter(
                color: context.textPrimary,
                fontSize: 11,
                fontWeight: FontWeight.w600,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 2),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '${category.toolCount} tools',
                  style: GoogleFonts.inter(
                    color: context.textMuted,
                    fontSize: 9,
                  ),
                ),
                Text(
                  'Explore →',
                  style: GoogleFonts.inter(
                    color: AppColors.purplePrimary,
                    fontSize: 9,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFilteredSection(List<Tool> filteredTools, double screenWidth) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSectionHeader(
            badge: _selectedFilter == 'Trending'
                ? '🔥 Trending now'
                : _selectedFilter == 'Featured'
                    ? "✨ Editor's picks"
                    : 'Fresh',
            badgeColor: const Color(0xFF2D1B69),
            title: _selectedFilter == 'Trending'
                ? "What's "
                : _selectedFilter == 'Featured'
                    ? 'Featured '
                    : 'Latest ',
            highlightedWord: _selectedFilter == 'Trending'
                ? 'hot'
                : _selectedFilter == 'Featured'
                    ? 'AI tools'
                    : 'additions',
            subtitle: _selectedFilter == 'Trending' ? ' this week' : '',
          ),
          const SizedBox(height: 16),
          _buildFilteredGrid(filteredTools, screenWidth),
        ],
      ),
    );
  }

  Widget _buildFilteredGrid(List<Tool> tools, double screenWidth) {
    int crossAxisCount = 2;
    double childAspectRatio = 1.55;

    if (screenWidth > 900) {
      crossAxisCount = 4;
      childAspectRatio = 1.65;
    } else if (screenWidth > 600) {
      crossAxisCount = 3;
      childAspectRatio = 1.43;
    } else if (screenWidth > 400) {
      crossAxisCount = 2;
      childAspectRatio = 1.7;
    } else {
      crossAxisCount = 2;
      childAspectRatio = 1.28;
    }

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: crossAxisCount,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
        childAspectRatio: childAspectRatio,
      ),
      itemCount: tools.length,
      itemBuilder: (context, index) {
        return _buildToolCard(tools[index]);
      },
    );
  }
}
