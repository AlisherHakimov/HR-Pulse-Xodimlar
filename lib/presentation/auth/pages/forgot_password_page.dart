import 'package:flutter/material.dart';
import 'package:hr_plus/presentation/auth/bloc/reset_password/reset_password_cubit.dart';

import '../../../core/core.dart';
import 'reset_password_confirm_code_page.dart';

class ForgotPasswordPage extends StatefulWidget {
  const ForgotPasswordPage({super.key, required this.phone});

  final String phone;

  @override
  State<ForgotPasswordPage> createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage> {
  final TextEditingController _phoneController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  String error = '';

  @override
  void initState() {
    super.initState();
    _phoneController.text = widget.phone;
  }

  @override
  dispose() {
    _phoneController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: 'recover_password'.tr(), isBackBtn: true),
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
              'forgot_password'.tr(),
              textAlign: TextAlign.start,
              style: AppTypography.semibold20.copyWith(
                color: AppColors.woodSmoke950,
              ),
            ),

            8.g,
            Text(
              'recover_password_desc'.tr(),
              textAlign: TextAlign.center,
              style: AppTypography.regular14.copyWith(
                color: AppColors.woodSmoke400,
              ),
            ),
            32.g,

            Form(
              key: _formKey,
              child: CustomTextField(
                controller: _phoneController,
                inputType: TextInputType.phone,
                inputFormatter: [phoneFormatter],
                prefixIcon: Padding(
                  padding: const EdgeInsets.only(left: 16, top: 15, bottom: 15),
                  child: Text(
                    '+998',
                    style: AppTypography.regular14.copyWith(
                      color: AppColors.shark950,
                    ),
                  ),
                ),
                validator: (val) {
                  if (val!.isEmpty) {
                    return 'empty_phone'.tr();
                  }
                  if (error.isNotEmpty) {
                    return error;
                  }
                },
              ),
            ),
            16.g,
            BlocBuilder<ResetPasswordCubit, ResetPasswordState>(
              builder: (context, state) {
                return AppButton(
                  title: 'get_code'.tr(),
                  isLoading: state.status.isLoading,
                  onTap: () => _sendCode(),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  void _sendCode() {
    if (_formKey.currentState!.validate()) {
      context.read<ResetPasswordCubit>().resetPassword(
        phoneNumber: '+998${_phoneController.text.toFormattedPhoneNumber}',

        onSuccess: (sessionId) => push(
          ResetPasswordConfirmCodePage(
            phone: _phoneController.text.toFormattedPhoneNumber,
            sessionId: sessionId,
          ),
        ),
        onError: (msg) {
          setState(() {
            error = msg;
            _formKey.currentState!.validate();
            error = '';
          });
        },
      );
    }
  }
}
