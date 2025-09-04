import 'package:cart_mate/controllers/home_controller.dart';
import 'package:cart_mate/utils/app_colors.dart';
import 'package:cart_mate/utils/app_strings.dart';
import 'package:cart_mate/views/add_mate_view.dart';
import 'package:cart_mate/views/item_view.dart';
import 'package:cart_mate/views/menu_list_view.dart';
import 'package:cart_mate/views/side_drawer_view.dart';
import 'package:cart_mate/views/your_code_view.dart';
import 'package:cart_mate/widgets/button_widgets.dart';
import 'package:cart_mate/widgets/loading_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/mates_controller.dart';
import '../controllers/menu_list_item_controller.dart';
import '../models/items_model.dart';
import '../services/responsive.dart';
import '../utils/app_routes.dart';
import '../widgets/animated_toggle.dart';
import '../widgets/dropdown_widget.dart';
import '../widgets/menu_card.dart';

class MenuListItemView extends StatefulWidget {
  const MenuListItemView({super.key});

  @override
  _MenuListItemViewState createState() => _MenuListItemViewState();
}

class _MenuListItemViewState extends State<MenuListItemView> {
  late final MenuListItemController controller;
  late final MatesController matesController;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    controller = Get.put(MenuListItemController());
    matesController = Get.put(MatesController());
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false, // don't let system pop directly
      onPopInvokedWithResult: (didPop, result) async {
        if (didPop) return; // ignore if already popped

        // Show loading dialog
        controller.isLoading.value = true;

        // Do your async task
        await Future.delayed(const Duration(seconds: 2));
        // await yourApiCall();

        // Close loader
        controller.isLoading.value = false; // close loading dialog

        // Now go back
        Navigator.of(context).pop();
      },

      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          backgroundColor: AppColors.white,
          leadingWidth: 40,
          title: const Text(
            AppStrings.appName,
            style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
          ),
          actions: [
            IconButton(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: Icon(Icons.arrow_back, size: 30),
            ),
          ],
        ),
        body: Obx(
              () => Stack(
            children: [
              Image.asset(
                'assets/images/animatedBg.png',
                fit: BoxFit.cover,
                width: Responsive.getWidth(context),
                height: Responsive.getHeight(context),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      AppStrings.addItem,
                      style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                    ),
                  ),

                  // Expanded(
                  //   child: ListView.builder(
                  //     itemCount: controller.matesList.value.data != null?controller.matesList.value.data?.length:0,
                  //     itemBuilder: (context, index) {
                  //       return Padding(
                  //         padding: EdgeInsetsGeometry.only(
                  //           bottom: index == (controller.matesList.value.data!.length - 1)
                  //               ? 170
                  //               : 0,
                  //         ),
                  //         child: Padding(
                  //           padding: const EdgeInsets.symmetric(
                  //             horizontal: 8.0,
                  //             vertical: 4,
                  //           ),
                  //           child: Container(
                  //             decoration: ShapeDecoration(
                  //               color: AppColors.listBg,
                  //               shape: ContinuousRectangleBorder(
                  //                 borderRadius: BorderRadius.circular(45.0),
                  //               ),
                  //               shadows: const [
                  //                 BoxShadow(
                  //                   color: Colors.black26,
                  //                   blurRadius: 8,
                  //                   offset: Offset(0, 4),
                  //                 ),
                  //               ],
                  //             ),
                  //             child: Padding(
                  //               padding: const EdgeInsets.all(8.0),
                  //               child: Row(
                  //                 children: [
                  //                   Text(
                  //                     controller.matesList.value.data?.elementAt(index).name??'',
                  //                     style: TextStyle(fontSize: 18),
                  //                   ),
                  //                   Spacer(),
                  //                   IconButton(
                  //                     onPressed: () async {
                  //                       await controller.deleteMateApi(context, controller.matesList.value.data?.elementAt(index).sId??'');
                  //                     },
                  //                     icon: Icon(Icons.delete_outline, size: 24),
                  //                   ),
                  //                 ],
                  //               ),
                  //             ),
                  //           ),
                  //         ),
                  //       );
                  //     },
                  //   ),
                  // ),
                ],
              ),
              Positioned(
                bottom: 20,
                right: 20,
                child:
                BasicButtonWidget(
                  width: 130,
                  elevation: true,
                  color: AppColors.menuBg,
                  onPressed: ()async {
                    await addInit();
                    Navigator.push(
                      context,
                      AppRoutes.transparentRoute(
                          ItemView(isEdit: false, mate: Data(),)
                      ),
                    );
                  },
                  labelColor: AppColors.black,
                  label: AppStrings.addItem,
                ),
              ),
              if (controller.isLoading.value)
                Positioned.fill(
                  child: Container(
                    color: AppColors.popupBG,
                    child: LoadingWidget.loader(),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> addInit() async {
    controller.isLoading.value = true;
    await matesController.getMateApi(context);
    controller.isLoading.value = false;
  }
}
