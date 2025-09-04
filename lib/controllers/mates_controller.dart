import 'package:cart_mate/models/mate_model.dart';
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
  Rx<MatesModel> matesList = MatesModel().obs;

  Future<void> getMateApi(BuildContext context) async {
    isLoading.value = true;
    bool isConnected = await NetworkController.checkConnectionShowSnackBar(context);
    if(!isConnected){
      isLoading.value = false;
      return;
    }
    try {
      String id = await SharedPrefManager.instance.getStringAsync(SharedPrefManager.id)??'';
      ApiResponse response = await apiService.request(
        method: ApiMethod.get,
        endpoint: Endpoints.getMates+id,
      );
      bool result = apiService.showApiResponse(
        context: context,
        response: response,
        codes: {
          ApiCode.requestTimeout1: true,
        }
      );
      if(result){
        matesList.value = MatesModel.fromJson(response.data);
        isLoading.value = false;
      }
    } catch (e) {
      SnackBarWidget.showError(context);
    } finally {
      isLoading.value = false;
    }
  }
  Future<void> deleteMateApi(BuildContext context, String mateId) async {
    isLoading.value = true;
    bool isConnected = await NetworkController.checkConnectionShowSnackBar(context);
    if(!isConnected){
      isLoading.value = false;
      return;
    }
    try {
      String id = await SharedPrefManager.instance.getStringAsync(SharedPrefManager.id)??'';
      ApiResponse response = await apiService.request(
        method: ApiMethod.delete,
        endpoint: Endpoints.deleteMate,
        body: {
          "id": id,
          "mateId": mateId
        }
      );
      bool result = apiService.showApiResponse(
        context: context,
        response: response,
        codes: {
          ApiCode.requestTimeout1: true,
          ApiCode.success200: true,
          ApiCode.notFound404: true,
        },
        customMessages: {
          ApiCode.success200: true,
          ApiCode.notFound404: true,
        },
      );
      if(result){
        await getMateApi(context);
        isLoading.value = false;
      }
    } catch (e) {
      SnackBarWidget.showError(context);
    } finally {
      isLoading.value = false;
    }
  }
}
