import 'dart:async';

import 'package:flutter/material.dart';
import 'package:hr_plus/presentation/auth/bloc/reset_password/reset_password_cubit.dart';

import '../../../core/core.dart';
import 'new_password_page.dart';

class ResetPasswordConfirmCodePage extends StatefulWidget {
  const ResetPasswordConfirmCodePage({super.key, this.phone, this.sessionId});

  final String? phone;
  final String? sessionId;

  @override
  State<ResetPasswordConfirmCodePage> createState() => _OtpScreenState();
}

class _OtpScreenState extends State<ResetPasswordConfirmCodePage> {
  final TextEditingController _pinController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  Timer? _timer;
  int _start = 60;

  String? errorMessage;

  @override
  void initState() {
    super.initState();
    startTimer();
  }

  @override
  void dispose() {
    _timer?.cancel();
    _pinController.dispose();
    super.dispose();
  }

  void startTimer() {
    _start = 60;
    _timer?.cancel(); // Cancel any existing timer
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (!mounted) {
        timer.cancel();
        return;
      }
      if (_start == 0) {
        setState(() {
          timer.cancel();
        });
      } else {
        setState(() {
          _start--;
        });
      }
    });
  }

  void _resendCode() {
    startTimer();
    context.read<ResetPasswordCubit>().resetPasswordResendOtp(
      sessionId: widget.sessionId ?? '',
      phoneNumber: widget.phone ?? '',
      onError: (err) {
        errorMessage = err.tr();
        _formKey.currentState!.validate();
        errorMessage = null;
      },
    );
    _pinController.clear();
  }

  void _confirmCode() {
    final code = _pinController.text.trim();
    if (_formKey.currentState!.validate()) {
      context.read<ResetPasswordCubit>().resetPasswordVerifyUser(
        sessionId: widget.sessionId ?? '',
        otp: int.parse(code),
        onSuccess: () {
          push(NewPasswordPage(sessionId: widget.sessionId ?? ''));
        },
        onError: (msg) {
          if (msg == 'invalid') {
            errorMessage = 'invalid_pin'.tr();
          } else {
            errorMessage = msg.tr();
          }
          _pinController.clear();
          _formKey.currentState!.validate();
          errorMessage = null;
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: 'recover_password', isBackBtn: true),

      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 32),

        child: Column(
          children: [
            Container(
              height: 80,
              width: 80,
              padding: EdgeInsets.all(24),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.primary100,
              ),
              child: SvgPicture.asset(Assets.lockLogo),
            ),
            16.g,
            Text(
              'enter_code'.tr(),
              textAlign: TextAlign.start,
              style: AppTypography.semibold20.copyWith(
                color: AppColors.woodSmoke950,
              ),
            ),

            8.g,
            Text(
              'enter_code_desc'.tr().tr(),
              textAlign: TextAlign.center,
              style: AppTypography.regular14.copyWith(
                color: AppColors.woodSmoke400,
              ),
            ),
            32.g,

            Form(
              key: _formKey,
              child: CustomTextField(
                controller: _pinController,
                autofillHints: [AutofillHints.oneTimeCode],
                inputType: TextInputType.number,
                maxLength: 6,
                validator: (val) {
                  if (val!.isEmpty) {
                    return 'empty_code'.tr();
                  }

                  if (errorMessage != null) {
                    return errorMessage;
                  }

                  return null;
                },

                hintText: 'code'.tr(),
              ),
            ),

            16.g,
            BlocBuilder<ResetPasswordCubit, ResetPasswordState>(
              builder: (context, state) {
                return AppButton(
                  title: 'confirm'.tr(),
                  isLoading: state.status.isLoading,
                  onTap: () => _confirmCode(),
                );
              },
            ),
            32.g,
            SizedBox(
              height: 18,
              child: _start == 0
                  ? InkWell(
                      onTap: _resendCode,
                      child: Text(
                        'get_new_code'.tr(),
                        textAlign: TextAlign.center,
                        style: AppTypography.medium14.copyWith(
                          color: AppColors.primary,
                        ),
                      ),
                    )
                  : Text.rich(
                      TextSpan(
                        children: [
                          TextSpan(
                            text: tr('resend_code_timer').split('{}')[0],
                            style: AppTypography.regular14.copyWith(
                              color: AppColors.neutral800,
                            ),
                          ),
                          TextSpan(
                            text: '$_start',
                            style: AppTypography.regular14.copyWith(
                              color: AppColors.primary,
                            ),
                          ),
                          TextSpan(
                            text: tr('resend_code_timer').split('{}')[1],
                            style: AppTypography.regular14.copyWith(
                              color: AppColors.neutral800,
                            ),
                          ),
                        ],
                      ),
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
