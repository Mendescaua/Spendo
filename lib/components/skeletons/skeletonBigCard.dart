import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

Widget SkeletonBigCard() {
  return Shimmer.fromColors(
    baseColor: Colors.grey.shade300,
    highlightColor: Colors.grey.shade100,
    child: Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade300, width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Imagem simulada
          ClipRRect(
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(16),
              topRight: Radius.circular(16),
            ),
            child: Container(
              height: 120,
              width: double.infinity,
              color: Colors.grey,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Título
                Container(
                  height: 16,
                  width: 120,
                  color: Colors.grey,
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    // Valor atual
                    Container(
                      height: 14,
                      width: 60,
                      color: Colors.grey,
                    ),
                    const Spacer(),
                    // Valor meta
                    Container(
                      height: 18,
                      width: 80,
                      color: Colors.grey,
                    ),
                  ],
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(
              left: 12,
              right: 12,
              bottom: 12,
              top: 4,
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(32),
              child: Container(
                height: 8,
                width: double.infinity,
                color: Colors.grey,
              ),
            ),
          ),
        ],
      ),
    ),
  );
}
