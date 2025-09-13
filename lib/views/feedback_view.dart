import 'package:cart_mate/controllers/add_mate_controller.dart';
import 'package:cart_mate/controllers/feedback_controller.dart';
import 'package:cart_mate/controllers/list_controller.dart';
import 'package:cart_mate/utils/app_colors.dart';
import 'package:cart_mate/utils/app_strings.dart';
import 'package:cart_mate/utils/app_validators.dart';
import 'package:cart_mate/widgets/button_widgets.dart';
import 'package:cart_mate/widgets/dropdown_widget.dart';
import 'package:cart_mate/widgets/loading_widget.dart';
import 'package:cart_mate/widgets/text_field_widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import '../controllers/update_controller.dart';
import '../utils/app_input_formatters.dart';


class FeedbackView extends StatefulWidget {
  const FeedbackView({super.key});

  @override
  _FeedbackViewState createState() => _FeedbackViewState();
}

class _FeedbackViewState extends State<FeedbackView> {
  late final FeedbackController controller;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    controller = Get.put(FeedbackController());
    controller.feedbackController.text = "";
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
        height: 280,
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
                    Text(AppStrings.helpFeedback, style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),),
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
                            maxLines: 3,radius: 20,
                            validator: AppValidators.feedback,
                            inputFormatters: [
                              AppInputFormatters.limitedText(maxLength: 255),
                              AppInputFormatters.lettersNumbersSpaceSymbolsFormat
                            ],
                            hint: AppStrings.enterYourFeedback,
                            controller: controller.feedbackController,
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
                                    await controller.saveApi(context);
                                  }
                                },
                                labelColor: AppColors.black,
                                label: AppStrings.send,
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
    );
  }
}