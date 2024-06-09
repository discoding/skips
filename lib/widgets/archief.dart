import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:table_calendar/table_calendar.dart';
import '../assets/constants.dart';
import '../models/boxmodel.dart';
import '../providers/boxprovider.dart';


class BoxCalendar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final boxProvider = Provider.of<BoxProvider>(context);
    final box = boxProvider.box;



    return Scaffold(
      appBar: AppBar(
        title: Text(box.archief!.first.date.toString() + ' ' + box.nummer.toString()),
      ),
      body: TableCalendar(
        firstDay: DateTime.utc(DateTime.now().year - 1, 1, 1),
        lastDay: DateTime.utc(DateTime.now().year + 1, 12, 31),
        focusedDay: DateTime.now(),
        calendarFormat: CalendarFormat.month,
        calendarBuilders: CalendarBuilders(
          defaultBuilder: (context, day, _) {
            return _buildCalendarCell(day, box);
          },
          todayBuilder: (context, day, _) {
            return _buildCalendarCell(day, box);
          },
        ),
      ),
    );
  }

  Widget _buildCalendarCell(DateTime day, Box box) {
    Color backgroundColor = Colors.transparent;
    DateTime today = DateTime.now();

    if (box.archief != null && box.archief!.isNotEmpty) {
      // Iterate over each entry in the archief
      for (var history in box.archief!) {
        if (history.date!.year == day.year &&
            history.date!.month == day.month &&
            history.date!.day == day.day) {
          backgroundColor = history.status == true ? Constanten.kleurbezettingbezet : Constanten.kleurbezettingvrij;
          break; // Exit the loop if a matching date is found
        }
      }

      // Get the first date in the archief
      final firstDateInArchief = box.archief!.first.date;

      // Check if the current day is before the first date in the archief
      if (backgroundColor == Colors.transparent && day.isBefore(firstDateInArchief!)) {
        backgroundColor = Constanten.kleurbezettingonbekend;
      }
    }

    return Container(
      color: backgroundColor,
      alignment: Alignment.center,
      child: Text(day.day.toString()),
    );
  }
}
