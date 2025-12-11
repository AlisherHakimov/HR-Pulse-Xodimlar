import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:hr_plus/core/components/app_button.dart';

class CustomTimePicker extends StatefulWidget {
  final TimeOfDay initialTime;
  final Function(TimeOfDay)? onTimeSelected;

  const CustomTimePicker({
    Key? key,
    required this.initialTime,
    this.onTimeSelected,
  }) : super(key: key);

  // static void show({
  //   required BuildContext context,
  //   required TimeOfDay initialTime,
  //   Function(TimeOfDay)? onTimeSelected,
  // }) {
  //   showModalBottomSheet(
  //     context: context,
  //     isScrollControlled: true,
  //     useSafeArea: true,
  //     builder: (BuildContext context) {
  //       return CustomTimePicker(
  //         initialTime: initialTime,
  //         onTimeSelected: onTimeSelected,
  //       );
  //     },
  //   );
  // }

  @override
  State<CustomTimePicker> createState() => _CustomTimePickerState();
}

class _CustomTimePickerState extends State<CustomTimePicker> {
  late TimeOfDay selectedTime;
  late FixedExtentScrollController hourController;
  late FixedExtentScrollController minuteController;
  late FixedExtentScrollController separatorController;

  // Infinite scroll uchun katta raqam - bu markaziy offset
  static const int _infiniteScrollOffset = 10000;

  @override
  void initState() {
    super.initState();
    selectedTime = widget.initialTime;

    // ListWheelChildLoopingListDelegate ishlatganda faqat haqiqiy qiymatni o'rnatamiz
    hourController = FixedExtentScrollController(
      initialItem: selectedTime.hour,
    );
    minuteController = FixedExtentScrollController(
      initialItem: selectedTime.minute,
    );
    separatorController = FixedExtentScrollController(
      initialItem: 4, // Separator uchun doim 0
    );
  }

  @override
  void dispose() {
    hourController.dispose();
    minuteController.dispose();
    separatorController.dispose();
    super.dispose();
  }

  // Soat uchun infinite scroll (ikki tomonga ham)
  int _getHourFromIndex(int index) {
    // Manfiy indekslar uchun ham to'g'ri ishlashi uchun
    return ((index % 24) + 24) % 24;
  }

  // Daqiqa uchun infinite scroll (ikki tomonga ham)
  int _getMinuteFromIndex(int index) {
    // Manfiy indekslar uchun ham to'g'ri ishlashi uchun
    return ((index % 60) + 60) % 60;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(20),
          bottom: Radius.circular(20),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Header
          Padding(
            padding: const EdgeInsets.all(24),
            child: Text(
              'Vaqtni tanlang',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                height: 1.5,
                color: Color(0xFF212121),
              ),
            ),
          ),
          Container(
            height: 240,
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: Stack(
              children: [
                // Fixed selection indicator in center
                Positioned.fill(
                  child: Center(
                    child: Container(
                      height: 56,
                      margin: EdgeInsets.symmetric(horizontal: 0),
                      decoration: BoxDecoration(
                        color: Colors.grey[200],
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ),
                ),

                // Scrollable time pickers
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Hours
                    SizedBox(
                      width: 56,
                      child: ListWheelScrollView.useDelegate(
                        controller: hourController,
                        itemExtent: 56,
                        perspective: 0.0005,
                        diameterRatio: 3,
                        physics: FixedExtentScrollPhysics(),
                        onSelectedItemChanged: (index) {
                          final hour = index % 24;
                          setState(() {
                            selectedTime = TimeOfDay(
                              hour: hour,
                              minute: selectedTime.minute,
                            );
                          });
                        },
                        childDelegate: ListWheelChildLoopingListDelegate(
                          children: List.generate(24, (index) {
                            bool isSelected = index == selectedTime.hour;
                            bool isNeighbour =
                                index == selectedTime.hour + 1 ||
                                index == selectedTime.hour - 1;
                            return _buildTimeItem(
                              index.toString().padLeft(2, '0'),
                              isSelected,
                              false,
                              isNeighbour,
                            );
                          }),
                        ),
                      ),
                    ),

                    // Colon separator
                    SizedBox(
                      width: 56,
                      child: ListWheelScrollView.useDelegate(
                        controller: separatorController,
                        itemExtent: 56,
                        perspective: 0.0005,
                        diameterRatio: 2,
                        physics: NeverScrollableScrollPhysics(),
                        onSelectedItemChanged: (index) {},
                        childDelegate: ListWheelChildBuilderDelegate(
                          childCount: _infiniteScrollOffset * 2,
                          builder: (context, index) {
                            int currentSelectedIndex =
                                separatorController.hasClients
                                ? (separatorController.selectedItem ?? 0)
                                : 0;
                            bool isSelected = index == currentSelectedIndex;
                            bool isNeighbour =
                                index == currentSelectedIndex + 1 ||
                                index == currentSelectedIndex - 1;
                            return _buildTimeItem(
                              ':',
                              isSelected,
                              false,
                              isNeighbour,
                            );
                          },
                        ),
                      ),
                    ),

                    // Minutes
                    SizedBox(
                      width: 64,
                      child: ListWheelScrollView.useDelegate(
                        controller: minuteController,
                        itemExtent: 64,
                        perspective: 0.0005,
                        diameterRatio: 3,
                        physics: FixedExtentScrollPhysics(),
                        onSelectedItemChanged: (index) {
                          final minute = index % 60;
                          setState(() {
                            selectedTime = TimeOfDay(
                              hour: selectedTime.hour,
                              minute: minute,
                            );
                          });
                        },
                        childDelegate: ListWheelChildLoopingListDelegate(
                          children: List.generate(60, (index) {
                            bool isSelected = index == selectedTime.minute;
                            bool isNeighbour =
                                index == selectedTime.minute + 1 ||
                                index == selectedTime.minute - 1;
                            return _buildTimeItem(
                              index.toString().padLeft(2, '0'),
                              isSelected,
                              false,
                              isNeighbour,
                            );
                          }),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          // Buttons
          Container(
            padding: EdgeInsets.all(20),
            child: Row(
              children: [
                Expanded(
                  child: AppButton(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    height: 40,
                    title: 'cancel'.tr(),
                    background: Color(0xFFF6F6F6),
                    titleColor: Color(0xFF282828),
                  ),
                ),
                SizedBox(width: 12),
                Expanded(
                  child: AppButton(
                    onTap: () {
                      widget.onTimeSelected?.call(selectedTime);
                      Navigator.of(context).pop(selectedTime);
                    },
                    height: 40,

                    title: 'Tanlash',
                  ),
                ),
              ],
            ),
          ),

          // Bottom safe area
          SizedBox(height: MediaQuery.of(context).padding.bottom),
        ],
      ),
    );
  }

  Widget _buildTimeItem(
    String text,
    bool isSelected,
    bool showBackground,
    bool isNeighbour,
  ) {
    return Container(
      height: 64,
      width: 64,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: showBackground && isSelected
            ? Colors.grey[200]
            : Colors.transparent,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        text,
        style: TextStyle(
          fontSize: isSelected ? 24 : 20,
          fontWeight: isSelected ? FontWeight.w700 : FontWeight.w600,
          color: isSelected
              ? Color(0xFF0D121C)
              : isNeighbour
              ? Color(0xFF4D5761)
              : Color(0xFFD2D6DB),
        ),
      ),
    );
  }
}
