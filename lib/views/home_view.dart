import 'package:cart_mate/controllers/home_controller.dart';
import 'package:cart_mate/utils/app_colors.dart';
import 'package:cart_mate/utils/app_strings.dart';
import 'package:cart_mate/widgets/button_widgets.dart';
import 'package:cart_mate/widgets/loading_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../services/responsive.dart';
import '../widgets/animated_toggle.dart';
import '../widgets/menu_card.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  _HomeViewState createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  late final HomeController controller;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    controller = Get.put(HomeController());
    controller.menuList.addAll([
      {
        "name": "karthi",
        "mateName": "kayan",
        "isList": true
      },{
        "name": "SEO",
        "mateName": "kayan",
        "isList": false
      },{
        "name": "sound",
        "mateName": "SUN",
        "isList": false
      },{
        "name": "rajesh",
        "mateName": "kamatchi",
        "isList": true
      },{
        "name": "karthi rk",
        "mateName": "kayan",
        "isList": false
      }
    ]);
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.white,
        leadingWidth:40,
        leading: InkWell(
          onTap: () {

          },
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: SizedBox( height: 24, width: 24, child: Image.asset("assets/images/menu.png",)),
          ),
        ),
        title: Center(child: const Text(AppStrings.appName, style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),)),
      ),
      body: Obx(
        ()=> Stack(
          children: [
            // Moving background image
            AnimatedPositioned(
              duration: Duration(milliseconds: 300),
              curve: Curves.easeInOut,
              left: controller.selectedTabIndex.value == 0 ? 0 : Responsive.getWidth(context)/2,
              child: Container(
                width: Responsive.getWidth(context)/2,
                height: Responsive.getHeight(context),
                decoration: BoxDecoration(
                  color: AppColors.bgTabSider,
                  borderRadius: BorderRadius.circular(30),
                ),
              ),
            ),
            Image.asset('assets/images/animatedBgWhite.png', fit: BoxFit.cover, width: Responsive.getWidth(context), height: Responsive.getHeight(context),),
            Column(
              children: [
                Row(
                  children: [
                    Flexible(
                      flex: 1,
                      child: InkWell(
                        focusColor: AppColors.transparent,
                        highlightColor: AppColors.transparent,
                        splashColor: AppColors.transparent,
                        hoverColor: AppColors.transparent,

                        onTap: (){
                          controller.selectedTabIndex.value = 0;
                        },
                        child: Container(margin: EdgeInsets.symmetric(vertical: 10), width: double.maxFinite,child: Center(child: Text(AppStrings.myList, style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500),)),),
                      ),
                    ),
                    Flexible(
                      flex: 1,
                      child: InkWell(
                        focusColor: AppColors.transparent,
                        highlightColor: AppColors.transparent,
                        splashColor: AppColors.transparent,
                        hoverColor: AppColors.transparent,

                        onTap: (){
                          controller.selectedTabIndex.value = 1;
                        },
                        child: Container(margin: EdgeInsets.symmetric(vertical: 10),width: double.maxFinite,child: Center(child: Text(AppStrings.matesList, style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500),)),),
                      ),
                    )
                  ],
                ),
                Expanded(
                  child: ListView.builder(
                    itemCount: controller.menuList.length,
                    itemBuilder: (context, index) {
                    return Padding(padding: EdgeInsetsGeometry.only(bottom: index == (controller.menuList.length-1)? 170: 0), child: MenuCard(isList: controller.menuList[index]["isList"],mateName: controller.menuList[index]["mateName"], name: controller.menuList[index]["name"], onDelete: () { controller.menuList.removeAt(index); }, ));
                  },),
                )
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
                  BoxShadow(color: Colors.black26, blurRadius: 8, offset: Offset(0, 4)),
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  BasicButtonWidget(
                    elevation: true,
                    color: AppColors.listBg,
                    onPressed: () {

                    },
                    labelColor: AppColors.black,
                    label: AppStrings.addList,
                  ),
                  SizedBox(height: 10,),
                  BasicButtonWidget(
                    elevation: true,
                    color: AppColors.menuBg,
                    onPressed: () {

                    },
                    labelColor: AppColors.black,
                    label: AppStrings.addItem,
                  ),
                ],
              ),

            )),
            if (controller.isLoading.value)
              Positioned.fill(
                child: Container(
                    color: AppColors.popupBG,
                    child: LoadingWidget.loader()
                ),
              ),
          ],
        ),
      )
    );
  }
}