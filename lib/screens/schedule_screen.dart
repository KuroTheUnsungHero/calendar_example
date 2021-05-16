import 'package:calendar_sched/database/database_helper.dart';
import 'package:calendar_sched/model/event.dart';
import 'package:calendar_sched/model/event_data_source.dart';
import 'package:calendar_sched/screens/event_view_screen.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';
import '../drawer/main_drawer.dart';

class ScheduleScreen extends StatefulWidget {
  const ScheduleScreen({Key? key}) : super(key: key);

  @override
  _ScheduleScreenState createState() => _ScheduleScreenState();
}

class _ScheduleScreenState extends State<ScheduleScreen> {

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
    future: DatabaseHelper.instance.queryEvents(),
    builder: (context, AsyncSnapshot<List<Event>> snapshot) {
      if (snapshot.hasData) {
        return Center( child: _buildSchedule(context, snapshot.data));
      }else
      return Center(
        child: CircularProgressIndicator(),
      );
    });
  }

  Widget _buildSchedule(BuildContext context, List<Event>? events) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Schedule'),
      ),
      drawer: Drawer(
        child: MainDrawer(),
      ),
      body: SfCalendar(
        view: CalendarView.schedule,
        dataSource: EventDataSource(events),
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