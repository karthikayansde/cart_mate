import 'package:cart_mate/controllers/item_controller.dart';
import 'package:cart_mate/utils/app_colors.dart';
import 'package:cart_mate/utils/app_strings.dart';
import 'package:cart_mate/utils/app_validators.dart';
import 'package:cart_mate/widgets/button_widgets.dart';
import 'package:cart_mate/widgets/dropdown_widget.dart';
import 'package:cart_mate/widgets/loading_widget.dart';
import 'package:cart_mate/widgets/text_field_widgets.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/list_controller.dart';


class ItemView extends StatefulWidget {
  const ItemView({super.key});

  @override
  _ItemViewState createState() => _ItemViewState();
}

class _ItemViewState extends State<ItemView> {
  late final ItemController controller;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    controller = Get.put(ItemController());
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
         height: 520,
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
                    Text(AppStrings.addItem, style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),),
                    Expanded(
                      child: SingleChildScrollView(
                        scrollDirection: Axis.vertical,
                        child: Form(
                          key: controller.formKey,
                          child: Column(
                            children: [
                              TextFieldWidget(
                                fillBgColor: true,
                                bgColor: AppColors.white,
                                isBorderNeeded: true,
                                hasHindOnTop: true,
                                onChanged: (p0) {},
                                validator: AppValidators.name,
                                hint: AppStrings.itemName,
                                controller: controller.itemNameController,
                              ),
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  SizedBox(
                                    width: 130,
                                    child: TextFieldWidget(
                                      fillBgColor: true,
                                      bgColor: AppColors.white,
                                      isBorderNeeded: true,
                                      hasHindOnTop: true,
                                      onChanged: (p0) {},
                                      validator: AppValidators.name,
                                      hint: AppStrings.units,
                                      controller: controller.itemNameController,
                                    ),
                                  ),
                                  Spacer(),
                                  Padding(
                                    padding: EdgeInsetsGeometry.only(top: 30, left: 3),
                                    child: DropdownWidget(onChanged: (value) {
                      
                                    },list: ["asdf", "asdfasdf", "sdfgsg"],selectedTable: 0,),
                                  ),
                      
                                ],
                              ),
                          Row(crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
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
                              Spacer(),
                              Stack(
                                children: [
                                  Container(
                                    height: 74,
                                    width: 74,
                                    decoration:  ShapeDecoration(
                                      shape: ContinuousRectangleBorder(side: BorderSide(color: AppColors.black),
                                        borderRadius: BorderRadius.circular(40.0),
                                      ),
                                    ),
                                    child: ClipPath(
                                      clipper: ShapeBorderClipper(
                                        shape: ContinuousRectangleBorder(
                                          borderRadius: BorderRadius.circular(
                                            40.0,
                                          ), // Same as container
                                        ),
                                      ),
                                      child: Image.asset(
                                        "assets/images/defaultMenuImage.png",
                                        fit: BoxFit.cover,
                                        width: double.infinity,
                                        height: double.infinity,
                                      ),
                                    ),
                                  ),
                                  Positioned(child: Icon(Icons.change_circle, size: 24,), top: 0,right: 0,)
                                ],
                              ),
                            ],
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
                                    label: AppStrings.save,
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