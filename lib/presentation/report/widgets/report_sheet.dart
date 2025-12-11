import 'package:flutter/material.dart';
import 'package:hr_plus/core/core.dart';
import 'package:hr_plus/data/model/report_model.dart';
import 'package:hr_plus/presentation/report/widgets/report_item.dart';

class ReportSheet extends StatelessWidget {
  const ReportSheet({super.key, required this.report});

  final ReportModel report;

  static void show(BuildContext context, {required ReportModel report}) =>
      showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        useSafeArea: true,
        builder: (context) => ReportSheet(report: report),
      );

  @override
  Widget build(BuildContext context) {
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
                'more_details'.tr(),
                textAlign: TextAlign.center,
                style: AppTypography.semibold18.copyWith(
                  color: AppColors.neutral800,
                ),
              ),
            ),
            12.g,
            _reportSheetItem(
              'report_type',
              (report.type ?? '').toReportType.tr,
            ),
            _reportSheetItem(
              'date',
              DateFormat(
                'dd.MM.yyyy',
              ).format(DateTime.parse(report.time ?? '')),
            ),
            _reportSheetItem(
              'quantity',
              '${report.amount.toString().moneyFormat} ${'sum'.tr()}',
            ),
            _reportSheetItem('description', report.comment ?? '', latest: true),
            28.g,
            AppButton(title: 'close'.tr(), onTap: () => Navigator.pop(context)),
            16.g,
          ],
        ),
      ),
    );
  }

  Column _reportSheetItem(String title, String value, {bool? latest}) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(
        title.tr(),
        style: AppTypography.regular14.copyWith(color: AppColors.neutral500),
      ),
      8.g,
      Text(
        value.tr(),

        style: AppTypography.medium16.copyWith(color: AppColors.neutral800),
      ),

      if (latest != true)
        Divider(height: 24, thickness: 1, color: AppColors.neutral100),
    ],
  );
}
