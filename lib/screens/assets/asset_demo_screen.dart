import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../constants/asset_paths.dart';

/// AssetDemoScreen - Demonstrates Flutter asset management.
///
/// This screen shows how to:
/// - Load and display local images (SVG, PNG, JPG)
/// - Use Flutter's built-in Material Icons
/// - Combine images and icons in layouts
/// - Handle different image formats
/// - Scale and fit images properly
class AssetDemoScreen extends StatelessWidget {
  const AssetDemoScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _buildHeader(),
              Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // Section 1: SVG Images
                    _buildSectionTitle('SVG Images'),
                    const SizedBox(height: 12),
                    _buildSvgImagesSection(),

                    const SizedBox(height: 28),

                    // Section 2: Flutter Material Icons
                    _buildSectionTitle('Flutter Material Icons'),
                    const SizedBox(height: 12),
                    _buildMaterialIconsSection(),

                    const SizedBox(height: 28),

                    // Section 3: Cupertino Icons
                    _buildSectionTitle('Cupertino Icons'),
                    const SizedBox(height: 12),
                    _buildCupertinoIconsSection(),

                    const SizedBox(height: 28),

                    // Section 4: Icon with Text Combinations
                    _buildSectionTitle('Icons + Text Combinations'),
                    const SizedBox(height: 12),
                    _buildIconTextCombinations(),

                    const SizedBox(height: 28),

                    // Section 5: Custom SVG Icons
                    _buildSectionTitle('Custom SVG Icons'),
                    const SizedBox(height: 12),
                    _buildCustomSvgIcons(),

                    const SizedBox(height: 28),

                    // Section 6: Empty State Example
                    _buildSectionTitle('Empty State with Image'),
                    const SizedBox(height: 12),
                    _buildEmptyStateExample(),

                    const SizedBox(height: 28),

                    // Section 7: Asset Configuration Info
                    _buildAssetConfigInfo(),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ═══════════════════════════════════════════════════════════════════
  // HEADER - Banner with logo
  // ═══════════════════════════════════════════════════════════════════

  Widget _buildHeader() {
    return Container(
      height: 200,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFF6366F1), Color(0xFF8B5CF6)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Stack(
        children: [
          // Background decorative circles
          Positioned(
            right: -30,
            top: -30,
            child: Container(
              width: 150,
              height: 150,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white.withValues(alpha: 0.1),
              ),
            ),
          ),
          Positioned(
            right: 40,
            bottom: -20,
            child: Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white.withValues(alpha: 0.1),
              ),
            ),
          ),
          // Content
          Padding(
            padding: const EdgeInsets.all(20),
            child: Row(
              children: [
                // Logo using SVG asset
                Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.1),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  padding: const EdgeInsets.all(12),
                  child: SvgPicture.asset(
                    AssetPaths.logo,
                    fit: BoxFit.contain,
                  ),
                ),
                const SizedBox(width: 20),
                // Text content
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        'Asset Management',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Images, Icons & SVG Demo',
                        style: TextStyle(
                          color: Colors.white.withValues(alpha: 0.9),
                          fontSize: 14,
                        ),
                      ),
                      const SizedBox(height: 12),
                      // Row of Material Icons
                      Row(
                        children: [
                          _buildHeaderIcon(Icons.image_rounded),
                          const SizedBox(width: 8),
                          _buildHeaderIcon(Icons.folder_rounded),
                          const SizedBox(width: 8),
                          _buildHeaderIcon(Icons.palette_rounded),
                          const SizedBox(width: 8),
                          _buildHeaderIcon(Icons.widgets_rounded),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeaderIcon(IconData icon) {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.2),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Icon(icon, color: Colors.white, size: 18),
    );
  }

  // ═══════════════════════════════════════════════════════════════════
  // SVG IMAGES SECTION
  // ═══════════════════════════════════════════════════════════════════

