import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:spendo/utils/theme.dart';

Widget StyleButton({
  required String text,
  final VoidCallback? onClick,
  bool isLoading = false,
}) {
  return Container(
    width: double.infinity,
    height: 60,
    decoration: BoxDecoration(
      color: AppTheme.primaryColor,
      borderRadius: BorderRadius.circular(16),
    ),
    child: TextButton(
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
          : Text(
              text,
              style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.w600,
                color: AppTheme.whiteColor,
              ),
            ),
    ),
  );
}
