import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../theme/app_dimensions.dart';

class LoadingOverlay extends StatelessWidget {
  final bool isLoading;
  final Widget child;
  final String? message;
  final Color? backgroundColor;

  const LoadingOverlay({
    super.key,
    required this.isLoading,
    required this.child,
    this.message,
    this.backgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        child,
        if (isLoading)
          Container(
            color: backgroundColor ?? Colors.black.withValues(alpha: 0.3),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const CircularProgressIndicator(
                    strokeWidth: 3,
                    valueColor: AlwaysStoppedAnimation(AppColors.lightAccent),
                  ),
                  if (message != null) ...[
                    const SizedBox(height: AppDimensions.lg),
                    Text(
                      message!,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: Colors.white,
                          ),
                    ),
                  ],
                ],
              ),
            ),
          ),
      ],
    );
  }
}
