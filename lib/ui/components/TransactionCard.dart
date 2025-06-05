import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';

class TransactionCard extends StatelessWidget {
  const TransactionCard({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        // boxShadow: [
        //   BoxShadow(
        //     color: const Color.fromARGB(10, 0, 0, 0),
        //     offset: Offset(0, 4),
        //     blurRadius: 6,
        //     spreadRadius: 0,
        //   ),
        // ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: const BoxDecoration(
              color: Color(0xFFFFF4E5),
              borderRadius: BorderRadius.all(Radius.circular(12)),
            ),
            child: const Icon(
              Iconsax.monitor,
              color: Color(0xFFFFC260),
              size: 24,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                Text(
                  "Dribbble",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    color: Colors.black,
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  "Subscription fee",
                  style: TextStyle(
                    color: Colors.grey,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
          const Text(
            "-\$15.00",
            style: TextStyle(
              color: Colors.red,
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
        ],
      ),
    );
  }
}
