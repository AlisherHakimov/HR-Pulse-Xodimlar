import 'package:flutter/material.dart';

import '../core.dart';

class AppButton extends StatelessWidget {
  const AppButton({
    super.key,
    this.onTap,
    this.background,
    this.isLoading = false,
    this.isDisabled = false,
    this.titleColor,
    this.borderRadius,
    this.disabledBackgroundColor,
    this.titleTextStyle,
    this.side = BorderSide.none,
    required this.title,
    this.height,
    this.prefix,
  });

  final Function()? onTap;
  final Color? background;
  final bool? isLoading;
  final bool? isDisabled;
  final String title;
  final Color? titleColor;
  final double? borderRadius;
  final Color? disabledBackgroundColor;
  final double? height;
  final TextStyle? titleTextStyle;
  final BorderSide side;
  final Widget? prefix;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: background ?? AppColors.primary,
        disabledBackgroundColor: disabledBackgroundColor,
        splashFactory: NoSplash.splashFactory,
        elevation: 0,
        padding: EdgeInsets.symmetric(horizontal: 12, vertical: 12),
        minimumSize: Size(MediaQuery.of(context).size.width - 32, height ?? 40),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(borderRadius ?? 6)),
          side: side,
        ),
      ),
      onPressed: (!(isDisabled ?? false) && isLoading != true) ? onTap : () {},
      child: isLoading!
          ? const SizedBox(
              height: 22,
              width: 22,
              child: CircularProgressIndicator(
                color: Colors.white,
                strokeWidth: 3,
              ),
            )
          : Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (prefix != null) prefix!,

                FittedBox(
                  child: Text(
                    title,
                    textAlign: TextAlign.center,
                    style:
                        titleTextStyle ??
                        TextStyle(
                          fontWeight: FontWeight.w500,
                          fontSize: 16  ,
                          color: titleColor ?? Colors.white,
                          height: 14/9
                        ),
                  ),
                ),
              ],
            ),
    );
  }
}

class CustomMaterialButton extends StatelessWidget {
  const CustomMaterialButton({
    super.key,
    this.onTap,
    this.color,
    required this.child,
    this.borderRadius,
    this.height,
    this.width,
    this.shape,
    this.padding,
    this.elevation,
  });

  final Function()? onTap;
  final Color? color;
  final Widget child;
  final double? borderRadius;
  final double? height;
  final double? width;
  final ShapeBorder? shape;
  final EdgeInsetsGeometry? padding;
  final double? elevation;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      height: height,
      child: MaterialButton(
        shape:
            shape ??
            RoundedRectangleBorder(
              borderRadius: BorderRadius.all(
                Radius.circular(borderRadius ?? 6),
              ),
            ),
        padding: padding ?? const EdgeInsets.all(0),
        height: height ?? 40,
        elevation: elevation ?? 0,
        highlightElevation: 0,
        color: color,
        onPressed: onTap,
        child: child,
      ),
    );
  }
}
