import 'package:flutter/material.dart';
import 'package:hr_plus/core/core.dart';
import 'package:hr_plus/presentation/language/bloc/language_cubit.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  const CustomAppBar({
    super.key,
    required this.title,
    this.isBackBtn = false,
    this.actions = const [],

    this.bottom,
    this.hasBottom = true,
    this.centerTitle,
    this.toolbarHeight = kToolbarHeight,
    this.backgroundColor,
  });

  final String title;
  final bool? isBackBtn;
  final bool? hasBottom;
  final bool? centerTitle;
  final Color? backgroundColor;

  final List<Widget> actions;
  final PreferredSizeWidget? bottom;

  final double toolbarHeight;

  @override
  Size get preferredSize => Size.fromHeight(toolbarHeight);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: BlocBuilder<LanguageCubit, LanguageState>(
        builder: (context, state) {
          return Localizations.override(
            context: context,
            child: Text(title.tr()),
          );
        },
      ),
      centerTitle: centerTitle,
      backgroundColor: backgroundColor,
      elevation: 1,

      leading: isBackBtn!
          ? Container(
              decoration: BoxDecoration(shape: BoxShape.circle),
              padding: const EdgeInsets.all(4),
              child: InkWell(
                onTap: () {
                  context.pop();
                },

                borderRadius: BorderRadius.circular(50),
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: SvgPicture.asset(Assets.back),
                ),
              ),
            )
          : null,
      actions: actions,
      bottom:
          bottom ??
          (hasBottom == true
              ? PreferredSize(
                  preferredSize: Size(double.infinity, 1),
                  child: Divider(
                    height: 1,
                    thickness: 1,
                    color: AppColors.neutral100,
                  ),
                )
              : null),
    );
  }
}
