import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:cart_mate/services/api/api_service.dart';
import 'package:cart_mate/services/api/endpoints.dart';
import 'package:cart_mate/services/network_service.dart';
import 'package:cart_mate/views/home_view.dart';
import 'package:cart_mate/views/otp_verification_view.dart';
import 'package:cart_mate/widgets/snack_bar_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../utils/app_strings.dart';

class SignupController extends GetxController {
  // data members
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController = TextEditingController();
  var isPasswordHidden = true.obs;
  var isConfirmPasswordHidden = true.obs;
  var isLoading = false.obs;
  final apiService = ApiService();

  // data methods
  Future<void> signupApi(BuildContext context) async {
    bool isConnected = await NetworkController.checkConnectionShowSnackBar(context);
    if(!isConnected){
      return;
    }
    isLoading.value = true;
    try {
      ApiResponse response = await apiService.request(
        method: ApiMethod.post,
        endpoint: Endpoints.signUp,
        body: {
          "name": nameController.text,
          "email": emailController.text,
          "password": passwordController.text,
        },
      );

      bool result = apiService.showApiResponse(
        context: context,
        response: response,
        codes: {
          ApiCode.requestTimeout1: true,
          ApiCode.unauthorized401: true,
          ApiCode.conflict409: true,
          ApiCode.notFound404: true,
        },
        customMessages: {
          ApiCode.unauthorized401: true,
          ApiCode.conflict409: true,
          ApiCode.notFound404: true,
        },
      );

      if (result) {
        isLoading.value = false;
        showDialog(context: context, barrierDismissible: false, builder: (context) => OtpVerificationView(),);
      }
    } catch (e) {
      SnackBarWidget.show(
        context,
        title: apiErrorConfigDefault.title,
        message: apiErrorConfigDefault.message,
        contentType: apiErrorConfigDefault.contentType,
      );
    } finally {
      isLoading.value = false;
    }
  }
}
