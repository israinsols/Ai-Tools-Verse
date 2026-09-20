import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../constants/app_colors.dart';
import '../../constants/theme_helper.dart';
import '../../models/models.dart';
import '../../providers/providers.dart';
import '../../widgets/app_network_image.dart';

class AdminScreen extends ConsumerStatefulWidget {
  const AdminScreen({super.key});

  @override
  ConsumerState<AdminScreen> createState() => _AdminScreenState();
}

class _AdminScreenState extends ConsumerState<AdminScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  List<Tool> _pendingTools = [];
  List<Tool> _rejectedTools = [];
  Map<String, dynamic> _stats = {};
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _loadData();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<void> _loadData() async {
    setState(() => _isLoading = true);
    try {
      final api = ref.read(apiServiceProvider);
      final pendingFuture = api.getPendingTools();
      final rejectedFuture = api.getRejectedTools();
      final statsFuture = api.getToolStats();
      final results = await Future.wait([pendingFuture, rejectedFuture, statsFuture]);
      setState(() {
        _pendingTools = results[0] as List<Tool>;
        _rejectedTools = results[1] as List<Tool>;
        _stats = results[2] as Map<String, dynamic>;
        _isLoading = false;
      });
    } catch (e) {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _approveTool(String toolId) async {
    try {
      final api = ref.read(apiServiceProvider);
      await api.approveTool(toolId);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Tool approved!'),
          backgroundColor: Colors.green,
        ),
      );
      _loadData();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed: $e'),
          backgroundColor: Colors.redAccent,
        ),
      );
    }
  }

  Future<void> _rejectTool(String toolId) async {
    try {
      final api = ref.read(apiServiceProvider);
      await api.rejectTool(toolId);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Tool rejected'),
          backgroundColor: Colors.orange,
        ),
      );
      _loadData();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed: $e'),
          backgroundColor: Colors.redAccent,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(context),
            _buildStats(context),
            _buildTabs(context),
            Expanded(
              child: _isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : TabBarView(
                      controller: _tabController,
                      children: [
                        _buildToolList(context, _pendingTools, isPending: true),
                        _buildToolList(context, _rejectedTools, isPending: false),
                      ],
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
      child: Align(
        alignment: Alignment.topLeft,
        child: Text(
          'Admin Dashboard',
          style: GoogleFonts.inter(
            color: context.textPrimary,
            fontSize: 20,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }

  Widget _buildStats(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: context.cardBg,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: context.borderColor, width: 0.5),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildStatItem(context, 'Total', _stats['total'] ?? 0, AppColors.purplePrimary),
          _buildStatItem(context, 'Approved', _stats['approved'] ?? 0, Colors.green),
          _buildStatItem(context, 'Pending', _stats['pending'] ?? 0, Colors.orange),
          _buildStatItem(context, 'Rejected', _stats['rejected'] ?? 0, Colors.redAccent),
        ],
      ),
    );
  }

  Widget _buildStatItem(BuildContext context, String label, int count, Color color) {
    return Column(
      children: [
        Text(
          count.toString(),
          style: GoogleFonts.inter(
            color: color,
            fontSize: 20,
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: GoogleFonts.inter(
            color: context.textSecondary,
            fontSize: 11,
          ),
        ),
      ],
    );
  }

  Widget _buildTabs(BuildContext context) {
    return Container(
      margin: const EdgeInsets.fromLTRB(16, 16, 16, 0),
      decoration: BoxDecoration(
        color: context.cardBg,
        borderRadius: BorderRadius.circular(10),
      ),
      child: TabBar(
        controller: _tabController,
        indicatorSize: TabBarIndicatorSize.tab,
        indicator: BoxDecoration(
          color: AppColors.purplePrimary,
          borderRadius: BorderRadius.circular(10),
        ),
        dividerColor: Colors.transparent,
        labelColor: context.textPrimary,
        unselectedLabelColor: context.textSecondary,
        labelStyle: GoogleFonts.inter(fontSize: 13, fontWeight: FontWeight.w500),
        unselectedLabelStyle: GoogleFonts.inter(fontSize: 13),
        tabs: [
          Tab(text: 'Pending (${_pendingTools.length})'),
          Tab(text: 'Rejected (${_rejectedTools.length})'),
        ],
      ),
    );
  }

  Widget _buildToolList(BuildContext context, List<Tool> tools, {required bool isPending}) {
    if (tools.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              isPending ? Icons.pending_actions : Icons.block,
              color: context.textMuted,
              size: 48,
            ),
            const SizedBox(height: 16),
            Text(
              isPending ? 'No pending tools' : 'No rejected tools',
              style: GoogleFonts.inter(
                color: context.textSecondary,
                fontSize: 14,
              ),
            ),
          ],
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: _loadData,
      child: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: tools.length,
        itemBuilder: (context, index) {
          final tool = tools[index];
          return _buildToolCard(context, tool, isPending: isPending);
        },
      ),
    );
  }

  Widget _buildToolCard(BuildContext context, Tool tool, {required bool isPending}) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: context.cardBg,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: context.borderColor, width: 0.5),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              AppNetworkImage(
                imageUrl: tool.logoUrl,
                initials: tool.name.substring(0, 2).toUpperCase(),
                size: 44,
                borderRadius: 10,
                gradientColors: AppNetworkImage.getGradientForId(tool.id),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      tool.name,
                      style: GoogleFonts.inter(
                        color: context.textPrimary,
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      tool.websiteUrl,
                      style: GoogleFonts.inter(
                        color: context.textMuted,
                        fontSize: 11,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            tool.description,
            style: GoogleFonts.inter(
              color: context.textSecondary,
              fontSize: 12,
              height: 1.5,
            ),
            maxLines: 3,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 6,
            runSpacing: 6,
            children: tool.tags.map((tag) {
              return Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: context.cardBgSecondary,
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  tag,
                  style: GoogleFonts.inter(
                    color: context.textSecondary,
                    fontSize: 10,
                  ),
                ),
              );
            }).toList(),
          ),
          if (isPending) ...[
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () => _approveTool(tool.id),
                    icon: const Icon(Icons.check, size: 16),
                    label: Text('Approve', style: GoogleFonts.inter(fontSize: 12)),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () => _rejectTool(tool.id),
                    icon: const Icon(Icons.close, size: 16),
                    label: Text('Reject', style: GoogleFonts.inter(fontSize: 12)),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.redAccent,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }
}
