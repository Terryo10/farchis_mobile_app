
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_dimensions.dart';
import '../../../core/widgets/farchis_button.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../blocs/services/services_bloc.dart';
import '../../../blocs/services/services_state.dart';
import '../../../blocs/services/services_event.dart';
import '../../../data/models/service_model.dart';

@RoutePage()
class CreateBookingScreen extends StatefulWidget {
  const CreateBookingScreen({super.key});

  @override
  State<CreateBookingScreen> createState() => _CreateBookingScreenState();
}

class _CreateBookingScreenState extends State<CreateBookingScreen>
    with TickerProviderStateMixin {
  int _currentStep = 0;
  int _selectedServiceIndex = -1;
  DateTime? _selectedDate;
  int _selectedTimeIndex = -1;

  late final PageController _pageController;
  late final AnimationController _fadeController;

  static const _stepLabels = ['Select Service', 'Choose Date', 'Confirm'];

  

  static const _timeSlots = [
    '08:00 AM',
    '09:30 AM',
    '11:00 AM',
    '01:00 PM',
    '02:30 PM',
    '04:00 PM',
  ];

  @override
  void initState() {
    super.initState();
    context.read<ServicesBloc>().add(const GetServicesEvent());
    _pageController = PageController();
    _fadeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    )..forward();
  }

  @override
  void dispose() {
    _pageController.dispose();
    _fadeController.dispose();
    super.dispose();
  }

  void _goToStep(int step) {
    if (step < 0 || step > 2) return;
    setState(() => _currentStep = step);
    _pageController.animateToPage(
      step,
      duration: const Duration(milliseconds: 350),
      curve: Curves.easeOutCubic,
    );
    _fadeController.reset();
    _fadeController.forward();
  }

  bool get _canProceed {
    switch (_currentStep) {
      case 0:
        return _selectedServiceIndex >= 0;
      case 1:
        return _selectedDate != null && _selectedTimeIndex >= 0;
      default:
        return true;
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: theme.scaffoldBackgroundColor,
        leading: IconButton(
          onPressed: () {
            if (_currentStep > 0) {
              _goToStep(_currentStep - 1);
            } else {
              context.router.maybePop();
            }
          },
          icon: Icon(
            Icons.arrow_back_rounded,
            color: theme.colorScheme.onSurface,
          ),
        ),
        title: Text(
          'Book a Service',
          style: theme.textTheme.headlineMedium,
        ),
        centerTitle: true,
        elevation: 0,
      ),
      body: Column(
        children: [
          // --- Step Indicator ---
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: AppDimensions.xxxl,
              vertical: AppDimensions.lg,
            ),
            child: _StepIndicator(
              currentStep: _currentStep,
              labels: _stepLabels,
              isDark: isDark,
              theme: theme,
            ),
          ),

          // --- Page Content ---
          Expanded(
            child: PageView(
              controller: _pageController,
              physics: const NeverScrollableScrollPhysics(),
              children: [
                _buildServiceStep(theme, isDark),
                _buildDateStep(theme, isDark),
                _buildConfirmStep(theme, isDark),
              ],
            ),
          ),

          // --- Bottom Navigation ---
          _buildBottomBar(theme, isDark),
        ],
      ),
    );
  }

  // ======================== Step 1: Service Selection ========================
  Widget _buildServiceStep(ThemeData theme, bool isDark) {
    return FadeTransition(
      opacity: _fadeController,
      child: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(
          AppDimensions.xxl,
          AppDimensions.sm,
          AppDimensions.xxl,
          AppDimensions.xxl,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'What service do you need?',
              style: theme.textTheme.headlineSmall?.copyWith(
                color: theme.colorScheme.onSurface,
              ),
            ),
            const SizedBox(height: AppDimensions.xs),
            Text(
              'Choose a category to get started',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: isDark
                    ? AppColors.darkTextSecondary
                    : AppColors.lightTextSecondary,
              ),
            ),
            const SizedBox(height: AppDimensions.xxl),
            BlocBuilder<ServicesBloc, ServicesState>(
              builder: (context, state) {
                if (state is ServicesLoading) {
                  return const Center(child: CircularProgressIndicator());
                } else if (state is ServicesLoaded) {
                  final services = state.services;
                  return GridView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: AppDimensions.lg,
                      mainAxisSpacing: AppDimensions.lg,
                      childAspectRatio: 0.88,
                    ),
                    itemCount: services.length,
                    itemBuilder: (context, index) {
                      final service = services[index];
                      final isSelected = _selectedServiceIndex == index;
                      return _ServiceCard(
                        service: service,
                        isSelected: isSelected,
                        isDark: isDark,
                        theme: theme,
                        onTap: () => setState(() => _selectedServiceIndex = index),
                      );
                    },
                  );
                } else if (state is ServicesLoadFailed) {
                  return const Center(child: Text('Failed to load services'));
                }
                return const SizedBox();
              },
            ),
          ],
        ),
      ),
    );
  }

  // ======================== Step 2: Date & Time ========================
  Widget _buildDateStep(ThemeData theme, bool isDark) {
    return FadeTransition(
      opacity: _fadeController,
      child: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(
          AppDimensions.xxl,
          AppDimensions.sm,
          AppDimensions.xxl,
          AppDimensions.xxl,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Pick a date & time',
              style: theme.textTheme.headlineSmall?.copyWith(
                color: theme.colorScheme.onSurface,
              ),
            ),
            const SizedBox(height: AppDimensions.xs),
            Text(
              'Available slots are highlighted',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: isDark
                    ? AppColors.darkTextSecondary
                    : AppColors.lightTextSecondary,
              ),
            ),
            const SizedBox(height: AppDimensions.xxl),
            GestureDetector(
              onTap: () async {
                final date = await showDatePicker(
                  context: context,
                  initialDate: _selectedDate ?? DateTime.now(),
                  firstDate: DateTime.now(),
                  lastDate: DateTime.now().add(const Duration(days: 365)),
                );
                if (date != null) {
                  setState(() => _selectedDate = date);
                }
              },
              child: Container(
                padding: const EdgeInsets.all(AppDimensions.lg),
                decoration: BoxDecoration(
                  color: isDark ? AppColors.navyDark : AppColors.lightSurface,
                  borderRadius: BorderRadius.circular(AppDimensions.radiusLg),
                  border: Border.all(
                    color: isDark ? AppColors.navyLight.withValues(alpha: 0.4) : AppColors.lightBorder,
                  ),
                ),
                child: Row(
                  children: [
                    Icon(Icons.calendar_today_rounded, color: theme.colorScheme.primary),
                    const SizedBox(width: AppDimensions.md),
                    Text(
                      _selectedDate == null
                          ? 'Select Date'
                          : '${_selectedDate!.day.toString().padLeft(2, '0')}/${_selectedDate!.month.toString().padLeft(2, '0')}/${_selectedDate!.year}',
                      style: theme.textTheme.titleMedium?.copyWith(
                        color: theme.colorScheme.onSurface,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: AppDimensions.xxl),
            Text(
              'Available Time Slots',
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w700,
                color: theme.colorScheme.onSurface,
              ),
            ),
            const SizedBox(height: AppDimensions.md),
            Wrap(
              spacing: AppDimensions.sm,
              runSpacing: AppDimensions.sm,
              children: List.generate(_timeSlots.length, (index) {
                final isSelected = _selectedTimeIndex == index;
                // Make some slots unavailable
                final isAvailable = index != 2 && index != 4;
                return GestureDetector(
                  onTap: isAvailable
                      ? () => setState(() => _selectedTimeIndex = index)
                      : null,
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    curve: Curves.easeOutCubic,
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppDimensions.lg,
                      vertical: AppDimensions.md,
                    ),
                    decoration: BoxDecoration(
                      color: isSelected
                          ? (isDark
                              ? AppColors.darkPrimary
                              : AppColors.lightPrimary)
                          : isAvailable
                              ? (isDark
                                  ? AppColors.navyDark
                                  : AppColors.lightSurface)
                              : (isDark
                                  ? AppColors.navyDarkest
                                  : AppColors.silverLight),
                      borderRadius:
                          BorderRadius.circular(AppDimensions.radiusMd),
                      border: Border.all(
                        color: isSelected
                            ? Colors.transparent
                            : isAvailable
                                ? theme.colorScheme.outline
                                : theme.colorScheme.outline.withValues(alpha: 0.3),
                      ),
                    ),
                    child: Text(
                      _timeSlots[index],
                      style: theme.textTheme.labelMedium?.copyWith(
                        color: isSelected
                            ? (isDark
                                ? AppColors.darkOnPrimary
                                : AppColors.lightOnPrimary)
                            : isAvailable
                                ? theme.colorScheme.onSurface
                                : theme.colorScheme.onSurface
                                    .withValues(alpha: 0.3),
                        fontWeight:
                            isSelected ? FontWeight.w700 : FontWeight.w500,
                      ),
                    ),
                  ),
                );
              }),
            ),
          ],
        ),
      ),
    );
  }

  // ======================== Step 3: Confirmation ========================
  Widget _buildConfirmStep(ThemeData theme, bool isDark) {
    final service = _selectedServiceIndex >= 0 ? context.read<ServicesBloc>().state is ServicesLoaded ? (context.read<ServicesBloc>().state as ServicesLoaded).services[_selectedServiceIndex] : null : null;
    final date = _selectedDate != null
        ? '${_selectedDate!.day.toString().padLeft(2, '0')}/${_selectedDate!.month.toString().padLeft(2, '0')}/${_selectedDate!.year}'
        : 'Not selected';
    final time = _selectedTimeIndex >= 0
        ? _timeSlots[_selectedTimeIndex]
        : 'Not selected';

    return FadeTransition(
      opacity: _fadeController,
      child: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(
          AppDimensions.xxl,
          AppDimensions.sm,
          AppDimensions.xxl,
          AppDimensions.xxl,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Confirm your booking',
              style: theme.textTheme.headlineSmall?.copyWith(
                color: theme.colorScheme.onSurface,
              ),
            ),
            const SizedBox(height: AppDimensions.xs),
            Text(
              'Review the details below',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: isDark
                    ? AppColors.darkTextSecondary
                    : AppColors.lightTextSecondary,
              ),
            ),
            const SizedBox(height: AppDimensions.xxl),
            // Summary Card
            Container(
              width: double.infinity,
              decoration: BoxDecoration(
                color: isDark ? AppColors.navyDark : AppColors.lightSurface,
                borderRadius:
                    BorderRadius.circular(AppDimensions.radiusLg),
                border: Border.all(
                  color: isDark ? AppColors.navyLight.withValues(alpha: 0.4) : AppColors.lightBorder,
                ),
                boxShadow: [
                  if (!isDark)
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.04),
                      blurRadius: 16,
                      offset: const Offset(0, 4),
                    ),
                ],
              ),
              child: Padding(
                padding: const EdgeInsets.all(AppDimensions.xxl),
                child: Column(
                  children: [
                    // Service
                    if (service != null) ...[
                      Container(
                        width: 64,
                        height: 64,
                        decoration: BoxDecoration(
                          color: AppColors.categoryMaintenance.withValues(alpha: 0.12),
                          borderRadius: BorderRadius.circular(
                            AppDimensions.radiusMd,
                          ),
                        ),
                        child: Icon(
                          Icons.build_circle_outlined,
                          color: AppColors.categoryMaintenance,
                          size: AppDimensions.iconLg,
                        ),
                      ),
                      const SizedBox(height: AppDimensions.lg),
                      Text(
                        service.name,
                        style: theme.textTheme.headlineMedium?.copyWith(
                          color: theme.colorScheme.onSurface,
                        ),
                      ),
                      Text(
                        service.description,
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: isDark
                              ? AppColors.darkTextSecondary
                              : AppColors.lightTextSecondary,
                        ),
                      ),
                    ],
                    const SizedBox(height: AppDimensions.xxl),
                    Divider(
                      color: theme.colorScheme.outline.withValues(alpha: 0.5),
                    ),
                    const SizedBox(height: AppDimensions.lg),
                    _ConfirmRow(
                      icon: Icons.calendar_today_rounded,
                      label: 'Date',
                      value: date,
                      theme: theme,
                      isDark: isDark,
                    ),
                    const SizedBox(height: AppDimensions.lg),
                    _ConfirmRow(
                      icon: Icons.schedule_rounded,
                      label: 'Time',
                      value: time,
                      theme: theme,
                      isDark: isDark,
                    ),
                    const SizedBox(height: AppDimensions.lg),
                    _ConfirmRow(
                      icon: Icons.directions_car_rounded,
                      label: 'Vehicle',
                      value: 'BMW 320i • ABC-1234',
                      theme: theme,
                      isDark: isDark,
                    ),
                    const SizedBox(height: AppDimensions.lg),
                    Divider(
                      color: theme.colorScheme.outline.withValues(alpha: 0.5),
                    ),
                    const SizedBox(height: AppDimensions.lg),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Estimated Cost',
                          style: theme.textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.w700,
                            color: theme.colorScheme.onSurface,
                          ),
                        ),
                        Text(
                          '\$${service?.price ?? 0}',
                          style: theme.textTheme.headlineMedium?.copyWith(
                            color: isDark
                                ? AppColors.darkSuccess
                                : AppColors.lightSuccess,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBottomBar(ThemeData theme, bool isDark) {
    return Container(
      padding: EdgeInsets.fromLTRB(
        AppDimensions.xxl,
        AppDimensions.lg,
        AppDimensions.xxl,
        MediaQuery.of(context).padding.bottom + AppDimensions.lg,
      ),
      decoration: BoxDecoration(
        color: isDark ? AppColors.navyDark : AppColors.lightSurface,
        border: Border(
          top: BorderSide(
            color: isDark ? AppColors.navyLight.withValues(alpha: 0.3) : AppColors.lightBorder,
          ),
        ),
      ),
      child: Row(
        children: [
          if (_currentStep > 0)
            Expanded(
              child: FarchisButton(
                label: 'Back',
                variant: ButtonVariant.secondary,
                size: ButtonSize.large,
                onPressed: () => _goToStep(_currentStep - 1),
              ),
            ),
          if (_currentStep > 0) const SizedBox(width: AppDimensions.md),
          Expanded(
            flex: _currentStep > 0 ? 2 : 1,
            child: _currentStep == 2
                ? FarchisButton(
                    label: 'Confirm Booking',
                    size: ButtonSize.large,
                    width: double.infinity,
                    icon: const Icon(Icons.check_circle_outline_rounded,
                        size: 20, color: Colors.white),
                    isEnabled: _canProceed,
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: const Text('Booking confirmed! 🎉'),
                          backgroundColor: isDark
                              ? AppColors.darkSuccess
                              : AppColors.lightSuccess,
                        ),
                      );
                      context.router.maybePop();
                    },
                  )
                : FarchisButton(
                    label: 'Next',
                    size: ButtonSize.large,
                    width: double.infinity,
                    isEnabled: _canProceed,
                    onPressed: () => _goToStep(_currentStep + 1),
                  ),
          ),
        ],
      ),
    );
  }

}

