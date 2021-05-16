import 'package:calendar_sched/database/database_helper.dart';
import 'package:calendar_sched/model/event.dart';
import 'package:calendar_sched/screens/calendar_screen.dart';
import 'package:calendar_sched/screens/edit_event_screen.dart';
import 'package:calendar_sched/services/import_export_service.dart';
import 'package:calendar_sched/utils/utils.dart';
import 'package:flutter/material.dart';

class ImportExportScreen extends StatelessWidget {

  const ImportExportScreen({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: CloseButton(),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(12),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(height: 10),
            _buildDisplayArea(),
          ],
        ),
      ),
    );
  }

  Widget _buildDisplayArea() => Column(
    children: [
      TextButton(
        style: ButtonStyle(
          foregroundColor: MaterialStateProperty.all<Color>(Colors.blue),
        ),
        onPressed: () { },
        child: Text('Import File'),
      ),
      TextButton(
        style: ButtonStyle(
          foregroundColor: MaterialStateProperty.all<Color>(Colors.blue),
        ),
        onPressed: () => {
          ImportExportService().export()
        },
        child: Text('Export File'),
      )
    ],
  );
}