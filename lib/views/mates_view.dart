import 'package:cart_mate/utils/app_colors.dart';
import 'package:cart_mate/utils/app_strings.dart';
import 'package:cart_mate/views/add_mate_view.dart';
import 'package:cart_mate/views/side_drawer_view.dart';
import 'package:cart_mate/views/your_code_view.dart';
import 'package:cart_mate/widgets/button_widgets.dart';
import 'package:cart_mate/widgets/loading_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/mates_controller.dart';
import '../services/responsive.dart';
import '../utils/app_routes.dart';

class MatesView extends StatefulWidget {
  const MatesView({super.key});

  @override
  _MatesViewState createState() => _MatesViewState();
}

class _MatesViewState extends State<MatesView> {
  late final MatesController controller;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    controller = Get.put(MatesController());
    init();
  }

  Future<void> init() async {
    await controller.getMateApi(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        backgroundColor: AppColors.white,
        leadingWidth: 40,
        leading: InkWell(
          onTap: () {
            _scaffoldKey.currentState?.openDrawer();
          },
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: SizedBox(
              height: 24,
              width: 24,
              child: Image.asset("assets/images/menu.png"),
            ),
          ),
        ),
        title: const Text(
          AppStrings.appName,
          style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 9.0),
            child: IconButton(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: Icon(Icons.arrow_back, size: 30, color: AppColors.black,),
            ),
          ),
        ],
      ),
      drawer: SideDrawerView(),
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
                  child: Row(
                    children: [
                      Text(
                        AppStrings.mates,
                        style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                      ),
                      Spacer(),
                      IconButton(onPressed: () async {
                        if(!controller.isLoading.value){
                          await init();
                        }
                      }, icon: Image.asset("assets/images/refresh.png", height: 30,)),
                    ],
                  ),
                ),

                Expanded(
                  child: RefreshIndicator(
                    onRefresh: () async {
                      if(!controller.isLoading.value){
                        await init();
                      }
                    },
                    child: controller.matesList.value.data == null || controller.matesList.value.data!.isEmpty ? Padding(
                        padding: EdgeInsetsGeometry.only(left: 10, right: 10, bottom: 200),
                        child: Center(child: Text(AppStrings.noMates,textAlign: TextAlign.center, style: TextStyle(fontSize: 18, color: AppColors.black, fontWeight: FontWeight.w500),))) : ListView.builder(
                      itemCount: controller.matesList.value.data != null?controller.matesList.value.data?.length:0,
                      itemBuilder: (context, index) {
                        return Padding(
                          padding: EdgeInsetsGeometry.only(
                            bottom: index == (controller.matesList.value.data!.length - 1)
                                ? 170
                                : 0,
                          ),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8.0,
                              vertical: 4,
                            ),
                            child: Container(
                              decoration: ShapeDecoration(
                                color: AppColors.listBg,
                                shape: ContinuousRectangleBorder(
                                  borderRadius: BorderRadius.circular(45.0),
                                ),
                                shadows: const [
                                  BoxShadow(
                                    color: Colors.black26,
                                    blurRadius: 8,
                                    offset: Offset(0, 4),
                                  ),
                                ],
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Row(
                                  children: [
                                    Text(
                                      controller.matesList.value.data?.elementAt(index).name??'',
                                      style: TextStyle(fontSize: 18),
                                    ),
                                    Spacer(),
                                    IconButton(
                                      onPressed: () async {
                                        await controller.deleteMateApi(context, controller.matesList.value.data?.elementAt(index).sId??'');
                                      },
                                      icon: Icon(Icons.delete_outline, size: 24),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ),
              ],
            ),
            Positioned(
              bottom: 20,
              right: 20,
              child: Container(
                padding: EdgeInsets.all(15),
                width: 190,
                decoration: ShapeDecoration(
                  color: AppColors.white,
                  shape: ContinuousRectangleBorder(
                    borderRadius: BorderRadius.circular(60.0),
                  ),
                  shadows: const [
                    BoxShadow(
                      color: Colors.black26,
                      blurRadius: 8,
                      offset: Offset(0, 4),
                    ),
                  ],
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    BasicButtonWidget(
                      elevation: true,
                      color: AppColors.listBg,
                      onPressed: () {
                        Navigator.push(
                          context,
                          AppRoutes.transparentRoute(AddMateView()),
                        );
                      },
                      labelColor: AppColors.black,
                      label: AppStrings.addMate,
                    ),
                    SizedBox(height: 10),
                    BasicButtonWidget(
                      elevation: true,
                      color: AppColors.menuBg,
                      onPressed: () {
                        showDialog(
                          barrierDismissible: false,
                          context: context,
                          builder: (BuildContext context) {
                            return YourCodeView();
                          },
                        );
                      },
                      labelColor: AppColors.black,
                      label: AppStrings.getYourCode,
                    ),
                  ],
                ),
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
    );
  }
}
