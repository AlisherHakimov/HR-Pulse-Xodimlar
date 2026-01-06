import 'package:flutter/material.dart';
import 'package:hr_plus/main.dart';
import 'package:hr_plus/presentation/auth/pages/login_page.dart';
import 'package:hr_plus/presentation/language/pages/change_language_page.dart';

import 'package:hr_plus/presentation/profile/bloc/profile_cubit.dart';
import 'package:hr_plus/presentation/profile/pages/permissions_page.dart';
import 'package:hr_plus/presentation/profile/pages/personal_info_page.dart';
import 'package:hr_plus/presentation/profile/widgets/profile_button.dart';

import '../../../core/core.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: 'profile'.tr(),
        centerTitle: false,
        actions: [],
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          context.read<ProfileCubit>().getMe();
        },
        child: BlocBuilder<ProfileCubit, ProfileState>(
          builder: (context, state) {
            return SafeArea(
              child: ListView(
                padding: EdgeInsets.only(left: 16, right: 16, top: 24),
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Avatar(
                        avatarUrl:
                            state.user?.image?.preview ??
                            state.user?.image?.file ??
                            '',
                        radius: 48,
                        borderColor: AppColors.primary,
                      ),
                      12.g,
                      Text(
                        state.user?.name ?? '',
                        style: AppTypography.medium16,
                      ),
                      4.g,
                      if (state.user?.phoneNumber != null &&
                          state.user!.phoneNumber!.isNotEmpty)
                        Text(
                          '+${(state.user!.phoneNumber) ?? ''}'
                              .toUzbekPhoneFormat,
                          style: AppTypography.regular14.copyWith(
                            color: AppColors.woodSmoke400,
                          ),
                        ),
                      24.g,
                    ],
                  ),
                  ProfileButton(
                    icon: Assets.profileInfo,
                    onTap: () => context.push(PersonalInfoPage()),
                    title: 'personal_info',
                  ),
                  ProfileButton(
                    icon: Assets.permissions,
                    onTap: () => context.push(PermissionsPage()),
                    title: 'permissions',
                  ),
                  ProfileButton(
                    icon: Assets.language,
                    onTap: () => context.push(ChangeLanguagePage()),
                    title: 'change_language',
                  ),
                  ProfileButton(
                    icon: Assets.logout,
                    onTap: () {
                      showConfirmationDialog(
                        context,
                        icon: Assets.logoutConfirmation,
                        title: 'log_out_of_profile'.tr(),
                        subtitle: 'logout_desc'.tr(),
                        confirmTitle: 'logout'.tr(),
                        onConfirm: () {
                          localeStorage.clear();
                          context.pushAndRemoveAll(LoginPage());
                        },
                      );
                    },
                    title: 'logout',
                    color: AppColors.destructive50,
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
