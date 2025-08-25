import 'package:cart_mate/controllers/forgot_password_controller.dart';
import 'package:cart_mate/utils/app_colors.dart';
import 'package:cart_mate/utils/app_input_formatters.dart';
import 'package:cart_mate/utils/app_strings.dart';
import 'package:cart_mate/utils/app_validators.dart';
import 'package:cart_mate/widgets/background_image_widget.dart';
import 'package:cart_mate/widgets/button_widgets.dart';
import 'package:cart_mate/widgets/loading_widget.dart';
import 'package:cart_mate/widgets/text_field_widgets.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';
import '../utils/app_images.dart';
import '../widgets/glassmorphic_card_widget.dart';

class ForgotPasswordView extends StatefulWidget {
  const ForgotPasswordView({super.key});

  @override
  State<ForgotPasswordView> createState() => _ForgotPasswordViewState();
}

class _ForgotPasswordViewState extends State<ForgotPasswordView> {

  late final ForgotPasswordController controller;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    controller = Get.put(ForgotPasswordController());
    controller.emailController.text = "";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Obx(
        ()=> Stack(
          children: [
            BackgroundImageWidget(
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: GlassmorphicCardWidget(
                    height: 340,
                    child: Form(
                      key: controller.formKey,
                      child: Padding(
                        padding: EdgeInsets.only(left: 20, right: 20),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              AppStrings.forgotPasswordTitle, // "Forgot Password?"
                              style: TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            Text(
                              AppStrings
                                  .forgotPasswordSubtitle,
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                            const SizedBox(height: 20),
                            TextFieldWidget(
                              isBorderNeeded: true,
                              hasHindOnTop: true,
                              suffixIcon: Padding(
                                padding: const EdgeInsets.only(left: 10, right: 10),
                                child: Icon(Icons.mail_outline_outlined, size: 18),
                              ),
                              inputFormatters: AppInputFormatters.email(),
                              onChanged: (p0) {},
                              validator: AppValidators.email,
                              hint: AppStrings.email,
                              controller: controller.emailController,
                            ),
                            const SizedBox(height: 30),
                            BasicButtonWidget(
                              onPressed: () {
                                if (controller.formKey.currentState!.validate()) {
                                  FocusScope.of(context).unfocus();
                                  controller.forgotPasswordApi(context);
                                }
                              },
                              label: AppStrings.sendOtp,
                            ),
                            const SizedBox(height: 15),
                            Align(
                              alignment: Alignment.center,
                              child: InkWell(
                                onTap: () {
                                  Navigator.pop(context);
                                },
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(
                                    'Back to Login',
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w700,
                                    ).copyWith(color: AppColors.primary),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
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
    );
  }
}
