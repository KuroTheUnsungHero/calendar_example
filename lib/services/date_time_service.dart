import 'package:flutter/material.dart';

class DateTimeService {
  Future pickDateTime({required bool pickDate, required DateTime dateTime, required BuildContext context}) async {
    final date = await _pickDateTime(dateTime, context, pickDate: pickDate);

    return date != null ? date : null;
  }

  Future<DateTime?> _pickDateTime(
    DateTime initialDate, 
    BuildContext context,
    {
      required bool pickDate,
      DateTime? firstDate,
    }
  ) async {
    if (pickDate) {
      final date = await showDatePicker(
        context: context, 
        initialDate: initialDate, 
        firstDate: firstDate ?? DateTime(2015, 8), 
        lastDate: DateTime(2101)
      );

      final time = Duration(
        hours: initialDate.hour,
        minutes: initialDate.minute
      );

      return date != null ? date.add(time) : null;
    } else {
      final timeOfDay = await showTimePicker(
        context: context, 
        initialTime: TimeOfDay.fromDateTime(initialDate),
      );

      if (timeOfDay != null) {
        final date = DateTime(initialDate.year, initialDate.month, initialDate.day);
        final time = Duration(
          hours: timeOfDay.hour,
          minutes: timeOfDay.minute
        );

        return date.add(time);
      } else {
        return null;
      }
    }
  }
}