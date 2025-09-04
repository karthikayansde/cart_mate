import 'package:cart_mate/utils/app_colors.dart';
import 'package:flutter/material.dart';

class AnimatedToggle extends StatefulWidget {
  final bool isOn;
  final ValueChanged<bool> onChanged;

  const AnimatedToggle({
    super.key,
    required this.isOn,
    required this.onChanged,
  });

  @override
  State<AnimatedToggle> createState() => _AnimatedToggleState();
}

class _AnimatedToggleState extends State<AnimatedToggle> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        widget.onChanged(!widget.isOn);
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        width: 45,
        height: 25,
        decoration: BoxDecoration(
          border: Border.all(color: AppColors.black),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Stack(
          // 👈 4. Use widget.isOn instead of internal state
          alignment: widget.isOn ? Alignment.centerRight : Alignment.centerLeft,
          children: [
            AnimatedPositioned(
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeIn,
              left: widget.isOn ? 21 : 2,
              right: widget.isOn ? 2 : 21,
              child: Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white,
                  border: Border.all(color: widget.isOn ? AppColors.green : AppColors.red),
                ),
                child: Padding(
                  padding: EdgeInsets.all(0),
                  child: Image.asset(widget.isOn ? "assets/images/bought.png" : "assets/images/yetToBought.png"),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}