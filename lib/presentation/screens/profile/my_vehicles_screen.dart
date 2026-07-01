import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../blocs/my_vehicles/my_vehicles_bloc.dart';
import '../../../blocs/my_vehicles/my_vehicles_event.dart';
import '../../../blocs/my_vehicles/my_vehicles_state.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_dimensions.dart';
import '../../../data/models/vehicle_model.dart';

@RoutePage()
class MyVehiclesScreen extends StatefulWidget {
  const MyVehiclesScreen({super.key});

  @override
  State<MyVehiclesScreen> createState() => _MyVehiclesScreenState();
}

class _MyVehiclesScreenState extends State<MyVehiclesScreen> {
  @override
  void initState() {
    super.initState();
    context.read<MyVehiclesBloc>().add(const LoadVehicles());
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: theme.colorScheme.surface,
      appBar: AppBar(
        backgroundColor: isDark ? AppColors.navyDark : AppColors.navyPrimary,
        foregroundColor: AppColors.white,
        title: const Text('My Vehicles'),
        elevation: 0,
      ),
      body: BlocBuilder<MyVehiclesBloc, MyVehiclesState>(
        builder: (context, state) {
          if (state.vehicles.isEmpty) {
            return _buildEmptyState(context, theme, isDark);
          }

          return ListView.separated(
            padding: const EdgeInsets.all(AppDimensions.lg),
            itemCount: state.vehicles.length,
            separatorBuilder: (_, _) => const SizedBox(height: AppDimensions.md),
            itemBuilder: (context, index) {
              final vehicle = state.vehicles[index];
              return _VehicleCard(
                vehicle: vehicle,
                isDark: isDark,
                onEdit: () => _showVehicleSheet(context, vehicle: vehicle),
                onDelete: () => context
                    .read<MyVehiclesBloc>()
                    .add(DeleteVehicle(vehicle.id)),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: isDark ? AppColors.navyLight : AppColors.navyPrimary,
        foregroundColor: AppColors.white,
        onPressed: () => _showVehicleSheet(context),
        icon: const Icon(Icons.add_rounded),
        label: const Text('Add Vehicle'),
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context, ThemeData theme, bool isDark) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppDimensions.xxxl),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(AppDimensions.xxl),
              decoration: BoxDecoration(
                color: (isDark ? AppColors.navyLight : AppColors.navyPrimary)
                    .withValues(alpha: 0.08),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.directions_car_outlined,
                size: 56,
                color: isDark ? AppColors.navyLight : AppColors.navyPrimary,
              ),
            ),
            const SizedBox(height: AppDimensions.xxl),
            Text(
              'No vehicles yet',
              style: theme.textTheme.titleLarge?.copyWith(
                color: theme.colorScheme.onSurface,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: AppDimensions.sm),
            Text(
              'Add one to speed up your next booking —\nyour details will be pre-filled automatically.',
              textAlign: TextAlign.center,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showVehicleSheet(BuildContext context, {VehicleModel? vehicle}) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Theme.of(context).colorScheme.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(AppDimensions.bottomSheetRadius),
        ),
      ),
      builder: (_) => BlocProvider.value(
        value: context.read<MyVehiclesBloc>(),
        child: _VehicleFormSheet(vehicle: vehicle),
      ),
    );
  }
}

// ─── Vehicle Card ────────────────────────────────────────────────────────────

class _VehicleCard extends StatelessWidget {
  final VehicleModel vehicle;
  final bool isDark;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const _VehicleCard({
    required this.vehicle,
    required this.isDark,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Dismissible(
      key: Key(vehicle.id),
      direction: DismissDirection.endToStart,
      background: Container(
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: AppDimensions.xl),
        decoration: BoxDecoration(
          color: AppColors.lightError,
          borderRadius: BorderRadius.circular(AppDimensions.radiusLg),
        ),
        child: const Icon(Icons.delete_rounded, color: AppColors.white, size: 28),
      ),
      confirmDismiss: (_) async {
        return await showDialog<bool>(
          context: context,
          builder: (ctx) => AlertDialog(
            title: const Text('Remove Vehicle'),
            content: Text('Remove ${vehicle.make} ${vehicle.model}?'),
            actions: [
              TextButton(
                  onPressed: () => Navigator.pop(ctx, false),
                  child: const Text('Cancel')),
              TextButton(
                  onPressed: () => Navigator.pop(ctx, true),
                  child: const Text('Remove',
                      style: TextStyle(color: AppColors.lightError))),
            ],
          ),
        );
      },
      onDismissed: (_) => onDelete(),
      child: Material(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(AppDimensions.radiusLg),
        child: InkWell(
          onTap: onEdit,
          borderRadius: BorderRadius.circular(AppDimensions.radiusLg),
          child: Container(
            padding: const EdgeInsets.all(AppDimensions.lg),
            decoration: BoxDecoration(
              border: Border.all(
                color: theme.colorScheme.outline.withValues(alpha: 0.3),
              ),
              borderRadius: BorderRadius.circular(AppDimensions.radiusLg),
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(AppDimensions.md),
                  decoration: BoxDecoration(
                    color: (isDark ? AppColors.navyLight : AppColors.navyPrimary)
                        .withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(AppDimensions.radiusSm),
                  ),
                  child: Icon(
                    Icons.directions_car_rounded,
                    color: isDark ? AppColors.navyLight : AppColors.navyPrimary,
                    size: AppDimensions.iconMd,
                  ),
                ),
                const SizedBox(width: AppDimensions.md),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '${vehicle.make} ${vehicle.model}'.trim().isEmpty
                            ? 'Vehicle'
                            : '${vehicle.make} ${vehicle.model}',
                        style: theme.textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.w600),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        [
                          if (vehicle.regNumber.isNotEmpty) vehicle.regNumber,
                          if (vehicle.color.isNotEmpty) vehicle.color,
                        ].join(' · '),
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
                        ),
                      ),
                    ],
                  ),
                ),
                Icon(
                  Icons.chevron_right_rounded,
                  color: theme.colorScheme.onSurface.withValues(alpha: 0.3),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// ─── Vehicle Form Sheet ───────────────────────────────────────────────────────

class _VehicleFormSheet extends StatefulWidget {
  final VehicleModel? vehicle; // null = add mode

  const _VehicleFormSheet({this.vehicle});

  @override
  State<_VehicleFormSheet> createState() => _VehicleFormSheetState();
}

class _VehicleFormSheetState extends State<_VehicleFormSheet> {
  final _regController = TextEditingController();
  final _makeController = TextEditingController();
  final _modelController = TextEditingController();
  final _colorController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    final v = widget.vehicle;
    if (v != null) {
      _regController.text = v.regNumber;
      _makeController.text = v.make;
      _modelController.text = v.model;
      _colorController.text = v.color;
    }
  }

  @override
  void dispose() {
    _regController.dispose();
    _makeController.dispose();
    _modelController.dispose();
    _colorController.dispose();
    super.dispose();
  }

  void _submit() {
    if (!(_formKey.currentState?.validate() ?? false)) return;

    final vehicle = VehicleModel(
      id: widget.vehicle?.id ??
          DateTime.now().millisecondsSinceEpoch.toString(),
      regNumber: _regController.text.trim(),
      make: _makeController.text.trim(),
      model: _modelController.text.trim(),
      color: _colorController.text.trim(),
    );

    if (widget.vehicle == null) {
      context.read<MyVehiclesBloc>().add(AddVehicle(vehicle));
    } else {
      context.read<MyVehiclesBloc>().add(UpdateVehicle(vehicle));
    }

    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isEdit = widget.vehicle != null;

    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
        left: AppDimensions.lg,
        right: AppDimensions.lg,
        top: AppDimensions.xl,
      ),
      child: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Handle
            Center(
              child: Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: theme.colorScheme.outline.withValues(alpha: 0.3),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            const SizedBox(height: AppDimensions.lg),
            Text(
              isEdit ? 'Edit Vehicle' : 'Add Vehicle',
              style: theme.textTheme.titleLarge
                  ?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: AppDimensions.lg),
            _SheetField(
              controller: _regController,
              label: 'Registration Number',
              hint: 'e.g. ABC 1234',
              textCapitalization: TextCapitalization.characters,
              validator: (v) =>
                  (v == null || v.trim().isEmpty) ? 'Reg number required' : null,
            ),
            const SizedBox(height: AppDimensions.md),
            _SheetField(
              controller: _makeController,
              label: 'Make',
              hint: 'e.g. Toyota',
              textCapitalization: TextCapitalization.words,
              validator: (v) =>
                  (v == null || v.trim().isEmpty) ? 'Make is required' : null,
            ),
            const SizedBox(height: AppDimensions.md),
            _SheetField(
              controller: _modelController,
              label: 'Model',
              hint: 'e.g. Corolla',
              textCapitalization: TextCapitalization.words,
              validator: (v) =>
                  (v == null || v.trim().isEmpty) ? 'Model is required' : null,
            ),
            const SizedBox(height: AppDimensions.md),
            _SheetField(
              controller: _colorController,
              label: 'Colour',
              hint: 'e.g. Silver',
              textCapitalization: TextCapitalization.words,
            ),
            const SizedBox(height: AppDimensions.xl),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _submit,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.navyPrimary,
                  foregroundColor: AppColors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius:
                        BorderRadius.circular(AppDimensions.radiusMd),
                  ),
                ),
                child: Text(
                  isEdit ? 'Save Changes' : 'Add Vehicle',
                  style: const TextStyle(
                      fontWeight: FontWeight.w600, fontSize: 16),
                ),
              ),
            ),
            const SizedBox(height: AppDimensions.xl),
          ],
        ),
      ),
    );
  }
}

class _SheetField extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final String? hint;
  final String? Function(String?)? validator;
  final TextCapitalization textCapitalization;

  const _SheetField({
    required this.controller,
    required this.label,
    this.hint,
    this.validator,
    this.textCapitalization = TextCapitalization.none,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      textCapitalization: textCapitalization,
      validator: validator,
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        border: const OutlineInputBorder(),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: AppDimensions.md,
          vertical: AppDimensions.md,
        ),
      ),
    );
  }
}
