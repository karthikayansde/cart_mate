import 'package:flutter/material.dart';
import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:cart_mate/utils/app_colors.dart';

class SnackBarWidget {

  static void show(
      BuildContext context, {
        required String message,
        required ContentType contentType,
        String title = '',
      }) {
    final snackBar = SnackBar(
      content: AwesomeSnackbarContent(
        title: title,
        message: message,
        contentType: contentType,
        color: contentType == ContentType.failure? AppColors.red: null,
      ),
      elevation: 0,
      backgroundColor: AppColors.transparent,
      behavior: SnackBarBehavior.floating,
    );

    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(snackBar);
  }
}