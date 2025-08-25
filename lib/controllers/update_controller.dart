import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:cart_mate/services/api/api_service.dart';
import 'package:cart_mate/services/api/endpoints.dart';
import 'package:cart_mate/services/network_service.dart';
import 'package:cart_mate/views/home_view.dart';
import 'package:cart_mate/widgets/loading_widget.dart';
import 'package:cart_mate/widgets/snack_bar_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../services/shared_pref_manager.dart';
import '../utils/app_strings.dart';

class UpdateController extends GetxController {
  // data members
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final TextEditingController nameController = TextEditingController();
  var isLoading = false.obs;
  final apiService = ApiService();

  // data methods
  Future<void> saveApi(BuildContext context) async {
    isLoading.value = true;
    bool isConnected = await NetworkController.checkConnectionShowSnackBar(context);
    if(!isConnected){
      isLoading.value = false;
      return;
    }
    try {
      ApiResponse response = await apiService.request(
        method: ApiMethod.post,
        endpoint: Endpoints.login,
        body: {
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
          name: response.data['name'],
          code: response.data['code'],
          id: response.data['_id'],
          mail: response.data['email'],
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
