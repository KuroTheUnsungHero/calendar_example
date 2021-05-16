import 'package:calendar_sched/screens/calendar_screen.dart';
import 'package:calendar_sched/screens/import_export_screen.dart';
import 'package:calendar_sched/screens/schedule_screen.dart';
import 'package:flutter/material.dart';

class MainDrawer extends StatelessWidget {

  void _goToCalendar(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => CalendarScreen(),
      ),
    );
  }

  void _goToSchedule(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => ScheduleScreen(),
      ),
    );
  }

  void _goToImportExport(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => ImportExportScreen(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: [
          Container(
            width: double.infinity,
            padding: EdgeInsets.all(20),
            color: Theme.of(context).primaryColor,
            child: Center(
              child: Column(
                children: [
                  Container(
                    width: 100,
                    height: 100,
                    margin: EdgeInsets.only(
                      top: 30
                    ),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      image: DecorationImage(
                        image: AssetImage('assets/images/yoshida3.png'),
                        fit: BoxFit.fill
                      ),
                    ),
                  ),
                  Text(
                    'Yoshida', 
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.white
                    ),
                  ),
                  Text(
                    'yoshidaman@yahoo.com', 
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.white
                    ),
                  ),
                ],
              ),
            ),
          ),
          ListTile(
            leading: Icon(Icons.calendar_today_outlined),
            title: Text(
              'Calendar',
              style: TextStyle(fontSize: 16),
            ),
            onTap: () => _goToCalendar(context),
          ),
          ListTile(
            leading: Icon(Icons.list),
            title: Text(
              'Schedule',
              style: TextStyle(fontSize: 16),
            ),
            onTap: () => _goToSchedule(context),
          ),
          ListTile(
            leading: Icon(Icons.save),
            title: Text(
              'Import/Export',
              style: TextStyle(fontSize: 16),
            ),
            onTap: () => _goToImportExport(context),
          ),
        ],
      ),
    );
  }
}