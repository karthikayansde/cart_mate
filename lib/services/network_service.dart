import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:cart_mate/utils/app_strings.dart';
import 'package:cart_mate/widgets/snack_bar_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:connectivity_plus/connectivity_plus.dart';

/// add this line in main
/// NetworkDependencyInjection.init();


class NetworkDependencyInjection {
  static void init() {
    Get.put<NetworkController>(NetworkController(), permanent: true);
  }
}

class NetworkController extends GetxController {
  final Connectivity _connectivity = Connectivity();
  final RxBool isConnected = true.obs;

  @override
  void onInit() {
    super.onInit();
    _connectivity.onConnectivityChanged.listen(_updateConnectionStatus);
    _checkInitialConnectivity();
  }

  void _updateConnectionStatus(List<ConnectivityResult> results) {
    final disconnected = results.every((res) => res == ConnectivityResult.none);
    isConnected.value = !disconnected;
  }

  Future<void> _checkInitialConnectivity() async {
    final result = await _connectivity.checkConnectivity();
    _updateConnectionStatus(result);
  }

  static Future<bool> checkConnection() async {
    final connectivityResult = await Connectivity().checkConnectivity();
    return connectivityResult[0] != ConnectivityResult.none;
  }
  static Future<bool> checkConnectionShowSnackBar(context) async {
    final connectivityResult = await Connectivity().checkConnectivity();
    if (connectivityResult[0] == ConnectivityResult.none) {
      SnackBarWidget.show(
        context,
        title: AppStrings.noInternetConnection,
        message: AppStrings.noInternetConnectionMsg,
        contentType: ContentType.failure,
      );
    }
    return connectivityResult[0] != ConnectivityResult.none;
  }
}

class InternetWrapper extends StatelessWidget {
  final Widget child;
  final Widget? offlineWidget;

  const InternetWrapper({
    super.key,
    required this.child,
    this.offlineWidget,
  });

  @override
  Widget build(BuildContext context) {
    final networkController = Get.find<NetworkController>();

    return Obx(() {
      return networkController.isConnected.value
          ? child
          : offlineWidget ??
          const Center(
            child: Text(
              "🚫 No Internet Connection",
              style: TextStyle(fontSize: 18, color: Colors.red),
            ),
          );
    });
  }
}