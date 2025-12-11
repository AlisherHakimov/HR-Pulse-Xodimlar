import 'package:flutter/material.dart';

TimeOfDay? parseDateTimeStringToTimeOfDay(String? dateTimeStr) {
  if (dateTimeStr == null || dateTimeStr.isEmpty) return null;

  try {
    // "25.11.2025 09:30:00" → faqat vaqt qismini ajratamiz
    final timePart = dateTimeStr.trim().split(' ')[1]; // "09:30:00"

    final timeComponents = timePart.split(':');
    final hour = int.parse(timeComponents[0]);
    final minute = int.parse(timeComponents[1]);

    return TimeOfDay(hour: hour, minute: minute);
  } catch (e) {
    print("Vaqt parse qilishda xato: $e, input: $dateTimeStr");
    return null;
  }
}