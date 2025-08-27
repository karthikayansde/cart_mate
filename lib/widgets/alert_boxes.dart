import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../utils/app_colors.dart';
import '../utils/app_strings.dart';

class AlertBoxes {
  static okCancelDialog({
    required BuildContext context,
    required String header,
    required String content,
    required VoidCallback onOk,
    VoidCallback? onCancel, String? okText,
  }) {
    return showCupertinoModalPopup(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) => CupertinoAlertDialog(
        title: Align(
          alignment: Alignment.center,
          child: Text(header),
        ),
        content: Text(content),
        actions: <CupertinoDialogAction>[
          CupertinoDialogAction(
            onPressed: onCancel??(){
              Navigator.pop(context);
            },
            child: Text(
              AppStrings.cancel,
              style: TextStyle(color: AppColors.black),
            ),
          ),
          CupertinoDialogAction(
            isDestructiveAction: true,
            onPressed:
          onOk,
            child: Text(
              okText??AppStrings.ok,
              style: TextStyle(
                color: AppColors.primary,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }
  static okDialog({
    required BuildContext context,
    required String header,
    required String content,
    required VoidCallback onOk,
  }){
    return showCupertinoModalPopup(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) => CupertinoAlertDialog(
        title: Align(
            alignment: Alignment.center, child: Text(header)),
        content: content == ''? null:Text(content),
        actions: <CupertinoDialogAction>[
          CupertinoDialogAction(
            isDestructiveAction: true,
            onPressed: onOk,
            child: Text(
              AppStrings.ok,
              style:
              TextStyle(color: AppColors.primary, fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }
}