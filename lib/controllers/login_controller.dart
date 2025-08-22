import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:cart_mate/services/api/api_service.dart';
import 'package:cart_mate/services/api/endpoints.dart';
import 'package:cart_mate/services/network_service.dart';
import 'package:cart_mate/views/home_view.dart';
import 'package:cart_mate/widgets/loading_widget.dart';
import 'package:cart_mate/widgets/snack_bar_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../utils/app_strings.dart';

class LoginController extends GetxController {
  // data members
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  var isPasswordHidden = true.obs;
  var isLoading = false.obs;
  final apiService = ApiService();

  // data methods
  Future<void> loginApi(BuildContext context) async {
    bool isConnected = await NetworkController.checkConnectionShowSnackBar(context);
    if(!isConnected){
      return;
    }
    isLoading.value = true;
    try {
      ApiResponse response = await apiService.request(
        method: ApiMethod.post,
        endpoint: Endpoints.login,
        body: {
          "email": emailController.text,
          "password": passwordController.text,
        },
      );
      if (response.code == ApiCode.success200.index) {
        isLoading.value = false;
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => HomeView()),
          (Route<dynamic> route) => false,
        );
      } else if(response.code == ApiCode.requestTimeout1.index){
        SnackBarWidget.show(
          context,
          title: AppStrings.requestTimedOutTitle,
          message: AppStrings.requestTimedOut,
          contentType: ContentType.failure,
        );
      } else if(response.code == ApiCode.unauthorized401.index){
        SnackBarWidget.show(
          context,
          message: response.message,
          contentType: ContentType.failure,
        );
      } else if(response.code == ApiCode.notFound404.index){
        SnackBarWidget.show(
          context,
          message: response.message,
          contentType: ContentType.failure,
        );
      } else {
        SnackBarWidget.show(
          context,
          title: AppStrings.somethingWentWrongTitle,
          message: AppStrings.somethingWentWrong,
          contentType: ContentType.failure,
        );
      }
    } catch (e) {
      SnackBarWidget.show(
        context,
        title: AppStrings.somethingWentWrongTitle,
        message: AppStrings.somethingWentWrong,
        contentType: ContentType.failure,
      );
    } finally {
      isLoading.value = false;
    }
  }
}
