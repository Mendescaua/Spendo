import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import 'package:spendo/utils/theme.dart';

Widget SkeletonCard({double height = 60, required BuildContext context}) {
  return Shimmer.fromColors(
    baseColor: AppTheme.dynamicSkeletonColor(context),
    highlightColor: Colors.grey,
    child: Container(
      margin: EdgeInsets.symmetric(vertical: 8),
      height: height,
      decoration: BoxDecoration(
        color: AppTheme.dynamicSkeletonColor(context),
        borderRadius: BorderRadius.circular(12),
      ),
    ),
  );
}
