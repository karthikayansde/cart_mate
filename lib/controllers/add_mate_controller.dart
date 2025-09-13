import 'package:cart_mate/services/api/api_service.dart';
import 'package:cart_mate/services/api/endpoints.dart';
import 'package:cart_mate/services/network_service.dart';
import 'package:cart_mate/widgets/snack_bar_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../services/shared_pref_manager.dart';

class AddMateController extends GetxController {
  // data members
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final TextEditingController codeController = TextEditingController();
  var isLoading = false.obs;
  final apiService = ApiService();

  // data methods
  Future<void> addMateApi(BuildContext context) async {
    isLoading.value = true;
    bool isConnected = await NetworkController.checkConnectionShowSnackBar(context);
    if(!isConnected){
      isLoading.value = false;
      return;
    }
    try {
      String id = await SharedPrefManager.instance.getStringAsync(SharedPrefManager.id)??'';
      ApiResponse response = await apiService.request(
        method: ApiMethod.post,
        endpoint: Endpoints.addMate,
        body: {
          "id": id,
          "code": codeController.text
        },
      );
      bool result = apiService.showApiResponse(
        context: context,
        response: response,
        codes: {
          ApiCode.requestTimeout1: true,
          ApiCode.success200: true,
          ApiCode.error400: true,
          ApiCode.notFound404: true,
          ApiCode.conflict409: true,
        },
        customMessages: {
          ApiCode.success200: true,
          ApiCode.error400: true,
          ApiCode.notFound404: true,
          ApiCode.conflict409: true,
        },
      );

      if(result){
        isLoading.value = false;
        Navigator.pop(context);
      }
    } catch (e) {
      SnackBarWidget.showError(context);
    } finally {
      isLoading.value = false;
    }
  }
}
