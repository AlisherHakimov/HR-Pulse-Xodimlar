import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:hr_plus/core/core.dart';
import 'package:hr_plus/data/model/report_model.dart';
import 'package:hr_plus/presentation/report/widgets/report_sheet.dart';

class ReportItem extends StatelessWidget {
  const ReportItem({super.key, required this.report});

  final ReportModel report;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => ReportSheet.show(context, report: report),
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(width: 1, color: AppColors.neutral100),
        ),
        padding: EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '${report.amount.toString().moneyFormat} ${'sum'.tr()}',
                  style: AppTypography.medium16.copyWith(
                    color: AppColors.neutral800,
                    height: 1.5,
                  ),
                ),

                SvgPicture.asset(Assets.reminder),
              ],
            ),
            Divider(height: 24, thickness: 1, color: AppColors.neutral100),
            Row(
              children: [
                SvgPicture.asset(Assets.calendar),
                Gap(4),
                Text(
                  DateFormat(
                    'dd.MM.yyyy',
                  ).format(DateTime.parse(report.time ?? '')),

                  style: AppTypography.regular14.copyWith(
                    color: AppColors.neutral500,
                    height: 1.5,
                  ),
                ),
                Spacer(),
                Container(
                  decoration: BoxDecoration(
                    color: (report.type ?? '').toReportType.backgroundColor,
                    borderRadius: BorderRadius.circular(24),
                  ),
                  padding: EdgeInsets.symmetric(horizontal: 10, vertical: 2),
                  child: Text(
                    (report.type ?? '').toReportType.tr,
                    style: AppTypography.regular14.copyWith(
                      color: (report.type ?? '').toReportType.titleColor,
                      height: 1.5,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

extension ReportTypeExtention on String {
  ReportType get toReportType => switch (this) {
    'ADVANCE_PAYMENT' => ReportType.ADVANCE_PAYMENT,
    'SALARY_PAYMENT' => ReportType.SALARY_PAYMENT,
    'SALARY_PAYMENT_CARD' => ReportType.SALARY_PAYMENT_CARD,
    'BONUS' => ReportType.BONUS,
    'PENALTY' => ReportType.PENALTY,
    _ => throw Exception('Unknown permission status: $this'),
  };
}
