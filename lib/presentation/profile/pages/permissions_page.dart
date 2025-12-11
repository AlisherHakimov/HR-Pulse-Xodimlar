import 'package:flutter/material.dart';
import 'package:hr_plus/core/components/empty_widget.dart';
import 'package:hr_plus/core/core.dart';
import 'package:hr_plus/data/model/permissions_response.dart';
import 'package:hr_plus/presentation/profile/bloc/permission/permission_cubit.dart';
import 'package:hr_plus/presentation/profile/widgets/ask_for_permission_sheet.dart';
import 'package:hr_plus/presentation/profile/widgets/permission_card.dart';
import 'package:hr_plus/presentation/profile/widgets/permission_detail_sheet.dart';

class PermissionsPage extends StatefulWidget {
  const PermissionsPage({super.key});

  @override
  State<PermissionsPage> createState() => _PermissionsPageState();
}

class _PermissionsPageState extends State<PermissionsPage> {
  @override
  void initState() {
    context.read<PermissionCubit>().getPermissions(
      status: PermissionStatus.ALL,
      page: 1,
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: 'permissions'.tr(),
        isBackBtn: true,
        backgroundColor: AppColors.neutral50,
        toolbarHeight: kTextTabBarHeight + 60,
        bottom: PreferredSize(
          preferredSize: Size(double.infinity, 52),
          child: BlocBuilder<PermissionCubit, PermissionState>(
            builder: (context, state) {
              return SizedBox(
                height: 52,
                child: ListView.separated(
                  padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  scrollDirection: Axis.horizontal,
                  itemBuilder: (ctx, i) {
                    final status = PermissionStatus.values[i];
                    int count = 0;

                    count = _calculateStatusCounts(status, state.statusCounts!);

                    return _filterButton(
                      onTap: () {
                        context.read<PermissionCubit>().getPermissions(
                          status: status,
                          page: 1,
                        );
                      },
                      title: status.tr,
                      count: count ?? 0,
                      isSelected: state.permissionStatus == status,
                    );
                  },
                  separatorBuilder: (ctx, i) => SizedBox(width: 8),
                  itemCount: PermissionStatus.values.length - 2,
                ),
              );
            },
          ),
        ),
      ),

      backgroundColor: AppColors.neutral50,

      body: RefreshIndicator(
        onRefresh: () => context.read<PermissionCubit>().getPermissions(
          status: context.read<PermissionCubit>().state.permissionStatus,
          page: 1,
        ),
        child: BlocBuilder<PermissionCubit, PermissionState>(
          builder: (context, state) {
            if (state.status.isLoading) {
              return Loader();
            }
            if (state.permissions.isEmpty) {
              return EmptyWidget(
                title: 'you_have_no_permission'.tr(),
                subtitle: 'tap_permission'.tr(),
                icon: Assets.emptyReport,
              );
            }
            return VerticalListView(
              padding: AppUtils.kPaddingAll16,
              physics: AlwaysScrollableScrollPhysics(),
              itemCount: state.permissions.length,
              itemBuilder: (ctx, i) {
                return PermissionCard(
                  permission: state.permissions[i],
                  onTap: () => PermissionDetailSheet.show(
                    context,
                    permission: state.permissions[i],
                  ),
                );
              },
              onLoadMore: () {
                context.read<PermissionCubit>().getPermissions(
                  status: state.permissionStatus,
                  page: state.page + 1,
                );
              },
            );
          },
        ),
      ),

      persistentFooterButtons: [
        AppButton(
          title: '+ ${'ask_for_permission'.tr()}',
          onTap: () {
            context.read<PermissionCubit>().getReasons();
            AskForPermissionSheet.show(context);
          },
        ),
      ],
    );
  }

  CustomMaterialButton _filterButton({
    required String title,
    required Function() onTap,
    int count = 0,
    bool isSelected = false,
  }) {
    return CustomMaterialButton(
      onTap: onTap,
      color: isSelected ? AppColors.primary : AppColors.neutral100,
      padding: EdgeInsets.symmetric(vertical: 8, horizontal: 12),
      borderRadius: 6,
      child: Row(
        children: [
          Text(
            title,
            style: AppTypography.medium14.copyWith(
              color: isSelected ? AppColors.neutral50 : AppColors.neutral700,
            ),
          ),
          8.g,
          Container(
            height: 20,
            width: 20,
            decoration: BoxDecoration(
              color: isSelected ? AppColors.primary400 : AppColors.neutral200,
              shape: BoxShape.circle,
            ),
            alignment: Alignment.center,
            child: Text(
              '$count',
              textAlign: TextAlign.center,
              style: AppTypography.medium12.copyWith(
                color: isSelected ? AppColors.neutral50 : AppColors.neutral500,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

int _calculateStatusCounts(PermissionStatus status, StatusCounts counts) {
  switch (status) {
    case PermissionStatus.PENDING:
      return (counts.pending ?? 0)+ (counts.review ?? 0);
    case PermissionStatus.APPROVED:
      return (counts.approved ?? 0) + (counts.aiApproved ?? 0);
    case PermissionStatus.REJECTED:
      return (counts.rejected ?? 0) + (counts.aiRejected ?? 0);
    case PermissionStatus.ALL:
      return (counts.pending ?? 0) +
          (counts.review ?? 0) +
          (counts.approved ?? 0) +
          (counts.aiApproved ?? 0) +
          (counts.rejected ?? 0) +
          (counts.aiRejected ?? 0);
    default:
      return 0;
  }
}
