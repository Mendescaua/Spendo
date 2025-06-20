import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:spendo/utils/theme.dart';

Widget StyleButton({
  required String text,
  final VoidCallback? onClick,
  final Color? color,
  final IconData? icon,
  bool isLoading = false,
}) {
  return Container(
    width: double.infinity,
    height: 60,
    child: ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: color ?? AppTheme.primaryColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
      ),
      onPressed: isLoading ? null : onClick,
      child: isLoading
          ? SizedBox(
              height: 24,
              width: 24,
              child: LoadingAnimationWidget.threeRotatingDots(
                color: AppTheme.whiteColor,
                size: 24,
              ),
            )
          : Row(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                if (icon != null) ...[
                  Icon(
                    icon,
                    color: AppTheme.whiteColor,
                    size: 24,
                  ),
                  const SizedBox(width: 8),
                ],
                Text(
                  text,
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w600,
                    color: AppTheme.whiteColor,
                  ),
                ),
              ],
            ),
    ),
  );
}
