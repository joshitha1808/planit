import 'package:url_launcher/url_launcher.dart';

import '../constants/app_constants.dart';

class GithubLauncher {
  Future<void> openGitHub() async {
    final Uri url = Uri.parse(AppConstants.githubUrl);
    if (!await launchUrl(url, mode: LaunchMode.externalApplication)) {
      throw Exception('Could not launch $url');
    }
  }
}
