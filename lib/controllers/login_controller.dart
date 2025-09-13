import 'package:cart_mate/services/api/api_service.dart';
import 'package:cart_mate/services/api/endpoints.dart';
import 'package:cart_mate/services/network_service.dart';
import 'package:cart_mate/views/home_view.dart';
import 'package:cart_mate/widgets/snack_bar_widget.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../services/shared_pref_manager.dart';

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
    isLoading.value = true;
    bool isConnected = await NetworkController.checkConnectionShowSnackBar(context);
    if(!isConnected){
      isLoading.value = false;
      return;
    }
    try {
      String? token;
      if(!kIsWeb){
        token = await FirebaseMessaging.instance.getToken();
      }
      ApiResponse response = await apiService.request(
        method: ApiMethod.post,
        endpoint: Endpoints.login,
        body: {
          "email": emailController.text,
          "password": passwordController.text,
          "fcm": token
        },
      );
      bool result = apiService.showApiResponse(
        context: context,
        response: response,
        codes: {
          ApiCode.requestTimeout1: true,
          ApiCode.unauthorized401: true,
          ApiCode.notFound404: true,
        },
        customMessages: {
          ApiCode.unauthorized401: true,
          ApiCode.notFound404: true,
        },
      );

      if(result){
        await SharedPrefManager.instance.setBoolAsync(SharedPrefManager.isLoggedIn, true);
        await SharedPrefManager.instance.setUserData(
          name: response.data["data"]['name'],
          code: response.data["data"]['code'],
          id: response.data["data"]['_id'],
          mail: response.data["data"]['email'],
        );
        isLoading.value = false;
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => HomeView()),
              (Route<dynamic> route) => false,
        );
      }
    } catch (e) {
      SnackBarWidget.showError(context);
    } finally {
      isLoading.value = false;
    }
  }
}
