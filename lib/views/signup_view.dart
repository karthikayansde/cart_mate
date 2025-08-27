import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:cart_mate/controllers/signup_controller.dart';
import 'package:cart_mate/utils/app_input_formatters.dart';
import 'package:cart_mate/utils/app_validators.dart';
import 'package:cart_mate/widgets/background_image_widget.dart';
import 'package:cart_mate/widgets/loading_widget.dart';
import 'package:cart_mate/widgets/snack_bar_widget.dart';
import 'package:get/get.dart';
import 'package:cart_mate/utils/app_colors.dart';
import 'package:cart_mate/utils/app_strings.dart';
import 'package:cart_mate/widgets/button_widgets.dart';
import 'package:cart_mate/widgets/text_field_widgets.dart';
import 'package:flutter/material.dart';

import '../utils/app_images.dart';
import '../widgets/glassmorphic_card_widget.dart';

class SignupView extends StatefulWidget {
  const SignupView({super.key});

  @override
  State<SignupView> createState() => _SignupViewState();
}

class _SignupViewState extends State<SignupView> {
  final controller = Get.put(SignupController());

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    controller.nameController.text = "";
    controller.emailController.text = "";
    controller.passwordController.text = "";
    controller.confirmPasswordController.text = "";
    controller.isPasswordHidden.value = true;
    controller.isConfirmPasswordHidden.value = true;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Obx(
        () => Stack(
          children: [
            BackgroundImageWidget(
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: GlassmorphicCardWidget(
                    // Increased height to accommodate all the new fields
                    height: 625,
                    child: SingleChildScrollView(
                      child: Form(
                        key: controller.formKey,
                        child: Padding(
                          padding: EdgeInsets.only(left: 20, right: 20),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const SizedBox(height: 20),
                              Text(
                                AppStrings.createAccount,
                                style: TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                              Text(
                                AppStrings.plsEnterDetailsToSignup,
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
                                  padding: const EdgeInsets.only(
                                    left: 10,
                                    right: 10,
                                  ),
                                  child: Icon(
                                    Icons.person_2_outlined,
                                    size: 18,
                                  ),
                                ),
                                onChanged: (p0) {},
                                validator: AppValidators.name,
                                controller: controller.nameController,
                                hint: AppStrings.name,
                              ),

                              TextFieldWidget(
                                isBorderNeeded: true,
                                hasHindOnTop: true,
                                suffixIcon: Padding(
                                  padding: const EdgeInsets.only(
                                    left: 10,
                                    right: 10,
                                  ),
                                  child: Icon(
                                    Icons.mail_outline_outlined,
                                    size: 18,
                                  ),
                                ),
                                inputFormatters: AppInputFormatters.email(),
                                onChanged: (p0) {},
                                validator: AppValidators.email,
                                hint: AppStrings.email,
                                controller: controller.emailController,
                              ),
                              TextFieldWidget(
                                isBorderNeeded: true,
                                hasHindOnTop: true,
                                isPassword: controller.isPasswordHidden.value,
                                suffixIcon: InkWell(
                                  onTap: () {
                                    controller.isPasswordHidden.value =
                                        !controller.isPasswordHidden.value;
                                  },
                                  child: Padding(
                                    padding: const EdgeInsets.only(
                                      left: 10,
                                      right: 10,
                                    ),
                                    child: controller.isPasswordHidden.value
                                        ? Icon(
                                            Icons.visibility_outlined,
                                            size: 18,
                                          )
                                        : Icon(
                                            Icons.visibility_off_outlined,
                                            size: 18,
                                          ),
                                  ),
                                ),
                                maxLines: 1,
                                onChanged: (p0) {},
                                inputFormatters: [
                                  AppInputFormatters.limitedText(maxLength: 16),
                                ],
                                validator: AppValidators.password,
                                hint: AppStrings.password,
                                controller: controller.passwordController,
                              ),

                              TextFieldWidget(
                                isBorderNeeded: true,
                                hasHindOnTop: true,
                                isPassword:
                                    controller.isConfirmPasswordHidden.value,
                                suffixIcon: InkWell(
                                  onTap: () {
                                    controller.isConfirmPasswordHidden.value =
                                        !controller
                                            .isConfirmPasswordHidden
                                            .value;
                                  },
                                  child: Padding(
                                    padding: const EdgeInsets.only(
                                      left: 10,
                                      right: 10,
                                    ),
                                    child:
                                        controller.isConfirmPasswordHidden.value
                                        ? Icon(
                                            Icons.visibility_outlined,
                                            size: 18,
                                          )
                                        : Icon(
                                            Icons.visibility_off_outlined,
                                            size: 18,
                                          ),
                                  ),
                                ),
                                maxLines: 1,
                                onChanged: (p0) {},
                                inputFormatters: [
                                  AppInputFormatters.limitedText(maxLength: 16),
                                ],
                                validator: AppValidators.confirmPassword,
                                hint: AppStrings.confirmPassword,
                                controller:
                                    controller.confirmPasswordController,
                              ),
                              const SizedBox(height: 10),
                              InkWell(
                                onTap: () {
                                  Navigator.pop(context);
                                },
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Text(
                                      AppStrings.alreadyHaveAnAccount,
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w700,
                                        height: 1.6,
                                        color: AppColors.black,
                                        letterSpacing: 0.2,
                                      ),
                                    ),
                                    const SizedBox(width: 8),
                                    Text(
                                      AppStrings.login,
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w700,
                                        height: 1.6,
                                        color: AppColors.primary,
                                        letterSpacing: 0.2,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(height: 30),
                              BasicButtonWidget(
                                onPressed: () async {
                                  if (controller.formKey.currentState!
                                      .validate()) {
                                    if (controller.passwordController.text !=
                                        controller
                                            .confirmPasswordController
                                            .text) {
                                      SnackBarWidget.show(
                                        context,
                                        message: AppStrings.passwordMatch,
                                        contentType: ContentType.warning,
                                      );
                                    } else {
                                      FocusScope.of(context).unfocus();
                                      await controller.signupApi(context);
                                    }
                                  }
                                },
                                label: AppStrings.signup,
                              ),
                              const SizedBox(height: 20),
                            ],
                          ),
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
                  child: LoadingWidget.loader(),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
