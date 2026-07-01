import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

import '../../../blocs/inspection_request/inspection_request_bloc.dart';
import '../../../blocs/inspection_request/inspection_request_event.dart';
import '../../../blocs/inspection_request/inspection_request_state.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_dimensions.dart';
import '../../../data/models/inspection_request_model.dart';
import '../../router/app_router.dart';

@RoutePage()
class InspectionRequestListScreen extends StatefulWidget {
  const InspectionRequestListScreen({super.key});

  @override
  State<InspectionRequestListScreen> createState() =>
      _InspectionRequestListScreenState();
}

class _InspectionRequestListScreenState
    extends State<InspectionRequestListScreen> {
  @override
  void initState() {
    super.initState();
    context.read<InspectionRequestBloc>().add(const LoadInspectionRequests());
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
        title: const Text('Inspection Requests'),
        elevation: 0,
      ),
      body: BlocBuilder<InspectionRequestBloc, InspectionRequestState>(
        builder: (context, state) {
          if (state.isLoading && state.requests.isEmpty) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state.requests.isEmpty) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(AppDimensions.xxxl),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.fact_check_outlined,
                      size: 56,
                      color: isDark
                          ? AppColors.navyLight
                          : AppColors.navyPrimary,
                    ),
                    const SizedBox(height: AppDimensions.xl),
                    Text(
                      'No inspection requests yet',
                      style: theme.textTheme.titleMedium,
                    ),
                    const SizedBox(height: AppDimensions.sm),
                    Text(
                      'Request a damage assessment and get a quote before booking.',
                      textAlign: TextAlign.center,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: theme.colorScheme.onSurface.withValues(
                          alpha: 0.6,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          }

          return RefreshIndicator(
            onRefresh: () async {
              context.read<InspectionRequestBloc>().add(
                const LoadInspectionRequests(),
              );
            },
            child: ListView.separated(
              padding: const EdgeInsets.all(AppDimensions.lg),
              itemCount: state.requests.length,
              separatorBuilder: (_, _) =>
                  const SizedBox(height: AppDimensions.md),
              itemBuilder: (context, index) {
                final request = state.requests[index];
                return _InspectionRequestCard(
                  request: request,
                  isDark: isDark,
                  onTap: () => context.router.push(
                    InspectionRequestDetailRoute(id: request.id),
                  ),
                );
              },
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: isDark ? AppColors.navyLight : AppColors.navyPrimary,
        foregroundColor: AppColors.white,
        onPressed: () =>
            context.router.push(const InspectionRequestFormRoute()),
        icon: const Icon(Icons.add_rounded),
        label: const Text('New Request'),
      ),
    );
  }
}

class _InspectionRequestCard extends StatelessWidget {
  final InspectionRequestModel request;
  final bool isDark;
  final VoidCallback onTap;

  const _InspectionRequestCard({
    required this.request,
    required this.isDark,
    required this.onTap,
  });

  Color _statusColor(InspectionStatus status) {
    switch (status) {
      case InspectionStatus.submitted:
      case InspectionStatus.reviewing:
        return AppColors.lightWarning;
      case InspectionStatus.quoted:
        return AppColors.lightInfo;
      case InspectionStatus.accepted:
      case InspectionStatus.completed:
        return AppColors.lightSuccess;
      case InspectionStatus.declined:
      case InspectionStatus.cancelled:
        return AppColors.lightError;
    }
  }

  String _statusLabel(InspectionStatus status) {
    final name = status.name;
    return name[0].toUpperCase() + name.substring(1);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final statusColor = _statusColor(request.status);

    return Material(
      color: theme.colorScheme.surface,
      borderRadius: BorderRadius.circular(AppDimensions.radiusLg),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppDimensions.radiusLg),
        child: Container(
          padding: const EdgeInsets.all(AppDimensions.lg),
          decoration: BoxDecoration(
            border: Border.all(
              color: isDark
                  ? AppColors.navyLight.withValues(alpha: 0.3)
                  : theme.colorScheme.outline.withValues(alpha: 0.3),
            ),
            borderRadius: BorderRadius.circular(AppDimensions.radiusLg),
          ),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      request.vehicle.displayName,
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      DateFormat('dd MMM yyyy').format(
                        DateTime.tryParse(request.preferredDate) ??
                            request.createdAt,
                      ),
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: theme.colorScheme.onSurface.withValues(
                          alpha: 0.6,
                        ),
                      ),
                    ),
                    if (request.quoteAmount != null) ...[
                      const SizedBox(height: 2),
                      Text(
                        'Quote: \$${request.quoteAmount!.toStringAsFixed(2)}',
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: AppColors.tierGold,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppDimensions.md,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: statusColor.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(
                    AppDimensions.radiusCircle,
                  ),
                ),
                child: Text(
                  _statusLabel(request.status),
                  style: theme.textTheme.labelSmall?.copyWith(
                    color: statusColor,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              const SizedBox(width: AppDimensions.sm),
              Icon(
                Icons.chevron_right_rounded,
                color: theme.colorScheme.onSurface.withValues(alpha: 0.3),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
