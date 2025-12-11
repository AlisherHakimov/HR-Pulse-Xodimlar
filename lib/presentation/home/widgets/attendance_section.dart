import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:hr_plus/core/core.dart';
import 'package:hr_plus/core/extentions/string_extention.dart';
import 'package:hr_plus/data/model/Attendance_model.dart';
import 'package:hr_plus/presentation/home/bloc/home_cubit.dart';
import 'package:hr_plus/presentation/home/widgets/attendance_sheet.dart';

class AttendanceSection extends StatefulWidget {
  const AttendanceSection({super.key});

  @override
  State<AttendanceSection> createState() => _AttendanceSectionState();
}

class _AttendanceSectionState extends State<AttendanceSection> {
  DateTime selectedDate = DateTime.now(); // Boshlang'ich oy

  // Oylar nomi (o'zbekcha)
  final List<String> _monthNames = [
    "january".tr(),
    "february".tr(),
    "march".tr(),
    "april".tr(),
    "may".tr(),
    "june".tr(),
    "july".tr(),
    "august".tr(),
    "september".tr(),
    "october".tr(),
    "november".tr(),
    "december".tr(),
  ];

  String get _formattedMonthYear {
    return '${_monthNames[selectedDate.month - 1]}, ${selectedDate.year}';
  }

  void _previousMonth() {
    setState(() {
      if (selectedDate.year >= 2025 && selectedDate.month > 1) {
        selectedDate = DateTime(selectedDate.year, selectedDate.month - 1);
        context.read<HomeCubit>().getAttendance(date: selectedDate);
      }
    });
  }

  void _nextMonth() {
    final next = DateTime(selectedDate.year, selectedDate.month + 1);
    final now = DateTime.now();
    final current = DateTime(now.year, now.month);

    if (next.isBefore(current) ||
        (next.year == current.year && next.month == current.month)) {
      setState(() {
        selectedDate = next;
      });
      context.read<HomeCubit>().getAttendance(date: selectedDate);
    }
  }

  Future<void> _selectMonthYear(BuildContext context) async {
    await showDialog(
      context: context,
      builder: (context) => MonthYearPickerDialog(
        initialDate: selectedDate,
        onDateSelected: (DateTime newDate) {
          setState(() {
            selectedDate = DateTime(newDate.year, newDate.month);
          });
          context.read<HomeCubit>().getAttendance(date: selectedDate);
        },
      ),
    );
  }

  @override
  void initState() {
    super.initState();

    context.read<HomeCubit>().getAttendance(date: selectedDate);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.white,
      child: Column(
        children: [
          24.g,
          SizedBox(
            height: 40,
            child: Row(
              children: [
                // Oldingi oy
                GestureDetector(
                  onTap: _previousMonth,
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(6),
                      border: Border.all(color: AppColors.neutral300),
                    ),
                    padding: EdgeInsets.only(left: 5),
                    alignment: Alignment.center,
                    width: 40,
                    child: Icon(Icons.arrow_back_ios, size: 16),
                  ),
                ),
                Gap(8),

                // Oy va yil tanlash
                Expanded(
                  child: GestureDetector(
                    onTap: () => _selectMonthYear(context),
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(6),
                        border: Border.all(color: AppColors.neutral300),
                      ),
                      padding: EdgeInsets.only(left: 5),

                      alignment: Alignment.center,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SvgPicture.asset(Assets.calendar),
                          Gap(4),
                          Text(
                            _formattedMonthYear,
                            style: AppTypography.regular16.copyWith(
                              color: AppColors.neutral700,
                              height: 1.5,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                Gap(8),

                // Keyingi oy
                GestureDetector(
                  onTap: _nextMonth,
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(6),
                      border: Border.all(color: AppColors.neutral300),
                    ),
                    width: 40,
                    alignment: Alignment.center,
                    child: Icon(Icons.arrow_forward_ios, size: 16),
                  ),
                ),
              ],
            ),
          ),

          BlocBuilder<HomeCubit, HomeState>(
            builder: (context, state) {
              if (state.status.isLoading) {
                return Loader(height: 400);
              }
              if (state.attendances.isEmpty) {
                return SizedBox(width: context.width, height: 400);
              }
              return VerticalListView(
                padding: EdgeInsets.only(top: 16, bottom: 16),
                reverse: true,
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemBuilder: (ctx, i) =>
                    AttendanceItem(model: state.attendances[i]),
                itemCount: state.attendances.length,
              );
            },
          ),
        ],
      ),
    );
  }
}

