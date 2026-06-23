import 'package:flutter/material.dart';
import '../constants/app_constants.dart';
import '../theme/app_colors.dart';
import '../theme/app_dimensions.dart';
import '../utils/formatters.dart';

class StatusBadge extends StatelessWidget {
  final String status;
  final bool compact;

  const StatusBadge({
    super.key,
    required this.status,
    this.compact = false,
  });

  Color get _backgroundColor {
    switch (status) {
      case AppConstants.bookingStatusConfirmed:
      case AppConstants.bookingStatusReady:
        return AppColors.lightSuccess.withValues(alpha: 0.2);
      case AppConstants.bookingStatusInProgress:
        return AppColors.lightInfo.withValues(alpha: 0.2);
      case AppConstants.bookingStatusCompleted:
        return AppColors.lightSuccess.withValues(alpha: 0.2);
      case AppConstants.bookingStatusCancelled:
        return AppColors.lightError.withValues(alpha: 0.2);
      case AppConstants.bookingStatusPending:
      case AppConstants.bookingStatusInQueue:
        return AppColors.lightWarning.withValues(alpha: 0.2);
      default:
        return AppColors.lightBorder;
    }
  }

  Color get _textColor {
    switch (status) {
      case AppConstants.bookingStatusConfirmed:
      case AppConstants.bookingStatusReady:
      case AppConstants.bookingStatusCompleted:
        return AppColors.lightSuccess;
      case AppConstants.bookingStatusInProgress:
        return AppColors.lightInfo;
      case AppConstants.bookingStatusCancelled:
        return AppColors.lightError;
      case AppConstants.bookingStatusPending:
      case AppConstants.bookingStatusInQueue:
        return AppColors.lightWarning;
      default:
        return AppColors.lightTextSecondary;
    }
  }

  @override
  Widget build(BuildContext context) {
    final formatted = Formatters.formatBookingStatus(status);

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: AppDimensions.md,
        vertical: compact ? AppDimensions.xs : AppDimensions.sm,
      ),
      decoration: BoxDecoration(
        color: _backgroundColor,
        borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
      ),
      child: Text(
        formatted,
        style: Theme.of(context).textTheme.labelSmall?.copyWith(
              color: _textColor,
              fontWeight: FontWeight.w600,
            ),
      ),
    );
  }
}
