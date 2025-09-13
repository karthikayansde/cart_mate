import 'package:cart_mate/services/api/api_service.dart';
import 'package:cart_mate/services/api/endpoints.dart';
import 'package:cart_mate/services/network_service.dart';
import 'package:cart_mate/views/menu_list_item_view.dart';
import 'package:cart_mate/widgets/snack_bar_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../services/shared_pref_manager.dart';

class ListController extends GetxController {
  // data members
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final TextEditingController listNameController = TextEditingController();
  final TextEditingController notesController = TextEditingController();
  var selectedMate = ''.obs;
  var isLoading = false.obs;
  final apiService = ApiService();

  // data methods
  Future<void> addListApi(BuildContext context) async {
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
        endpoint: Endpoints.addList,
        body: {
          "name": listNameController.text,
          "notes": notesController.text,
          "createdBy": id,
          "mateId": selectedMate.value.split("mzqxv9rklt8ph2wj")[1]
        },
      );
      bool result = apiService.showApiResponse(
        context: context,
        response: response,
        codes: {
          ApiCode.requestTimeout1: true,
          ApiCode.notFound404: true,
        },
        customMessages: {
          ApiCode.notFound404: true,
        },
      );

      if(result){isLoading.value = false;
        Navigator.pop(context);
        Navigator.push(context, MaterialPageRoute(builder: (context) => MenuListItemView(),));

      }
    } catch (e) {
      SnackBarWidget.showError(context);
    } finally {
      isLoading.value = false;
    }
  }
}
