import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_dimensions.dart';

@RoutePage()
class GalleryScreen extends StatefulWidget {
  const GalleryScreen({super.key});

  @override
  State<GalleryScreen> createState() => _GalleryScreenState();
}

class _GalleryScreenState extends State<GalleryScreen>
    with TickerProviderStateMixin {
  late final TabController _tabController;
  late final AnimationController _animController;

  static const _tabs = ['All', 'Detailing', 'Repairs', 'Custom'];

  final List<_GalleryItem> _allItems = const [
    _GalleryItem(
      title: 'Full Body Detail',
      category: 'Detailing',
      badge: 'After',
      colors: [Color(0xFF1565C0), Color(0xFF42A5F5)],
    ),
    _GalleryItem(
      title: 'Engine Bay Clean',
      category: 'Detailing',
      badge: 'Before',
      colors: [Color(0xFF4E342E), Color(0xFF795548)],
    ),
    _GalleryItem(
      title: 'Bumper Repair',
      category: 'Repairs',
      badge: 'After',
      colors: [Color(0xFFC62828), Color(0xFFEF5350)],
    ),
    _GalleryItem(
      title: 'Paint Correction',
      category: 'Detailing',
      badge: 'After',
      colors: [Color(0xFF0D47A1), Color(0xFF1E88E5)],
    ),
    _GalleryItem(
      title: 'Custom Wrap',
      category: 'Custom',
      badge: 'After',
      colors: [Color(0xFF212121), Color(0xFF616161)],
    ),
    _GalleryItem(
      title: 'Dent Removal',
      category: 'Repairs',
      badge: 'Before',
      colors: [Color(0xFF827717), Color(0xFFAFB42B)],
    ),
    _GalleryItem(
      title: 'Interior Restore',
      category: 'Detailing',
      badge: 'After',
      colors: [Color(0xFF4A148C), Color(0xFF9C27B0)],
    ),
    _GalleryItem(
      title: 'Custom Exhaust',
      category: 'Custom',
      badge: 'After',
      colors: [Color(0xFFBF360C), Color(0xFFFF5722)],
    ),
    _GalleryItem(
      title: 'Scratch Repair',
      category: 'Repairs',
      badge: 'Before',
      colors: [Color(0xFF33691E), Color(0xFF689F38)],
    ),
    _GalleryItem(
      title: 'Ceramic Coating',
      category: 'Detailing',
      badge: 'After',
      colors: [Color(0xFF006064), Color(0xFF00ACC1)],
    ),
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: _tabs.length, vsync: this);
    _animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );
    _animController.forward();
    _tabController.addListener(() {
      if (!_tabController.indexIsChanging) {
        setState(() {});
      }
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    _animController.dispose();
    super.dispose();
  }

  List<_GalleryItem> get _filteredItems {
    final selectedTab = _tabs[_tabController.index];
    if (selectedTab == 'All') return _allItems;
    return _allItems
        .where((item) => item.category == selectedTab)
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      body: NestedScrollView(
        physics: const BouncingScrollPhysics(),
        headerSliverBuilder: (context, innerBoxIsScrolled) {
          return [
            SliverAppBar(
              floating: true,
              snap: true,
              title: Text(
                'Before & After Gallery',
                style: theme.textTheme.headlineMedium,
              ),
              centerTitle: true,
              backgroundColor: theme.scaffoldBackgroundColor,
              bottom: PreferredSize(
                preferredSize: const Size.fromHeight(52),
                child: _buildTabBar(theme, isDark),
              ),
            ),
          ];
        },
        body: _buildGalleryGrid(context, theme, isDark),
      ),
    );
  }

  Widget _buildTabBar(ThemeData theme, bool isDark) {
    return Container(
      margin: const EdgeInsets.symmetric(
        horizontal: AppDimensions.lg,
      ),
      padding: const EdgeInsets.all(AppDimensions.xs),
      decoration: BoxDecoration(
        color: isDark
            ? AppColors.navyDark.withValues(alpha: 0.5)
            : AppColors.silver.withValues(alpha: 0.3),
        borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
      ),
      child: TabBar(
        controller: _tabController,
        indicator: BoxDecoration(
          color: theme.colorScheme.surface,
          borderRadius: BorderRadius.circular(AppDimensions.radiusSm),
          boxShadow: [
            BoxShadow(
              color: AppColors.black.withValues(alpha: 0.08),
              blurRadius: 4,
              offset: const Offset(0, 1),
            ),
          ],
        ),
        indicatorSize: TabBarIndicatorSize.tab,
        dividerColor: AppColors.transparent,
        labelColor: theme.colorScheme.onSurface,
        unselectedLabelColor:
            theme.colorScheme.onSurface.withValues(alpha: 0.5),
        labelStyle: theme.textTheme.labelMedium?.copyWith(
          fontWeight: FontWeight.w700,
        ),
        unselectedLabelStyle: theme.textTheme.labelMedium,
        tabs: _tabs
            .map((tab) => Tab(
                  height: 36,
                  text: tab,
                ))
            .toList(),
      ),
    );
  }

  Widget _buildGalleryGrid(
    BuildContext context,
    ThemeData theme,
    bool isDark,
  ) {
    final items = _filteredItems;

    if (items.isEmpty) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.photo_library_outlined,
              size: AppDimensions.iconXl,
              color: theme.colorScheme.onSurface.withValues(alpha: 0.3),
            ),
            const SizedBox(height: AppDimensions.md),
            Text(
              'No gallery items yet',
              style: theme.textTheme.bodyMedium,
            ),
          ],
        ),
      );
    }

    return GridView.builder(
      padding: const EdgeInsets.fromLTRB(
        AppDimensions.lg,
        AppDimensions.lg,
        AppDimensions.lg,
        120,
      ),
      physics: const BouncingScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: AppDimensions.md,
        crossAxisSpacing: AppDimensions.md,
        childAspectRatio: 0.75,
      ),
      itemCount: items.length,
      itemBuilder: (context, index) {
        final item = items[index];
        return TweenAnimationBuilder<double>(
          key: ValueKey('${item.title}_${_tabController.index}'),
          tween: Tween(begin: 0.0, end: 1.0),
          duration: Duration(milliseconds: 300 + (index * 60)),
          curve: Curves.easeOutCubic,
          builder: (context, value, child) {
            return Opacity(
              opacity: value,
              child: Transform.scale(
                scale: 0.9 + (0.1 * value),
                child: child,
              ),
            );
          },
          child: _buildGalleryCard(context, theme, isDark, item),
        );
      },
    );
  }

  Widget _buildGalleryCard(
    BuildContext context,
    ThemeData theme,
    bool isDark,
    _GalleryItem item,
  ) {
    final isBefore = item.badge == 'Before';

    return GestureDetector(
      onTap: () {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Viewing: ${item.title}'),
            behavior: SnackBarBehavior.floating,
            duration: const Duration(seconds: 1),
          ),
        );
      },
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(AppDimensions.radiusLg),
          boxShadow: [
            BoxShadow(
              color: (isDark ? AppColors.black : AppColors.navyDarkest)
                  .withValues(alpha: 0.1),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(AppDimensions.radiusLg),
          child: Stack(
            fit: StackFit.expand,
            children: [
              // Colored placeholder simulating an image
              Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: item.colors,
                  ),
                ),
                child: Center(
                  child: Icon(
                    Icons.directions_car_rounded,
                    size: AppDimensions.iconXl,
                    color: AppColors.white.withValues(alpha: 0.2),
                  ),
                ),
              ),

              // Bottom gradient overlay
              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: Container(
                  padding: const EdgeInsets.fromLTRB(
                    AppDimensions.md,
                    AppDimensions.xxxl,
                    AppDimensions.md,
                    AppDimensions.md,
                  ),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        AppColors.transparent,
                        AppColors.black.withValues(alpha: 0.7),
                      ],
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        item.title,
                        style: theme.textTheme.titleSmall?.copyWith(
                          color: AppColors.white,
                          fontWeight: FontWeight.w700,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: AppDimensions.xs),
                      Text(
                        item.category,
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: AppColors.white.withValues(alpha: 0.7),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // Before/After badge
              Positioned(
                top: AppDimensions.sm,
                right: AppDimensions.sm,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppDimensions.sm,
                    vertical: AppDimensions.xs,
                  ),
                  decoration: BoxDecoration(
                    color: isBefore
                        ? AppColors.categoryRepair.withValues(alpha: 0.9)
                        : AppColors.categoryMaintenance.withValues(alpha: 0.9),
                    borderRadius: BorderRadius.circular(
                      AppDimensions.radiusSm,
                    ),
                  ),
                  child: Text(
                    item.badge,
                    style: theme.textTheme.labelSmall?.copyWith(
                      color: AppColors.white,
                      fontWeight: FontWeight.w700,
                      fontSize: 10,
                    ),
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

class _GalleryItem {
  final String title;
  final String category;
  final String badge;
  final List<Color> colors;

  const _GalleryItem({
    required this.title,
    required this.category,
    required this.badge,
    required this.colors,
  });
}
