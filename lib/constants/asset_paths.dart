/// AssetPaths - Centralized asset path management.
///
/// This file contains all asset paths used in the application.
/// Using constants prevents typos and makes asset management easier.
///
/// Benefits:
/// - Single source of truth for all asset paths
/// - Compile-time checking for typos
/// - Easy refactoring when paths change
/// - IDE autocomplete support
class AssetPaths {
  // Prevent instantiation
  AssetPaths._();

  // ═══════════════════════════════════════════════════════════════════
  // IMAGE ASSETS
  // Located in: assets/images/
  // ═══════════════════════════════════════════════════════════════════

  /// SmartQueue logo - used in headers, splash screen, about page
  static const String logo = 'assets/images/smartqueue_logo.svg';

  /// Banner image - used for promotional sections
  static const String banner = 'assets/images/banner_placeholder.svg';

  /// Empty state illustration - used when no data is available
  static const String emptyState = 'assets/images/empty_state.svg';

  // ═══════════════════════════════════════════════════════════════════
  // ICON ASSETS
  // Located in: assets/icons/
  // ═══════════════════════════════════════════════════════════════════

  /// Order icon - represents order-related actions
  static const String orderIcon = 'assets/icons/order_icon.svg';

  /// Queue icon - represents queue management
  static const String queueIcon = 'assets/icons/queue_icon.svg';

  // ═══════════════════════════════════════════════════════════════════
  // ASSET DIRECTORIES
  // Use these when loading all assets from a directory
  // ═══════════════════════════════════════════════════════════════════

  /// Base directory for images
  static const String imagesDir = 'assets/images/';

  /// Base directory for icons
  static const String iconsDir = 'assets/icons/';

  // ═══════════════════════════════════════════════════════════════════
  // HELPER METHODS
  // ═══════════════════════════════════════════════════════════════════

  /// Get image path from filename
  static String image(String filename) => '$imagesDir$filename';

  /// Get icon path from filename
  static String icon(String filename) => '$iconsDir$filename';
}
