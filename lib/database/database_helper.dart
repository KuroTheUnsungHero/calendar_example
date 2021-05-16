import 'dart:io';
import 'package:calendar_sched/model/event.dart';
import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart';

final String tableEvents = 'events';
final String columnId = '_id';
final String columnTitle = 'title';
final String columnDescription = 'description';
final String columnFromDate = 'fromDate';
final String columnToDate = 'toDate';
final String backgroundColor = 'backgroundColor';
final String allDayStatus = 'allDay';

class DatabaseHelper {

  // This is the actual database filename that is saved in the docs directory.
  static final _databaseName = "events.db";
  // Increment this version when you need to change the schema.
  static final _databaseVersion = 1;

  // Make this a singleton class.
  DatabaseHelper._privateConstructor();
  static final DatabaseHelper instance = DatabaseHelper._privateConstructor();

  // Only allow a single open connection to the database.
  late Database _database;
  Future<Database> get database async {
    _database = await _initDatabase();
    return _database;
  }

  // open the database
  _initDatabase() async {
    // The path_provider plugin gets the right directory for Android or iOS.
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, _databaseName);
    // Open the database. Can also add an onUpdate callback parameter.
    return await openDatabase(path,
        version: _databaseVersion,
        onCreate: _onCreate);
  }

  // SQL string to create the database 
  Future _onCreate(Database db, int version) async {
    await db.execute('''
          CREATE TABLE $tableEvents (
            $columnId INTEGER PRIMARY KEY,
            $columnTitle TEXT NOT NULL,
            $columnDescription TEXT,
            $columnFromDate TEXT NOT NULL,
            $columnToDate TEXT NOT NULL,
            $backgroundColor INTEGER NOT NULL,
            $allDayStatus INTEGER NOT NULL
          )
          ''');
  }

  // Database helper methods:
  Future<int> insertUpdate(Event event, Event oldEvent, bool isEdit) async {
    Database db = await database;

    if (!isEdit) {
      int id = await db.insert(tableEvents, event.toMap());
      return id;
    } else {
      return update(event, oldEvent);
    }
  }

  Future<List<Event>> queryEvents() async {
    List<Event> events = [];
    Database db = await database;
    List<Map> maps = await db.query(tableEvents);

    for (int i = 0; i < maps.length; i++) {
      Event eventsFromDb = Event.fromMap(maps[i]);
      events.add(eventsFromDb);
    }

    return events;
  }

  Future<int> update(Event event, Event oldEvent) async {
    Database db = await database;

    Map<String, dynamic> row = {
      columnDescription: event.description,
      columnFromDate: event.fromDate.toString(),
      columnToDate: event.toDate.toString(),
      allDayStatus: event.isAllday ? '1':'0'
    };

    if (event.backgroundColor == Colors.red) {
      row[backgroundColor] = 0;
    } else if (event.backgroundColor == Colors.deepOrange) {
      row[backgroundColor] = 1;
    } else if (event.backgroundColor == Colors.yellow) {
      row[backgroundColor] = 2;
    } else if (event.backgroundColor == Colors.lightGreen) {
      row[backgroundColor] = 3;
    } else if (event.backgroundColor == Colors.blue) {
      row[backgroundColor] = 4;
    } else if (event.backgroundColor == Colors.purple) {
      row[backgroundColor] = 5;
    }
    
    int updateCount = await db.update(
        tableEvents,
        row,
        where: '$columnTitle = ?',
        whereArgs: [oldEvent.title]);

    return updateCount;
  }

  Future<int> delete(Event event) async {
    Database db = await database;

    int deleteCount = await db.delete(
        tableEvents,
        where: '$columnTitle = ?',
        whereArgs: [event.title]);

    return deleteCount;
  }

  Future<List<Event>> queryEventsByDate(DateTime selectedDate) async {
    List<Event> events = [];
    var selectedDateStr = selectedDate.toString();
    Database db = await database;
    List<Map> maps = await db.rawQuery('''SELECT * FROM $tableEvents WHERE date($columnFromDate) >= date('$selectedDateStr') AND date($columnFromDate) < date('$selectedDateStr', '+1 day')''');

    for (int i = 0; i < maps.length; i++) {
      Event eventsFromDb = Event.fromMap(maps[i]);
      events.add(eventsFromDb);
    }

    return events;
  }

  Future<List<List<dynamic>>> queryEventsForExport() async {
    List<List<dynamic>> list = [];
    List<dynamic> events = [];
    Database db = await database;
    List<Map> maps = await db.query(tableEvents);

    for (int i = 0; i < maps.length; i++) {
      Event eventsFromDb = Event.fromMap(maps[i]);
      events.add(eventsFromDb);
    }

    list.add(events);
    return list;
  }
}