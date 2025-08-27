import 'package:cart_mate/controllers/add_mate_controller.dart';
import 'package:cart_mate/controllers/list_controller.dart';
import 'package:cart_mate/controllers/mates_controller.dart';
import 'package:cart_mate/utils/app_colors.dart';
import 'package:cart_mate/utils/app_input_formatters.dart';
import 'package:cart_mate/utils/app_strings.dart';
import 'package:cart_mate/utils/app_validators.dart';
import 'package:cart_mate/widgets/button_widgets.dart';
import 'package:cart_mate/widgets/dropdown_widget.dart';
import 'package:cart_mate/widgets/loading_widget.dart';
import 'package:cart_mate/widgets/text_field_widgets.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';


class AddMateView extends StatefulWidget {
  const AddMateView({super.key});

  @override
  _AddMateViewState createState() => _AddMateViewState();
}

class _AddMateViewState extends State<AddMateView> {
  late final AddMateController controller;
  late final MatesController matesController;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    controller = Get.put(AddMateController());
    matesController = Get.put(MatesController());
    controller.codeController.text = '';
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.popupBG,
      body: Center(
        child: Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          backgroundColor: Colors.white,
          child:
          SizedBox(
            height: 240,
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
                        Text(AppStrings.addMate, style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),),
                        Form(
                          key: controller.formKey,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              TextFieldWidget(
                                fillBgColor: true,
                                bgColor: AppColors.white,
                                isBorderNeeded: true,
                                hasHindOnTop: true,
                                inputFormatters: [
                                  AppInputFormatters.limitedText(maxLength: 6)
                                ],
                                onChanged: (p0) {},
                                validator: AppValidators.mateCode,
                                hint: AppStrings.matesCode,
                                controller: controller.codeController,
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
                                    onPressed: () async {
                                      if(controller.formKey.currentState!.validate()){
                                        await controller.addMateApi(context);
                                        await matesController.getMateApi(context);
                                      }
                                    },
                                    labelColor: AppColors.black,
                                    label: AppStrings.add,
                                  ),
                                ],
                              ),
                              SizedBox(height: 10,)

                            ],
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
        ),
      ),
    );
  }
}