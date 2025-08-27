import 'package:cart_mate/services/responsive.dart';
import 'package:cart_mate/services/shared_pref_manager.dart';
import 'package:cart_mate/utils/app_colors.dart';
import 'package:cart_mate/utils/app_strings.dart';
import 'package:cart_mate/views/home_view.dart';
import 'package:cart_mate/views/login_view.dart';
import 'package:cart_mate/views/new_password_view.dart';
import 'package:cart_mate/views/signup_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';

Future<void> main() async {
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();

  // Keeps native splash ON until we remove it manually
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);
  final bool isLoggedIn = (await SharedPrefManager.instance.getBoolAsync(SharedPrefManager.isLoggedIn))??false;
  FlutterNativeSplash.remove();

  runApp(MyApp(isLoggedIn: isLoggedIn,));
}

class MyApp extends StatelessWidget {
  final bool isLoggedIn;
  const MyApp({super.key, required this.isLoggedIn});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: AppStrings.appName,
      theme: ThemeData(
        brightness: Brightness.light,
        fontFamily: 'M_PLUS_Rounded_1c',
        scaffoldBackgroundColor: AppColors.white,
        colorScheme: ColorScheme.fromSeed(
          seedColor: AppColors.primary,
          brightness: Brightness.light,
        ),
      ),
      // home: const SignupView(),
      home: isLoggedIn? HomeView(): const LoginView(),
      // home: HomeView(),
      // home: ForgotPasswordView()
      // home: NewPasswordView()
      // home: OtpVerificationView(),
    );
  }
}