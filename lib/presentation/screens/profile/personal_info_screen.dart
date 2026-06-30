import 'dart:io';

import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:skeletonizer/skeletonizer.dart';

import '../../../blocs/personal_info/personal_info_bloc.dart';
import '../../../blocs/personal_info/personal_info_event.dart';
import '../../../blocs/personal_info/personal_info_state.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_dimensions.dart';
import '../../../core/widgets/farchis_button.dart';
import '../../../core/widgets/farchis_text_field.dart';

@RoutePage()
class PersonalInfoScreen extends StatefulWidget {
  const PersonalInfoScreen({super.key});

  @override
  State<PersonalInfoScreen> createState() => _PersonalInfoScreenState();
}

class _PersonalInfoScreenState extends State<PersonalInfoScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  File? _selectedAvatar;
  bool _populated = false;

  @override
  void initState() {
    super.initState();
    context.read<PersonalInfoBloc>().add(const LoadPersonalInfo());
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  void _populateFromState(PersonalInfoState state) {
    if (_populated || state.user == null) return;
    _nameController.text = state.user!.name;
    _emailController.text = state.user!.email;
    _phoneController.text = state.user?.phone ?? '';
    _populated = true;
  }

  Future<void> _pickAvatar() async {
    final picker = ImagePicker();
    final picked = await picker.pickImage(source: ImageSource.gallery, imageQuality: 80);
    if (picked != null) setState(() => _selectedAvatar = File(picked.path));
  }

  void _save() {
    if (!(_formKey.currentState?.validate() ?? false)) return;
    context.read<PersonalInfoBloc>().add(
          SavePersonalInfo(
            name: _nameController.text.trim(),
            email: _emailController.text.trim(),
            phone: _phoneController.text.trim(),
            avatarFile: _selectedAvatar,
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
        title: const Text('Personal Info'),
        elevation: 0,
      ),
      body: BlocConsumer<PersonalInfoBloc, PersonalInfoState>(
        listener: (context, state) {
          _populateFromState(state);
          if (state.status == PersonalInfoStatus.saved) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Profile updated successfully')),
            );
          }
          if (state.status == PersonalInfoStatus.error) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.failure?.message ?? 'Update failed')),
            );
          }
        },
        builder: (context, state) {
          final loading = state.status == PersonalInfoStatus.loading ||
              state.status == PersonalInfoStatus.initial;
          final saving = state.status == PersonalInfoStatus.saving;

          return Skeletonizer(
            enabled: loading,
            effect: ShimmerEffect(
              baseColor: AppColors.navyLight.withValues(alpha: 0.3),
              highlightColor: AppColors.navyPrimary.withValues(alpha: 0.5),
            ),
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(AppDimensions.lg),
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    const SizedBox(height: AppDimensions.lg),

                    // Avatar
                    GestureDetector(
                      onTap: loading ? null : _pickAvatar,
                      child: Stack(
                        alignment: Alignment.bottomRight,
                        children: [
                          CircleAvatar(
                            radius: 50,
                            backgroundColor: AppColors.navyLight,
                            backgroundImage: _selectedAvatar != null
                                ? FileImage(_selectedAvatar!)
                                : (state.user?.fullAvatarUrl != null
                                    ? NetworkImage(state.user!.fullAvatarUrl!)
                                        as ImageProvider
                                    : null),
                            child: _selectedAvatar == null &&
                                    state.user?.fullAvatarUrl == null
                                ? const Icon(Icons.person_rounded,
                                    size: 50, color: AppColors.silverLight)
                                : null,
                          ),
                          Container(
                            padding: const EdgeInsets.all(6),
                            decoration: BoxDecoration(
                              color: isDark ? AppColors.navyLight : AppColors.navyPrimary,
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: theme.colorScheme.surface,
                                width: 2,
                              ),
                            ),
                            child: const Icon(Icons.camera_alt_rounded,
                                size: 16, color: AppColors.white),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: AppDimensions.xl),

                    // Full Name
                    FarchisTextField(
                      controller: _nameController,
                      label: 'Full Name',
                      prefixIcon: const Icon(Icons.person_outline_rounded),
                      validator: (v) =>
                          (v == null || v.trim().isEmpty) ? 'Name is required' : null,
                    ),

                    const SizedBox(height: AppDimensions.md),

                    // Email
                    FarchisTextField(
                      controller: _emailController,
                      label: 'Email Address',
                      prefixIcon: const Icon(Icons.email_outlined),
                      keyboardType: TextInputType.emailAddress,
                      validator: (v) {
                        if (v == null || v.trim().isEmpty) return 'Email is required';
                        if (!v.contains('@')) return 'Enter a valid email';
                        return null;
                      },
                    ),

                    const SizedBox(height: AppDimensions.md),

                    // Phone
                    FarchisTextField(
                      controller: _phoneController,
                      label: 'Phone Number',
                      prefixIcon: const Icon(Icons.phone_outlined),
                      keyboardType: TextInputType.phone,
                    ),

                    const SizedBox(height: AppDimensions.xxxl),

                    // Save button
                    SizedBox(
                      width: double.infinity,
                      child: FarchisButton(
                        label: 'Save Changes',
                        isLoading: saving,
                        isEnabled: !loading,
                        onPressed: _save,
                      ),
                    ),

                    const SizedBox(height: AppDimensions.xl),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
