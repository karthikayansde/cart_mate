import 'package:url_launcher/url_launcher.dart';
// add this in AndroidManifest.xml
// <queries>
// <intent>
// <action android:name="android.intent.action.VIEW" />
// <category android:name="android.intent.category.BROWSABLE" />
// <data android:scheme="https" />
// </intent>
// </queries>
class UrlOpener {
  static Future<bool> launch(String phUrl) async {
    final Uri url = Uri.parse(phUrl);
    if (await canLaunchUrl(url)) {
      return await launchUrl(url, mode: LaunchMode.externalApplication);
    } else {
      return false;
    }
  }
}