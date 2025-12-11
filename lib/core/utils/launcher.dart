import 'package:url_launcher/url_launcher.dart';

void launchPhone(String phoneNumber) async {
  final url =
      'tel:$phoneNumber'; // The "tel" URL scheme is used to initiate phone calls
  if (await canLaunchUrl(Uri.parse(url))) {
    await launchUrl(Uri.parse(url));
  } else {
    throw 'Could not launch phone dialer';
  }
}

void launchEmail(String email) async {
  final url =
      'mailto:$email'; // The "mailto" URL scheme is used to open the email client
  if (await canLaunchUrl(Uri.parse(url))) {
    await launchUrl(Uri.parse(url));
  } else {
    throw 'Could not launch email client';
  }
}
