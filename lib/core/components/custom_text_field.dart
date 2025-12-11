import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../core.dart';

class CustomTextField extends StatefulWidget {
  const CustomTextField({
    super.key,
    this.autofillHints,
    this.controller,
    this.inputType,
    this.style,
    this.textAlign,
    this.prefixText,
    this.hintText,
    this.inputFormatter,
    this.onChanged,
    this.prefixIcon,
    this.suffixIcon,
    this.color,
    this.contentPadding,
    this.textInputAction,
    this.readOnly,
    this.validator,
    this.isObscureText,
    this.focusNode,
    this.maxLines = 1,
    this.maxLength,
    this.onTap,
    this.canRequestFocus,
    this.autoFocus = false,
    this.prefix,
    this.borderColor,
    this.borderRadius,
    this.hintStyle,
  });

  final TextStyle? hintStyle;
  final BorderRadius? borderRadius;
  final TextEditingController? controller;
  final TextInputType? inputType;
  final TextStyle? style;
  final TextAlign? textAlign;
  final String? hintText;
  final Function(String?)? onChanged;
  final List<TextInputFormatter>? inputFormatter;
  final bool? isObscureText;
  final String? Function(String?)? validator;
  final bool? readOnly;
  final EdgeInsets? contentPadding;
  final int? maxLines;
  final int? maxLength;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final TextInputAction? textInputAction;
  final Color? color;
  final Color? borderColor;
  final FocusNode? focusNode;
  final Function()? onTap;
  final bool? canRequestFocus;
  final bool autoFocus;
  final Widget? prefix;
  final String? prefixText;
  final Iterable<String>? autofillHints;

  @override
  State<CustomTextField> createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  bool? _obscureText;

  @override
  void initState() {
    super.initState();
    _obscureText = widget.isObscureText ?? false;
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: widget.controller,
      autofillHints: widget.autofillHints,
      keyboardType: widget.inputType,
      obscureText: _obscureText ?? false,
      readOnly: widget.readOnly ?? false,
      maxLines: widget.maxLines ?? 1,
      validator: widget.validator,
      canRequestFocus: widget.canRequestFocus ?? true,
      textInputAction: widget.textInputAction,
      mouseCursor: MouseCursor.defer,
      autofocus: widget.autoFocus,
      onTap: widget.onTap,
      onTapOutside: (event) => FocusScope.of(context).unfocus(),
      focusNode: widget.focusNode,
      cursorColor: AppColors.primary,
      maxLength: widget.maxLength,

      decoration: InputDecoration(
        contentPadding: EdgeInsets.symmetric(vertical: 10, horizontal: 12),
        filled: widget.color != null,
        focusColor: AppColors.primary,
        hoverColor: AppColors.primary,
        fillColor: widget.color ?? AppColors.white,
        suffixIconColor: AppColors.grayBg,
        prefixIcon: widget.prefixIcon,
        // prefix: widget.prefix ?? SizedBox(width: 12,),
        prefixText: widget.prefixText,
        prefixStyle: AppTypography.medium14.copyWith(color: AppColors.c10101A),
        suffixIcon: widget.isObscureText ?? false
            ? GestureDetector(
                onTap: () {
                  _obscureText = !_obscureText!;
                  setState(() {});
                },
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 10,
                  ),
                  child: SvgPicture.asset(
                    height: 20,
                    _obscureText!
                        ? Assets.passwordUnvisible
                        : Assets.passwordVisible,
                  ),
                ),
              )
            : widget.suffixIcon,
        enabledBorder: OutlineInputBorder(
          // gapPadding: 16,
          borderSide: widget.borderColor != null
              ? BorderSide(color: widget.borderColor!, width: 1)
              : BorderSide(color: AppColors.neutral300, width: 1),
          borderRadius: widget.borderRadius ?? AppUtils.kBorderRadius8,
        ),
        border: OutlineInputBorder(
          // gapPadding: 16,
          borderSide: widget.borderColor != null
              ? BorderSide(color: widget.borderColor!, width: 1)
              : BorderSide(color: AppColors.neutral300, width: 1),
          borderRadius: widget.borderRadius ?? AppUtils.kBorderRadius8,
        ),
        errorBorder: OutlineInputBorder(
          //gapPadding:16,
          borderSide: const BorderSide(color: AppColors.red, width: 1),
          borderRadius: widget.borderRadius ?? AppUtils.kBorderRadius8,
        ),
        focusedBorder: OutlineInputBorder(
          // gapPadding: 16,
          borderSide: widget.borderColor != null
              ? BorderSide(color: widget.borderColor!, width: 1)
              : BorderSide(color: AppColors.neutral300, width: 1),
          borderRadius: widget.borderRadius ?? AppUtils.kBorderRadius8,
        ),
        focusedErrorBorder: OutlineInputBorder(
          // gapPadding: 16,
          borderSide: const BorderSide(color: AppColors.red, width: 1),
          borderRadius: widget.borderRadius ?? AppUtils.kBorderRadius8,
        ),
        counter: const SizedBox.shrink(),
        hintText: widget.hintText,
        errorStyle: AppTypography.regular12.copyWith(
          color: AppColors.red,
          // height: 1.5,
        ),
        errorMaxLines: 3,
        // Error textni chap tomonga hizalash
        alignLabelWithHint: true,
        hintStyle:
            widget.hintStyle ??
            const TextStyle(
              color: AppColors.neutral400,
              fontSize: 14.0,
              height: 1.5,
              fontWeight: FontWeight.w400,
            ),
      ),

      onChanged: widget.onChanged,
      style: AppTypography.regular14.copyWith(color: AppColors.c10101A),
      inputFormatters: widget.inputFormatter,
    );
  }
}
