
class Endpoints {
  static String get baseUrl => 'https://cart-mate-api.onrender.com';
  // static String get baseUrl => 'http://localhost:3000';

  // auth
  static String get login => '/auth/login';
  static String get update => '/auth/update';
  static String get delete => '/auth/delete-account/';
  static String get resendOtp => '/auth/resend-otp';
  static String get signUp => '/auth/sign-up';
  static String get verifyOtp => '/auth/verify-otp';
  static String get forgotPassword => '/auth/forgot-password/';
  static String get changePassword => '/auth/change-password';

  // mate
  static String get addMate => '/mates/add';
  static String get getMates => '/mates/list/';
  static String get deleteMate => '/mates/delete';


}