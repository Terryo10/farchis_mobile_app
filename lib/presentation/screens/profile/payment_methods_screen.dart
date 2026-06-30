import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:skeletonizer/skeletonizer.dart';

import '../../../blocs/payment_methods/payment_methods_bloc.dart';
import '../../../blocs/payment_methods/payment_methods_event.dart';
import '../../../blocs/payment_methods/payment_methods_state.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_dimensions.dart';
import '../../../data/models/payment_method_model.dart';

@RoutePage()
class PaymentMethodsScreen extends StatefulWidget {
  const PaymentMethodsScreen({super.key});

  @override
  State<PaymentMethodsScreen> createState() => _PaymentMethodsScreenState();
}

class _PaymentMethodsScreenState extends State<PaymentMethodsScreen> {
  @override
  void initState() {
    super.initState();
    context.read<PaymentMethodsBloc>().add(const LoadPaymentMethods());
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
        title: const Text('Payment Methods'),
        elevation: 0,
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── Stub notice banner ────────────────────────────────────────────
          // STUB: Remove this banner when the real payment provider is wired.
          // See lib/data/providers/local_payment_provider.dart for swap guide.
          Container(
            width: double.infinity,
            margin: const EdgeInsets.all(AppDimensions.lg),
            padding: const EdgeInsets.symmetric(
              horizontal: AppDimensions.md,
              vertical: AppDimensions.sm,
            ),
            decoration: BoxDecoration(
              color: (isDark ? AppColors.navyLight : AppColors.navyPrimary)
                  .withValues(alpha: 0.08),
              borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
              border: Border.all(
                color: (isDark ? AppColors.navyLight : AppColors.navyPrimary)
                    .withValues(alpha: 0.25),
              ),
            ),
            child: Row(
              children: [
                Icon(
                  Icons.info_outline_rounded,
                  size: AppDimensions.iconSm,
                  color: isDark ? AppColors.navyLight : AppColors.navyPrimary,
                ),
                const SizedBox(width: AppDimensions.sm),
                Expanded(
                  child: Text(
                    'Payment integration coming soon — saved methods are stored locally.',
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: isDark ? AppColors.navyLight : AppColors.navyPrimary,
                    ),
                  ),
                ),
              ],
            ),
          ),

