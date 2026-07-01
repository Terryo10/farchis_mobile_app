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
      body: BlocConsumer<MyVehiclesBloc, MyVehiclesState>(
        listener: (context, state) {
          final failure = state.failure;
          if (failure != null) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(failure.message)),
            );
          }
        },
        builder: (context, state) {
          if (state.isLoading && state.vehicles.isEmpty) {
            return const Center(child: CircularProgressIndicator());
          }

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
                onSetPrimary: () => context
                    .read<MyVehiclesBloc>()
                    .add(SetPrimaryVehicle(vehicle.id)),
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
  final VoidCallback onSetPrimary;

  const _VehicleCard({
    required this.vehicle,
    required this.isDark,
    required this.onEdit,
    required this.onDelete,
    required this.onSetPrimary,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Dismissible(
      key: Key('vehicle_${vehicle.id}'),
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
                color: vehicle.isPrimary
                    ? (isDark ? AppColors.navyLight : AppColors.navyPrimary)
                    : theme.colorScheme.outline.withValues(alpha: 0.3),
                width: vehicle.isPrimary ? 1.5 : 1,
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
                      Row(
                        children: [
                          Flexible(
                            child: Text(
                              vehicle.displayName.isEmpty ? 'Vehicle' : vehicle.displayName,
                              style: theme.textTheme.titleMedium?.copyWith(
                                  fontWeight: FontWeight.w600),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          if (vehicle.isPrimary) ...[
                            const SizedBox(width: AppDimensions.sm),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                              decoration: BoxDecoration(
                                color: (isDark ? AppColors.navyLight : AppColors.navyPrimary)
                                    .withValues(alpha: 0.15),
                                borderRadius: BorderRadius.circular(AppDimensions.radiusCircle),
                              ),
                              child: Text(
                                'Primary',
                                style: theme.textTheme.labelSmall?.copyWith(
                                  color: isDark ? AppColors.navyLight : AppColors.navyPrimary,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ),
                          ],
                        ],
                      ),
                      const SizedBox(height: 2),
                      Text(
                        [
                          if ((vehicle.plate ?? '').isNotEmpty) vehicle.plate!,
                          if ((vehicle.color ?? '').isNotEmpty) vehicle.color!,
                          if (vehicle.vehicleSizeCategory != null) vehicle.vehicleSizeCategory!.name,
                        ].join(' · '),
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
                        ),
                      ),
                    ],
                  ),
                ),
                PopupMenuButton<String>(
                  icon: Icon(
                    Icons.more_vert_rounded,
                    color: theme.colorScheme.onSurface.withValues(alpha: 0.4),
                  ),
                  onSelected: (value) {
                    if (value == 'primary') onSetPrimary();
                    if (value == 'edit') onEdit();
                    if (value == 'delete') onDelete();
                  },
                  itemBuilder: (_) => [
                    if (!vehicle.isPrimary)
                      const PopupMenuItem(
                        value: 'primary',
                        child: ListTile(
                          leading: Icon(Icons.star_outline_rounded),
                          title: Text('Set as Primary'),
                          contentPadding: EdgeInsets.zero,
                          dense: true,
                        ),
                      ),
                    const PopupMenuItem(
                      value: 'edit',
                      child: ListTile(
                        leading: Icon(Icons.edit_outlined),
                        title: Text('Edit'),
                        contentPadding: EdgeInsets.zero,
                        dense: true,
                      ),
                    ),
                    const PopupMenuItem(
                      value: 'delete',
                      child: ListTile(
                        leading: Icon(Icons.delete_outline_rounded, color: AppColors.lightError),
                        title: Text('Remove', style: TextStyle(color: AppColors.lightError)),
                        contentPadding: EdgeInsets.zero,
                        dense: true,
                      ),
                    ),
                  ],
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
  final _plateController = TextEditingController();
  final _makeController = TextEditingController();
  final _modelController = TextEditingController();
  final _yearController = TextEditingController();
  final _colorController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  int? _sizeCategoryId;

  @override
  void initState() {
    super.initState();
    final v = widget.vehicle;
    if (v != null) {
      _plateController.text = v.plate ?? '';
      _makeController.text = v.make;
      _modelController.text = v.model;
      _yearController.text = v.year?.toString() ?? '';
      _colorController.text = v.color ?? '';
      _sizeCategoryId = v.vehicleSizeCategoryId;
    }
  }

  @override
  void dispose() {
    _plateController.dispose();
    _makeController.dispose();
    _modelController.dispose();
    _yearController.dispose();
    _colorController.dispose();
    super.dispose();
  }

  void _submit() {
    if (!(_formKey.currentState?.validate() ?? false)) return;

    final payload = <String, dynamic>{
      'make': _makeController.text.trim(),
      'model': _modelController.text.trim(),
      'year': _yearController.text.trim().isEmpty ? null : int.tryParse(_yearController.text.trim()),
      'plate': _plateController.text.trim().isEmpty ? null : _plateController.text.trim(),
      'color': _colorController.text.trim().isEmpty ? null : _colorController.text.trim(),
      'vehicle_size_category_id': _sizeCategoryId,
    };

    if (widget.vehicle == null) {
      context.read<MyVehiclesBloc>().add(AddVehicle(payload));
    } else {
      context.read<MyVehiclesBloc>().add(UpdateVehicle(widget.vehicle!.id, payload));
    }

    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isEdit = widget.vehicle != null;
    final sizeCategories = context.watch<MyVehiclesBloc>().state.sizeCategories;

    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
        left: AppDimensions.lg,
        right: AppDimensions.lg,
        top: AppDimensions.xl,
      ),
      child: Form(
        key: _formKey,
        child: SingleChildScrollView(
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
                controller: _yearController,
                label: 'Year',
                hint: 'e.g. 2020',
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: AppDimensions.md),
              _SheetField(
                controller: _plateController,
                label: 'Registration Number',
                hint: 'e.g. ABC 1234',
                textCapitalization: TextCapitalization.characters,
              ),
              const SizedBox(height: AppDimensions.md),
              _SheetField(
                controller: _colorController,
                label: 'Colour',
                hint: 'e.g. Silver',
                textCapitalization: TextCapitalization.words,
              ),
              const SizedBox(height: AppDimensions.md),
              DropdownButtonFormField<int>(
                initialValue: _sizeCategoryId,
                decoration: const InputDecoration(
                  labelText: 'Vehicle Size',
                  border: OutlineInputBorder(),
                  contentPadding: EdgeInsets.symmetric(
                    horizontal: AppDimensions.md,
                    vertical: AppDimensions.md,
                  ),
                ),
                hint: const Text('Select size category'),
                items: sizeCategories
                    .map((c) => DropdownMenuItem(value: c.id, child: Text(c.name)))
                    .toList(),
                onChanged: (value) => setState(() => _sizeCategoryId = value),
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
  final TextInputType? keyboardType;

  const _SheetField({
    required this.controller,
    required this.label,
    this.hint,
    this.validator,
    this.textCapitalization = TextCapitalization.none,
    this.keyboardType,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      textCapitalization: textCapitalization,
      keyboardType: keyboardType,
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
