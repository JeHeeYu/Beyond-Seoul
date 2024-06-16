import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../../statics/colors.dart';

class ScheduleWidget extends StatefulWidget {
  final void Function(DateTime selectedDay) onDaySelected;
  final DateTime? endDateDisable;
  final DateTime? startDate;

  const ScheduleWidget({
    Key? key,
    required this.onDaySelected,
    this.endDateDisable,
    this.startDate,
  }) : super(key: key);

  @override
  State<ScheduleWidget> createState() => _ScheduleWidgetState();
}

class _ScheduleWidgetState extends State<ScheduleWidget> {
  DateTime selectedDay = DateTime.now();
  DateTime focusedDay = DateTime.now();

  @override
  Widget build(BuildContext context) {
    return TableCalendar(
      calendarBuilders: CalendarBuilders(
        dowBuilder: (context, day) {
          if (day.weekday == DateTime.sunday) {
            return const Center(
              child: Text(
                '일',
                style: TextStyle(color: Colors.red),
              ),
            );
          }
          if (day.weekday == DateTime.saturday) {
            return const Center(
              child: Text(
                '토',
                style: TextStyle(color: Colors.blue),
              ),
            );
          }
        },
      ),
      focusedDay: DateTime.now(),
      firstDay: DateTime(1900),
      lastDay: DateTime(3000),
      locale: 'ko-KR',
      headerStyle: const HeaderStyle(
        formatButtonVisible: false,
        titleCentered: true,
        titleTextStyle: TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 20.0,
        ),
      ),
      calendarStyle: const CalendarStyle(
        isTodayHighlighted: true,
        outsideDaysVisible: false,
        todayDecoration: BoxDecoration(
          color: Color(UserColors.enable),
          shape: BoxShape.circle,
        ),
      ),
      enabledDayPredicate: (DateTime day) {
        if (widget.startDate != null && widget.endDateDisable != null) {
          return day.isAfter(widget.startDate!.subtract(Duration(days: 1))) && 
                 day.isBefore(widget.endDateDisable!.add(Duration(days: 1)));
        } else if (widget.startDate != null) {
          return day.isAfter(widget.startDate!.subtract(Duration(days: 1)));
        } else if (widget.endDateDisable != null) {
          return day.isBefore(widget.endDateDisable!.add(Duration(days: 1)));
        }
        return true;
      },
      onDaySelected: (DateTime selectedDay, DateTime focusedDay) {
        setState(() {
          this.selectedDay = selectedDay;
          this.focusedDay = focusedDay;
        });

        widget.onDaySelected(selectedDay);

        Navigator.of(context).pop();
      },
      selectedDayPredicate: (DateTime day) {
        return isSameDay(selectedDay, day);
      },
    );
  }
}

void showScheduleBottomSheet(
    BuildContext context, void Function(DateTime) callback, {DateTime? startDate, DateTime? endDateDisable}) {
  showModalBottomSheet(
    context: context,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.only(
        topLeft: Radius.circular(20),
        topRight: Radius.circular(20),
      ),
    ),
    isScrollControlled: true,
    builder: (BuildContext context) {
      return FractionallySizedBox(
        heightFactor: 0.6,
        child: ScheduleWidget(
          onDaySelected: callback,
          startDate: startDate,
          endDateDisable: endDateDisable,
        ),
      );
    },
  );
}
