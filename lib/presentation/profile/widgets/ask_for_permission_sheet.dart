import 'package:flutter/material.dart';
import 'package:hr_plus/core/core.dart';
import 'package:hr_plus/core/utils/functions/parce_time.dart';
import 'package:hr_plus/data/model/request/permission_request.dart';
import 'package:hr_plus/main.dart';
import 'package:hr_plus/presentation/profile/bloc/permission/permission_cubit.dart';
import 'package:hr_plus/presentation/profile/bloc/profile_cubit.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';
import 'package:numberpicker/numberpicker.dart';

class AskForPermissionSheet extends StatefulWidget {
  const AskForPermissionSheet({super.key});

  static void show(BuildContext context) => showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    useSafeArea: true,
    builder: (context) => AskForPermissionSheet(),
  );

  @override
  State<AskForPermissionSheet> createState() => _AskForPermissionSheetState();
}

class _AskForPermissionSheetState extends State<AskForPermissionSheet> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final TextEditingController _dateController = TextEditingController();
  final TextEditingController _fromController = TextEditingController();
  final TextEditingController _toController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();

  DateTimeRange? _selectedDateRange;

  final DateFormat _dateFormat = DateFormat(
    'dd MMM',
    localeStorage.language == 'uz' ? 'uz' : 'ru',
  );

  bool get _isSingleDay {
    if (_selectedDateRange == null) return false;
    final start = _selectedDateRange!.start;
    final end = _selectedDateRange!.end;
    return start.year == end.year &&
        start.month == end.month &&
        start.day == end.day;
  }

  Future<void> _pickDateRange() async {
    await showDialog(
      context: context,
      builder: (context) {
        DateRangePickerController controller = DateRangePickerController();
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
          contentPadding: EdgeInsets.all(16),
          content: StatefulBuilder(
            builder: (context, setDialogState) {
              return Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                ),
                width: context.width,
                height: 320,
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
                    minDate: DateTime.now(),
                    maxDate: DateTime.now().add(const Duration(days: 30)),
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
              onPressed: () {
                Navigator.pop(context);
              },
              style: ButtonStyle(
                backgroundColor: WidgetStatePropertyAll<Color>(
                  AppColors.neutral100,
                ),
                shape: WidgetStatePropertyAll<RoundedRectangleBorder>(
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
                disabledBackgroundColor: AppColors.neutral100,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              onPressed: () {
                if (tempRange?.startDate == null) {
                  showError(context, 'select_date'.tr());
                  return;
                }
                final start = tempRange!.startDate!;
                final end = tempRange!.endDate ?? start;

                setState(() {
                  _selectedDateRange = DateTimeRange(start: start, end: end);
                  final formattedStart = _dateFormat.format(start);
                  final formattedEnd = _dateFormat.format(end);
                  _dateController.text =
                      (start.day == end.day &&
                          start.month == end.month &&
                          start.year == end.year)
                      ? formattedStart
                      : '$formattedStart - $formattedEnd';
                });
                Navigator.pop(context);
              },
              child: Text('save'.tr(), style: TextStyle(color: Colors.white)),
            ),
          ],
        );
      },
    );
  }

  Future<void> _pickTime(
    TextEditingController controller, {
    required bool isFrom,
  }) async {
    final attendance = context.read<ProfileCubit>().state.user?.attendance;
    final TimeOfDay? workStart = parseDateTimeStringToTimeOfDay(
      attendance?.wtStart,
    );

    if (workStart == null) {
      showError(context, 'work_time_not_set'.tr());
      return;
    }

    TimeOfDay initialTime = workStart;

    // Agar allaqachon tanlangan bo'lsa
    if (controller.text.isNotEmpty) {
      final parsed = _parseTime(controller.text);
      if (parsed != null) initialTime = parsed;
    }

    TimeOfDay? minimumTime;
    TimeOfDay? maximumTime;

    if (isFrom) {
      // From faqat wtStart dan keyin yoki teng bo'lishi mumkin
      minimumTime = workStart;
      maximumTime = null; // cheklov yo'q
    } else {
      // To tanlayotganda
      final fromTime = _fromController.text.isNotEmpty
          ? _parseTime(_fromController.text)
          : null;

      if (fromTime != null) {
        // From dan 30 daqiqa keyin
        int minHour = fromTime.hour;
        int minMinute = fromTime.minute + 30;
        if (minMinute >= 60) {
          minHour += 1;
          minMinute -= 60;
        }
        minimumTime = TimeOfDay(hour: minHour, minute: minMinute);
      } else {
        // Agar From tanlanmagan bo'lsa, wtStart + 30 daqiqa
        int minHour = workStart.hour;
        int minMinute = workStart.minute + 30;
        if (minMinute >= 60) {
          minHour += 1;
          minMinute -= 60;
        }
        minimumTime = TimeOfDay(hour: minHour, minute: minMinute);
      }
      maximumTime = null; // To uchun yuqori cheklov yo'q
    }

    // initialTime ni cheklovlarga moslashtirish
    if (minimumTime != null) {
      final initMinutes = initialTime.hour * 60 + initialTime.minute;
      final minMinutes = minimumTime.hour * 60 + minimumTime.minute;

      if (initMinutes < minMinutes) {
        initialTime = minimumTime;
      }
    }

    final TimeOfDay? selected = await showDialog<TimeOfDay>(
      context: context,
      barrierDismissible: true,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        contentPadding: EdgeInsets.zero,
        insetPadding: const EdgeInsets.all(20),
        content: _CustomTimePickerWidget(
          initialTime: initialTime,
          minimumTime: minimumTime,
          maximumTime: maximumTime,
        ),
      ),
    );

    if (selected != null) {
      final String formatted = selected.format(context);

      if (isFrom) {
        _fromController.text = formatted;

        // Agar To tanlangan bo'lsa va endi From dan oldinroq bo'lsa → To ni tozalash
        if (_toController.text.isNotEmpty) {
          final toTime = _parseTime(_toController.text);
          if (toTime != null) {
            final fromMinutes = selected.hour * 60 + selected.minute;
            final toMinutes = toTime.hour * 60 + toTime.minute;

            if (toMinutes <= fromMinutes + 29) {
              // 30 daqiqadan kam bo'lsa
              _toController.clear();
            }
          }
        }
      } else {
        _toController.text = formatted;
      }

      setState(() {});
    }
  }

  TimeOfDay? _parseTime(String text) {
    if (text.isEmpty) return null;
    try {
      final parts = text.split(':');
      final hour = int.parse(parts[0]);
      final minuteStr = parts[1].split(' ').first;
      final minute = int.parse(minuteStr);
      return TimeOfDay(hour: hour, minute: minute);
    } catch (e) {
      return null;
    }
  }

  void _submitRequest() {
    if (_formKey.currentState!.validate()) {
      final bool isSingle = _isSingleDay;
      context.read<PermissionCubit>().askForPermission(
        request: PermissionRequest(
          mode: isSingle ? 'SINGLE' : 'RANGE',
          start:
              _selectedDateRange!.start.toString().split(' ')[0] +
              (isSingle ? ' ${_fromController.text}' : ''),
          end:
              _selectedDateRange!.end.toString().split(' ')[0] +
              (isSingle ? ' ${_toController.text}' : ''),
          comment: _descriptionController.text,
        ),
        onError: (msg) => showError(context, msg),
        onSuccess: () {
          context.pop();
          showSuccess(context, 'success_request_sent'.tr());
        },
      );
    }
  }

  @override
  void dispose() {
    _dateController.dispose();
    _fromController.dispose();
    _toController.dispose();
    _descriptionController.dispose();
    FocusScope.of(context).unfocus();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      width: context.width,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: SafeArea(
        top: false,
        child: SingleChildScrollView(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom + 20,
          ),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Center(
                  child: Text(
                    'ask_for_permission'.tr(),
                    style: AppTypography.semibold18.copyWith(
                      color: AppColors.neutral800,
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                Text(
                  'date'.tr(),
                  style: AppTypography.medium14.copyWith(
                    color: AppColors.neutral900,
                  ),
                ),
                const SizedBox(height: 4),
                CustomTextField(
                  controller: _dateController,
                  hintText: 'select_date'.tr(),
                  readOnly: true,
                  onTap: _pickDateRange,
                  suffixIcon: const Icon(
                    Icons.calendar_today,
                    color: AppColors.neutral400,
                  ),
                  validator: (value) =>
                      value?.isEmpty ?? true ? 'select_date'.tr() : null,
                ),

                const SizedBox(height: 16),

                if (_isSingleDay) ...[
                  SizedBox(
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'from'.tr(),
                                style: AppTypography.medium14.copyWith(
                                  color: AppColors.neutral900,
                                ),
                              ),
                              const SizedBox(height: 4),
                              CustomTextField(
                                controller: _fromController,
                                hintText: 'HH:MM',
                                readOnly: true,
                                onTap: () =>
                                    _pickTime(_fromController, isFrom: true),
                                suffixIcon: const Icon(
                                  Icons.access_time,
                                  color: AppColors.neutral400,
                                ),
                                validator: (value) {
                                  if (!_isSingleDay) return null;
                                  return value?.isEmpty ?? true
                                      ? 'select_start_date'.tr()
                                      : null;
                                },
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'to'.tr(),
                                style: AppTypography.medium14.copyWith(
                                  color: AppColors.neutral900,
                                ),
                              ),
                              const SizedBox(height: 4),
                              CustomTextField(
                                controller: _toController,
                                hintText: 'HH:MM',
                                readOnly: true,
                                onTap: () =>
                                    _pickTime(_toController, isFrom: false),
                                suffixIcon: const Icon(
                                  Icons.access_time,
                                  color: AppColors.neutral400,
                                ),
                                validator: (value) {
                                  if (!_isSingleDay) return null;
                                  return value?.isEmpty ?? true
                                      ? 'select_end_date'.tr()
                                      : null;
                                },
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                ],

                Text(
                  'comment'.tr(),
                  style: AppTypography.medium14.copyWith(
                    color: AppColors.neutral900,
                  ),
                ),
                const SizedBox(height: 4),
                CustomTextField(
                  controller: _descriptionController,
                  maxLines: 4,
                  hintText: 'type_your_comment'.tr(),
                  validator: (value) => (value?.isEmpty ?? true)
                      ? 'type_your_comment1'.tr()
                      : null,
                ),

                const SizedBox(height: 28),

                Row(
                  children: [
                    Expanded(
                      child: AppButton(
                        title: 'cancel'.tr(),
                        background: AppColors.primary50,
                        titleColor: AppColors.primary,
                        onTap: () => Navigator.pop(context),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: BlocBuilder<PermissionCubit, PermissionState>(
                        buildWhen: (p, c) => c.createStatus.isLoading,

                        builder: (context, state) {
                          return AppButton(
                            title: 'send_request'.tr(),
                            isLoading: state.createStatus.isLoading,
                            onTap: _submitRequest,
                          );
                        },
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _CustomTimePickerWidget extends StatefulWidget {
  final TimeOfDay initialTime;
  final TimeOfDay? minimumTime;
  final TimeOfDay? maximumTime;

  const _CustomTimePickerWidget({
    required this.initialTime,
    this.minimumTime,
    this.maximumTime,
  });

  @override
  State<_CustomTimePickerWidget> createState() =>
      _CustomTimePickerWidgetState();
}

class _CustomTimePickerWidgetState extends State<_CustomTimePickerWidget> {
  late int _hour;
  late int _minute;

  @override
  void initState() {
    super.initState();
    _hour = widget.initialTime.hour;
    _minute = widget.initialTime.minute;
  }

  @override
  Widget build(BuildContext context) {
    final int minHour = widget.minimumTime?.hour ?? 0;
    final int maxHour = widget.maximumTime?.hour ?? 23;

    int minMinute = 0;
    int maxMinute = 59;

    // Agar joriy soat minimum soatga teng bo'lsa → daqiqani cheklaymiz
    if (widget.minimumTime != null && _hour == minHour) {
      minMinute = widget.minimumTime!.minute;
    }

    // Agar joriy soat maximum soatga teng bo'lsa → daqiqani cheklaymiz
    if (widget.maximumTime != null && _hour == maxHour) {
      maxMinute = widget.maximumTime!.minute;
    }

    // CRITICAL FIX: Ensure _minute is within bounds
    if (_minute < minMinute) {
      _minute = minMinute;
    }
    if (_minute > maxMinute) {
      _minute = maxMinute;
    }

    return Container(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            'select_time'.tr(),
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: AppColors.neutral900,
            ),
          ),
          const SizedBox(height: 24),

          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              NumberPicker(
                minValue: minHour,
                maxValue: maxHour,
                value: _hour,
                zeroPad: true,
                textStyle: const TextStyle(
                  fontSize: 22,
                  color: AppColors.neutral400,
                ),
                selectedTextStyle: const TextStyle(
                  fontSize: 36,
                  fontWeight: FontWeight.bold,
                  color: AppColors.primary,
                ),
                onChanged: (value) {
                  setState(() {
                    _hour = value;

                    // Soatni o'zgartirganda daqiqani to'g'rilash
                    if (widget.minimumTime != null &&
                        value == minHour &&
                        _minute < widget.minimumTime!.minute) {
                      _minute = widget.minimumTime!.minute;
                    }
                    if (widget.maximumTime != null &&
                        value == maxHour &&
                        _minute > widget.maximumTime!.minute) {
                      _minute = widget.maximumTime!.minute;
                    }
                  });
                },
              ),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 24),
                child: Text(
                  ':',
                  style: TextStyle(fontSize: 40, fontWeight: FontWeight.bold),
                ),
              ),
              NumberPicker(
                minValue: minMinute,
                maxValue: maxMinute,
                value: _minute,
                zeroPad: true,
                textMapper: (numberValue) {
                  return numberValue.padLeft(2, '0');
                },
                step: 5,
                textStyle: const TextStyle(
                  fontSize: 22,
                  color: AppColors.neutral400,
                ),
                selectedTextStyle: const TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: AppColors.primary,
                ),
                onChanged: (value) => setState(() => _minute = value),
              ),
            ],
          ),

          const SizedBox(height: 32),

          Row(
            children: [
              Expanded(
                child: TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: Text(
                    'cancel'.tr(),
                    style: const TextStyle(color: AppColors.neutral600),
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                  ),
                  onPressed: () => Navigator.pop(
                    context,
                    TimeOfDay(hour: _hour, minute: _minute),
                  ),
                  child: Text(
                    'save'.tr(),
                    style: const TextStyle(color: Colors.white),
                  ),
                ),
              ),
            ],
          ),
          const SafeArea(child: SizedBox(height: 24)),
        ],
      ),
    );
  }
}
