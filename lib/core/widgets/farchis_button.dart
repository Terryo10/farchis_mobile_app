import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../theme/app_dimensions.dart';
import '../theme/app_text_styles.dart';

class FarchisButton extends StatelessWidget {
  final String label;
  final VoidCallback onPressed;
  final bool isLoading;
  final bool isEnabled;
  final ButtonVariant variant;
  final ButtonSize size;
  final Widget? icon;
  final double? width;

  const FarchisButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.isLoading = false,
    this.isEnabled = true,
    this.variant = ButtonVariant.primary,
    this.size = ButtonSize.medium,
    this.icon,
    this.width,
  });

  double get _height {
    switch (size) {
      case ButtonSize.small:
        return AppDimensions.buttonHeightSm;
      case ButtonSize.medium:
        return AppDimensions.buttonHeightMd;
      case ButtonSize.large:
        return AppDimensions.buttonHeightLg;
    }
  }

  EdgeInsets get _padding {
    switch (size) {
      case ButtonSize.small:
        return const EdgeInsets.symmetric(
          horizontal: AppDimensions.md,
          vertical: AppDimensions.sm,
        );
      case ButtonSize.medium:
        return const EdgeInsets.symmetric(
          horizontal: AppDimensions.lg,
          vertical: AppDimensions.md,
        );
      case ButtonSize.large:
        return const EdgeInsets.symmetric(
          horizontal: AppDimensions.xl,
          vertical: AppDimensions.lg,
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    switch (variant) {
      case ButtonVariant.primary:
        return SizedBox(
          width: width,
          height: _height,
          child: ElevatedButton(
            onPressed: isEnabled && !isLoading ? onPressed : null,
            style: ElevatedButton.styleFrom(
              padding: _padding,
              backgroundColor: isEnabled ? theme.colorScheme.primary : Colors.grey[400],
            ),
            child: _buildChild(context),
          ),
        );
      case ButtonVariant.secondary:
        return SizedBox(
          width: width,
          height: _height,
          child: OutlinedButton(
            onPressed: isEnabled && !isLoading ? onPressed : null,
            child: _buildChild(context),
          ),
        );
      case ButtonVariant.text:
        return TextButton(
          onPressed: isEnabled && !isLoading ? onPressed : null,
          child: _buildChild(context),
        );
    }
  }

  Widget _buildChild(BuildContext context) {
    if (isLoading) {
      return SizedBox(
        height: 20,
        width: 20,
        child: CircularProgressIndicator(
          strokeWidth: 2,
          valueColor: AlwaysStoppedAnimation(
            variant == ButtonVariant.primary
                ? Colors.white
                : Theme.of(context).colorScheme.primary,
          ),
        ),
      );
    }

    if (icon != null) {
      return Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          icon!,
          const SizedBox(width: AppDimensions.sm),
          Text(label),
        ],
      );
    }

    return Text(label);
  }
}

enum ButtonVariant { primary, secondary, text }

enum ButtonSize { small, medium, large }
