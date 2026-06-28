import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../core/theme/app_colors.dart';
import '../router/app_router.dart';

@RoutePage()
class MainLayoutScreen extends StatelessWidget {
  const MainLayoutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return AutoTabsRouter(
      routes: const [
        HomeRoute(),
        BookingListRoute(),
        LoyaltyRoute(),
        ProfileRoute(),
      ],
      builder: (context, child) {
        final tabsRouter = AutoTabsRouter.of(context);
        return Scaffold(
          body: child,
          extendBody: true,
          bottomNavigationBar: _buildBottomNav(context, tabsRouter),
        );
      },
    );
  }

  Widget _buildBottomNav(BuildContext context, TabsRouter tabsRouter) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Container(
      margin: const EdgeInsets.only(left: 24, right: 24, bottom: 24),
      decoration: BoxDecoration(
        color: isDark ? AppColors.navyDark : AppColors.navyPrimary,
        borderRadius: BorderRadius.circular(30),
        boxShadow: [
          BoxShadow(
            color: const Color.fromARGB(51, 0, 0, 0), // ~0.2 opacity black
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        child: Row(
            children: [
              Expanded(
                child: _NavItem(
                  icon: Icons.home_rounded,
                  label: 'Home',
                  isSelected: tabsRouter.activeIndex == 0,
                  onTap: () {
                    HapticFeedback.lightImpact();
                    tabsRouter.setActiveIndex(0);
                  },
                ),
              ),
              Expanded(
                child: _NavItem(
                  icon: Icons.calendar_month_rounded,
                  label: 'Bookings',
                  isSelected: tabsRouter.activeIndex == 1,
                  onTap: () {
                    HapticFeedback.lightImpact();
                    tabsRouter.setActiveIndex(1);
                  },
                ),
              ),
              Expanded(
                child: _NavItem(
                  icon: Icons.stars_rounded,
                  label: 'Rewards',
                  isSelected: tabsRouter.activeIndex == 2,
                  onTap: () {
                    HapticFeedback.lightImpact();
                    tabsRouter.setActiveIndex(2);
                  },
                ),
              ),
              Expanded(
                child: _NavItem(
                  icon: Icons.person_rounded,
                  label: 'Account',
                  isSelected: tabsRouter.activeIndex == 3,
                  onTap: () {
                    HapticFeedback.lightImpact();
                    tabsRouter.setActiveIndex(3);
                  },
                ),
              ),
            ],
          ),
        ),
      );
    }
}

class _NavItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const _NavItem({
    required this.icon,
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Semantics(
        label: label,
        button: true,
        selected: isSelected,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          curve: Curves.easeOutCubic,
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
          decoration: BoxDecoration(
            color: isSelected
                ? const Color.fromARGB(26, 255, 255, 255) // white ~0.1
                : AppColors.transparent,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                icon,
                color: isSelected
                    ? AppColors.white
                    : const Color(0xFF8FA3BF),
                size: 22,
              ),
              const SizedBox(height: 4),
              Text(
                label,
                style: TextStyle(
                  color: isSelected
                      ? AppColors.white
                      : const Color(0xFF8FA3BF),
                  fontWeight: FontWeight.w600,
                  fontSize: 11,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

