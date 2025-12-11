import 'package:flutter/material.dart';

import '../core.dart';

class CustomCheckbox extends StatelessWidget {
  CustomCheckbox({super.key, required this.value, this.onChanged});

  final bool value;

  Function(bool value)? onChanged;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        onChanged?.call(!value);
      },

      child: Container(
        height: 18,
        width: 18,
        padding: const EdgeInsets.all(2),
        decoration: BoxDecoration(
          color: value ? AppColors.primary : AppColors.woodSmoke100,
          borderRadius: BorderRadius.circular(4),
        ),

        child: value
            ? Icon(Icons.check, size: 14, color: AppColors.white)
            : null,
      ),
    );
  }
}
