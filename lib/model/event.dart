import 'package:flutter/material.dart';

final String tableEvents = 'events';
final String columnId = '_id';
final String columnTitle = 'title';
final String columnDescription = 'description';
final String columnFromDate = 'fromDate';
final String columnToDate = 'toDate';
final String backgroundColorDb = 'backgroundColor';
final String allDayStatus = 'allDay';

class Event {
  late String title;
  late String description;
  late DateTime fromDate;
  late DateTime toDate;
  late Color backgroundColor;
  late bool isAllday;

  Event({
    required this.title,
    required this.description,
    required this.fromDate,
    required this.toDate,
    required this.backgroundColor,
    this.isAllday = false,
  });

  Event.fromMap(Map<dynamic, dynamic> map) {
    title = map[columnTitle];
    description = map[columnDescription];
    fromDate = DateTime.parse(map[columnFromDate]);
    toDate = DateTime.parse(map[columnToDate]);
    
    switch(map[backgroundColorDb]) {
      case 0: backgroundColor = Colors.red; break;
      case 1: backgroundColor = Colors.deepOrange; break;
      case 2: backgroundColor = Colors.yellow; break;
      case 3: backgroundColor = Colors.lightGreen; break;
      case 4: backgroundColor = Colors.blue; break;
      case 5: backgroundColor = Colors.purple; break;
      default: backgroundColor = Colors.red;
    }

    if (map[allDayStatus] == 0) {
      isAllday = false;
    } else {
      isAllday = true;
    }
  }

  // convenience method to create a Map from this Word object
  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{
      columnTitle: title,
      columnDescription: description,
      columnFromDate: fromDate.toString(),
      columnToDate: toDate.toString(),
      allDayStatus: isAllday ? '1':'0',
    };

    if (backgroundColor == Colors.red) {
      map[backgroundColorDb] = 0;
    } else if (backgroundColor == Colors.deepOrange) {
      map[backgroundColorDb] = 1;
    } else if (backgroundColor == Colors.yellow) {
      map[backgroundColorDb] = 2;
    } else if (backgroundColor == Colors.lightGreen) {
      map[backgroundColorDb] = 3;
    } else if (backgroundColor == Colors.blue) {
      map[backgroundColorDb] = 4;
    } else if (backgroundColor == Colors.purple) {
      map[backgroundColorDb] = 5;
    }

    return map;
  }
}