// =================== Step Indicator ===================
class _StepIndicator extends StatelessWidget {
  final int currentStep;
  final List<String> labels;
  final bool isDark;
  final ThemeData theme;

  const _StepIndicator({
    required this.currentStep,
    required this.labels,
    required this.isDark,
    required this.theme,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: List.generate(labels.length * 2 - 1, (i) {
        if (i.isOdd) {
          final stepBefore = i ~/ 2;
          final isCompleted = stepBefore < currentStep;
          return Expanded(
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              height: 2.5,
              decoration: BoxDecoration(
                color: isCompleted
                    ? (isDark ? AppColors.darkSuccess : AppColors.lightSuccess)
                    : theme.colorScheme.outline.withValues(alpha: 0.3),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          );
        }
        final stepIndex = i ~/ 2;
        final isActive = stepIndex == currentStep;
        final isCompleted = stepIndex < currentStep;
        return _StepDot(
          index: stepIndex,
          label: labels[stepIndex],
          isActive: isActive,
          isCompleted: isCompleted,
          isDark: isDark,
          theme: theme,
        );
      }),
    );
  }
}

class _StepDot extends StatelessWidget {
  final int index;
  final String label;
  final bool isActive;
  final bool isCompleted;
  final bool isDark;
  final ThemeData theme;

