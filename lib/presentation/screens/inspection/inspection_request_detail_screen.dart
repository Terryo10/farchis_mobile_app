import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../blocs/inspection_request/inspection_request_bloc.dart';
import '../../../blocs/inspection_request/inspection_request_event.dart';
import '../../../blocs/inspection_request/inspection_request_state.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_dimensions.dart';
import '../../../core/widgets/farchis_button.dart';
import '../../../data/models/inspection_request_model.dart';

@RoutePage()
class InspectionRequestDetailScreen extends StatefulWidget {
  final int id;
  const InspectionRequestDetailScreen({super.key, required this.id});

  @override
  State<InspectionRequestDetailScreen> createState() =>
      _InspectionRequestDetailScreenState();
}

class _InspectionRequestDetailScreenState
    extends State<InspectionRequestDetailScreen> {
  @override
  void initState() {
    super.initState();
    context.read<InspectionRequestBloc>().add(
      LoadInspectionRequestDetail(widget.id),
    );
  }

  void _confirmDecline(BuildContext context) {
    showDialog<void>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Decline Quote'),
        content: const Text('Are you sure you want to decline this quote?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(ctx);
              context.read<InspectionRequestBloc>().add(
                DeclineInspectionRequest(widget.id),
              );
            },
            child: const Text(
              'Decline',
              style: TextStyle(color: AppColors.lightError),
            ),
          ),
        ],
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
        title: const Text('Inspection Request'),
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
          if (state.acceptedBookingId != null) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text(
                  'Quote accepted! A booking has been created for you.',
                ),
              ),
            );
          }
        },
        builder: (context, state) {
          final request = state.selected;
          if (state.isLoading && request == null) {
            return const Center(child: CircularProgressIndicator());
          }
          if (request == null || request.id != widget.id) {
            return const Center(child: Text('Inspection request not found'));
          }

          return ListView(
            padding: const EdgeInsets.all(AppDimensions.lg),
            children: [
              _DetailCard(request: request, theme: theme, isDark: isDark),
              if (request.status == InspectionStatus.quoted) ...[
                const SizedBox(height: AppDimensions.xl),
                FarchisButton(
                  label: 'Accept Quote',
                  size: ButtonSize.large,
                  width: double.infinity,
                  isLoading: state.isSubmitting,
                  onPressed: () => context.read<InspectionRequestBloc>().add(
                    AcceptInspectionQuote(widget.id),
                  ),
                ),
                const SizedBox(height: AppDimensions.md),
                FarchisButton(
                  label: 'Decline',
                  variant: ButtonVariant.secondary,
                  size: ButtonSize.large,
                  width: double.infinity,
                  isEnabled: !state.isSubmitting,
                  onPressed: () => _confirmDecline(context),
                ),
              ],
            ],
          );
        },
      ),
    );
  }
}

class _DetailCard extends StatelessWidget {
  final InspectionRequestModel request;
  final ThemeData theme;
  final bool isDark;

  const _DetailCard({
    required this.request,
    required this.theme,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppDimensions.xxl),
      decoration: BoxDecoration(
        color: isDark ? AppColors.navyDark : AppColors.lightSurface,
        borderRadius: BorderRadius.circular(AppDimensions.radiusLg),
        border: Border.all(
          color: isDark
              ? AppColors.navyLight.withValues(alpha: 0.4)
              : AppColors.lightBorder,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            request.vehicle.displayName,
            style: theme.textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: AppDimensions.lg),
          _Row(
            icon: Icons.location_on_outlined,
            label: 'Mode',
            value: request.inspectionMode == InspectionMode.onSite
                ? 'At my location'
                : 'At the shop',
          ),
          if (request.address != null) ...[
            const SizedBox(height: AppDimensions.md),
            _Row(
              icon: Icons.home_outlined,
              label: 'Address',
              value: request.address!,
            ),
          ],
          const SizedBox(height: AppDimensions.md),
          _Row(
            icon: Icons.calendar_today_rounded,
            label: 'Preferred Date',
            value:
                request.preferredDate +
                (request.preferredTime != null
                    ? ' ${request.preferredTime}'
                    : ''),
          ),
          const SizedBox(height: AppDimensions.md),
          _Row(
            icon: Icons.description_outlined,
            label: 'Description',
            value: request.description,
          ),
          const SizedBox(height: AppDimensions.md),
          _Row(
            icon: Icons.flag_outlined,
            label: 'Status',
            value:
                request.status.name[0].toUpperCase() +
                request.status.name.substring(1),
          ),
          if (request.quoteAmount != null) ...[
            const SizedBox(height: AppDimensions.lg),
            Divider(color: theme.colorScheme.outline.withValues(alpha: 0.5)),
            const SizedBox(height: AppDimensions.lg),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Quote',
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                ),
                Text(
                  '\$${request.quoteAmount!.toStringAsFixed(2)}',
                  style: theme.textTheme.headlineMedium?.copyWith(
                    color: AppColors.tierGold,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ],
            ),
            if (request.quoteNotes != null) ...[
              const SizedBox(height: AppDimensions.sm),
              Text(
                request.quoteNotes!,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: isDark
                      ? AppColors.darkTextSecondary
                      : AppColors.lightTextSecondary,
                ),
              ),
            ],
          ],
        ],
      ),
    );
  }
}

class _Row extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const _Row({required this.icon, required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(
          icon,
          size: 18,
          color: theme.colorScheme.onSurface.withValues(alpha: 0.5),
        ),
        const SizedBox(width: AppDimensions.md),
        SizedBox(
          width: 110,
          child: Text(
            label,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
            ),
          ),
        ),
        Expanded(
          child: Text(
            value,
            style: theme.textTheme.bodyMedium?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    );
  }
}
