import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:hr_plus/core/components/empty_widget.dart';
import 'package:hr_plus/core/core.dart';
import 'package:hr_plus/core/extentions/padding_extention.dart';
import 'package:hr_plus/main.dart';
import 'package:hr_plus/presentation/report/bloc/reports_cubit.dart';
import 'package:hr_plus/presentation/report/widgets/report_item.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';

class ReportPage extends StatefulWidget {
  const ReportPage({super.key});

  @override
  State<ReportPage> createState() => _ReportPageState();
}

class _ReportPageState extends State<ReportPage> {
  DateTimeRange? _selectedDateRange;
  final DateFormat _displayFormat = DateFormat(
    'dd MMM yyyy',
    localeStorage.language == 'uz' ? 'uz' : 'ru',
  );
  final DateFormat _apiFormat = DateFormat('yyyy-MM-dd');

  // Ekran uchun ko‘rsatiladigan matn
  String get _formattedDateRange {
    if (_selectedDateRange == null) {
      return 'Vaqt oralig\'ini tanlang';
    }
    final start = _displayFormat.format(_selectedDateRange!.start);
    final end = _displayFormat.format(_selectedDateRange!.end);
    return '$start - $end';
  }

  // Boshlang‘ich qiymat – oxirgi 30 kun
  void _resetToDefaultRange() {
    final now = DateTime.now();
    final defaultRange = DateTimeRange(
      start: now.subtract(const Duration(days: 30)),
      end: now,
    );

    setState(() {
      _selectedDateRange = defaultRange;
    });

    context.read<ReportsCubit>().getReports(
      startDate: _apiFormat.format(defaultRange.start),
      endDate: _apiFormat.format(defaultRange.end),
    );
  }

