import 'dart:async';

import 'package:flutter/material.dart';
import 'package:hr_plus/main.dart';

import '../../core/core.dart';

class ConnectionPage extends StatefulWidget {
  const ConnectionPage({super.key});

  @override
  InternetConnectionScreenState createState() =>
      InternetConnectionScreenState();
}

class InternetConnectionScreenState extends State<ConnectionPage> {
  late bool isLoading = false;
  late Timer timer;

  @override
  void initState() {
    super.initState();
    timer = Timer.periodic(const Duration(seconds: 1), (_) {
      _updateConnectionStatus();
    });
  }

  Future<void> _updateConnectionStatus() async {
    if (await hasConnection()) {
      if (!mounted) {
        return;
      } else {
        navigatorKey.currentState?.pop();
      }
    }
  }

  @override
  void dispose() {
    timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => WillPopScope(
    onWillPop: () async => false,
    child: Scaffold(
      body: SizedBox(
        width: context.width,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // SvgPicture.asset(Assets.noInternet),
            32.g,
            Text(
              'no_internet'.tr(),
              style: const TextStyle(
                color: Colors.black,
                fontSize: 20,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              'check_connection'.tr(),
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: Color(0xff818C99),
                fontSize: 17,
                fontWeight: FontWeight.w400,
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: SafeArea(
        minimum: const EdgeInsets.all(16),
        child: AppButton(
          title: 'reload'.tr(),
          onTap: () async {
            setState(() {
              isLoading = true;
            });
            final isConnected = await hasConnection();
            setState(() {
              isLoading = false;
            });
            if (isConnected) {
              if (mounted) {
                return;
              } else {
                navigatorKey.currentState?.pop();
              }
            }
          },
        ),
      ),
    ),
  );
}