  const _StepDot({
    required this.index,
    required this.label,
    required this.isActive,
    required this.isCompleted,
    required this.isDark,
    required this.theme,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        AnimatedContainer(
          duration: const Duration(milliseconds: 250),
          curve: Curves.easeOutCubic,
          width: isActive ? 36 : 28,
          height: isActive ? 36 : 28,
          decoration: BoxDecoration(
            color: isCompleted
                ? (isDark ? AppColors.darkSuccess : AppColors.lightSuccess)
                : isActive
                    ? (isDark
                        ? AppColors.darkPrimary
                        : AppColors.lightPrimary)
                    : Colors.transparent,
            shape: BoxShape.circle,
            border: Border.all(
              color: isCompleted
                  ? (isDark
                      ? AppColors.darkSuccess
                      : AppColors.lightSuccess)
                  : isActive
                      ? (isDark
                          ? AppColors.darkPrimary
                          : AppColors.lightPrimary)
                      : theme.colorScheme.outline.withValues(alpha: 0.4),
              width: 2,
            ),
          ),
          child: Center(
            child: isCompleted
                ? Icon(
                    Icons.check_rounded,
                    size: 16,
                    color:
                        isDark ? AppColors.darkOnPrimary : AppColors.white,
                  )
                : Text(
                    '${index + 1}',
                    style: theme.textTheme.labelSmall?.copyWith(
                      color: isActive
                          ? (isDark
                              ? AppColors.darkOnPrimary
                              : AppColors.lightOnPrimary)
                          : theme.colorScheme.onSurface.withValues(alpha: 0.4),
                      fontWeight: FontWeight.w700,
                    ),
                  ),
          ),
        ),
        const SizedBox(height: AppDimensions.xs),
        Text(
          label,
          style: theme.textTheme.bodySmall?.copyWith(
            fontSize: 10,
            color: isActive || isCompleted
                ? theme.colorScheme.onSurface
                : theme.colorScheme.onSurface.withValues(alpha: 0.4),
            fontWeight: isActive ? FontWeight.w600 : FontWeight.w400,
          ),
        ),
      ],
    );
  }
}

