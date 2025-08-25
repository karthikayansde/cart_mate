import 'package:cart_mate/utils/app_colors.dart';
import 'package:flutter/material.dart';

class BasicButtonWidget extends StatefulWidget {
  final void Function() onPressed;
  final String label;
  final Color? labelColor;
  final Color? color;
  final double? height;
  final double? width;
  final double radius;
  final bool isDisable;
  final bool? elevation;

  const BasicButtonWidget({super.key, required this.onPressed, required this.label, this.height = 44, this.width = double.maxFinite, this.color = AppColors.primary, this.radius = 50, this.isDisable = false, this.labelColor, this.elevation});

  @override
  State<BasicButtonWidget> createState() => _BasicButtonWidgetState();
}

class _BasicButtonWidgetState extends State<BasicButtonWidget> {
  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: BoxConstraints(maxWidth: 450, maxHeight: 45, ),
      child: InkWell(
        focusColor: AppColors.transparent,
        hoverColor: AppColors.transparent,
        highlightColor: AppColors.transparent,
        splashColor: AppColors.transparent,
        onTap: widget.isDisable ? null : widget.onPressed,
        child: Container(
          width: widget.width,
          height: widget.height,
          decoration: BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(widget.radius)),

            boxShadow: widget.elevation == true || widget.elevation != null? [
              BoxShadow(
                color: AppColors.black.withOpacity(0.20), // opacity matches Figma
                offset: const Offset(0, 1), // X=0, Y=1
                blurRadius: 3, // matches Figma blur
                spreadRadius: 0, // matches Figma spread
              )
            ]:null,
          ),
          child: Stack(
            alignment: Alignment.center,
            children: [
              Container(decoration: BoxDecoration(color: widget.isDisable ? AppColors.black : widget.color, borderRadius: BorderRadius.all(Radius.circular(widget.radius))), height: widget.height, width: widget.width),
              Container(decoration: BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(widget.radius))), height: widget.height, width: widget.width, child: Center(child: Text(widget.label, style: TextStyle(fontSize: 16, color: widget.labelColor??AppColors.white, fontWeight: FontWeight.w600),))),
            ],
          ),
        ),
      ),
    );
  }
}