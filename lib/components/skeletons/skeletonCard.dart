import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

Widget SkeletonCard({double height = 60}) {
  return Shimmer.fromColors(
    baseColor: Colors.grey.shade300,
    highlightColor: Colors.grey.shade100,
    child: Container(
      margin: EdgeInsets.symmetric(vertical: 8),
      height: height,
      decoration: BoxDecoration(
        color: Colors.grey,
        borderRadius: BorderRadius.circular(12),
      ),
    ),
  );
}