// =================== Service Card ===================
class _ServiceCard extends StatefulWidget {
  final ServiceModel service;
  final bool isSelected;
  final bool isDark;
  final ThemeData theme;
  final VoidCallback onTap;

  const _ServiceCard({
    required this.service,
    required this.isSelected,
    required this.isDark,
    required this.theme,
    required this.onTap,
  });

  @override
  State<_ServiceCard> createState() => _ServiceCardState();
}

class _ServiceCardState extends State<_ServiceCard> {
  bool _isPressed = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => setState(() => _isPressed = true),
      onTapUp: (_) {
        setState(() => _isPressed = false);
        widget.onTap();
      },
      onTapCancel: () => setState(() => _isPressed = false),
      child: AnimatedScale(
        scale: _isPressed ? 0.95 : 1.0,
        duration: const Duration(milliseconds: 150),
        curve: Curves.easeOutCubic,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 250),
          curve: Curves.easeOutCubic,
          decoration: BoxDecoration(
            color: widget.isDark
                ? AppColors.navyDark
                : AppColors.lightSurface,
            borderRadius: BorderRadius.circular(AppDimensions.radiusLg),
            border: Border.all(
              color: widget.isSelected
                  ? AppColors.categoryMaintenance
                  : widget.isDark
                      ? AppColors.navyLight.withValues(alpha: 0.4)
                      : AppColors.lightBorder,
              width: widget.isSelected ? 2 : 1,
            ),
            boxShadow: widget.isSelected
              ? [
                    BoxShadow(
                      color: AppColors.categoryMaintenance.withValues(alpha: 0.2),
                      blurRadius: 16,
                      offset: const Offset(0, 4),
                    ),
                  ]
                : [
                    if (!widget.isDark)
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.03),
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                  ],
          ),
          child: Padding(
            padding: const EdgeInsets.all(AppDimensions.lg),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: 52,
                  height: 52,
                  decoration: BoxDecoration(
                    color: AppColors.categoryMaintenance.withValues(alpha: 0.12),
                    borderRadius:
                        BorderRadius.circular(AppDimensions.radiusMd),
                  ),
                  child: Icon(
                    Icons.build_circle_outlined,
                    color: AppColors.categoryMaintenance,
                    size: 28,
                  ),
                ),
                const SizedBox(height: AppDimensions.md),
                Text(
                  widget.service.name,
                  style: widget.theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w700,
                    color: widget.theme.colorScheme.onSurface,
                  ),
                ),
                const SizedBox(height: AppDimensions.xs),
                Text(
                  widget.service.description,
                  textAlign: TextAlign.center,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: widget.theme.textTheme.bodySmall?.copyWith(
                    fontSize: 11,
                    color: widget.isDark
                        ? AppColors.darkTextSecondary
                        : AppColors.lightTextSecondary,
                  ),
                ),
                const SizedBox(height: AppDimensions.sm),
                Text(
                  'From ${'\$${widget.service.price}'}',
                  style: widget.theme.textTheme.labelMedium?.copyWith(
                    color: AppColors.categoryMaintenance,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}


// =================== Confirmation Row ===================
class _ConfirmRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final ThemeData theme;
  final bool isDark;

  const _ConfirmRow({
    required this.icon,
    required this.label,
    required this.value,
    required this.theme,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(
          icon,
          size: 18,
          color: isDark
              ? AppColors.darkTextTertiary
              : AppColors.lightTextTertiary,
        ),
        const SizedBox(width: AppDimensions.md),
        Text(
          label,
          style: theme.textTheme.bodyMedium?.copyWith(
            color: isDark
                ? AppColors.darkTextSecondary
                : AppColors.lightTextSecondary,
          ),
        ),
        const Spacer(),
        Text(
          value,
          style: theme.textTheme.titleSmall?.copyWith(
            fontWeight: FontWeight.w600,
            color: theme.colorScheme.onSurface,
          ),
        ),
      ],
    );
  }
}

// =================== Data Model ===================