import 'package:flutter/material.dart';
import 'package:spendo/utils/theme.dart';

Widget StyleButton({
  required String text,
  required Function() onClick,
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
          ? const SizedBox(
              height: 24,
              width: 24,
              child: CircularProgressIndicator(
                color: Colors.white,
                strokeWidth: 3,
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
