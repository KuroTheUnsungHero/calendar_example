import 'dart:io';
import 'package:calendar_sched/database/database_helper.dart';
import 'package:csv/csv.dart';
import 'package:path_provider/path_provider.dart';

class ImportExportService {

  void export() async {
    late List<List<dynamic>> events = [];
    events = await DatabaseHelper.instance.queryEventsForExport();

    String csv = const ListToCsvConverter().convert(events);
    final String directory = (await getApplicationSupportDirectory()).path;
    final String path = '$directory/test.csv';
    final File file = File(path);
    await file.writeAsString(csv);
  }
}