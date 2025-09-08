import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:cart_mate/controllers/home_controller.dart';
import 'package:cart_mate/services/shared_pref_manager.dart';
import 'package:cart_mate/utils/app_colors.dart';
import 'package:cart_mate/utils/app_strings.dart';
import 'package:cart_mate/views/item_view.dart';
import 'package:cart_mate/views/menu_list_view.dart';
import 'package:cart_mate/views/side_drawer_view.dart';
import 'package:cart_mate/widgets/button_widgets.dart';
import 'package:cart_mate/widgets/loading_widget.dart';
import 'package:cart_mate/widgets/snack_bar_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/mates_controller.dart';
import '../models/items_model.dart';
import '../services/responsive.dart';
import '../utils/app_routes.dart';
import '../widgets/menu_card.dart';
import 'mates_view.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  _HomeViewState createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  late final HomeController controller;
  late final MatesController matesController;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    controller = Get.put(HomeController());
    matesController = Get.put(MatesController());
    init();
  }
  Future<void> init() async {
    controller.isLoading.value = true;
    controller.id.value = (await SharedPrefManager.instance.getStringAsync(SharedPrefManager.id) ?? '');
    await controller.getItemsApi(context);
    controller.isLoading.value = false;
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        backgroundColor: AppColors.white,
        leadingWidth:40,
        leading: InkWell(
          onTap: () {
            _scaffoldKey.currentState?.openDrawer();
          },
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: SizedBox( height: 24, width: 24, child: Image.asset("assets/images/menu.png",)),
          ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 4.0),
            child: IconButton(onPressed: () async {
              if(!controller.isLoading.value){
                await init();
              }
            }, icon: Image.asset("assets/images/refresh.png", height: 30,)),
          )
        ],
        title: Center(child: Padding(
          padding: const EdgeInsets.only(left: 20.0),
          child: const Text(AppStrings.appName, style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),),
        )),
      ),
        drawer: SideDrawerView(),
      body: SafeArea(
        child: Obx(
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
                          child: Container(margin: EdgeInsets.symmetric(vertical: 10), width: double.maxFinite,child: Center(child: Text(AppStrings.myList, style: TextStyle(fontSize: 24, fontWeight: FontWeight.w500),)),),
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
                          child: Container(margin: EdgeInsets.symmetric(vertical: 10),width: double.maxFinite,child: Center(child: Text(AppStrings.matesList, style: TextStyle(fontSize: 24, fontWeight: FontWeight.w500),)),),
                        ),
                      )
                    ],
                  ),
                  Expanded(
                    child:
                    controller.selectedTabIndex.value == 0 ?RefreshIndicator(
                      onRefresh: () async {
                        await controller.getItemsApi(context);
                      },
                      child: controller.myList.isEmpty? Padding(
                          padding: EdgeInsetsGeometry.only(left: 10, right: 10, bottom: 200),
                          child: Center(child: Text(AppStrings.noItems,textAlign: TextAlign.center, style: TextStyle(fontSize: 18, color: AppColors.black, fontWeight: FontWeight.w500),)))  : ListView.builder(
                        itemCount: controller.myList.length,
                        itemBuilder: (context, index) {
                          return Padding(padding: EdgeInsetsGeometry.only(bottom: index == (controller.myList.length-1)? 120: 0), child: MenuCard(
                            onStatusUpdate: () async {
                              return await controller.updateStatus(context, controller.myList[index].sId!);
                            },
                            onEdit: () {
                              Navigator.push(context, AppRoutes.transparentRoute(ItemView(isEdit: true, mate: controller.myList[index],)));
                            },
                            isMate: false, mate: controller.myList[index],
                            onDelete: () async {
                              if((controller.myList[index].createdBy!.sId??'') == controller.id.value){
                                await controller.deleteItemApi(context, controller.myList[index].sId!, (){controller.myList.removeAt(index);});
                              }else{
                                SnackBarWidget.show(
                                  context,
                                  title: AppStrings.actionRestricted,
                                  message: AppStrings.creatorCanDelete,
                                  contentType: ContentType.warning,
                                );
                              }
                            },
                          ));
                        },),
                    ):RefreshIndicator(
                      onRefresh: () async {
                        await controller.getItemsApi(context);
                      },
                      child: controller.mateList.isEmpty? Padding(
                          padding: EdgeInsetsGeometry.only(left: 10, right: 10, bottom: 200),
                          child: Center(child: Text(AppStrings.noItems,textAlign: TextAlign.center, style: TextStyle(fontSize: 18, color: AppColors.black, fontWeight: FontWeight.w500),)))
                          : ListView.builder(
                        itemCount: controller.mateList.length,
                        itemBuilder: (context, index) {
                          return Padding(padding: EdgeInsetsGeometry.only(bottom: index == (controller.mateList.length-1)? 120: 0), child: MenuCard(
                            onStatusUpdate: () async {
                              return false;
                            },
                            onEdit: () {
                              Navigator.push(context, AppRoutes.transparentRoute(ItemView(isEdit: true, mate: controller.mateList[index],)));},
                            isMate: true, mate: controller.mateList[index],
                            onDelete: () async { await controller.deleteItemApi(context, controller.mateList[index].sId!, (){controller.mateList.removeAt(index);}); }, ));
                        },),
                    ),),
                ],
              ),
              Positioned(
                  bottom: 20,
                  right: 20,
                  child: controller.selectedTabIndex.value == 0?
                //   Container(
                // padding: EdgeInsets.all(15),
                // width: 190,
                // decoration: ShapeDecoration(
                //   color: AppColors.white,
                //   shape: ContinuousRectangleBorder(
                //     borderRadius: BorderRadius.circular(60.0),
                //   ),
                //   shadows: const [
                //     BoxShadow(color: Colors.black26, blurRadius: 8, offset: Offset(0, 4)),
                //   ],
                // ),
                // child: Column(
                //   mainAxisSize: MainAxisSize.min,
                //   children: [
                    // BasicButtonWidget(
                    //   elevation: true,
                    //   color: AppColors.listBg,
                    //   onPressed: () async {
                    //     await addInit();
                    //     Navigator.push(
                    //       context,
                    //       AppRoutes.transparentRoute(
                    //         MenuListView()
                    //       ),
                    //     );
                    //   },
                    //   labelColor: AppColors.black,
                    //   label: AppStrings.addList,
                    // ),
                    // SizedBox(height: 10,),
                    BasicButtonWidget(
                      width: 130,
                      elevation: true,
                      color: AppColors.menuBg,
                      onPressed: (){
                        Navigator.push(
                          context,
                          AppRoutes.transparentRoute(
                              ItemView(isEdit: false, mate: Data(),)
                          ),
                        );
                      },
                      labelColor: AppColors.black,
                      label: AppStrings.addItem,
                    )
              //     ],
              //   ),
              //
              // )
          :
                  BasicButtonWidget(
                    width: 130,
                    elevation: true,
                    color: AppColors.menuBg,
                    onPressed: () {
                      Navigator.push(context, MaterialPageRoute(builder: (context) => MatesView(),));
                    },
                    labelColor: AppColors.black,
                    label: AppStrings.mates,
                  ),
              ),
              if (controller.isLoading.value)
                Positioned.fill(
                  child: Container(
                      color: AppColors.popupBG,
                      child: LoadingWidget.loader()
                  ),
                ),
            ],
          ),
        ),
      )
    );
  }
}