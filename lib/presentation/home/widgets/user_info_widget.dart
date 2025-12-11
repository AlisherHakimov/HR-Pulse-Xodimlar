import 'package:flutter/material.dart';
import 'package:hr_plus/core/core.dart';
import 'package:hr_plus/presentation/profile/bloc/profile_cubit.dart';

class UserInfoWidget extends StatelessWidget {
  const UserInfoWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProfileCubit, ProfileState>(
      builder: (context, state) {
        return SafeArea(
          bottom: false,
          child: SizedBox(
            width: context.width,
            child: Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,

                children: [
                  12.g,
                  Avatar(
                    avatarUrl:
                        state.user?.image?.preview ??
                        state.user?.image?.file ??
                        '',
                    radius: 36,
                    borderColor: AppColors.white,
                  ),
                  16.g,
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          state.user?.name ?? '',
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: AppTypography.semibold20.copyWith(
                            color: AppColors.neutral800,
                            height: 1.5,
                          ),
                        ),
                        if (('${state.user?.department?.name ?? ''}${((state.user?.department?.name?.isNotEmpty ?? false) && (state.user?.job?.name?.isNotEmpty ?? false)) ? ' - ' : ''}${state.user?.job?.name ?? ''}')
                            .isNotEmpty) ...[
                          4.g,

                          Text(
                            '${state.user?.department?.name ?? ''}${((state.user?.department?.name?.isNotEmpty ?? false) && (state.user?.job?.name?.isNotEmpty ?? false)) ? ' - ' : ''}${state.user?.job?.name ?? ''}',
                            style: AppTypography.regular16.copyWith(
                              color: AppColors.neutral600,
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
