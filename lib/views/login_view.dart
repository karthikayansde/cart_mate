import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:cart_mate/controllers/login_controller.dart';
import 'package:cart_mate/utils/app_colors.dart';
import 'package:cart_mate/utils/app_strings.dart';
import 'package:cart_mate/utils/app_validators.dart';
import 'package:cart_mate/views/forgot_password_view.dart';
import 'package:cart_mate/views/signup_view.dart';
import 'package:cart_mate/widgets/background_image_widget.dart';
import 'package:cart_mate/widgets/button_widgets.dart';
import 'package:cart_mate/widgets/loading_widget.dart';
import 'package:cart_mate/widgets/snack_bar_widget.dart';
import 'package:cart_mate/widgets/text_field_widgets.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../utils/app_input_formatters.dart';
import '../widgets/glassmorphic_card_widget.dart';

class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {

  late final LoginController controller;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    controller = Get.put(LoginController());
    controller.emailController.text = "";
    controller.passwordController.text = "";
    controller.isPasswordHidden.value = true;
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
                    height: 480,
                    child: Form(
                      key: controller.formKey,
                      child: Padding(
                        padding: EdgeInsets.only(left: 20, right: 20),
                        child: Obx(
                          () => Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                AppStrings.welcomeBack,
                                style: TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                              Text(
                                AppStrings.plsEnterMailPassword,
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
                                        : Icon(Icons.visibility_off_outlined, size: 18),
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
                              Align(
                                alignment: Alignment.centerRight,
                                child: InkWell(
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => ForgotPasswordView(),
                                      ),
                                    );
                                  },
                                  child: Text(
                                    AppStrings.forgotPassword,
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w700,
                                    ).copyWith(color: AppColors.primary),
                                  ),
                                ),
                              ),
                              const SizedBox(height: 15),
                              InkWell(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => SignupView(),
                                    ),
                                  );
                                },
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Text(
                                      AppStrings.dontHaveAnAccount,
                                      style: TextStyle(
                                        fontSize: 16,
                                        height: 1.6,
                                        color: AppColors.black,
                                        letterSpacing: 0.2,
                                      ),
                                    ),
                                    const SizedBox(width: 8),
                                    Text(
                                      AppStrings.signup,
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
                                  if (controller.formKey.currentState!.validate()) {
                                    FocusScope.of(context).unfocus();
                                    await controller.loginApi(context);
                                  }
                                },
                                label: AppStrings.login,
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
                  child: LoadingWidget.loader()
                ),
              ),
          ],
        ),
      ),
    );
  }
}
