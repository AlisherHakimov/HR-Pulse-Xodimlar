import 'package:flutter/material.dart';
import 'package:hr_plus/core/core.dart';
import 'package:hr_plus/presentation/auth/bloc/reset_password/reset_password_cubit.dart';
import 'package:hr_plus/presentation/home/bloc/home_cubit.dart';
import 'package:hr_plus/presentation/main/main_page.dart';
import 'package:hr_plus/presentation/notifications/bloc/notification_cubit.dart';
import 'package:hr_plus/presentation/profile/bloc/profile_cubit.dart';

import 'login_page.dart';

class NewPasswordPage extends StatefulWidget {
  const NewPasswordPage({super.key, required this.sessionId});

  final String sessionId;

  @override
  State<NewPasswordPage> createState() => _NewPasswordPageState();
}

class _NewPasswordPageState extends State<NewPasswordPage> {
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();

  final _formKey = GlobalKey<FormState>();

  @override
  dispose() {
    _phoneController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: 'recover_password', isBackBtn: true),
      body: Form(
        key: _formKey,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
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
                'enter_new_password'.tr(),
                textAlign: TextAlign.start,
                style: AppTypography.semibold20.copyWith(
                  color: AppColors.woodSmoke950,
                ),
              ),

              8.g,
              Text(
                'enter_new_password_desc'.tr().tr(),
                textAlign: TextAlign.center,
                style: AppTypography.regular14.copyWith(
                  color: AppColors.woodSmoke400,
                ),
              ),
              32.g,
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'new_password'.tr(),
                  textAlign: TextAlign.start,
                  style: AppTypography.medium14.copyWith(
                    color: AppColors.shark950,
                  ),
                ),
              ),
              8.g,
              CustomTextField(
                controller: _passwordController,
                inputType: TextInputType.multiline,
                isObscureText: true,
                hintText: 'new_password'.tr(),
                // suffixIcon: SvgPicture.asset(Assets.),
                validator: (val) {
                  if (val!.isEmpty) {
                    return 'empty_password'.tr();
                  }
                },
              ),
              16.g,
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'confirm_new_password'.tr(),
                  textAlign: TextAlign.start,
                  style: AppTypography.medium14.copyWith(
                    color: AppColors.shark950,
                  ),
                ),
              ),
              8.g,
              CustomTextField(
                controller: _confirmPasswordController,
                inputType: TextInputType.multiline,
                isObscureText: true,
                hintText: 'confirm_new_password'.tr(),
                // suffixIcon: SvgPicture.asset(Assets.),
                validator: (val) {
                  if (val!.isEmpty) {
                    return 'empty_password'.tr();
                  }
                  if (val != _passwordController.text) {
                    return 'password_doesnt_match'.tr();
                  }
                },
              ),

              24.g,
              BlocBuilder<ResetPasswordCubit, ResetPasswordState>(
                builder: (context, state) {
                  return AppButton(
                    title: 'set_password'.tr(),
                    isLoading: state.status.isLoading,
                    onTap: () => _changePassword(),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _changePassword() {
    if (_formKey.currentState!.validate()) {
      context.read<ResetPasswordCubit>().changePassword(
        sessionId: widget.sessionId,
        newPassword: _passwordController.text,
        onSuccess: () {
          showSuccessDialog(context, message: 'password_update_success'.tr());
          Future.delayed(const Duration(milliseconds: 1500), () {
            if (!mounted) return;
            pop();

            context.read<ProfileCubit>().getMe();
            context.read<HomeCubit>().getAttendance();
            context.read<NotificationCubit>().getNotifications();

            pushAndRemoveAll(MainPage());
          });
        },
        onError: (msg) => showError(context, msg),
      );
    }
  }
}
