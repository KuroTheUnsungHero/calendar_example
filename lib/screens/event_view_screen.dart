import 'package:calendar_sched/database/database_helper.dart';
import 'package:calendar_sched/model/event.dart';
import 'package:calendar_sched/screens/calendar_screen.dart';
import 'package:calendar_sched/screens/edit_event_screen.dart';
import 'package:calendar_sched/utils/utils.dart';
import 'package:flutter/material.dart';

class EventViewScreen extends StatelessWidget {
  final Event? event;

  const EventViewScreen({
    @required this.event,
    Key? key,
  }) : super(key: key);

  Future deleteEvent(BuildContext context) async {
    DatabaseHelper.instance.delete(event!);

    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => CalendarScreen(),
      ),
    );
  }

  Future editEvent(BuildContext context) async {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => EditEventScreen(event: event,),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: CloseButton(),
        actions: _buildEditingActions(context),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(12),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(height: 10),
            _buildFromDateDisplay(),
            SizedBox(height: 10),
            _buildToDateDisplay(),
            SizedBox(height: 10),
            _buildDisplayArea(),
          ],
        ),
      ),
    );
  }

  List<Widget> _buildEditingActions(BuildContext context) => [
    ElevatedButton.icon(
      style: ElevatedButton.styleFrom(
        primary: Colors.transparent,
        shadowColor: Colors.transparent,
      ),
      onPressed: () => editEvent(context), 
      icon: Icon(Icons.edit), 
      label: Text('')
    ),
    ElevatedButton.icon(
      style: ElevatedButton.styleFrom(
        primary: Colors.transparent,
        shadowColor: Colors.transparent,
      ),
      onPressed: () => deleteEvent(context), 
      icon: Icon(Icons.delete), 
      label: Text('')
    )
  ];

  Widget _buildDisplayArea() => Column(
    children: [
      Text(
        event!.title,
        style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
      ),
      Text(
        event!.description,
      )
    ],
  );

  Widget _buildFromDateDisplay() => Row(
    children: [
      Expanded(
        child: Text(
          'FROM',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        )
      ),
      Expanded(
        child: Text(
          Utils.toDateTime(event!.fromDate),
        )
      ),
    ],
  );

  Widget _buildToDateDisplay() => Row(
    children: [
      Expanded(
        child: Text(
          'TO',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        )
      ),
      Expanded(
        child: Text(
          Utils.toDateTime(event!.toDate),
        )
      ),
    ],
  );
}