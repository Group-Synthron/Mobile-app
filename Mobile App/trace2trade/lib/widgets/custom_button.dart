import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  final String label;
  final VoidCallback onPressed;
  final bool isLoading;
  final Color? backgroundColor;
  final Color? textColor;
  final Color? loadingColor;
  final EdgeInsetsGeometry? padding;
  final double? elevation;
  final BorderRadiusGeometry? borderRadius;
  final double? minWidth;

  const CustomButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.isLoading = false,
    this.backgroundColor,
    this.textColor,
    this.loadingColor = Colors.white,
    this.padding = const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
    this.elevation = 2,
    this.borderRadius = const BorderRadius.all(Radius.circular(8)),
    this.minWidth = double.infinity,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return ConstrainedBox(
      constraints: BoxConstraints(minWidth: minWidth!),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: backgroundColor ?? theme.primaryColor,
          foregroundColor: textColor ?? Colors.white,
          padding: padding,
          elevation: elevation,
          shape: RoundedRectangleBorder(
            borderRadius: borderRadius!,
          ),
          disabledBackgroundColor: backgroundColor?.withOpacity(0.5) ?? 
              theme.primaryColor.withOpacity(0.5),
        ),
        onPressed: isLoading ? null : onPressed,
        child: isLoading
            ? SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  color: loadingColor,
                ),
              )
            : Text(
                label,
                style: TextStyle(
                  color: textColor ?? Colors.white,
                  fontWeight: FontWeight.w600,
                ),
              ),
      ),
    );
  }
}