          // ── Methods list ──────────────────────────────────────────────────
          Expanded(
            child: BlocBuilder<PaymentMethodsBloc, PaymentMethodsState>(
              builder: (context, state) {
                if (state.isLoading) {
                  return Skeletonizer(
                    enabled: true,
                    effect: ShimmerEffect(
                      baseColor: AppColors.navyLight.withValues(alpha: 0.3),
                      highlightColor:
                          AppColors.navyPrimary.withValues(alpha: 0.5),
                    ),
                    child: _buildSkeletonList(),
                  );
                }

                if (state.methods.isEmpty) {
                  return _buildEmptyState(context, theme, isDark);
                }

                return ListView.separated(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppDimensions.lg,
                  ),
                  itemCount: state.methods.length,
                  separatorBuilder: (_, __) =>
                      const SizedBox(height: AppDimensions.md),
                  itemBuilder: (context, index) {
                    final method = state.methods[index];
                    return _PaymentMethodCard(
                      method: method,
                      isDark: isDark,
                      onSetDefault: () => context
                          .read<PaymentMethodsBloc>()
                          .add(SetDefaultPaymentMethod(method.id)),
                      onDelete: () => context
                          .read<PaymentMethodsBloc>()
                          .add(RemovePaymentMethod(method.id)),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: isDark ? AppColors.navyLight : AppColors.navyPrimary,
        foregroundColor: AppColors.white,
        onPressed: () => _showAddMethodSheet(context),
        icon: const Icon(Icons.add_rounded),
        label: const Text('Add Method'),
      ),
    );
  }

  Widget _buildSkeletonList() {
    return ListView.separated(
      padding: const EdgeInsets.symmetric(horizontal: AppDimensions.lg),
      itemCount: 3,
      separatorBuilder: (_, __) => const SizedBox(height: AppDimensions.md),
      itemBuilder: (_, __) => Container(
        height: 72,
        decoration: BoxDecoration(
          color: AppColors.navyLight.withValues(alpha: 0.2),
          borderRadius: BorderRadius.circular(AppDimensions.radiusLg),
        ),
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
                Icons.payment_rounded,
                size: 56,
                color: isDark ? AppColors.navyLight : AppColors.navyPrimary,
              ),
            ),
            const SizedBox(height: AppDimensions.xxl),
            Text(
              'No payment methods',
              style: theme.textTheme.titleLarge
                  ?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: AppDimensions.sm),
            Text(
              'Add a card or EcoCash number to pay for bookings quickly.',
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

  void _showAddMethodSheet(BuildContext context) {
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
        value: context.read<PaymentMethodsBloc>(),
        child: const _AddMethodSheet(),
      ),
    );
  }
}

// ─── Payment Method Card ──────────────────────────────────────────────────────

class _PaymentMethodCard extends StatelessWidget {
  final PaymentMethodModel method;
  final bool isDark;
  final VoidCallback onSetDefault;
  final VoidCallback onDelete;

  const _PaymentMethodCard({
    required this.method,
    required this.isDark,
    required this.onSetDefault,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isCard = method.type == PaymentMethodType.card;

    return Container(
      padding: const EdgeInsets.all(AppDimensions.md),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(AppDimensions.radiusLg),
        border: Border.all(
          color: method.isDefault
              ? (isDark ? AppColors.navyLight : AppColors.navyPrimary)
                  .withValues(alpha: 0.5)
              : theme.colorScheme.outline.withValues(alpha: 0.3),
          width: method.isDefault ? 1.5 : 1,
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.black.withValues(alpha: 0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          // Icon
          Container(
            padding: const EdgeInsets.all(AppDimensions.sm),
            decoration: BoxDecoration(
              color: (isDark ? AppColors.navyLight : AppColors.navyPrimary)
                  .withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(AppDimensions.radiusSm),
            ),
            child: Icon(
              isCard ? Icons.credit_card_rounded : Icons.phone_android_rounded,
              size: AppDimensions.iconMd,
              color: isDark ? AppColors.navyLight : AppColors.navyPrimary,
            ),
          ),
          const SizedBox(width: AppDimensions.md),

          // Label + default badge
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  method.displayLabel,
                  style: theme.textTheme.titleSmall
                      ?.copyWith(fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 2),
                Row(
                  children: [
                    Text(
                      isCard ? 'Credit / Debit Card' : 'EcoCash',
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: theme.colorScheme.onSurface.withValues(alpha: 0.5),
                      ),
                    ),
                    if (method.isDefault) ...[
                      const SizedBox(width: AppDimensions.sm),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 6,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          color: (isDark
                                  ? AppColors.navyLight
                                  : AppColors.navyPrimary)
                              .withValues(alpha: 0.15),
                          borderRadius:
                              BorderRadius.circular(AppDimensions.radiusCircle),
                        ),
                        child: Text(
                          'Default',
                          style: theme.textTheme.labelSmall?.copyWith(
                            color: isDark
                                ? AppColors.navyLight
                                : AppColors.navyPrimary,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
              ],
            ),
          ),

          // Actions
          PopupMenuButton<String>(
            icon: Icon(
              Icons.more_vert_rounded,
              color: theme.colorScheme.onSurface.withValues(alpha: 0.4),
            ),
            onSelected: (value) {
              if (value == 'default') onSetDefault();
              if (value == 'delete') onDelete();
            },
            itemBuilder: (_) => [
              if (!method.isDefault)
                const PopupMenuItem(
                  value: 'default',
                  child: ListTile(
                    leading: Icon(Icons.star_outline_rounded),
                    title: Text('Set as Default'),
                    contentPadding: EdgeInsets.zero,
                    dense: true,
                  ),
                ),
              const PopupMenuItem(
                value: 'delete',
                child: ListTile(
                  leading: Icon(Icons.delete_outline_rounded,
                      color: AppColors.lightError),
                  title: Text('Remove',
                      style: TextStyle(color: AppColors.lightError)),
                  contentPadding: EdgeInsets.zero,
                  dense: true,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// ─── Add Method Sheet ─────────────────────────────────────────────────────────

class _AddMethodSheet extends StatefulWidget {
  const _AddMethodSheet();

  @override
  State<_AddMethodSheet> createState() => _AddMethodSheetState();
}

class _AddMethodSheetState extends State<_AddMethodSheet> {
  PaymentMethodType _selectedType = PaymentMethodType.card;
  final _field1Controller = TextEditingController(); // card number / phone
  final _field2Controller = TextEditingController(); // cardholder name / (unused for ecocash)
  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _field1Controller.dispose();
    _field2Controller.dispose();
    super.dispose();
  }

  void _submit() {
    if (!(_formKey.currentState?.validate() ?? false)) return;

    final String label;
    if (_selectedType == PaymentMethodType.card) {
      final raw = _field1Controller.text.replaceAll(RegExp(r'\s'), '');
      final masked = raw.length >= 4
          ? '**** **** **** ${raw.substring(raw.length - 4)}'
          : raw;
      label = masked;
    } else {
      label = _field1Controller.text.trim();
    }

    final method = PaymentMethodModel(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      type: _selectedType,
      displayLabel: label,
    );

    context.read<PaymentMethodsBloc>().add(AddPaymentMethod(method));
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isCard = _selectedType == PaymentMethodType.card;

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
            Text('Add Payment Method',
                style: theme.textTheme.titleLarge
                    ?.copyWith(fontWeight: FontWeight.bold)),
            const SizedBox(height: AppDimensions.lg),

            // Type selector
            Row(
              children: [
                _TypeChip(
                  label: 'Card',
                  icon: Icons.credit_card_rounded,
                  selected: isCard,
                  onTap: () =>
                      setState(() => _selectedType = PaymentMethodType.card),
                ),
                const SizedBox(width: AppDimensions.md),
                _TypeChip(
                  label: 'EcoCash',
                  icon: Icons.phone_android_rounded,
                  selected: !isCard,
                  onTap: () =>
                      setState(() => _selectedType = PaymentMethodType.ecocash),
                ),
              ],
            ),
            const SizedBox(height: AppDimensions.lg),

            // Fields
            TextFormField(
              controller: _field1Controller,
              keyboardType: isCard
                  ? TextInputType.number
                  : TextInputType.phone,
              decoration: InputDecoration(
                labelText: isCard ? 'Card Number' : 'EcoCash Number',
                hintText: isCard ? '1234 5678 9012 3456' : '+263 77 123 4567',
                border: const OutlineInputBorder(),
              ),
              validator: (v) =>
                  (v == null || v.trim().isEmpty) ? 'This field is required' : null,
            ),

            if (isCard) ...[
              const SizedBox(height: AppDimensions.md),
              TextFormField(
                controller: _field2Controller,
                textCapitalization: TextCapitalization.words,
                decoration: const InputDecoration(
                  labelText: 'Cardholder Name',
                  border: OutlineInputBorder(),
                ),
                validator: (v) =>
                    (v == null || v.trim().isEmpty) ? 'Name is required' : null,
              ),
            ],

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
                child: const Text('Save',
                    style: TextStyle(
                        fontWeight: FontWeight.w600, fontSize: 16)),
              ),
            ),
            const SizedBox(height: AppDimensions.xl),
          ],
        ),
      ),
    );
  }
}

class _TypeChip extends StatelessWidget {
  final String label;
  final IconData icon;
  final bool selected;
  final VoidCallback onTap;

  const _TypeChip({
    required this.label,
    required this.icon,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(
          horizontal: AppDimensions.md,
          vertical: AppDimensions.sm,
        ),
        decoration: BoxDecoration(
          color: selected
              ? (isDark ? AppColors.navyLight : AppColors.navyPrimary)
                  .withValues(alpha: 0.12)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
          border: Border.all(
            color: selected
                ? (isDark ? AppColors.navyLight : AppColors.navyPrimary)
                : theme.colorScheme.outline.withValues(alpha: 0.4),
            width: selected ? 1.5 : 1,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              size: AppDimensions.iconSm,
              color: selected
                  ? (isDark ? AppColors.navyLight : AppColors.navyPrimary)
                  : theme.colorScheme.onSurface.withValues(alpha: 0.5),
            ),
            const SizedBox(width: AppDimensions.xs),
            Text(
              label,
              style: theme.textTheme.labelMedium?.copyWith(
                color: selected
                    ? (isDark ? AppColors.navyLight : AppColors.navyPrimary)
                    : theme.colorScheme.onSurface.withValues(alpha: 0.6),
                fontWeight: selected ? FontWeight.w700 : FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
