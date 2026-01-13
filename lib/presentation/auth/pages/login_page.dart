import 'package:flutter/material.dart';
import 'package:hr_plus/core/core.dart';
import 'package:hr_plus/core/services/notification_service.dart';
import 'package:hr_plus/data/api/auth_api.dart';
import 'package:hr_plus/main.dart';
import 'package:hr_plus/presentation/auth/bloc/login/login_cubit.dart';
import 'package:hr_plus/presentation/auth/pages/forgot_password_page.dart';
import 'package:hr_plus/presentation/home/bloc/home_cubit.dart';
import 'package:hr_plus/presentation/main/main_page.dart';
import 'package:hr_plus/presentation/notifications/bloc/notification_cubit.dart';
import 'package:hr_plus/presentation/profile/bloc/profile_cubit.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  final _formKey = GlobalKey<FormState>();
  bool notFound = false;
  bool wrongPassword = false;

  @override
  dispose() {
    _phoneController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => LoginCubit(),
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: AppColors.white,
        body: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(16, 24, 16, 24),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SafeArea(child: SizedBox(height: 24)),
                Center(
                  child: Image.asset(Assets.appLogo, height: 48, width: 48),
                ),
                16.g,
                Center(
                  child: Text(
                    'HR PULSE XODIM',
                    style: AppTypography.bold28.copyWith(
                      color: AppColors.neutral800,
                      height: 9 / 7,
                    ),
                  ),
                ),

                80.g,
                Text(
                  'phone_number'.tr(),
                  style: AppTypography.medium14.copyWith(
                    color: AppColors.neutral900,
                  ),
                ),
                8.g,
                CustomTextField(
                  controller: _phoneController,
                  inputType: TextInputType.phone,
                  autoFocus: true,
                  color: AppColors.white,
                  prefixIcon: Padding(
                    padding: const EdgeInsets.only(
                      left: 16,
                      top: 15,
                      bottom: 15,
                    ),
                    child: Text('+998', style: AppTypography.regular14),
                  ),
                  inputFormatter: [phoneFormatter],
                  validator: (val) {
                    if (val!.isEmpty) {
                      return 'empty_phone'.tr();
                    }
                    if (notFound) {
                      return 'employee_not_found'.tr();
                    }
                  },
                ),
                16.g,
                Text(
                  'password'.tr(),
                  style: AppTypography.medium14.copyWith(
                    color: AppColors.neutral900,
                  ),
                ),
                8.g,
                CustomTextField(
                  controller: _passwordController,
                  inputType: TextInputType.multiline,
                  color: AppColors.white,
                  isObscureText: true,
                  hintText: 'password'.tr(),

                  validator: (val) {
                    if (val!.isEmpty) {
                      return 'empty_password'.tr();
                    }
                    if (wrongPassword) {
                      return 'wrong_password'.tr();
                    }
                  },
                ),
                2.g,
                TextButton(
                  onPressed: () => context.push(
                    ForgotPasswordPage(phone: _phoneController.text),
                  ),
                  child: Text(
                    'forgot_password'.tr(),
                    style: AppTypography.regular14.copyWith(
                      color: AppColors.primary700,
                    ),
                  ),
                ),
                12.g,
                BlocBuilder<LoginCubit, LoginState>(
                  builder: (context, state) {
                    return AppButton(
                      title: 'login'.tr(),
                      isLoading: state.status.isLoading,
                      onTap: () => _login(context),
                    );
                  },
                ),

                SafeArea(child: SizedBox()),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _login(BuildContext context) {
    if (_formKey.currentState!.validate()) {
      context.read<LoginCubit>().loginUser(
        phoneNumber: '998${_phoneController.text.toFormattedPhoneNumber}',
        password: _passwordController.text,
        onSuccess: () {
          context.read<ProfileCubit>().getMe();
          context.read<HomeCubit>().getAttendance();
          context.read<NotificationCubit>().getNotifications();

          NotificationService.getFcmToken().then((fcm) {
            if (fcm != null) {
              sl<AuthApi>().updateFcm(fcmToken: fcm, lang: localeStorage.language);
            }
          });

          pushAndRemoveAll(MainPage());
        },
        onError: (msg) {
          if (msg == 'employee_notfound') {
            notFound = true;
          } else {
            wrongPassword = true;
          }
          _formKey.currentState!.validate();
          notFound = false;
          wrongPassword = false;
        },
      );
    }
  }
}
