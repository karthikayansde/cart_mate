import 'package:cart_mate/services/api/api_service.dart';
import 'package:cart_mate/services/api/endpoints.dart';
import 'package:cart_mate/services/network_service.dart';
import 'package:cart_mate/views/home_view.dart';
import 'package:cart_mate/views/new_password_view.dart';
import 'package:cart_mate/views/otp_verification_view.dart';
import 'package:cart_mate/widgets/snack_bar_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../services/shared_pref_manager.dart';

class MatesController extends GetxController {
  // data members
  var isLoading = false.obs;
  final apiService = ApiService();
  var matesList = [].obs;

// data methods
}
