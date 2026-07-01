import 'dart:io';

import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';

import '../../../blocs/inspection_request/inspection_request_bloc.dart';
import '../../../blocs/inspection_request/inspection_request_event.dart';
import '../../../blocs/inspection_request/inspection_request_state.dart';
import '../../../blocs/my_vehicles/my_vehicles_bloc.dart';
import '../../../blocs/my_vehicles/my_vehicles_event.dart';
import '../../../blocs/my_vehicles/my_vehicles_state.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_dimensions.dart';
import '../../../core/widgets/farchis_button.dart';
import '../../../core/widgets/farchis_text_field.dart';
import '../../../data/models/vehicle_model.dart';

/// Server-side inspection mode identifiers — must match the backend's
/// `@JsonValue`-mapped `InspectionMode` enum values exactly.
const String _kOnSite = 'on_site';
const String _kInShop = 'in_shop';

@RoutePage()
class InspectionRequestFormScreen extends StatefulWidget {
  const InspectionRequestFormScreen({super.key});

  @override
  State<InspectionRequestFormScreen> createState() =>
      _InspectionRequestFormScreenState();
}

class _InspectionRequestFormScreenState
    extends State<InspectionRequestFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final _addressController = TextEditingController();
  final _descriptionController = TextEditingController();

  VehicleModel? _selectedVehicle;
  String _mode = _kOnSite;
  DateTime? _preferredDate;
  TimeOfDay? _preferredTime;
  final List<File> _photos = [];

  @override
  void initState() {
    super.initState();
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
  }

  @override
  void dispose() {
    _addressController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  Future<void> _pickPhotos() async {
    final picker = ImagePicker();
    final picked = await picker.pickMultiImage(imageQuality: 80);
    if (picked.isEmpty) return;
    setState(() {
      _photos.addAll(picked.map((x) => File(x.path)));
    });
  }

  void _removePhoto(int index) {
    setState(() => _photos.removeAt(index));
  }

  Future<void> _pickDate() async {
    final date = await showDatePicker(
      context: context,
      initialDate: _preferredDate ?? DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );
    if (date != null) setState(() => _preferredDate = date);
  }

  Future<void> _pickTime() async {
    final time = await showTimePicker(
      context: context,
      initialTime: _preferredTime ?? TimeOfDay.now(),
    );
    if (time != null) setState(() => _preferredTime = time);
  }

  void _submit() {
    if (!(_formKey.currentState?.validate() ?? false)) return;
    if (_selectedVehicle == null) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Please select a vehicle')));
      return;
    }
    if (_preferredDate == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please choose a preferred date')),
      );
      return;
    }
    if (_mode == _kOnSite && _addressController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please provide an address for the on-site inspection'),
        ),
      );
      return;
    }

    context.read<InspectionRequestBloc>().add(
      CreateInspectionRequest(
        vehicleId: _selectedVehicle!.id,
        inspectionMode: _mode,
        address: _mode == _kOnSite ? _addressController.text.trim() : null,
        preferredDate: DateFormat('yyyy-MM-dd').format(_preferredDate!),
        preferredTime: _preferredTime != null
            ? '${_preferredTime!.hour.toString().padLeft(2, '0')}:${_preferredTime!.minute.toString().padLeft(2, '0')}'
            : null,
        description: _descriptionController.text.trim(),
        photoPaths: _photos.map((f) => f.path).toList(),
      ),
    );
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
        title: const Text('Request an Inspection'),
        elevation: 0,
      ),
      body: BlocConsumer<InspectionRequestBloc, InspectionRequestState>(
        listener: (context, state) {
          final failure = state.failure;
          if (failure != null) {
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(SnackBar(content: Text(failure.message)));
          }
          if (state.createSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Inspection request submitted')),
            );
            context.router.maybePop();
          }
        },
        builder: (context, state) {
          return Form(
            key: _formKey,
            child: ListView(
              padding: const EdgeInsets.all(AppDimensions.lg),
              children: [
                Text(
                  'Vehicle',
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: AppDimensions.sm),
                BlocBuilder<MyVehiclesBloc, MyVehiclesState>(
                  builder: (context, vehiclesState) {
                    if (vehiclesState.vehicles.isEmpty) {
                      return Text(
                        'No saved vehicles — add one from My Garage first.',
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: isDark
                              ? AppColors.darkTextSecondary
                              : AppColors.lightTextSecondary,
                        ),
                      );
                    }
                    return Wrap(
                      spacing: AppDimensions.sm,
                      runSpacing: AppDimensions.sm,
                      children: vehiclesState.vehicles.map((vehicle) {
                        final isSelected = _selectedVehicle?.id == vehicle.id;
                        return ChoiceChip(
                          label: Text(vehicle.displayName),
                          selected: isSelected,
                          onSelected: (_) =>
                              setState(() => _selectedVehicle = vehicle),
                        );
                      }).toList(),
                    );
                  },
                ),
                const SizedBox(height: AppDimensions.xl),
                Text(
                  'Inspection Location',
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: AppDimensions.sm),
                Row(
                  children: [
                    Expanded(
                      child: ChoiceChip(
                        label: const Text('At my location'),
                        selected: _mode == _kOnSite,
                        onSelected: (_) => setState(() => _mode = _kOnSite),
                      ),
                    ),
                    const SizedBox(width: AppDimensions.sm),
                    Expanded(
                      child: ChoiceChip(
                        label: const Text('At the shop'),
                        selected: _mode == _kInShop,
                        onSelected: (_) => setState(() => _mode = _kInShop),
                      ),
                    ),
                  ],
                ),
                if (_mode == _kOnSite) ...[
                  const SizedBox(height: AppDimensions.md),
                  FarchisTextField(
                    label: 'Address',
                    hint: 'Where should we come to inspect your vehicle?',
                    controller: _addressController,
                    maxLines: 2,
                    minLines: 1,
                  ),
                ],
                const SizedBox(height: AppDimensions.xl),
                Text(
                  'Preferred Date & Time',
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: AppDimensions.sm),
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed: _pickDate,
                        icon: const Icon(
                          Icons.calendar_today_rounded,
                          size: 18,
                        ),
                        label: Text(
                          _preferredDate == null
                              ? 'Select date'
                              : DateFormat(
                                  'dd/MM/yyyy',
                                ).format(_preferredDate!),
                        ),
                      ),
                    ),
                    const SizedBox(width: AppDimensions.sm),
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed: _pickTime,
                        icon: const Icon(Icons.schedule_rounded, size: 18),
                        label: Text(
                          _preferredTime == null
                              ? 'Select time'
                              : _preferredTime!.format(context),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: AppDimensions.xl),
                Text(
                  'Description',
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: AppDimensions.sm),
                FarchisTextField(
                  hint: 'Describe the damage or issue in detail',
                  controller: _descriptionController,
                  maxLines: 4,
                  minLines: 3,
                  validator: (v) => (v == null || v.trim().isEmpty)
                      ? 'Description is required'
                      : null,
                ),
                const SizedBox(height: AppDimensions.xl),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Photos',
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    TextButton.icon(
                      onPressed: _pickPhotos,
                      icon: const Icon(Icons.add_a_photo_outlined, size: 18),
                      label: const Text('Add'),
                    ),
                  ],
                ),
                if (_photos.isNotEmpty)
                  SizedBox(
                    height: 88,
                    child: ListView.separated(
                      scrollDirection: Axis.horizontal,
                      itemCount: _photos.length,
                      separatorBuilder: (_, _) =>
                          const SizedBox(width: AppDimensions.sm),
                      itemBuilder: (context, index) {
                        return Stack(
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(
                                AppDimensions.radiusMd,
                              ),
                              child: Image.file(
                                _photos[index],
                                width: 88,
                                height: 88,
                                fit: BoxFit.cover,
                              ),
                            ),
                            Positioned(
                              right: 2,
                              top: 2,
                              child: GestureDetector(
                                onTap: () => _removePhoto(index),
                                child: const CircleAvatar(
                                  radius: 11,
                                  backgroundColor: Colors.black54,
                                  child: Icon(
                                    Icons.close_rounded,
                                    size: 14,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        );
                      },
                    ),
                  ),
                const SizedBox(height: AppDimensions.xxl),
                FarchisButton(
                  label: 'Submit Request',
                  size: ButtonSize.large,
                  width: double.infinity,
                  isLoading: state.isSubmitting,
                  onPressed: _submit,
                ),
                const SizedBox(height: AppDimensions.xl),
              ],
            ),
          );
        },
      ),
    );
  }
}
