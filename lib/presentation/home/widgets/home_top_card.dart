import 'package:flutter/material.dart';
import 'package:hr_plus/core/core.dart';
import 'package:hr_plus/presentation/profile/bloc/profile_cubit.dart';

class HomeTopCard extends StatelessWidget {
  const HomeTopCard({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProfileCubit, ProfileState>(
      builder: (context, state) {
        return Container(
          decoration: BoxDecoration(
            color: AppColors.primary,
            borderRadius: BorderRadius.circular(12),
          ),
          padding: EdgeInsets.all(12),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    state.user?.attendance?.date ?? '',
                    style: AppTypography.semibold16.copyWith(
                      color: AppColors.neutral50,
                      height: 1.2,
                    ),
                  ),
                  // Container(
                  //   decoration: BoxDecoration(
                  //     color: AppColors.primary50,
                  //     borderRadius: BorderRadius.circular(12),
                  //   ),
                  //   padding: EdgeInsets.only(
                  //     left: 6,
                  //     top: 2,
                  //     bottom: 2,
                  //     right: 8,
                  //   ),
                  //   child: Row(
                  //     children: [
                  //       SvgPicture.asset(Assets.clock),
                  //       4.g,
                  //       Text(
                  //         '16:45',
                  //         style: AppTypography.regular14.copyWith(
                  //           color: AppColors.primary,
                  //           height: 1.6,
                  //         ),
                  //       ),
                  //     ],
                  //   ),
                  // ),
                ],
              ),
              12.g,
              Container(
                decoration: BoxDecoration(
                  color: AppColors.primary400,
                  borderRadius: BorderRadius.circular(8),
                ),
                padding: EdgeInsets.symmetric(vertical: 16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Expanded(
                      child: Column(
                        children: [
                          Text(
                            state.user?.attendance?.wtStart?.substring(
                                  11,
                                  16,
                                ) ??
                                '',
                            style: AppTypography.bold20.copyWith(
                              color: AppColors.neutral50,
                              height: 1.4,
                            ),
                          ),
                          2.g,
                          Text(
                            'start_time'.tr(),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: AppTypography.regular14.copyWith(
                              color: AppColors.neutral50,
                              height: 1.6,
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 48,
                      child: VerticalDivider(
                        width: 25,
                        color: AppColors.primary300,
                        thickness: 1,
                      ),
                    ),
                    Expanded(
                      child: Column(
                        children: [
                          Text(
                            state.user?.attendance?.wtEnd?.substring(11, 16) ??
                                '',
                            style: AppTypography.bold20.copyWith(
                              color: AppColors.neutral50,
                              height: 1.4,
                            ),
                          ),
                          2.g,
                          Text(
                            'end_time'.tr(),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: AppTypography.regular14.copyWith(
                              color: AppColors.neutral50,
                              height: 1.6,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
