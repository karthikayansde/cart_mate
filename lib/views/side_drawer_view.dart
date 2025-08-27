import 'package:cart_mate/services/api/api_service.dart';
import 'package:cart_mate/utils/app_strings.dart';
import 'package:cart_mate/views/feedback_view.dart';
import 'package:cart_mate/views/login_view.dart';
import 'package:cart_mate/views/update_view.dart';
import 'package:cart_mate/widgets/alert_boxes.dart';
import 'package:cart_mate/widgets/loading_widget.dart';
import 'package:flutter/material.dart';

import '../services/api/endpoints.dart';
import '../services/network_service.dart';
import '../services/shared_pref_manager.dart';
import '../utils/app_routes.dart';
import '../widgets/snack_bar_widget.dart';
import 'forgot_password_view.dart';
import 'new_password_view.dart';

class SideDrawerView extends StatelessWidget {
  const SideDrawerView({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: Colors.white,
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          DrawerHeader(
            decoration: const BoxDecoration(
              color: Colors.white,
              image: DecorationImage(
                image: AssetImage('assets/images/animatedBg.png'),
                fit: BoxFit.cover,
              ),
            ),
            child: Center(
              child: Row(
                children: [
                  Column(
                    children: [

                      Image.asset(
                        'assets/images/cartmateLogo.png',
                        width: 80,
                        height: 80,
                      ),
                      const SizedBox(height: 3),
                      // App name or user name.
                      const Text(
                        AppStrings.appName,
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  Spacer(),
                  Align( alignment: Alignment.topRight, child: IconButton(onPressed: (){Navigator.pop(context);}, icon: Icon(Icons.close, color: Colors.black, size: 30,),))
                ],
              ),
            ),
          ),
          ListTile(
            leading: const Icon(Icons.person),
            title: const Text(AppStrings.editProfile),
            onTap: () {
              Navigator.pop(context);
              Navigator.push(
                context,
                AppRoutes.transparentRoute(UpdateView()),
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.lock),
            title: const Text('Change Password'),
            onTap: () {
              Navigator.pop(context);
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => NewPasswordView(fromForgotPassword: false,)),
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.delete_forever),
            title: const Text(AppStrings.deleteAccount),
            onTap: () {
              AlertBoxes.okCancelDialog(context: context, header: AppStrings.deleteAccount, content: AppStrings.deleteAccountDetail,
                  onOk: () async {
                LoadingWidget.showLoader(context);
                bool isConnected = await NetworkController.checkConnectionShowSnackBar(
                  context,
                );
                if (!isConnected) {
                  LoadingWidget.closeLoader(context);
                  return;
                }
                try {

                  String id = await SharedPrefManager.instance.getStringAsync(SharedPrefManager.id)??'';
                  ApiResponse response = await ApiService().request(
                    method: ApiMethod.delete,
                    endpoint: Endpoints.delete+id,
                  );

                  bool result = ApiService().showApiResponse(
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

                  if (result) {
                    await SharedPrefManager.instance.logout();
                    Navigator.of(context).pushAndRemoveUntil(
                      MaterialPageRoute(builder: (context) => const LoginView()),
                          (Route<dynamic> route) => false,
                    );
                  }else{
                    LoadingWidget.closeLoader(context);
                  }
                }catch (e) {
                  SnackBarWidget.showError(context);
                }
              }, okText: AppStrings.yes);
            },
          ),
          ListTile(
            leading: const Icon(Icons.exit_to_app),
            title: const Text(AppStrings.logout),
            onTap: () {
              AlertBoxes.okCancelDialog(context: context, header: AppStrings.logout, content: AppStrings.logoutDetail, onOk: () async {
                await SharedPrefManager.instance.logout();
                Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(builder: (context) => const LoginView()),
                      (Route<dynamic> route) => false,
                );
              }, okText: AppStrings.yes);
            },
          ),
          // A Divider to separate main options from support/feedback options.
          const Divider(),
          // Support and feedback options.
          ListTile(
            leading: const Icon(Icons.help_outline),
            title: const Text(AppStrings.helpFeedback),
            onTap: () {
              // Handle the action for "Help and Feedback".
              Navigator.pop(context);
              showDialog(
                barrierDismissible: false,
                context: context,
                builder: (BuildContext context) {
                  return FeedbackView();
                },
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.star),
            title: const Text('Enjoying? Rate us!'),
            onTap: () {
              // Handle the action for "Rate Us".
              // This could open a dialog or redirect to the app store.
              Navigator.pop(context);
              // You could show a custom dialog here, for example:
              // showDialog(
              //   context: context,
              //   builder: (BuildContext context) {
              //     return AlertDialog(
              //       title: const Text('Rate Us'),
              //       content: const Text('Please rate us on the app store!'),
              //       actions: <Widget>[
              //         TextButton(
              //           onPressed: () {
              //             Navigator.of(context).pop();
              //           },
              //           child: const Text('OK'),
              //         ),
              //       ],
              //     );
              //   },
              // );
            },
          ),
        ],
      ),
    );
  }
}
