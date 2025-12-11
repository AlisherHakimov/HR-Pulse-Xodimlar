import 'package:flutter/material.dart';
import 'package:hr_plus/core/core.dart';
import 'package:hr_plus/data/model/Attendance_model.dart';
import 'package:hr_plus/presentation/home/bloc/home_cubit.dart';

class AttendanceSheet extends StatelessWidget {
  const AttendanceSheet({super.key, required this.model});

  final AttendanceModel model;

  static void show(BuildContext context, {required AttendanceModel model}) =>
      showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        useSafeArea: true,
        builder: (context) => AttendanceSheet(model: model),
      );

  // Helper method to combine date and time strings
  DateTime? _parseDateTime(String? date, String? time) {
    if (date == null || time == null) return null;
    try {
      final dateOnly = date.substring(0, 10); // Get YYYY-MM-DD part
      return DateTime.parse('$dateOnly $time');
    } catch (e) {
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomeCubit, HomeState>(
      builder: (context, state) {
        // Parse datetime values once for reuse
        final checkInTime = model.attendance?.checkIn != null
            ? DateTime.parse(model.attendance!.checkIn!)
            : null;
        final checkOutTime = model.attendance?.checkOut != null
            ? DateTime.parse(model.attendance!.checkOut!)
            : null;
        final workStartTime = _parseDateTime(model.date, model.workTime?.start);
        final workEndTime = _parseDateTime(model.date, model.workTime?.end);

        // Determine status
        final isOnTime =
            checkInTime != null &&
            workStartTime != null &&
            checkInTime.isBefore(workStartTime);
        final leftOnTime =
            checkOutTime != null &&
            workEndTime != null &&
            checkOutTime.isAfter(workEndTime);

        return Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
          ),
          width: context.width,
          padding: EdgeInsets.symmetric(horizontal: 16),
          child: SafeArea(
            top: false,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Center(
                  child: Text(
                    DateFormat(
                      'dd.MM.yyyy',
                    ).format(DateTime.parse(model.date ?? '')),
                    textAlign: TextAlign.center,
                    style: AppTypography.semibold18.copyWith(
                      color: AppColors.neutral800,
                    ),
                  ),
                ),
                12.g,
                Text(
                  'attendance'.tr(),
                  textAlign: TextAlign.center,
                  style: AppTypography.medium16.copyWith(
                    color: AppColors.neutral800,
                  ),
                ),
                Divider(height: 32, thickness: 1, color: AppColors.neutral100),
                Row(
                  children: [
                    SvgPicture.asset(Assets.came),
                    4.g,
                    Text(
                      model.attendance?.checkIn?.substring(11, 16) ?? '--:--',
                      style: AppTypography.regular14.copyWith(
                        color: AppColors.neutral500,
                      ),
                    ),
                    16.g,
                    SvgPicture.asset(Assets.gone),
                    4.g,
                    Text(
                      model.attendance?.checkOut?.substring(11, 16) ??
                          (model.attendance?.checkIn == null
                              ? '--:--'
                              : 'not_marked'.tr()),
                      style: AppTypography.regular14.copyWith(
                        color: AppColors.neutral500,
                      ),
                    ),
                    Spacer(),
                    Container(
                      decoration: BoxDecoration(
                        color: (isOnTime
                            ? AppColors.success50
                            : AppColors.destructive50),
                        borderRadius: BorderRadius.circular(24),
                      ),
                      padding: EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 2,
                      ),
                      child: Text(
                        checkInTime == null
                            ? 'not_marked'.tr()
                            : isOnTime
                            ? 'arrived_on_time'.tr()
                            : 'late'.tr(),
                        style: AppTypography.regular14.copyWith(
                          color: isOnTime
                              ? AppColors.success700
                              : AppColors.destructive700,
                          height: 1.5,
                        ),
                      ),
                    ),
                  ],
                ),

                16.g,
                Text(
                  'action_journal'.tr(),
                  textAlign: TextAlign.center,
                  style: AppTypography.medium16.copyWith(
                    color: AppColors.neutral800,
                  ),
                ),
                if (state.getActionStatus.isLoading)
                  Loader(height: 40)
                else if (state.dailyActions.isNotEmpty)
                  for (var action in state.dailyActions)
                    if (action.type == 'OUTSIDE') ...[
                      _attendanceSheetItem(
                        action.start?.substring(11, 16) ?? '--:--',
                        'left'.tr(),
                        false,
                        statusColor: AppColors.neutral100,
                        statusTitleColor: AppColors.neutral700,
                      ),
                      _attendanceSheetItem(
                        action.end?.substring(11, 16) ?? '--:--',
                        'arrived'.tr(),
                        true,
                        statusColor: AppColors.neutral100,
                        statusTitleColor: AppColors.neutral700,
                      ),
                    ],
                28.g,
                AppButton(
                  title: 'close'.tr(),
                  onTap: () => Navigator.pop(context),
                ),
                16.g,
              ],
            ),
          ),
        );
      },
    );
  }

  Column _attendanceSheetItem(
    String time,
    String statusText,
    bool status, {
    Color? statusColor,
    Color? statusTitleColor,
  }) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Divider(height: 32, thickness: 1, color: AppColors.neutral100),
      Row(
        children: [
          SvgPicture.asset(status ? Assets.came : Assets.gone),
          4.g,
          Text(
            time,
            style: AppTypography.regular14.copyWith(
              color: AppColors.neutral500,
            ),
          ),
          Spacer(),
          Container(
            decoration: BoxDecoration(
              color:
                  statusColor ??
                  (status ? AppColors.success50 : AppColors.destructive50),
              borderRadius: BorderRadius.circular(24),
            ),
            padding: EdgeInsets.symmetric(horizontal: 10, vertical: 2),
            child: Text(
              statusText,
              style: AppTypography.regular14.copyWith(
                color:
                    statusTitleColor ??
                    statusColor ??
                    (status ? AppColors.success700 : AppColors.destructive700),
                height: 1.5,
              ),
            ),
          ),
        ],
      ),
    ],
  );
}
