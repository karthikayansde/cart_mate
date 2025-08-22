import 'package:cart_mate/utils/app_colors.dart';
import 'package:cart_mate/utils/app_strings.dart';
import 'package:cart_mate/widgets/button_widgets.dart';
import 'package:cart_mate/widgets/text_field_widgets.dart';
import 'package:flutter/material.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

class OtpVerificationView extends StatefulWidget {
  const OtpVerificationView({super.key});

  @override
  State<OtpVerificationView> createState() => _OtpVerificationViewState();
}

class _OtpVerificationViewState extends State<OtpVerificationView> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _otpController = TextEditingController();

  @override
  void dispose() {
    _otpController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(

        borderRadius: BorderRadius.circular(20),

      ),
      child: SizedBox(
        width: 340,
        height: 380,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Form(
            key: _formKey,
            child: Padding(
              padding: EdgeInsets.only(left: 20, right: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    AppStrings.otpVerificationTitle, // "OTP Verification"
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  Text(
                    AppStrings
                        .otpVerificationSubtitle, // "Enter the 6-digit code sent to your email."
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  const SizedBox(height: 20),
                  Align(
                    alignment: Alignment.center,
                    child: SizedBox(
                      width: 165,
                      child: PinCodeTextField(
                        controller: _otpController,
                        cursorColor: AppColors.primary,
                        length: 4,
                        appContext: context,
                        keyboardType: TextInputType.number,
                        onChanged: (value) => {},
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "Please enter OTP";
                          } else if (value.length < 4) {
                            return "OTP must be 4 digits";
                          }
                          return null;
                        },
                        pinTheme: PinTheme(
                          shape: PinCodeFieldShape.box,
                          borderWidth: .5,
                          borderRadius: BorderRadius.circular(5),
                          fieldHeight: 35,
                          fieldWidth: 30,
                          activeFillColor: Colors.white,
                          selectedFillColor: Colors.white,
                          inactiveFillColor: Colors.white,
                          activeColor: Colors.blue,
                          selectedColor: Colors.blue,
                          inactiveColor: Colors.black54,
                        ),
                      ),
                    ),
                  ),
                  // TextFieldWidget(
                  //   isBorderNeeded: true,
                  //   hasHindOnTop: true,
                  //   keyboardType: TextInputType.numberWithOptions(
                  //     signed: true,
                  //   ),
                  //   onChanged: (p0) {},
                  //   controller: _otpController,
                  //   hint: AppStrings.otpHint, // "Enter OTP"
                  // ),
                  const SizedBox(height: 30),

                  BasicButtonWidget(
                    onPressed: () {},
                    label: AppStrings.verifyAndProceed,
                  ),
                  const SizedBox(height: 15),
                  Align(
                    alignment: Alignment.center,
                    child: InkWell(
                      onTap: () {
                        // Handle resending the OTP code
                      },
                      child: Text(
                        'Resend Code',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                        ).copyWith(color: AppColors.primary),
                      ),
                    ),
                  ),
                  const SizedBox(height: 15),
                  Align(
                    alignment: Alignment.center,
                    child: InkWell(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: Text(
                        'Cancel',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                        ).copyWith(color: AppColors.black),
                      ),
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
