import 'package:cart_mate/utils/app_colors.dart';
import 'package:flutter/material.dart';

class ProgressWidget extends StatelessWidget {
  final int progress;

  const ProgressWidget({
    super.key,
    required this.progress,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 135,
      height: 12,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Stack(
        children: [
          LayoutBuilder(
            builder: (context, constraints) {
              return AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                width: constraints.maxWidth * (progress / 100.0),
                height: 20,
                decoration: BoxDecoration(
                  color: AppColors.darkPrim,
                  borderRadius: BorderRadius.circular(10),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}