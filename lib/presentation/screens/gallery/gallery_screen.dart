import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:skeletonizer/skeletonizer.dart';
import '../../../blocs/gallery/gallery_bloc.dart';
import '../../../blocs/gallery/gallery_event.dart';
import '../../../blocs/gallery/gallery_state.dart';
import '../../../data/models/gallery_item_model.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_dimensions.dart';
import '../../../core/widgets/farchis_button.dart';

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

    // Trigger loading of gallery items
    context.read<GalleryBloc>().add(const GetGalleryEvent());
  }

  @override
  void dispose() {
    _tabController.dispose();
    _animController.dispose();
    super.dispose();
  }

  List<GalleryItemModel> _filteredItems(List<GalleryItemModel> allItems) {
    final selectedTab = _tabs[_tabController.index];
    if (selectedTab == 'All') return allItems;
    return allItems.where((item) {
      final caption = item.caption?.toLowerCase() ?? '';
      return caption.contains(selectedTab.toLowerCase());
    }).toList();
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
        body: BlocBuilder<GalleryBloc, GalleryState>(
          builder: (context, state) {
            final isLoading = state is GalleryLoading || state is GalleryInitial;
            if (state is GalleryLoadFailed) {
              return Center(
                child: Padding(
                  padding: const EdgeInsets.all(AppDimensions.lg),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.error_outline_rounded,
                        size: 48,
                        color: theme.colorScheme.error,
                      ),
                      const SizedBox(height: AppDimensions.md),
                      Text(
                        'Failed to load gallery',
                        style: theme.textTheme.titleMedium,
                      ),
                      const SizedBox(height: AppDimensions.sm),
                      Text(
                        state.failure.message,
                        textAlign: TextAlign.center,
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
                        ),
                      ),
                      const SizedBox(height: AppDimensions.lg),
                      FarchisButton(
                        label: 'Retry',
                        onPressed: () {
                          context.read<GalleryBloc>().add(const GetGalleryEvent());
                        },
                      ),
                    ],
                  ),
                ),
              );
            }

            final items = state is GalleryLoaded
                ? state.items
                : GalleryItemModel.placeholderList(6);

            return Skeletonizer(
              enabled: isLoading,
              effect: ShimmerEffect(
                baseColor: const Color(0xFF253971).withValues(alpha: 0.08),
                highlightColor: const Color(0xFF253971).withValues(alpha: 0.15),
              ),
              child: _buildGalleryGrid(context, theme, isDark, items, isLoading: isLoading),
            );
          },
        ),
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
    List<GalleryItemModel> allItems, {
    bool isLoading = false,
  }) {
    final items = isLoading ? allItems : _filteredItems(allItems);

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
              'No gallery items in this category',
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
          key: ValueKey('${item.id}_${_tabController.index}'),
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
    GalleryItemModel item,
  ) {
    return GestureDetector(
      onTap: () {
        showDialog(
          context: context,
          builder: (context) => _GalleryItemDetailsDialog(item: item),
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
              // After image as background, since it's the final result
              Image.network(
                item.afterImageUrl,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [Color(0xFF1565C0), Color(0xFF42A5F5)],
                      ),
                    ),
                    child: Center(
                      child: Icon(
                        Icons.directions_car_rounded,
                        size: AppDimensions.iconXl,
                        color: AppColors.white.withValues(alpha: 0.2),
                      ),
                    ),
                  );
                },
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
                        item.caption ?? 'Awesome Service',
                        style: theme.textTheme.titleSmall?.copyWith(
                          color: AppColors.white,
                          fontWeight: FontWeight.w700,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: AppDimensions.xs),
                      Text(
                        'Tap to compare',
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: AppColors.white.withValues(alpha: 0.7),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // Visual badge
              Positioned(
                top: AppDimensions.sm,
                right: AppDimensions.sm,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppDimensions.sm,
                    vertical: AppDimensions.xs,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.categoryMaintenance.withValues(alpha: 0.9),
                    borderRadius: BorderRadius.circular(
                      AppDimensions.radiusSm,
                    ),
                  ),
                  child: Text(
                    'Result',
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

class _GalleryItemDetailsDialog extends StatefulWidget {
  final GalleryItemModel item;

  const _GalleryItemDetailsDialog({required this.item});

  @override
  State<_GalleryItemDetailsDialog> createState() =>
      __GalleryItemDetailsDialogState();
}

class __GalleryItemDetailsDialogState extends State<_GalleryItemDetailsDialog> {
  bool _showAfter = true;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppDimensions.radiusLg),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(AppDimensions.radiusLg),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Stack(
              children: [
                AspectRatio(
                  aspectRatio: 1,
                  child: AnimatedCrossFade(
                    duration: const Duration(milliseconds: 300),
                    firstCurve: Curves.easeInOutCubic,
                    secondCurve: Curves.easeInOutCubic,
                    crossFadeState: _showAfter
                        ? CrossFadeState.showFirst
                        : CrossFadeState.showSecond,
                    firstChild: Image.network(
                      widget.item.afterImageUrl,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) =>
                          const _PlaceholderImage(),
                    ),
                    secondChild: Image.network(
                      widget.item.beforeImageUrl,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) =>
                          const _PlaceholderImage(),
                    ),
                  ),
                ),
                Positioned(
                  top: AppDimensions.sm,
                  right: AppDimensions.sm,
                  child: IconButton(
                    icon: const Icon(Icons.close, color: Colors.white),
                    style: IconButton.styleFrom(
                      backgroundColor: Colors.black.withValues(alpha: 0.4),
                    ),
                    onPressed: () => Navigator.pop(context),
                  ),
                ),
                Positioned(
                  bottom: AppDimensions.md,
                  left: AppDimensions.md,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppDimensions.md,
                      vertical: AppDimensions.sm,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.black.withValues(alpha: 0.6),
                      borderRadius: BorderRadius.circular(AppDimensions.radiusSm),
                    ),
                    child: Text(
                      _showAfter ? 'AFTER' : 'BEFORE',
                      style: theme.textTheme.labelMedium?.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(AppDimensions.lg),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.item.caption ?? 'Service Transformation',
                    style: theme.textTheme.titleMedium,
                  ),
                  const SizedBox(height: AppDimensions.md),
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton(
                          style: OutlinedButton.styleFrom(
                            backgroundColor: !_showAfter
                                ? theme.colorScheme.primary.withValues(alpha: 0.1)
                                : null,
                            side: BorderSide(
                              color: !_showAfter
                                  ? theme.colorScheme.primary
                                  : theme.dividerColor,
                            ),
                          ),
                          onPressed: () {
                            setState(() {
                              _showAfter = false;
                            });
                          },
                          child: const Text('Before'),
                        ),
                      ),
                      const SizedBox(width: AppDimensions.md),
                      Expanded(
                        child: OutlinedButton(
                          style: OutlinedButton.styleFrom(
                            backgroundColor: _showAfter
                                ? theme.colorScheme.primary.withValues(alpha: 0.1)
                                : null,
                            side: BorderSide(
                              color: _showAfter
                                  ? theme.colorScheme.primary
                                  : theme.dividerColor,
                            ),
                          ),
                          onPressed: () {
                            setState(() {
                              _showAfter = true;
                            });
                          },
                          child: const Text('After'),
                        ),
                      ),
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
}

class _PlaceholderImage extends StatelessWidget {
  const _PlaceholderImage();

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.grey[300],
      child: const Center(
        child: Icon(Icons.broken_image, size: 48, color: Colors.grey),
      ),
    );
  }
}
