import 'package:url_launcher/url_launcher.dart';

class UrlOpener {
  static Future<bool> launch(String phUrl) async {
    final Uri url = Uri.parse(phUrl);
    if (await canLaunchUrl(url)) {
      return await launchUrl(url);
    } else {
      return false;
    }
  }
}