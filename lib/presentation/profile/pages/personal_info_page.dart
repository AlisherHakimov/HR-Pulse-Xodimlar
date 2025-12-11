import 'package:flutter/material.dart';
import 'package:hr_plus/data/model/user_model.dart' show UserModel;
import 'package:hr_plus/presentation/profile/bloc/profile_cubit.dart';

import '../../../core/core.dart';

class PersonalInfoPage extends StatefulWidget {
  const PersonalInfoPage({super.key});

  @override
  State<PersonalInfoPage> createState() => _PersonalInfoPageState();
}

class _PersonalInfoPageState extends State<PersonalInfoPage> {
  final _formKey = GlobalKey<FormState>();

  @override
  initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: 'personal_info', isBackBtn: true),
      body: Form(
        key: _formKey,
        child: BlocBuilder<ProfileCubit, ProfileState>(
          builder: (context, state) {
            final user = state.user;

            return ListView(
              padding: AppUtils.kPaddingHor16Ver24,
              children: [
                Center(
                  child: Avatar(avatarUrl: user?.image?.file ?? '', radius: 44),
                ),
                24.g,
                ProfileInfoItem(title: 'name'.tr(), value: user?.name ?? ''),
                ProfileInfoItem(
                  title: 'phone'.tr(),
                  value:
                      '+${(state.user!.phoneNumber) ?? ''}'.toUzbekPhoneFormat,
                ),
                if (user?.department != null)
                  ProfileInfoItem(
                    title: 'workplace'.tr(),
                    value: user?.department?.name ?? '',
                  ),
                ProfileInfoItem(
                  title: 'position'.tr(),
                  value: user?.job?.name ?? '',
                ),
                ProfileInfoItem(
                  title: 'salary1'.tr(),
                  value: '${user?.salary.toString().moneyFormat} ${'sum'.tr()}',
                ),
                WorkingDays(user: user!),

                ProfileInfoItem(
                  title: 'lunch_time'.tr(),
                  value: user?.lunchMode == 'DURATION'
                      ? formatLunchDuration(user?.lunchDuration) ?? ''
                      : '${user?.lunchTime?.start ?? ''} ${user?.lunchTime?.start != null ? '-' : ''} ${user?.lunchTime?.end ?? ''}',
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}

class ProfileInfoItem extends StatelessWidget {
  const ProfileInfoItem({super.key, required this.title, required this.value});

  final String title;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,

          style: AppTypography.medium14.copyWith(color: AppColors.neutral900),
        ),
        12.g,
        Text(
          value,
          style: AppTypography.regular14.copyWith(color: AppColors.neutral500),
        ),
        11.g,
        Divider(height: 1, thickness: 1, color: AppColors.neutral200),
        16.g,
      ],
    );
  }
}

String? formatLunchDuration(String? durationStr) {
  // "01:00:00" → Duration obyektiga aylantirish
  if (durationStr == null) return null;

  final parts = durationStr.split(':');

  final duration = Duration(
    hours: int.parse(parts[0]),
    minutes: int.parse(parts[1]),
    seconds: int.parse(parts[2]),
  );

  final hours = duration.inHours;
  final minutes = duration.inMinutes.remainder(60);

  if (hours == 0) {
    return '$minutes daqiqa';
  } else if (minutes == 0) {
    return hours == 1 ? '1 soat' : '$hours soat';
  } else {
    final hourText = hours == 1 ? '1 soat' : '$hours soat';
    return '$hourText $minutes daqiqa';
  }
}

class WorkingDays extends StatelessWidget {
  const WorkingDays({super.key, required this.user});

  final UserModel user;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'date_time'.tr(),
          style: AppTypography.medium14.copyWith(color: AppColors.neutral900),
        ),
        12.g,
        _weekDay(
          day: 'monday',
          start: user.wtMonday?.start,
          end: user.wtMonday?.end,
        ),
        _weekDay(
          day: 'tuesday',
          start: user.wtTuesday?.start,
          end: user.wtTuesday?.end,
        ),
        _weekDay(
          day: 'wednesday',
          start: user.wtWednesday?.start,
          end: user.wtWednesday?.end,
        ),
        _weekDay(
          day: 'thursday',
          start: user.wtThursday?.start,
          end: user.wtThursday?.end,
        ),
        _weekDay(
          day: 'friday',
          start: user.wtFriday?.start,
          end: user.wtFriday?.end,
        ),
        _weekDay(
          day: 'saturday',
          start: user.wtSaturday?.start,
          end: user.wtSaturday?.end,
        ),
        _weekDay(
          day: 'sunday',
          start: user.wtSunday?.start,
          end: user.wtSunday?.end,
        ),
        11.g,
        Divider(height: 1, thickness: 1, color: AppColors.neutral200),
        16.g,
      ],
    );
  }

  Column _weekDay({required String day, String? start, String? end}) {
    return Column(
      children: [
        Row(
          children: [
            Text(
              day.tr(),
              style: AppTypography.regular14.copyWith(
                color: AppColors.neutral500,
              ),
            ),
            const Spacer(),

            Text(
              user.wtMode == 'SIMPLE'
                  ? start != null
                        ? '$start - $end'
                        : 'day_off'.tr()
                  : user.wtMode == 'FREE'
                  ? 'free'.tr()
                  : '',
              style: AppTypography.regular14.copyWith(
                color: AppColors.neutral500,
              ),
            ),
          ],
        ),
        8.g,
      ],
    );
  }
}
