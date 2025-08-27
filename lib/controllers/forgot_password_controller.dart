import 'package:cart_mate/services/api/api_service.dart';
import 'package:cart_mate/services/api/endpoints.dart';
import 'package:cart_mate/services/network_service.dart';
import 'package:cart_mate/utils/app_routes.dart';
import 'package:cart_mate/views/home_view.dart';
import 'package:cart_mate/views/new_password_view.dart';
import 'package:cart_mate/views/otp_verification_view.dart';
import 'package:cart_mate/widgets/snack_bar_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../services/shared_pref_manager.dart';

class ForgotPasswordController extends GetxController {
  // data members
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final TextEditingController emailController = TextEditingController();
  var isLoading = false.obs;
  final apiService = ApiService();

  // data methods
  Future<void> forgotPasswordApi(BuildContext context) async {
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
        method: ApiMethod.get,
        endpoint: Endpoints.forgotPassword+emailController.text,
      );

      bool result = apiService.showApiResponse(
        context: context,
        response: response,
        codes: {
          ApiCode.requestTimeout1: true,
          ApiCode.notFound404: true,
          ApiCode.success200: true,
        },
        customMessages: {
          ApiCode.notFound404: true,
          ApiCode.success200: true,
        },
      );

      if (result) {
        isLoading.value = false;
        Navigator.push(
          context,
            AppRoutes.transparentRoute(
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
                        "isForgotPassword": true
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
                        name: response.data["userData"]['name'],
                        code: response.data["userData"]['code'],
                        id: response.data["userData"]['_id'],
                        mail: response.data["userData"]['email'],
                      );

                      Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(builder: (context) => NewPasswordView(fromForgotPassword: true,)),
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
            )

        );
      }
    } catch (e) {
      SnackBarWidget.showError(context);
    } finally {
      isLoading.value = false;
    }
  }
}
