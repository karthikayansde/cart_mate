import 'package:cart_mate/utils/app_colors.dart';
import 'package:flutter/material.dart';

class AnimatedToggle extends StatefulWidget {
  const AnimatedToggle({super.key});

  @override
  State<AnimatedToggle> createState() => _AnimatedToggleState();
}

class _AnimatedToggleState extends State<AnimatedToggle> {
  bool _isOn = false;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        setState(() {
          _isOn = !_isOn;
        });
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        width: 42, // Updated width
        height: 24, // Updated height
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20), // Adjusted for new size
          color: _isOn? AppColors.green.withOpacity(0.85): AppColors.red.withOpacity(0.85),
        ),
        child: Stack(
          alignment: _isOn ? Alignment.centerRight : Alignment.centerLeft,
          children: [
            AnimatedPositioned(
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeIn,
              left: _isOn ? 20 : 2, // Adjusted for new size
              right: _isOn ? 2 : 20, // Adjusted for new size
              child: Container(
                width: 18, // Adjusted for new size
                height: 18, // Adjusted for new size
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white,
                ),
                child: Icon(
                  _isOn ? Icons.check : Icons.clear,
                  color: _isOn? AppColors.green: AppColors.red,
                  size: 18, // Adjusted for new size
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}