class AttendanceItem extends StatelessWidget {
  const AttendanceItem({super.key, required this.model});

  final AttendanceModel model;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        context.read<HomeCubit>().getDailyActions(
          id: model.attendance?.id ?? '',
        );
        AttendanceSheet.show(context, model: model);
      },
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
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text(
                  model.date?.toLocalizedDate() ?? '',
                  style: AppTypography.medium16.copyWith(
                    color: AppColors.neutral800,
                    height: 1.5,
                  ),
                ),
              ],
            ),
            Divider(height: 24, thickness: 1, color: AppColors.neutral100),
            Row(
              children: [
                SvgPicture.asset(Assets.came),
                Gap(4),
                Text(
                  model.attendance?.checkIn?.substring(11, 16) ?? '--:--',
                  style: AppTypography.regular14.copyWith(
                    color: AppColors.neutral500,
                    height: 1.5,
                  ),
                ),
                Gap(16),
                SvgPicture.asset(Assets.gone),
                Gap(4),
                Text(
                  model.attendance?.checkOut?.substring(11, 16) ??
                      (model.attendance?.checkIn != null
                          ? 'not_marked'.tr()
                          : '--:--'),
                  style: AppTypography.regular14.copyWith(
                    color: AppColors.neutral500,
                    height: 1.5,
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

class MonthYearPickerDialog extends StatefulWidget {
  final DateTime initialDate;
  final Function(DateTime) onDateSelected;

  const MonthYearPickerDialog({
    super.key,
    required this.initialDate,
    required this.onDateSelected,
  });

  @override
  State<MonthYearPickerDialog> createState() => _MonthYearPickerDialogState();
}

class _MonthYearPickerDialogState extends State<MonthYearPickerDialog> {
  late int selectedYear;
  late int selectedMonth;

  final List<String> _monthNames = [
    "january".tr(),
    "february".tr(),
    "march".tr(),
    "april".tr(),
    "may".tr(),
    "june".tr(),
    "july".tr(),
    "august".tr(),
    "september".tr(),
    "october".tr(),
    "november".tr(),
    "december".tr(),
  ];

  late FixedExtentScrollController _monthController;
  late FixedExtentScrollController _yearController;

  @override
  void initState() {
    super.initState();
    selectedYear = widget.initialDate.year;
    selectedMonth = widget.initialDate.month;

    _monthController = FixedExtentScrollController(
      initialItem: selectedMonth - 1,
    );
    _yearController = FixedExtentScrollController(
      initialItem: selectedYear - 2025,
    );
  }

  @override
  void dispose() {
    _monthController.dispose();
    _yearController.dispose();
    super.dispose();
  }

  // Joriy yil va oyni olish
  DateTime get _now => DateTime.now();

  int get _currentYear => _now.year;

  int get _currentMonth => _now.month;

  // Yillar ro'yxati: 2020 dan joriy yilgacha
  List<int> get _availableYears {
    return List.generate(_currentYear - 2025 + 1, (i) => 2025 + i);
  }

  // Mavjud oylar: agar joriy yil tanlansa → faqat joriy oygacha, aks holda 12 oy
  List<String> get _availableMonths {
    if (selectedYear < _currentYear) {
      return _monthNames;
    } else {
      // Joriy yilda faqat joriy oygacha
      return _monthNames.sublist(0, _currentMonth);
    }
  }

  @override
  Widget build(BuildContext context) {
    final availableMonths = _availableMonths;
    final int maxMonthIndex = availableMonths.length - 1;

    // Agar tanlangan oy mavjud bo'lmasa (masalan, oldin 12-oy tanlangan, endi joriy yilga o'tganda)
    if (selectedMonth > availableMonths.length) {
      selectedMonth = availableMonths.length;
      _monthController.jumpToItem(selectedMonth - 1);
    }

    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Container(
        padding: EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'choose_month_year'.tr(),
              style: AppTypography.medium18.copyWith(
                color: AppColors.neutral900,
                fontWeight: FontWeight.w600,
              ),
            ),
            Gap(24),

            Row(
              children: [
                // OY PICKER
                Expanded(
                  child: Column(
                    children: [
                      Text(
                        'month'.tr(),
                        style: AppTypography.medium12.copyWith(
                          color: AppColors.neutral500,
                          letterSpacing: 1.2,
                        ),
                      ),
                      Gap(8),
                      Container(
                        height: 160,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          color: AppColors.neutral50,
                          border: Border.all(color: AppColors.neutral300),
                        ),
                        child: ListWheelScrollView.useDelegate(
                          controller: _monthController,
                          itemExtent: 48,
                          perspective: 0.004,
                          diameterRatio: 1.8,
                          physics: FixedExtentScrollPhysics(),
                          onSelectedItemChanged: (index) {
                            setState(() {
                              selectedMonth = index + 1;
                            });
                          },
                          childDelegate: ListWheelChildListDelegate(
                            children: availableMonths.map((month) {
                              final monthIndex = _monthNames.indexOf(month);
                              final isSelected =
                                  monthIndex + 1 == selectedMonth;
                              return Center(
                                child: Text(
                                  month,
                                  style: AppTypography.medium16.copyWith(
                                    color: isSelected
                                        ? AppColors.primary
                                        : AppColors.neutral700,
                                    fontWeight: isSelected
                                        ? FontWeight.bold
                                        : FontWeight.w500,
                                  ),
                                ),
                              );
                            }).toList(),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                Gap(16),

                // YIL PICKER
                Expanded(
                  child: Column(
                    children: [
                      Text(
                        'year'.tr(),
                        style: AppTypography.medium12.copyWith(
                          color: AppColors.neutral500,
                          letterSpacing: 1.2,
                        ),
                      ),
                      Gap(8),
                      Container(
                        height: 160,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          color: AppColors.neutral50,
                          border: Border.all(color: AppColors.neutral300),
                        ),
                        child: ListWheelScrollView.useDelegate(
                          controller: _yearController,
                          itemExtent: 48,
                          perspective: 0.004,
                          diameterRatio: 1.8,
                          physics: FixedExtentScrollPhysics(),
                          onSelectedItemChanged: (index) {
                            setState(() {
                              selectedYear = 2025 + index;
                              // Yil o'zgarganda, agar oy chegaradan oshsa → to'g'rilash
                              final maxMonth = selectedYear < _currentYear
                                  ? 12
                                  : _currentMonth;
                              if (selectedMonth > maxMonth) {
                                selectedMonth = maxMonth;
                                _monthController.jumpToItem(selectedMonth - 1);
                              }
                            });
                          },
                          childDelegate: ListWheelChildBuilderDelegate(
                            builder: (context, index) {
                              if (index >= _availableYears.length) return null;
                              final year = _availableYears[index];
                              final isSelected = year == selectedYear;
                              return Center(
                                child: Text(
                                  year.toString(),
                                  style: AppTypography.medium16.copyWith(
                                    color: isSelected
                                        ? AppColors.primary
                                        : AppColors.neutral700,
                                    fontWeight: isSelected
                                        ? FontWeight.bold
                                        : FontWeight.w500,
                                  ),
                                ),
                              );
                            },
                            childCount: _availableYears.length,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),

            Gap(32),

            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: () => Navigator.pop(context),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.neutral100,
                      foregroundColor: AppColors.neutral700,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      padding: EdgeInsets.symmetric(vertical: 14),
                    ),
                    child: Text('cancel'.tr(), style: AppTypography.medium14),
                  ),
                ),
                Gap(12),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      final newDate = DateTime(selectedYear, selectedMonth);
                      widget.onDateSelected(newDate);
                      Navigator.pop(context);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      foregroundColor: Colors.white,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      padding: EdgeInsets.symmetric(vertical: 14),
                    ),
                    child: Text(
                      'select1'.tr(),
                      style: AppTypography.medium14.copyWith(
                        color: Colors.white,
                      ),
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
