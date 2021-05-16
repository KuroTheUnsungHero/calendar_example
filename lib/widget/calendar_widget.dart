import 'package:calendar_sched/database/database_helper.dart';
import 'package:calendar_sched/model/event.dart';
import 'package:calendar_sched/model/event_data_source.dart';
import 'package:calendar_sched/screens/event_view_screen.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';
import 'package:syncfusion_flutter_core/theme.dart';

class CalendarWidget extends StatefulWidget {
  final DateTime? selectedDate;

  const CalendarWidget({
    Key? key,
    this.selectedDate,
  }) : super(key: key);

  @override
  _CalendarWidgetState createState() => _CalendarWidgetState();
}

class _CalendarWidgetState extends State<CalendarWidget> {

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
    future: DatabaseHelper.instance.queryEventsByDate(widget.selectedDate!),
    builder: (context, AsyncSnapshot<List<Event>> snapshot) {
      if (snapshot.hasData) {
        return Center(
          child: _buildModal(context, snapshot.data),
        );
      } else
      return Center(
        child: CircularProgressIndicator(),
      );
    });
  }

  Widget _buildModal(BuildContext context, List<Event>? events) {

    if(events!.isEmpty) {
      return Center(
        child: Text(
          'No events found!',
          style: TextStyle(color: Colors.black, fontSize: 24),  
        ),
      );
    }

    return SfCalendarTheme(
      data: SfCalendarThemeData(
        headerTextStyle: TextStyle(color: Colors.white, fontSize: 16),
        timeTextStyle: TextStyle(color: Colors.white, fontSize: 16)
      ),
      child: SfCalendar(
        cellBorderColor: Colors.white,
        backgroundColor: Colors.black,
        todayHighlightColor: Colors.white,
        view: CalendarView.timelineDay,
        dataSource: EventDataSource(events),
        initialDisplayDate: widget.selectedDate,
        onTap: (details) {
          if (details.appointments == null) return;

          final event = details.appointments!.first;
          
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => EventViewScreen(event: event,),
            ),
          );
        },
      ),
    );
  }
}