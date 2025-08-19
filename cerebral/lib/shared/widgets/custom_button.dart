import 'package:flutter/material.dart';
import '../../theme/app_theme.dart';

enum ButtonType { primary, secondary, outline, text }

class CustomButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final ButtonType type;
  final IconData? icon;
  final bool isLoading;
  final bool isFullWidth;
  final double? width;
  final double height;
  final EdgeInsets? padding;
  final BorderRadius? borderRadius;

  const CustomButton({
    super.key,
    required this.text,
    this.onPressed,
    this.type = ButtonType.primary,
    this.icon,
    this.isLoading = false,
    this.isFullWidth = false,
    this.width,
    this.height = 52,
    this.padding,
    this.borderRadius,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    Widget button;

    switch (type) {
      case ButtonType.primary:
        button = _buildElevatedButton(theme);
        break;
      case ButtonType.secondary:
        button = _buildSecondaryButton(theme);
        break;
      case ButtonType.outline:
        button = _buildOutlinedButton(theme);
        break;
      case ButtonType.text:
        button = _buildTextButton(theme);
        break;
    }

    return SizedBox(
      width: isFullWidth ? double.infinity : width,
      height: height,
      child: button,
    );
  }

  Widget _buildElevatedButton(ThemeData theme) {
    return ElevatedButton.icon(
      icon: _buildIcon(),
      label: _buildLabel(),
      style: ElevatedButton.styleFrom(
        backgroundColor: AppTheme.primaryColor,
        foregroundColor: Colors.white,
        elevation: 0,
        padding:
            padding ?? const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        shape: RoundedRectangleBorder(
          borderRadius: borderRadius ?? BorderRadius.circular(12),
        ),
      ),
      onPressed: isLoading ? null : onPressed,
    );
  }

  Widget _buildSecondaryButton(ThemeData theme) {
    return ElevatedButton.icon(
      icon: _buildIcon(),
      label: _buildLabel(),
      style: ElevatedButton.styleFrom(
        backgroundColor: AppTheme.secondaryColor,
        foregroundColor: Colors.white,
        elevation: 0,
        padding:
            padding ?? const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        shape: RoundedRectangleBorder(
          borderRadius: borderRadius ?? BorderRadius.circular(12),
        ),
      ),
      onPressed: isLoading ? null : onPressed,
    );
  }

  Widget _buildOutlinedButton(ThemeData theme) {
    return OutlinedButton.icon(
      icon: _buildIcon(),
      label: _buildLabel(),
      style: OutlinedButton.styleFrom(
        foregroundColor: AppTheme.primaryColor,
        side: const BorderSide(color: AppTheme.primaryColor, width: 2),
        padding:
            padding ?? const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        shape: RoundedRectangleBorder(
          borderRadius: borderRadius ?? BorderRadius.circular(12),
        ),
      ),
      onPressed: isLoading ? null : onPressed,
    );
  }

  Widget _buildTextButton(ThemeData theme) {
    return TextButton.icon(
      icon: _buildIcon(),
      label: _buildLabel(),
      style: TextButton.styleFrom(
        foregroundColor: AppTheme.primaryColor,
        padding:
            padding ?? const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      ),
      onPressed: isLoading ? null : onPressed,
    );
  }

  Widget _buildIcon() {
    if (isLoading) {
      return const SizedBox(
        width: 20,
        height: 20,
        child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2),
      );
    }

    if (icon != null) {
      return Icon(icon);
    }

    return const SizedBox.shrink();
  }

  Widget _buildLabel() {
    return Text(
      isLoading ? 'Chargement...' : text,
      style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
    );
  }
}
