import 'package:url_launcher/url_launcher.dart';

Future<bool> launchPhone(String phone) async {
  final value = phone.trim();
  if (value.isEmpty) return false;
  final uri = Uri(scheme: 'tel', path: value);
  if (!await canLaunchUrl(uri)) return false;
  return launchUrl(uri, mode: LaunchMode.externalApplication);
}
