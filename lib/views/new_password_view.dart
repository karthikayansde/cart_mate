import 'package:cart_mate/utils/app_colors.dart';
import 'package:cart_mate/utils/app_strings.dart';
import 'package:cart_mate/widgets/button_widgets.dart';
import 'package:cart_mate/widgets/text_field_widgets.dart';
import 'package:flutter/material.dart';

import '../utils/app_images.dart';
import '../widgets/glassmorphic_card_widget.dart';

class NewPasswordView extends StatefulWidget {
  const NewPasswordView({super.key});

  @override
  State<NewPasswordView> createState() => _NewPasswordViewState();
}

class _NewPasswordViewState extends State<NewPasswordView> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _newPasswordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();

  @override
  void dispose() {
    _newPasswordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          /// Background image
          SizedBox(
            height: double.maxFinite,
            width: double.maxFinite,
            child: Image.asset(AppImages.bg, fit: BoxFit.cover),
          ),

          Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: GlassmorphicCardWidget(
                height: 430,
                child: Form(
                  key: _formKey,
                  child: Padding(
                    padding: EdgeInsets.only(left: 20, right: 20),
                    child: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            AppStrings.newPasswordTitle, // "Set a New Password"
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          Text(
                            AppStrings
                                .newPasswordSubtitle, // "Create a new, strong password for your account."
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                          const SizedBox(height: 20),
                          TextFieldWidget(
                            isBorderNeeded: true,
                            hasHindOnTop: true,
                            suffixIcon: InkWell(
                              onTap: () {
                                // Implement password visibility toggle if needed
                              },
                              child: Padding(
                                padding: const EdgeInsets.only(
                                  left: 10,
                                  right: 10,
                                ),
                                child: Icon(
                                  Icons.visibility_outlined,
                                  size: 18,
                                ),
                              ),
                            ),
                            maxLines: 1,
                            onChanged: (p0) {},
                            controller: _newPasswordController,
                            hint: AppStrings.newPassword, // "New Password"
                          ),
                          TextFieldWidget(
                            isBorderNeeded: true,
                            hasHindOnTop: true,
                            suffixIcon: InkWell(
                              onTap: () {
                                // Implement password visibility toggle if needed
                              },
                              child: Padding(
                                padding: const EdgeInsets.only(
                                  left: 10,
                                  right: 10,
                                ),
                                child: Icon(
                                  Icons.visibility_outlined,
                                  size: 18,
                                ),
                              ),
                            ),
                            maxLines: 1,
                            onChanged: (p0) {},
                            controller: _confirmPasswordController,
                            hint: AppStrings
                                .confirmPassword, // "Confirm Password"
                          ),
                          const SizedBox(height: 30),

                          BasicButtonWidget(
                            onPressed: () {},
                            label: AppStrings.savePassword,
                          ),
                          const SizedBox(height: 15),
                          Align(
                            alignment: Alignment.center,
                            child: InkWell(
                              onTap: () {
                                // Navigate back to the login screen
                              },
                              child: Text(
                                AppStrings.backToLogin,
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w700,
                                ).copyWith(color: AppColors.primary),
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
        ],
      ),
    );
  }
}
