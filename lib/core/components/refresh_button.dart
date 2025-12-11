import 'package:flutter/material.dart';

import '../core.dart';

class RefreshButton extends StatelessWidget {
  const RefreshButton({super.key, this.message = '', this.onRefresh});

  final String message;

  final Function()? onRefresh;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            message,
            style: const TextStyle(
              color: Color(0xFF6C6C6F),
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
          ),
          IconButton(
            onPressed: onRefresh,
            icon: const Icon(
              Icons.refresh,
              size: 32,
              color: AppColors.primary,
            ),
          )
        ],
      ),
    );
  }
}
