import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_stripe/flutter_stripe.dart' as stripe;
import 'package:intl/intl.dart';
import 'package:skeletonizer/skeletonizer.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_dimensions.dart';
import '../../../core/widgets/farchis_button.dart';
import '../../../core/widgets/farchis_info_banner.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../blocs/theme/theme_cubit.dart';
import '../../../blocs/services/services_bloc.dart';
import '../../../blocs/services/services_state.dart';
import '../../../blocs/services/services_event.dart';
import '../../../blocs/booking_create/booking_create_bloc.dart';
import '../../../blocs/booking_create/booking_create_event.dart';
import '../../../blocs/booking_create/booking_create_state.dart';
import '../../../blocs/my_vehicles/my_vehicles_bloc.dart';
import '../../../blocs/my_vehicles/my_vehicles_event.dart';
import '../../../blocs/my_vehicles/my_vehicles_state.dart';
import '../../../data/models/booking_model.dart';
import '../../../data/models/service_model.dart';
import '../../../data/models/vehicle_model.dart';
import '../../../data/repositories/booking_repository.dart';
import '../../../data/repositories/payment_repository.dart';
import '../../../data/repositories/service_repository.dart';

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
  VehicleModel? _selectedVehicle;
  DateTime? _selectedDate;
  String? _selectedSlot;
  List<String> _availableSlots = [];
  bool _loadingSlots = false;

  // Server-resolved price (Step 3: Confirm)
  double? _resolvedPrice;
  bool _priceLoading = false;

  // Payment (Step 4)
  bool _isProcessingPayment = false;

  late final PageController _pageController;
  late final AnimationController _fadeController;

  static const _stepLabels = [
    'Select Service',
    'Choose Date',
    'Confirm',
    'Payment',
  ];

  String _formatSlotLabel(String slot24) {
    final parsed = DateFormat('HH:mm').parse(slot24);
    return DateFormat('h:mm a').format(parsed);
  }

  Future<void> _loadAvailableSlots(DateTime date) async {
    setState(() {
      _loadingSlots = true;
      _selectedSlot = null;
      _availableSlots = [];
    });

    final result = await context.read<BookingRepository>().getAvailableSlots(
      DateFormat('yyyy-MM-dd').format(date),
    );

    if (!mounted) return;

    result.when(
      onSuccess: (slots) => setState(() {
        _availableSlots = slots;
        _loadingSlots = false;
      }),
      onFailure: (_) => setState(() {
        _availableSlots = [];
        _loadingSlots = false;
      }),
    );
  }

  @override
  void initState() {
    super.initState();
    context.read<ServicesBloc>().add(const GetServicesEvent());
    final vehiclesState = context.read<MyVehiclesBloc>().state;
    if (vehiclesState.vehicles.isEmpty && !vehiclesState.isLoading) {
      context.read<MyVehiclesBloc>().add(const LoadVehicles());
    } else {
      for (final v in vehiclesState.vehicles) {
        if (v.isPrimary) {
          _selectedVehicle = v;
          break;
        }
      }
    }
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
    if (step < 0 || step > 3) return;
    setState(() => _currentStep = step);
    _pageController.animateToPage(
      step,
      duration: const Duration(milliseconds: 350),
      curve: Curves.easeOutCubic,
    );
    _fadeController.reset();
    _fadeController.forward();

    if (step == 2) {
      _resolvePrice();
    }
  }

  bool get _canProceed {
    switch (_currentStep) {
      case 0:
        return _selectedServiceIndex >= 0;
      case 1:
        return _selectedDate != null && _selectedSlot != null;
      default:
        return true;
    }
  }

  ServiceModel? get _currentSelectedService {
    if (_selectedServiceIndex < 0) return null;
    final state = context.read<ServicesBloc>().state;
    if (state is ServicesLoaded &&
        _selectedServiceIndex < state.services.length) {
      return state.services[_selectedServiceIndex];
    }
    return null;
  }

  Future<void> _resolvePrice() async {
    final service = _currentSelectedService;
    if (service == null) return;

    setState(() {
      _priceLoading = true;
      _resolvedPrice = null;
    });

    final result = await context.read<ServiceRepository>().getPrice(
      service.id,
      _selectedVehicle?.id,
    );

    if (!mounted) return;

    result.when(
      onSuccess: (price) => setState(() {
        _resolvedPrice = price;
        _priceLoading = false;
      }),
      onFailure: (_) => setState(() {
        // Fall back to the service's base list price if the price endpoint
        // fails — better to show an estimate than nothing.
        _resolvedPrice = service.price;
        _priceLoading = false;
      }),
    );
  }

  Future<void> _payWithStripe(BookingModel booking) async {
    setState(() => _isProcessingPayment = true);

    final result = await context
        .read<PaymentRepository>()
        .initiateStripePayment(booking.id);

    if (!mounted) return;

    await result.when(
      onSuccess: (intent) async {
        try {
          await stripe.Stripe.instance.initPaymentSheet(
            paymentSheetParameters: stripe.SetupPaymentSheetParameters(
              paymentIntentClientSecret: intent.clientSecret,
              merchantDisplayName: 'Farchis Automotive',
            ),
          );
          await stripe.Stripe.instance.presentPaymentSheet();

          if (!mounted) return;
          setState(() => _isProcessingPayment = false);
          _completeBooking(message: 'Payment successful! Booking confirmed 🎉');
        } on stripe.StripeException catch (e) {
          if (!mounted) return;
          setState(() => _isProcessingPayment = false);
          final cancelled = e.error.code == stripe.FailureCode.Canceled;
          if (!cancelled) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(e.error.localizedMessage ?? 'Payment failed'),
              ),
            );
          }
        } catch (e) {
          if (!mounted) return;
          setState(() => _isProcessingPayment = false);
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text('Payment failed: $e')));
        }
      },
      onFailure: (failure) async {
        if (!mounted) return;
        setState(() => _isProcessingPayment = false);
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(failure.message)));
      },
    );
  }

  void _payLater() {
    _completeBooking(
      message: 'Booking confirmed! Please settle payment at your appointment.',
    );
  }

  void _completeBooking({required String message}) {
    if (!mounted) return;
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(message)));
    context.read<BookingCreateBloc>().add(ResetBookingCreate());
    context.router.maybePop();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ThemeCubit, ThemeMode>(
      builder: (context, themeMode) {
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
                    _buildPaymentStep(theme, isDark),
                  ],
                ),
              ),

              // --- Bottom Navigation ---
              _buildBottomBar(theme, isDark),
            ],
          ),
        );
      },
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
                final isLoading =
                    state is ServicesLoading || state is ServicesInitial;
                if (state is ServicesLoadFailed) {
                  return const Center(child: Text('Failed to load services'));
                }

                final services = state is ServicesLoaded
                    ? state.services
                    : ServiceModel.placeholderList(6);

                return Skeletonizer(
                  enabled: isLoading,
                  effect: ShimmerEffect(
                    baseColor: const Color(0xFF253971).withValues(alpha: 0.08),
                    highlightColor: const Color(
                      0xFF253971,
                    ).withValues(alpha: 0.15),
                  ),
                  child: GridView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          crossAxisSpacing: AppDimensions.lg,
                          mainAxisSpacing: AppDimensions.lg,
                          childAspectRatio: 0.80,
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
                        onTap: () {
                          setState(() => _selectedServiceIndex = index);
                          context.read<BookingCreateBloc>().add(
                            SelectService(service),
                          );
                        },
                      );
                    },
                  ),
                );
              },
            ),
            const SizedBox(height: AppDimensions.xxl),
            Text(
              'Which vehicle?',
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w700,
                color: theme.colorScheme.onSurface,
              ),
            ),
            const SizedBox(height: AppDimensions.xs),
            Text(
              'Optional — helps us give you an accurate price',
              style: theme.textTheme.bodySmall?.copyWith(
                color: isDark
                    ? AppColors.darkTextSecondary
                    : AppColors.lightTextSecondary,
              ),
            ),
            const SizedBox(height: AppDimensions.md),
            BlocBuilder<MyVehiclesBloc, MyVehiclesState>(
              builder: (context, state) {
                if (state.vehicles.isEmpty) {
                  return Container(
                    padding: const EdgeInsets.all(AppDimensions.md),
                    decoration: BoxDecoration(
                      color: isDark
                          ? AppColors.navyDark
                          : AppColors.lightSurface,
                      borderRadius: BorderRadius.circular(
                        AppDimensions.radiusMd,
                      ),
                      border: Border.all(
                        color: isDark
                            ? AppColors.navyLight.withValues(alpha: 0.4)
                            : AppColors.lightBorder,
                      ),
                    ),
                    child: Text(
                      'No saved vehicles — add one from My Garage for faster bookings.',
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: isDark
                            ? AppColors.darkTextSecondary
                            : AppColors.lightTextSecondary,
                      ),
                    ),
                  );
                }

                return Wrap(
                  spacing: AppDimensions.sm,
                  runSpacing: AppDimensions.sm,
                  children: state.vehicles.map((vehicle) {
                    final isSelected = _selectedVehicle?.id == vehicle.id;
                    return GestureDetector(
                      onTap: () {
                        setState(() => _selectedVehicle = vehicle);
                        context.read<BookingCreateBloc>().add(
                          SelectVehicle(vehicle),
                        );
                      },
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
                              : (isDark
                                    ? AppColors.navyDark
                                    : AppColors.lightSurface),
                          borderRadius: BorderRadius.circular(
                            AppDimensions.radiusMd,
                          ),
                          border: Border.all(
                            color: isSelected
                                ? Colors.transparent
                                : theme.colorScheme.outline,
                          ),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.directions_car_rounded,
                              size: 16,
                              color: isSelected
                                  ? (isDark
                                        ? AppColors.darkOnPrimary
                                        : AppColors.lightOnPrimary)
                                  : theme.colorScheme.onSurface.withValues(
                                      alpha: 0.6,
                                    ),
                            ),
                            const SizedBox(width: AppDimensions.sm - 2),
                            Text(
                              vehicle.displayName,
                              style: theme.textTheme.labelMedium?.copyWith(
                                color: isSelected
                                    ? (isDark
                                          ? AppColors.darkOnPrimary
                                          : AppColors.lightOnPrimary)
                                    : theme.colorScheme.onSurface,
                                fontWeight: isSelected
                                    ? FontWeight.w700
                                    : FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  }).toList(),
                );
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
                  _loadAvailableSlots(date);
                }
              },
              child: Container(
                padding: const EdgeInsets.all(AppDimensions.lg),
                decoration: BoxDecoration(
                  color: isDark ? AppColors.navyDark : AppColors.lightSurface,
                  borderRadius: BorderRadius.circular(AppDimensions.radiusLg),
                  border: Border.all(
                    color: isDark
                        ? AppColors.navyLight.withValues(alpha: 0.4)
                        : AppColors.lightBorder,
                  ),
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.calendar_today_rounded,
                      color: theme.colorScheme.primary,
                    ),
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
            if (_selectedDate == null)
              Text(
                'Select a date to see available slots',
                style: theme.textTheme.bodySmall?.copyWith(
                  color: isDark
                      ? AppColors.darkTextSecondary
                      : AppColors.lightTextSecondary,
                ),
              )
            else if (_loadingSlots)
              const Center(child: CircularProgressIndicator())
            else if (_availableSlots.isEmpty)
              Text(
                'No slots available for this date',
                style: theme.textTheme.bodySmall?.copyWith(
                  color: isDark
                      ? AppColors.darkTextSecondary
                      : AppColors.lightTextSecondary,
                ),
              )
            else
              Wrap(
                spacing: AppDimensions.sm,
                runSpacing: AppDimensions.sm,
                children: _availableSlots.map((slot) {
                  final isSelected = _selectedSlot == slot;
                  return GestureDetector(
                    onTap: () {
                      setState(() => _selectedSlot = slot);
                      context.read<BookingCreateBloc>().add(
                        SelectDate(date: _selectedDate!, slot: slot),
                      );
                    },
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
                            : (isDark
                                  ? AppColors.navyDark
                                  : AppColors.lightSurface),
                        borderRadius: BorderRadius.circular(
                          AppDimensions.radiusMd,
                        ),
                        border: Border.all(
                          color: isSelected
                              ? Colors.transparent
                              : theme.colorScheme.outline,
                        ),
                      ),
                      child: Text(
                        _formatSlotLabel(slot),
                        style: theme.textTheme.labelMedium?.copyWith(
                          color: isSelected
                              ? (isDark
                                    ? AppColors.darkOnPrimary
                                    : AppColors.lightOnPrimary)
                              : theme.colorScheme.onSurface,
                          fontWeight: isSelected
                              ? FontWeight.w700
                              : FontWeight.w500,
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),
          ],
        ),
      ),
    );
  }

  // ======================== Step 3: Confirmation ========================
  Widget _buildConfirmStep(ThemeData theme, bool isDark) {
    final service = _selectedServiceIndex >= 0
        ? context.read<ServicesBloc>().state is ServicesLoaded
              ? (context.read<ServicesBloc>().state as ServicesLoaded)
                    .services[_selectedServiceIndex]
              : null
        : null;
    final date = _selectedDate != null
        ? '${_selectedDate!.day.toString().padLeft(2, '0')}/${_selectedDate!.month.toString().padLeft(2, '0')}/${_selectedDate!.year}'
        : 'Not selected';
    final time = _selectedSlot != null
        ? _formatSlotLabel(_selectedSlot!)
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
                borderRadius: BorderRadius.circular(AppDimensions.radiusLg),
                border: Border.all(
                  color: isDark
                      ? AppColors.navyLight.withValues(alpha: 0.4)
                      : AppColors.lightBorder,
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
                          color: isDark
                              ? FarchisColors.navy.withValues(alpha: 0.25)
                              : FarchisColors.light.withValues(alpha: 0.15),
                          borderRadius: BorderRadius.circular(
                            AppDimensions.radiusMd,
                          ),
                        ),
                        child: Icon(
                          _getServiceIcon(service.slug, service.category),
                          color: isDark
                              ? FarchisColors.light
                              : FarchisColors.navy,
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
                      value: _selectedVehicle != null
                          ? '${_selectedVehicle!.displayName}${_selectedVehicle!.plate != null ? ' • ${_selectedVehicle!.plate}' : ''}'
                          : 'Not selected',
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
                        if (_priceLoading)
                          const SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                        else
                          Text(
                            _resolvedPrice != null
                                ? _formatPrice(_resolvedPrice!)
                                : (service != null
                                      ? _formatPrice(service.price!)
                                      : '\$0'),
                            style: theme.textTheme.headlineMedium?.copyWith(
                              color: AppColors.tierGold,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: AppDimensions.xl),
            const FarchisInfoBanner(
              icon: Icons.access_time_rounded,
              message:
                  'Please arrive 20 minutes before your scheduled appointment time.',
            ),
          ],
        ),
      ),
    );
  }

  // ======================== Step 4: Payment ========================
  Widget _buildPaymentStep(ThemeData theme, bool isDark) {
    return FadeTransition(
      opacity: _fadeController,
      child: BlocBuilder<BookingCreateBloc, BookingCreateState>(
        builder: (context, state) {
          final booking = state is BookingSuccess ? state.booking : null;

          return SingleChildScrollView(
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
                  'How would you like to pay?',
                  style: theme.textTheme.headlineSmall?.copyWith(
                    color: theme.colorScheme.onSurface,
                  ),
                ),
                const SizedBox(height: AppDimensions.xs),
                Text(
                  booking != null
                      ? 'Booking #${booking.id} is confirmed — settle payment now or at your appointment.'
                      : 'Preparing your booking…',
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: isDark
                        ? AppColors.darkTextSecondary
                        : AppColors.lightTextSecondary,
                  ),
                ),
                const SizedBox(height: AppDimensions.xxl),
                if (booking == null)
                  const Center(child: CircularProgressIndicator())
                else ...[
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(AppDimensions.xxl),
                    decoration: BoxDecoration(
                      color: isDark
                          ? AppColors.navyDark
                          : AppColors.lightSurface,
                      borderRadius: BorderRadius.circular(
                        AppDimensions.radiusLg,
                      ),
                      border: Border.all(
                        color: isDark
                            ? AppColors.navyLight.withValues(alpha: 0.4)
                            : AppColors.lightBorder,
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Total Due',
                          style: theme.textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.w700,
                            color: theme.colorScheme.onSurface,
                          ),
                        ),
                        Text(
                          _resolvedPrice != null
                              ? _formatPrice(_resolvedPrice!)
                              : '\$0',
                          style: theme.textTheme.headlineMedium?.copyWith(
                            color: AppColors.tierGold,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: AppDimensions.xl),
                  FarchisButton(
                    label: 'Pay Now with Card',
                    size: ButtonSize.large,
                    width: double.infinity,
                    icon: const Icon(
                      Icons.credit_card_rounded,
                      size: 20,
                      color: Colors.white,
                    ),
                    isLoading: _isProcessingPayment,
                    onPressed: () => _payWithStripe(booking),
                  ),
                  const SizedBox(height: AppDimensions.md),
                  FarchisButton(
                    label: 'Pay Later at Appointment',
                    variant: ButtonVariant.secondary,
                    size: ButtonSize.large,
                    width: double.infinity,
                    isEnabled: !_isProcessingPayment,
                    onPressed: _payLater,
                  ),
                  const SizedBox(height: AppDimensions.xl),
                  const FarchisInfoBanner(
                    icon: Icons.access_time_rounded,
                    message:
                        'Please arrive 20 minutes before your scheduled appointment time.',
                  ),
                ],
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildBottomBar(ThemeData theme, bool isDark) {
    // Step 4 (Payment) owns its own action buttons within the scroll view.
    if (_currentStep == 3) return const SizedBox.shrink();

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
            color: isDark
                ? AppColors.navyLight.withValues(alpha: 0.3)
                : AppColors.lightBorder,
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
                ? BlocConsumer<BookingCreateBloc, BookingCreateState>(
                    listener: (context, state) {
                      if (state is BookingSuccess) {
                        _goToStep(3);
                      } else if (state is BookingFailure) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(state.failure.message),
                            backgroundColor: isDark
                                ? AppColors.darkError
                                : AppColors.lightError,
                          ),
                        );
                      }
                    },
                    builder: (context, state) {
                      final isSubmitting = state is BookingSubmitting;
                      return FarchisButton(
                        label: 'Confirm Booking',
                        size: ButtonSize.large,
                        width: double.infinity,
                        icon: const Icon(
                          Icons.check_circle_outline_rounded,
                          size: 20,
                          color: Colors.white,
                        ),
                        isEnabled: _canProceed,
                        isLoading: isSubmitting,
                        onPressed: () => context.read<BookingCreateBloc>().add(
                          SubmitBooking(),
                        ),
                      );
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

IconData _getServiceIcon(String slug, ServiceCategory category) {
  final normalizedSlug = slug.toLowerCase();

  if (normalizedSlug.contains('engine')) {
    return Icons.settings_suggest_rounded;
  } else if (normalizedSlug.contains('full-valet')) {
    return Icons.auto_awesome_rounded;
  } else if (normalizedSlug.contains('valet')) {
    return Icons.cleaning_services_rounded;
  } else if (normalizedSlug.contains('quick-wash') ||
      normalizedSlug.contains('wash')) {
    return Icons.water_drop_rounded;
  } else if (normalizedSlug.contains('polish')) {
    return Icons.auto_fix_high_rounded;
  } else if (normalizedSlug.contains('headlight')) {
    return Icons.light_mode_rounded;
  } else if (normalizedSlug.contains('interior')) {
    return Icons.cleaning_services_rounded;
  } else if (normalizedSlug.contains('paint') ||
      normalizedSlug.contains('spray')) {
    return Icons.format_paint_rounded;
  } else if (normalizedSlug.contains('coating') ||
      normalizedSlug.contains('ceramic')) {
    return Icons.shield_rounded;
  } else if (normalizedSlug.contains('window') ||
      normalizedSlug.contains('tint')) {
    return Icons.window_rounded;
  } else if (normalizedSlug.contains('scratch') ||
      normalizedSlug.contains('dent') ||
      normalizedSlug.contains('bodywork')) {
    return Icons.car_repair_rounded;
  }

  switch (category) {
    case ServiceCategory.mechanical:
      return Icons.settings_rounded;
    case ServiceCategory.repairs:
    case ServiceCategory.bodywork:
      return Icons.car_repair_rounded;
    case ServiceCategory.detailing:
      return Icons.cleaning_services_rounded;
    case ServiceCategory.paint:
      return Icons.format_paint_rounded;
    case ServiceCategory.wash:
      return Icons.local_car_wash_rounded;
    case ServiceCategory.accessories:
      return Icons.directions_car_rounded;
    case ServiceCategory.electrical:
      return Icons.electrical_services_rounded;
    default:
      return Icons.build_circle_outlined;
  }
}

String _truncateDescription(String text) {
  const int maxLength = 55;
  if (text.length <= maxLength) return text;

  final substring = text.substring(0, maxLength);
  final lastSpace = substring.lastIndexOf(' ');

  if (lastSpace == -1) {
    return '$substring...';
  }

  return '${substring.substring(0, lastSpace)}...';
}

String _formatPrice(double price) {
  if (price == price.toInt()) {
    return '\$${price.toInt()}';
  } else {
    return '\$${price.toStringAsFixed(2)}';
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
                ? (isDark ? AppColors.darkPrimary : AppColors.lightPrimary)
                : Colors.transparent,
            shape: BoxShape.circle,
            border: Border.all(
              color: isCompleted
                  ? (isDark ? AppColors.darkSuccess : AppColors.lightSuccess)
                  : isActive
                  ? (isDark ? AppColors.darkPrimary : AppColors.lightPrimary)
                  : theme.colorScheme.outline.withValues(alpha: 0.4),
              width: 2,
            ),
          ),
          child: Center(
            child: isCompleted
                ? Icon(
                    Icons.check_rounded,
                    size: 16,
                    color: isDark ? AppColors.darkOnPrimary : AppColors.white,
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
            color: widget.isDark ? AppColors.navyDark : AppColors.lightSurface,
            borderRadius: BorderRadius.circular(AppDimensions.radiusLg),
            border: Border.all(
              color: widget.isSelected
                  ? (widget.isDark ? FarchisColors.light : FarchisColors.navy)
                  : widget.isDark
                  ? AppColors.navyLight.withValues(alpha: 0.4)
                  : AppColors.lightBorder,
              width: widget.isSelected ? 2 : 1,
            ),
            boxShadow: widget.isSelected
                ? [
                    BoxShadow(
                      color:
                          (widget.isDark
                                  ? FarchisColors.light
                                  : FarchisColors.navy)
                              .withValues(alpha: 0.2),
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
                    color: widget.isDark
                        ? FarchisColors.navy.withValues(alpha: 0.25)
                        : FarchisColors.light.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
                  ),
                  child: Icon(
                    _getServiceIcon(
                      widget.service.slug,
                      widget.service.category,
                    ),
                    color: widget.isDark
                        ? FarchisColors.light
                        : FarchisColors.navy,
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
                  _truncateDescription(widget.service.description),
                  textAlign: TextAlign.center,
                  maxLines: 2,
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
                  'From ${widget.service.price != null ? _formatPrice(widget.service.price!) : '\$0'}',
                  style: widget.theme.textTheme.labelMedium?.copyWith(
                    color: AppColors.tierGold,
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
