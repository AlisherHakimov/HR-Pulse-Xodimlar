import 'package:flutter/material.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:io';

class UpdateService {
  static const String androidAppId = 'com.example.yourapp';
  static const String iosAppId = '123456789'; // Your App Store ID

  // For custom update server
  static const String updateCheckUrl = 'https://your-server.com/api/check-update';

  /// Check for updates using Play Store/App Store APIs
  static Future<UpdateInfo?> checkStoreUpdate() async {
    try {
      PackageInfo packageInfo = await PackageInfo.fromPlatform();
      String currentVersion = packageInfo.version;
      String? latestVersion;
      String? updateUrl;

      if (Platform.isAndroid) {
        // Check Google Play Store
        final response = await http.get(
          Uri.parse('https://play.google.com/store/apps/details?id=$androidAppId'),
        );

        if (response.statusCode == 200) {
          // Parse HTML to extract version (this is a simplified approach)
          // In production, consider using proper HTML parsing
          final versionRegex = RegExp(r'Current Version.*?>([\d\.]+)<');
          final match = versionRegex.firstMatch(response.body);
          latestVersion = match?.group(1);
          updateUrl = 'https://play.google.com/store/apps/details?id=$androidAppId';
        }
      } else if (Platform.isIOS) {
        // Check App Store
        final response = await http.get(
          Uri.parse('https://itunes.apple.com/lookup?id=$iosAppId'),
        );

        if (response.statusCode == 200) {
          final data = json.decode(response.body);
          if (data['resultCount'] > 0) {
            latestVersion = data['results'][0]['version'];
            updateUrl = data['results'][0]['trackViewUrl'];
          }
        }
      }

      if (latestVersion != null && _isNewVersionAvailable(currentVersion, latestVersion)) {
        return UpdateInfo(
          currentVersion: currentVersion,
          latestVersion: latestVersion,
          updateUrl: updateUrl!,
          isUpdateAvailable: true,
        );
      }
    } catch (e) {
      print('Error checking for updates: $e');
    }

    return null;
  }

  /// Check for updates using custom server
  static Future<UpdateInfo?> checkCustomUpdate() async {
    try {
      PackageInfo packageInfo = await PackageInfo.fromPlatform();
      String currentVersion = packageInfo.version;
      String platform = Platform.isAndroid ? 'android' : 'ios';

      final response = await http.post(
        Uri.parse(updateCheckUrl),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'currentVersion': currentVersion,
          'platform': platform,
        }),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);

        if (data['updateAvailable'] == true) {
          return UpdateInfo(
            currentVersion: currentVersion,
            latestVersion: data['latestVersion'],
            updateUrl: data['downloadUrl'],
            isUpdateAvailable: true,
            isForced: data['isForced'] ?? false,
            releaseNotes: data['releaseNotes'],
          );
        }
      }
    } catch (e) {
      print('Error checking for custom updates: $e');
    }

    return null;
  }

  static bool _isNewVersionAvailable(String currentVersion, String latestVersion) {
    List<int> current = currentVersion.split('.').map(int.parse).toList();
    List<int> latest = latestVersion.split('.').map(int.parse).toList();

    // Ensure both lists have the same length
    while (current.length < latest.length) current.add(0);
    while (latest.length < current.length) latest.add(0);

    for (int i = 0; i < current.length; i++) {
      if (latest[i] > current[i]) return true;
      if (latest[i] < current[i]) return false;
    }
    return false;
  }

  static Future<void> launchUpdate(String updateUrl) async {
    final Uri url = Uri.parse(updateUrl);
    if (await canLaunchUrl(url)) {
      await launchUrl(url, mode: LaunchMode.externalApplication);
    } else {
      throw 'Could not launch $updateUrl';
    }
  }
}

class UpdateInfo {
  final String currentVersion;
  final String latestVersion;
  final String updateUrl;
  final bool isUpdateAvailable;
  final bool isForced;
  final String? releaseNotes;

  UpdateInfo({
    required this.currentVersion,
    required this.latestVersion,
    required this.updateUrl,
    required this.isUpdateAvailable,
    this.isForced = false,
    this.releaseNotes,
  });
}


class UpdateChecker extends StatefulWidget {
  const UpdateChecker({Key? key}) : super(key: key);

  @override
  State<UpdateChecker> createState() => _UpdateCheckerState();
}

class _UpdateCheckerState extends State<UpdateChecker> {
  UpdateInfo? updateInfo;
  bool isCheckingUpdate = false;

  @override
  void initState() {
    super.initState();
    checkForUpdatesAutomatically();
  }

  Future<void> checkForUpdatesAutomatically() async {
    // Check for updates when app starts
    await Future.delayed(const Duration(seconds: 2)); // Delay to avoid interfering with app startup
    await checkForUpdates(showNoUpdateDialog: false);
  }

  Future<void> checkForUpdates({bool showNoUpdateDialog = true}) async {
    setState(() {
      isCheckingUpdate = true;
    });

    try {
      // Try store update first, fallback to custom update
      UpdateInfo? info = await UpdateService.checkStoreUpdate();
      info ??= await UpdateService.checkCustomUpdate();

      setState(() {
        updateInfo = info;
        isCheckingUpdate = false;
      });

      if (info != null && info.isUpdateAvailable) {
        _showUpdateDialog(info);
      } else if (showNoUpdateDialog) {
        _showNoUpdateDialog();
      }
    } catch (e) {
      setState(() {
        isCheckingUpdate = false;
      });

      if (showNoUpdateDialog) {
        _showErrorDialog('Failed to check for updates: $e');
      }
    }
  }

  void _showUpdateDialog(UpdateInfo info) {
    showDialog(
      context: context,
      barrierDismissible: !info.isForced, // Can't dismiss if forced update
      builder: (context) => AlertDialog(
        title: Text(info.isForced ? 'Required Update' : 'Update Available'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Current Version: ${info.currentVersion}'),
            Text('Latest Version: ${info.latestVersion}'),
            if (info.releaseNotes != null) ...[
              const SizedBox(height: 16),
              const Text('Release Notes:', style: TextStyle(fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              Text(info.releaseNotes!),
            ],
          ],
        ),
        actions: [
          if (!info.isForced)
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Later'),
            ),
          ElevatedButton(
            onPressed: () async {
              Navigator.of(context).pop();
              try {
                await UpdateService.launchUpdate(info.updateUrl);
              } catch (e) {
                _showErrorDialog('Failed to open update: $e');
              }
            },
            child: const Text('Update Now'),
          ),
        ],
      ),
    );
  }

  void _showNoUpdateDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('No Updates'),
        content: const Text('You are using the latest version of the app.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Error'),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Update Checker Demo'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (updateInfo != null) ...[
              Card(
                margin: const EdgeInsets.all(16),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: [
                      Text('Current Version: ${updateInfo!.currentVersion}'),
                      if (updateInfo!.isUpdateAvailable) ...[
                        Text('Latest Version: ${updateInfo!.latestVersion}'),
                        const SizedBox(height: 8),
                        ElevatedButton(
                          onPressed: () => _showUpdateDialog(updateInfo!),
                          child: const Text('Update Available'),
                        ),
                      ] else
                        const Text('App is up to date'),
                    ],
                  ),
                ),
              ),
            ],
            ElevatedButton(
              onPressed: isCheckingUpdate ? null : () => checkForUpdates(),
              child: isCheckingUpdate
                  ? const Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SizedBox(
                    width: 16,
                    height: 16,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  ),
                  SizedBox(width: 8),
                  Text('Checking...'),
                ],
              )
                  : const Text('Check for Updates'),
            ),
          ],
        ),
      ),
    );
  }
}