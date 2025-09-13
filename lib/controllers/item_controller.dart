import 'dart:convert';

import 'package:cart_mate/models/image_model.dart';
import 'package:cart_mate/services/api/api_service.dart';
import 'package:cart_mate/services/api/endpoints.dart';
import 'package:cart_mate/services/network_service.dart';
import 'package:cart_mate/widgets/snack_bar_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:image/image.dart' as img;

import '../services/shared_pref_manager.dart';

class ItemController extends GetxController {
  // data members
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final TextEditingController itemNameController = TextEditingController();
  final TextEditingController unitController = TextEditingController();
  final TextEditingController notesController = TextEditingController();
  var selectedMate = ''.obs;
  var selectedUom = ''.obs;
  var isLoading = false.obs;
  var imageList = ImagesModel().obs;
  final apiService = ApiService();
  String? base64Image;


  // data methods
  Future<void> addItemApi(BuildContext context) async {
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
        endpoint: Endpoints.addItem,
        body: {
          "name": itemNameController.text,
          "imageUrl": base64Image,
          "uomId": selectedUom.value.split("mzqxv9rklt8ph2wj")[1],
          "quantity": unitController.text,
          "mateId": selectedMate.value.split("mzqxv9rklt8ph2wj")[1],
          "notes": notesController.text,
          "createdBy": id
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

      if(result){isLoading.value = false;
      Navigator.pop(context);
      }
    } catch (e) {
      SnackBarWidget.showError(context);
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> editItemApi(BuildContext context, String itemId) async {
    isLoading.value = true;
    bool isConnected = await NetworkController.checkConnectionShowSnackBar(context);
    if(!isConnected){
      isLoading.value = false;
      return;
    }
    try {
      ApiResponse response = await apiService.request(
        method: ApiMethod.post,
        endpoint: Endpoints.editItem,
        body:
        {
          "id": itemId,
          "name": itemNameController.text,
          "imageUrl": base64Image,
          "uomId": selectedUom.value.split("mzqxv9rklt8ph2wj")[1],
          "quantity": unitController.text,
          "mateId": selectedMate.value.split("mzqxv9rklt8ph2wj")[1],
          "notes": notesController.text,
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

      if(result){isLoading.value = false;
      Navigator.pop(context);
      }
    } catch (e) {
      SnackBarWidget.showError(context);
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> getImageApi(BuildContext context, String query) async {
    isLoading.value = true;
    imageList.value = ImagesModel();
    bool isConnected = await NetworkController.checkConnectionShowSnackBar(context);
    if(!isConnected){
      isLoading.value = false;
      return;
    }
    try {
      ApiResponse response = await apiService.request(
        method: ApiMethod.get,
        endpoint: Endpoints.getImage(query),
        customUrl: true
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
        imageList.value = ImagesModel.fromJson(response.data);
        imageList.value.hits!.insert(0, Hits());
        isLoading.value = false;
      }
    } catch (e) {
      SnackBarWidget.showError(context);
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> processImage(String imageUrl) async {
      isLoading.value = true;

    try {
      // Step 1: Download the image from the URL.
      final response = await http.get(Uri.parse(imageUrl));
      if (response.statusCode != 200) {
        throw Exception(
          'Failed to download image. Status code: ${response.statusCode}',
        );
      }

      // Decode the downloaded image bytes into a manipulable Image object.
      final image = img.decodeImage(response.bodyBytes);
      if (image == null) {
        throw Exception('Failed to decode image.');
      }

      int? height, width;
      if(image.height > image.width){
        height = 100;
        width = null;
      }else{
        height = null;
        width = 100;
      }

      // Step 2: Resize the image to 100x100 pixels.
      // The image package handles this in memory.
      final resizedImage = img.copyResize(image, height: height, width: width);

      // Step 3: Convert the resized image to a Base64 string.
      // First, encode the image back into a byte format (e.g., PNG).
      final resizedBytes = img.encodePng(resizedImage);
      // Then, convert the bytes to a Base64 string.
      base64Image = base64Encode(resizedBytes);
    } catch (e) {
      base64Image = null;
    } finally {
      isLoading.value = false;
    }
  }
}
