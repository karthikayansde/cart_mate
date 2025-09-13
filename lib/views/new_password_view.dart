import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:cart_mate/controllers/new_password_controller.dart';
import 'package:cart_mate/utils/app_colors.dart';
import 'package:cart_mate/utils/app_strings.dart';
import 'package:cart_mate/utils/app_validators.dart';
import 'package:cart_mate/widgets/background_image_widget.dart';
import 'package:cart_mate/widgets/button_widgets.dart';
import 'package:cart_mate/widgets/loading_widget.dart';
import 'package:cart_mate/widgets/snack_bar_widget.dart';
import 'package:cart_mate/widgets/text_field_widgets.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../utils/app_input_formatters.dart';
import '../widgets/glassmorphic_card_widget.dart';

class NewPasswordView extends StatefulWidget {
  final bool fromForgotPassword;
  const NewPasswordView({super.key, required this.fromForgotPassword, });

  @override
  State<NewPasswordView> createState() => _NewPasswordViewState();
}

class _NewPasswordViewState extends State<NewPasswordView> {
  late final NewPasswordController controller;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    controller = Get.put(NewPasswordController());
    controller.passwordController.text = '';
    controller.confirmPasswordController.text = '';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: widget.fromForgotPassword?null:
      AppBar(
      backgroundColor: AppColors.white,
      leadingWidth: 40,
      automaticallyImplyLeading: false,
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
      body: Obx(
        () => Stack(
          children: [
            BackgroundImageWidget(
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: GlassmorphicCardWidget(
                    height: 400,
                    child: Form(
                      key: controller.formKey,
                      child: Padding(
                        padding: EdgeInsets.only(left: 20, right: 20),
                        child: SingleChildScrollView(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                AppStrings.newPasswordTitle,
                                style: TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                              Text(
                                AppStrings.newPasswordSubtitle,
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                              const SizedBox(height: 20),
                              TextFieldWidget(
                                isPassword: controller.isPasswordHidden.value,
                                isBorderNeeded: true,
                                hasHindOnTop: true,
                                validator: AppValidators.newPassword,
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
                                inputFormatters: [
                                  AppInputFormatters.limitedText(maxLength: 16),
                                  AppInputFormatters.lettersNumbersSymbolsFormat,
                                ],
                                controller: controller.passwordController,
                                hint: AppStrings.newPassword,
                              ),
                              TextFieldWidget(
                                isPassword: controller.isConfirmPasswordHidden.value,
                                isBorderNeeded: true,
                                hasHindOnTop: true,
                                validator: AppValidators.confirmPassword,
                                suffixIcon: InkWell(
                                  onTap: () {
                                    controller.isConfirmPasswordHidden.value =
                                        !controller.isConfirmPasswordHidden.value;

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
                                inputFormatters: [
                                  AppInputFormatters.limitedText(maxLength: 16),
                                  AppInputFormatters.lettersNumbersSymbolsFormat,
                                ],
                                controller:
                                    controller.confirmPasswordController,
                                hint: AppStrings.confirmPassword,
                              ),
                              const SizedBox(height: 30),

                              BasicButtonWidget(
                                onPressed: () async {
                                  if (controller.formKey.currentState!.validate()) {
                                    if (controller.passwordController.text != controller
                                            .confirmPasswordController
                                            .text) {
                                      SnackBarWidget.show(
                                        context,
                                        message: AppStrings.passwordMatch,
                                        contentType: ContentType.warning,
                                      );
                                    } else {
                                      FocusScope.of(context).unfocus();
                                      await controller.changePasswordApi(context, widget.fromForgotPassword);
                                    }
                                  }
                                },
                                label: AppStrings.savePassword,
                              ),
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
