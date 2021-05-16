import 'package:calendar_sched/database/database_helper.dart';
import 'package:calendar_sched/model/event.dart';
import 'package:calendar_sched/model/event_data_source.dart';
import 'package:calendar_sched/screens/edit_event_screen.dart';
import 'package:calendar_sched/widget/calendar_widget.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';
import '../drawer/main_drawer.dart';

class CalendarScreen extends StatefulWidget {
  const CalendarScreen({Key? key}) : super(key: key);

  @override
  _CalendarScreenState createState() => _CalendarScreenState();
}

class _CalendarScreenState extends State<CalendarScreen> {
  late List<Event> events = [];

  void _goToEditScreen(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => EditEventScreen(),
      ),
    );
  }

  @override
  void initState() {
    super.initState();

    getEvents();
  }

  Future getEvents() async {
    this.events = await DatabaseHelper.instance.queryEvents();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
    future: DatabaseHelper.instance.queryEvents(),
    builder: (context, AsyncSnapshot<List<Event>> snapshot) {
      if (snapshot.hasData) {
        return Center( child: _buildCalendar(context, snapshot.data));
      }else
      return Center(
        child: CircularProgressIndicator(),
      );
    });
  }

  Widget _buildCalendar(BuildContext context, List<Event>? events) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Calendar'),
      ),
      drawer: Drawer(
        child: MainDrawer(),
      ),
      body: SfCalendar(
        view: CalendarView.month,
        dataSource: EventDataSource(events),
        onLongPress: (details) {
          final selectedDate = details.date!;

          showModalBottomSheet(
            context: context, 
            builder: (context) => CalendarWidget(selectedDate: selectedDate,),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _goToEditScreen(context),
        child: Icon(Icons.add),
      ),
    );
  }
}