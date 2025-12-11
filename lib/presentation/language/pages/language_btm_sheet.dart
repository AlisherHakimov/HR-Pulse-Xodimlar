// import 'package:flutter/material.dart';
// import 'package:hr_plus/presentation/language/pages/language_selection_page.dart';
//
// import '../../../core/core.dart';
//
// void showLanguageBottomSheet(BuildContext context) {
//   showModalBottomSheet(
//     context: context,
//     useSafeArea: false,
//     isScrollControlled: true,
//     showDragHandle: true,
//     builder: (context) {
//       return Padding(
//         padding: AppUtils.kPaddingHor16,
//         child: Column(
//           mainAxisSize: MainAxisSize.min,
//           children: [
//             Text(
//               'app_language'.tr(),
//               style: AppTypography.semibold20.copyWith(
//                 color: AppColors.blackText,
//               ),
//             ),
//             16.g,
//             LanguageSelectionBtn(lang: 'uz', color:  AppColors.white,),
//             8.g,
//             LanguageSelectionBtn(lang: 'ru',color:  AppColors.white,),
//             16.g,
//             SafeArea(child: SizedBox()),
//           ],
//         ),
//       );
//     },
//   );
// }