  Widget _buildSvgImagesSection() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildCodeSnippet('SvgPicture.asset(AssetPaths.logo)'),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildSvgShowcase(
                AssetPaths.logo,
                'Logo',
                60,
              ),
              _buildSvgShowcase(
                AssetPaths.orderIcon,
                'Order',
                50,
              ),
              _buildSvgShowcase(
                AssetPaths.queueIcon,
                'Queue',
                50,
              ),
            ],
          ),
          const SizedBox(height: 16),
          const Text(
            'SVG images scale without losing quality. Perfect for icons and logos.',
            style: TextStyle(
              color: Color(0xFF64748B),
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSvgShowcase(String assetPath, String label, double size) {
    return Column(
      children: [
        Container(
          width: size + 20,
          height: size + 20,
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: const Color(0xFFF1F5F9),
            borderRadius: BorderRadius.circular(12),
          ),
          child: SvgPicture.asset(
            assetPath,
            width: size,
            height: size,
            fit: BoxFit.contain,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          label,
          style: const TextStyle(
            color: Color(0xFF64748B),
            fontSize: 12,
          ),
        ),
      ],
    );
  }

  // ═══════════════════════════════════════════════════════════════════
  // MATERIAL ICONS SECTION
  // ═══════════════════════════════════════════════════════════════════

  Widget _buildMaterialIconsSection() {
    final icons = [
      (Icons.home_rounded, 'Home', const Color(0xFF6366F1)),
      (Icons.shopping_cart_rounded, 'Cart', const Color(0xFF10B981)),
      (Icons.person_rounded, 'User', const Color(0xFF3B82F6)),
      (Icons.settings_rounded, 'Settings', const Color(0xFF64748B)),
      (Icons.notifications_rounded, 'Alerts', const Color(0xFFF59E0B)),
      (Icons.favorite_rounded, 'Favorite', const Color(0xFFEF4444)),
      (Icons.search_rounded, 'Search', const Color(0xFF8B5CF6)),
      (Icons.add_circle_rounded, 'Add', const Color(0xFF10B981)),
    ];

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildCodeSnippet('Icon(Icons.home_rounded, size: 28)'),
          const SizedBox(height: 16),
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 4,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
              childAspectRatio: 1,
            ),
            itemCount: icons.length,
            itemBuilder: (context, index) {
              final iconData = icons[index];
              return _buildIconTile(iconData.$1, iconData.$2, iconData.$3);
            },
          ),
        ],
      ),
    );
  }

  Widget _buildIconTile(IconData icon, String label, Color color) {
    return Container(
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, color: color, size: 28),
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              color: color,
              fontSize: 10,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  // ═══════════════════════════════════════════════════════════════════
  // CUPERTINO ICONS SECTION
  // ═══════════════════════════════════════════════════════════════════

  Widget _buildCupertinoIconsSection() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildCodeSnippet('Icon(CupertinoIcons.heart_fill)'),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildCupertinoIcon(Icons.apple, 'Apple'),
              _buildCupertinoIcon(Icons.smartphone, 'Device'),
              _buildCupertinoIcon(Icons.cloud, 'Cloud'),
              _buildCupertinoIcon(Icons.lock, 'Privacy'),
            ],
          ),
          const SizedBox(height: 12),
          const Text(
            'iOS-style icons available via cupertino_icons package.',
            style: TextStyle(
              color: Color(0xFF64748B),
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCupertinoIcon(IconData icon, String label) {
    return Column(
      children: [
        Container(
          width: 56,
          height: 56,
          decoration: BoxDecoration(
            color: const Color(0xFF1E293B),
            borderRadius: BorderRadius.circular(14),
          ),
          child: Icon(icon, color: Colors.white, size: 26),
        ),
        const SizedBox(height: 6),
        Text(
          label,
          style: const TextStyle(
            color: Color(0xFF64748B),
            fontSize: 11,
          ),
        ),
      ],
    );
  }

  // ═══════════════════════════════════════════════════════════════════
  // ICON + TEXT COMBINATIONS
  // ═══════════════════════════════════════════════════════════════════

  Widget _buildIconTextCombinations() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          // List tiles with icons
          _buildIconListTile(
            Icons.receipt_long_rounded,
            'New Order',
            'ORD-001 • 2 items',
            const Color(0xFF6366F1),
          ),
          const Divider(height: 1),
          _buildIconListTile(
            Icons.access_time_rounded,
            'Queue Status',
            '8 orders waiting',
            const Color(0xFFF59E0B),
          ),
          const Divider(height: 1),
          _buildIconListTile(
            Icons.check_circle_rounded,
            'Completed Today',
            '47 orders delivered',
            const Color(0xFF10B981),
          ),
        ],
      ),
    );
  }

  Widget _buildIconListTile(IconData icon, String title, String subtitle, Color color) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: color, size: 24),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    color: Color(0xFF1E293B),
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Text(
                  subtitle,
                  style: const TextStyle(
                    color: Color(0xFF64748B),
                    fontSize: 13,
                  ),
                ),
              ],
            ),
          ),
          Icon(Icons.chevron_right_rounded, color: color),
        ],
      ),
    );
  }

  // ═══════════════════════════════════════════════════════════════════
  // CUSTOM SVG ICONS
  // ═══════════════════════════════════════════════════════════════════

  Widget _buildCustomSvgIcons() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: const Color(0xFF6366F1).withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: SvgPicture.asset(
                  AssetPaths.orderIcon,
                  width: 32,
                  height: 32,
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Custom SVG Icons',
                      style: TextStyle(
                        color: Color(0xFF1E293B),
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Store custom icons in assets/icons/',
                      style: TextStyle(
                        color: const Color(0xFF64748B),
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: const Color(0xFFF1F5F9),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Row(
              children: [
                const Icon(Icons.lightbulb_outline, color: Color(0xFFF59E0B), size: 18),
                const SizedBox(width: 10),
                const Expanded(
                  child: Text(
                    'SVGs can be colored using colorFilter property',
                    style: TextStyle(
                      color: Color(0xFF64748B),
                      fontSize: 12,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ═══════════════════════════════════════════════════════════════════
  // EMPTY STATE EXAMPLE
  // ═══════════════════════════════════════════════════════════════════

  Widget _buildEmptyStateExample() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          SvgPicture.asset(
            AssetPaths.emptyState,
            width: 150,
            height: 150,
          ),
          const SizedBox(height: 16),
          const Text(
            'No Orders in Queue',
            style: TextStyle(
              color: Color(0xFF1E293B),
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'Your queue is empty. New orders will appear here.',
            style: TextStyle(
              color: Color(0xFF64748B),
              fontSize: 14,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 20),
          ElevatedButton.icon(
            onPressed: () {},
            icon: const Icon(Icons.add_rounded),
            label: const Text('Add New Order'),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF6366F1),
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ═══════════════════════════════════════════════════════════════════
  // ASSET CONFIGURATION INFO
  // ═══════════════════════════════════════════════════════════════════

  Widget _buildAssetConfigInfo() {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: const Color(0xFF1E293B),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Icon(Icons.code_rounded, color: Color(0xFF10B981), size: 20),
              SizedBox(width: 10),
              Text(
                'Asset Configuration',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          _buildConfigLine('pubspec.yaml', 'Register asset directories'),
          const SizedBox(height: 8),
          _buildConfigLine('assets/images/', 'Store image files'),
          const SizedBox(height: 8),
          _buildConfigLine('assets/icons/', 'Store custom icons'),
          const SizedBox(height: 8),
          _buildConfigLine('lib/constants/', 'Asset path constants'),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: const Color(0xFF334155),
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Text(
              '# pubspec.yaml\nflutter:\n  assets:\n    - assets/images/\n    - assets/icons/',
              style: TextStyle(
                color: Color(0xFF10B981),
                fontSize: 12,
                fontFamily: 'monospace',
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildConfigLine(String path, String description) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          decoration: BoxDecoration(
            color: const Color(0xFF6366F1).withValues(alpha: 0.2),
            borderRadius: BorderRadius.circular(4),
          ),
          child: Text(
            path,
            style: const TextStyle(
              color: Color(0xFF818CF8),
              fontSize: 11,
              fontFamily: 'monospace',
            ),
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Text(
            description,
            style: const TextStyle(
              color: Color(0xFF94A3B8),
              fontSize: 12,
            ),
          ),
        ),
      ],
    );
  }

  // ═══════════════════════════════════════════════════════════════════
  // HELPER WIDGETS
  // ═══════════════════════════════════════════════════════════════════

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(
        color: Color(0xFF1E293B),
        fontSize: 18,
        fontWeight: FontWeight.bold,
      ),
    );
  }

  Widget _buildCodeSnippet(String code) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: const Color(0xFFF1F5F9),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          const Icon(Icons.code_rounded, color: Color(0xFF6366F1), size: 16),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              code,
              style: const TextStyle(
                color: Color(0xFF6366F1),
                fontSize: 12,
                fontFamily: 'monospace',
              ),
            ),
          ),
        ],
      ),
    );
  }
}