  Future<void> _pickDateRange() async {
    await showDialog(
      context: context,
      builder: (context) {
        final controller = DateRangePickerController();
        PickerDateRange? tempRange = _selectedDateRange != null
            ? PickerDateRange(
                _selectedDateRange!.start,
                _selectedDateRange!.end,
              )
            : null;

        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          contentPadding: const EdgeInsets.all(16),
          content: StatefulBuilder(
            builder: (context, setDialogState) {
              return Container(
                width: context.width,
                height: 380,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Theme(
                  data: Theme.of(context).copyWith(
                    colorScheme: const ColorScheme.light(
                      primary: AppColors.primary,
                    ),
                  ),
                  child: SfDateRangePicker(
                    controller: controller,
                    view: DateRangePickerView.month,
                    backgroundColor: Colors.white,
                    headerHeight: 56,
                    selectionMode: DateRangePickerSelectionMode.range,
                    minDate: DateTime(2025),
                    maxDate: DateTime.now(),
                    initialSelectedRange: tempRange,
                    selectableDayPredicate: (DateTime date) {
                      return true;
                    },
                    headerStyle: const DateRangePickerHeaderStyle(
                      textAlign: TextAlign.center,
                      backgroundColor: Colors.white,
                      textStyle: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: AppColors.neutral900,
                      ),
                    ),
                    monthViewSettings: const DateRangePickerMonthViewSettings(
                      firstDayOfWeek: 1,
                      weekendDays: [],
                      viewHeaderStyle: DateRangePickerViewHeaderStyle(
                        backgroundColor: Colors.white,
                        textStyle: TextStyle(
                          fontWeight: FontWeight.w500,
                          fontSize: 12,
                          color: AppColors.neutral500,
                        ),
                      ),
                      dayFormat: 'EE',
                    ),
                    selectionColor: AppColors.primary,
                    startRangeSelectionColor: AppColors.primary,
                    endRangeSelectionColor: AppColors.primary,
                    rangeSelectionColor: AppColors.primary.withOpacity(0.2),
                    todayHighlightColor: AppColors.primary,
                    selectionTextStyle: const TextStyle(color: Colors.white),
                    rangeTextStyle: const TextStyle(
                      color: AppColors.neutral900,
                    ),
                    onSelectionChanged:
                        (DateRangePickerSelectionChangedArgs args) {
                          setDialogState(() {
                            tempRange = args.value as PickerDateRange?;
                          });
                        },
                    onViewChanged: (DateRangePickerViewChangedArgs args) {},
                  ),
                ),
              );
            },
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              style: ButtonStyle(
                backgroundColor: WidgetStateProperty.all(AppColors.neutral100),
                shape: WidgetStateProperty.all(
                  RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
              child: Text(
                'cancel'.tr(),
                style: const TextStyle(color: AppColors.neutral600),
              ),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              onPressed: () {
                if (tempRange?.startDate == null) {
                  showError(context, 'please_select_date'.tr());
                  return;
                }

                final start = tempRange!.startDate!;
                final end = tempRange!.endDate ?? start;

                setState(() {
                  _selectedDateRange = DateTimeRange(start: start, end: end);
                });

                context.read<ReportsCubit>().getReports(
                  startDate: _apiFormat.format(start),
                  endDate: _apiFormat.format(end),
                );

                Navigator.pop(context);
              },
              child: Text(
                'save'.tr(),
                style: const TextStyle(color: Colors.white),
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  void initState() {
    super.initState();
    _resetToDefaultRange(); // birinchi yuklanishda 30 kunlik ma'lumot
  }

  @override
  Widget build(BuildContext context) {
    // Default range bilan hozirgi tanlangan range bir xilmi?
    final now = DateTime.now();
    final defaultRange = DateTimeRange(
      start: now.subtract(const Duration(days: 30)),
      end: now,
    );
    final bool isDefaultRange =
        _selectedDateRange != null &&
        _selectedDateRange!.start.day == defaultRange.start.day &&
        _selectedDateRange!.start.month == defaultRange.start.month &&
        _selectedDateRange!.start.year == defaultRange.start.year &&
        _selectedDateRange!.end.day == defaultRange.end.day &&
        _selectedDateRange!.end.month == defaultRange.end.month &&
        _selectedDateRange!.end.year == defaultRange.end.year;

    // Close ikonka faqat defaultdan farqli bo‘lsa ko‘rinsin
    final bool showClearButton = !isDefaultRange;

    return Scaffold(
      appBar: CustomAppBar(title: 'report', centerTitle: false),
      body: RefreshIndicator(
        onRefresh: () async {
          context.read<ReportsCubit>().getReports(
            startDate: _apiFormat.format(_selectedDateRange!.start),
            endDate: _apiFormat.format(_selectedDateRange!.end),
          );
        },
        child: Column(
          children: [
            const Gap(16),
            SizedBox(
              height: 40,
              child: Row(
                children: [
                  // Sana tanlash maydoni
                  Expanded(
                    child: GestureDetector(
                      onTap: _pickDateRange,
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(6),
                          border: Border.all(color: AppColors.neutral300),
                        ),
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                        alignment: Alignment.center,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SvgPicture.asset(Assets.calendar),
                            const Gap(8),
                            Flexible(
                              child: Text(
                                _formattedDateRange,
                                style: AppTypography.regular16.copyWith(
                                  color: AppColors.neutral700,
                                  height: 1.5,
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),

                  // Close tugmasi – faqat kerak bo‘lganda ko‘rinsin
                  if (showClearButton) ...[
                    const Gap(8),
                    GestureDetector(
                      onTap: _resetToDefaultRange,
                      child: Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(6),
                          border: Border.all(color: AppColors.neutral300),
                        ),
                        alignment: Alignment.center,
                        child: const Icon(
                          Icons.close,
                          size: 20,
                          color: AppColors.neutral700,
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            ),

            // Hisobotlar ro‘yxati
            BlocBuilder<ReportsCubit, ReportsState>(
              builder: (context, state) {
                if (state.status.isLoading) {
                  return Loader(height: context.height * 0.7);
                }
                if (state.reports.isEmpty) {
                  return SingleChildScrollView(
                    physics: const AlwaysScrollableScrollPhysics(),
                    child: EmptyWidget(
                      title: 'report_empty'.tr(),
                      subtitle: 'report_empty_subtitle'.tr(),
                      icon: Assets.emptyReport,
                    ),
                  );
                }

                return Expanded(
                  child: VerticalListView(
                    padding: const EdgeInsets.only(top: 16, bottom: 16),
                    physics: AlwaysScrollableScrollPhysics(),
                    itemBuilder: (ctx, i) =>
                        ReportItem(report: state.reports[i]),
                    itemCount: state.reports.length,
                  ),
                );
              },
            ),
          ],
        ).paddingSymmetric(horizontal: 16),
      ),
    );
  }
}
