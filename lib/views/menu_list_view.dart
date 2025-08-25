import 'package:cart_mate/controllers/item_controller.dart';
import 'package:cart_mate/controllers/list_controller.dart';
import 'package:cart_mate/utils/app_colors.dart';
import 'package:cart_mate/utils/app_strings.dart';
import 'package:cart_mate/utils/app_validators.dart';
import 'package:cart_mate/widgets/button_widgets.dart';
import 'package:cart_mate/widgets/dropdown_widget.dart';
import 'package:cart_mate/widgets/loading_widget.dart';
import 'package:cart_mate/widgets/text_field_widgets.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';


class MenuListView extends StatefulWidget {
  const MenuListView({super.key});

  @override
  _MenuListViewState createState() => _MenuListViewState();
}

class _MenuListViewState extends State<MenuListView> {
  late final ListController controller;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    controller = Get.put(ListController());
  }
  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      backgroundColor: Colors.white,
      child:
      SizedBox(
        height: 420,
        child: Obx(
              ()=> Stack(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: Image.asset(
                  "assets/images/animatedBg.png",
                  fit: BoxFit.cover,
                  width: double.infinity,
                  height: double.maxFinite,
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: Column(

                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(AppStrings.addList, style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),),
                    Expanded(
                      child: SingleChildScrollView(
                        scrollDirection: Axis.vertical,
                        child: Form(
                          key: controller.formKey,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              TextFieldWidget(
                                fillBgColor: true,
                                bgColor: AppColors.white,
                                isBorderNeeded: true,
                                hasHindOnTop: true,
                                onChanged: (p0) {},
                                validator: AppValidators.name,
                                hint: AppStrings.listName,
                                controller: controller.listNameController,
                              ),

                              Padding(
                                padding: EdgeInsets.symmetric(vertical: 5.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.all(1.0),
                                      child: Text( AppStrings.tagMate, style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w500,
                                          color: AppColors.black
                                      ),),
                                    ),
                                    DropdownWidget(
                                      width: 180,
                                      onChanged: (value) {

                                      },list: ["asdf", "asdfasdfasdfasdf", "sdfgsg"],selectedTable: 1,),

                                  ],
                                ),
                              ),

                              TextFieldWidget(
                                fillBgColor: true,
                                bgColor: AppColors.white,
                                isBorderNeeded: true,
                                hasHindOnTop: true,
                                onChanged: (p0) {},
                                hint: AppStrings.addNote,
                                controller: controller.notesController,
                              ),
                              SizedBox(height: 20,),

                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                children: [
                                  BasicButtonWidget(
                                    width: 120,
                                    elevation: true,
                                    color: AppColors.listBg,
                                    onPressed: () {
                                      Navigator.pop(context);
                                    },
                                    labelColor: AppColors.black,
                                    label: AppStrings.cancel,
                                  ),
                                  SizedBox(height: 10,),
                                  BasicButtonWidget(
                                    width: 120,
                                    elevation: true,
                                    color: AppColors.menuBg,
                                    onPressed: () {
                                      if(controller.formKey.currentState!.validate()){

                                      }
                                    },
                                    labelColor: AppColors.black,
                                    label: AppStrings.create,
                                  ),
                                ],
                              ),
                              SizedBox(height: 10,)

                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
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
      ),
    );
  }
}