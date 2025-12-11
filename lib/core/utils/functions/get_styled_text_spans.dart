// import 'package:flutter/material.dart';
// import 'package:tema_shop_user_side/core/resources/colors.dart';
// import 'package:tema_shop_user_side/core/resources/typography.dart';
//
// List<TextSpan> getStyledTextSpans(String text, String place) {
//   // Split the text based on the placeholder
//   List<TextSpan> spans = [];
//   List<String> parts = text.split(place);
//
//   if (parts.length > 1) {
//     spans.add(TextSpan(
//       text: parts[0],
//       style: AppTypography.h3SemiBold.copyWith(color: AppColors.c10101A),
//     ));
//   }
//
//   spans.add(TextSpan(
//     text: place, // "Arzon Bozor"
//     style: AppTypography.h3SemiBold.copyWith(color: AppColors.primary),
//   ));
//
//   if (parts.length > 1 && parts[1].isNotEmpty) {
//     spans.add(TextSpan(
//       text: parts[1], // The text after "Arzon Bozor"
//       style: AppTypography.h3SemiBold.copyWith(color: AppColors.c10101A),
//     ));
//   }
//
//   return spans;
// }
