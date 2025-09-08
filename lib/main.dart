import 'package:cart_mate/services/local_notification_service.dart';
import 'package:cart_mate/services/shared_pref_manager.dart';
import 'package:cart_mate/utils/app_colors.dart';
import 'package:cart_mate/utils/app_strings.dart';
import 'package:cart_mate/views/home_view.dart';
import 'package:cart_mate/views/login_view.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
Future<void> main() async {
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();

  // Keeps native splash ON until we remove it manually
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);
  final bool isLoggedIn = (await SharedPrefManager.instance.getBoolAsync(SharedPrefManager.isLoggedIn))??false;
  FlutterNativeSplash.remove();
  if(!kIsWeb){
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );

    NotificationService().initFCM();

    String? token = await FirebaseMessaging.instance.getToken();
    print("kkkis:$token kkkis");
    await LocalNotificationService().init();
  }

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
//------------------------
class NotificationService {
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;


  // Initialize FCM
  void initFCM() {
    // // Request permission (for iOS)
    // _firebaseMessaging.requestPermission();


    // Listen for foreground messages
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      print('Received message while in foreground: ${message.notification}');
      if (message.notification != null) {
        LocalNotificationService().showNotification(id: 0, title: message.notification!.title??'', body: message.notification!.body??'');
        print("${message.notification!.title},=== ${message.notification!.body}");
      }
    });
    // Handle background and terminated notifications
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      print("${message.notification!.title},=== ${message.notification!.body}");
    });
  }
}