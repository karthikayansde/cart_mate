import 'package:cart_mate/models/items_model.dart';
import 'package:cart_mate/models/uom_model.dart';
import 'package:cart_mate/services/api/api_service.dart';
import 'package:cart_mate/services/api/endpoints.dart';
import 'package:cart_mate/services/network_service.dart';
import 'package:cart_mate/widgets/snack_bar_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../services/shared_pref_manager.dart';

class HomeController extends GetxController {
  // data members
  var isLoading = false.obs;
  final apiService = ApiService();
  var selectedTabIndex = 0.obs;
  var myList = <Data>[].obs;
  var mateList = <Data>[].obs;
  var uomList = <UomModel>[].obs;
  var id = "".obs;

  // data methods
  @override
  void onInit() {
    init();
    super.onInit();
  }

  Future<void> init() async {
    isLoading.value = true;
    id.value = (await SharedPrefManager.instance.getStringAsync(SharedPrefManager.id) ?? '');
    await getUomApi();
    isLoading.value = false;
  }

  Future<void> getUomApi() async {
    bool isConnected = await NetworkController.checkConnection();
    if(!isConnected){
      return;
    }
    try {
      ApiResponse response = await apiService.request(
        method: ApiMethod.get,
        endpoint: Endpoints.getUom,
      );
      if(response.code == ApiCode.success200.index){
        for(int i = 0; i < response.data.length; i++){
          uomList.add(UomModel.fromJson(response.data[i]));
        }
        isLoading.value = false;
      }
    } catch (e) {
      print(e);
    }
  }

  Future<void> getItemsApi(BuildContext context) async {
    isLoading.value = true;
    bool isConnected = await NetworkController.checkConnectionShowSnackBar(context);
    if(!isConnected){
      isLoading.value = false;
      return;
    }
    try {
      ApiResponse response = await apiService.request(
        method: ApiMethod.get,
        endpoint: Endpoints.getItems+id.value,
      );
      bool result = apiService.showApiResponse(
        context: context,
        response: response,
        codes: {
          ApiCode.requestTimeout1: true,
        },
        customMessages: {
        },
      );

      if(result){
        ItemsModel itemsModel = ItemsModel.fromJson(response.data);
        myList.clear();
        mateList.clear();
        for(int i = 0; i < itemsModel.data!.length; i++){
          if(itemsModel.data![i].mateId!.sId == id.value){
            myList.add(itemsModel.data![i]);
          }else{
            mateList.add(itemsModel.data![i]);
          }
        }
        isLoading.value = false;
      }
    } catch (e) {
      SnackBarWidget.showError(context);
    } finally {
      isLoading.value = false;
    }
  }

  Future<bool> updateStatus(BuildContext context, String itemId) async {
    isLoading.value = true;
    bool isConnected = await NetworkController.checkConnectionShowSnackBar(context);
    if(!isConnected){
      isLoading.value = false;
      return false;
    }
    try {
      ApiResponse response = await apiService.request(
        method: ApiMethod.get,
        endpoint: Endpoints.updateStatus+itemId,
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

      if(result){
        isLoading.value = false;
        return true;
      }else{
        return false;
      }
    } catch (e) {
      SnackBarWidget.showError(context);
      return false;
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> deleteItemApi(BuildContext context, String itemId, Function() fun ) async {
    isLoading.value = true;
    bool isConnected = await NetworkController.checkConnectionShowSnackBar(context);
    if(!isConnected){
      isLoading.value = false;
      return;
    }
    try {
      ApiResponse response = await apiService.request(
        method: ApiMethod.delete,
        endpoint: Endpoints.deleteItem,
        body: {
          "id": itemId,
          "userId": id.value
        }
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

      if(result){
        fun();
        isLoading.value = false;
      }
    } catch (e) {
      SnackBarWidget.showError(context);
    } finally {
      isLoading.value = false;
    }
  }

}
