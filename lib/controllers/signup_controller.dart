import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:cart_mate/services/api/api_service.dart';
import 'package:cart_mate/services/api/endpoints.dart';
import 'package:cart_mate/services/network_service.dart';
import 'package:cart_mate/views/home_view.dart';
import 'package:cart_mate/views/otp_verification_view.dart';
import 'package:cart_mate/widgets/snack_bar_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../services/shared_pref_manager.dart';
import '../utils/app_strings.dart';

class SignupController extends GetxController {
  // data members
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();
  var isPasswordHidden = true.obs;
  var isConfirmPasswordHidden = true.obs;
  var isLoading = false.obs;
  final apiService = ApiService();

  PageRouteBuilder<void> transparentRoute(Widget page) {
    return PageRouteBuilder(
      opaque: false,
      pageBuilder: (context, _, __) => page,
    );
  }

  // data methods
  Future<void> signupApi(BuildContext context) async {
    isLoading.value = true;
    bool isConnected = await NetworkController.checkConnectionShowSnackBar(
      context,
    );
    if (!isConnected) {
      isLoading.value = false;
      return;
    }
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
        Navigator.push(
          context,
          transparentRoute(
            OtpVerificationView(
              verify: (otp, clearOtp) async {
                bool isConnected = await NetworkController.checkConnectionShowSnackBar(context);
                if (!isConnected) {
                  return;
                }

                try {
                  ApiResponse response = await apiService.request(
                    method: ApiMethod.post,
                    endpoint: Endpoints.verifyOtp,
                    body: {
                      "email": emailController.text,
                      "otp": otp,
                    },
                  );

                  bool result = apiService.showApiResponse(
                    context: context,
                    response: response,
                    codes: {
                      ApiCode.success200: true,
                      ApiCode.notFound404: true,
                      ApiCode.error400: true,
                    },
                    customMessages: {
                      ApiCode.success200: true,
                      ApiCode.notFound404: true,
                      ApiCode.error400: true,
                    },
                  );

                  if (result) {

                    await SharedPrefManager.instance.setBoolAsync(SharedPrefManager.isLoggedIn, true);
                    await SharedPrefManager.instance.setUserData(
                      name: response.data['name'],
                      code: response.data['code'],
                      id: response.data['_id'],
                      mail: response.data['email'],
                    );

                    Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(builder: (context) => HomeView()),
                          (Route<dynamic> route) => false,
                    );
                  }else if(response.code == ApiCode.notFound404.index){
                    Navigator.pop(context);
                  }else if(response.code == ApiCode.error400.index){
                    clearOtp();
                  }
                } catch (e) {
                  SnackBarWidget.showError(context);
                }
              },
              resend: ()  async {
                bool isConnected = await NetworkController.checkConnectionShowSnackBar(context);
                if (!isConnected) {
                  return;
                }

                try {
                  ApiResponse response = await apiService.request(
                    method: ApiMethod.post,
                    endpoint: Endpoints.resendOtp,
                    body: {
                      "email": emailController.text
                    },
                  );

                  bool result = apiService.showApiResponse(
                    context: context,
                    response: response,
                    codes: {
                      ApiCode.success200: true,
                      ApiCode.notFound404: true,
                    },
                    customMessages: {
                      ApiCode.success200: true,
                      ApiCode.notFound404: true,
                    },
                  );

                  if(response.code == ApiCode.notFound404.index){
                    Navigator.pop(context);
                  }
                } catch (e) {
                  SnackBarWidget.showError(context);
                }
              },
            ),
          ),
        );
      }
    } catch (e) {
      SnackBarWidget.showError(context);
    } finally {
      isLoading.value = false;
    }
  }
}
