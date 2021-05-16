import 'package:calendar_sched/drawer/main_drawer.dart';
import 'package:calendar_sched/screens/calendar_screen.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key? key, this.title}) : super(key: key);

  final String? title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  
  // @override
  // void initState() {
  //   super.initState();

  //   Navigator.of(context).push(
  //     MaterialPageRoute(
  //       builder: (context) => CalendarScreen(),
  //     ),
  //   );
  // }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Calendar',
      themeMode: ThemeMode.dark,
      darkTheme: ThemeData.dark(),
      home: CalendarScreen(),
    );
  }
}
