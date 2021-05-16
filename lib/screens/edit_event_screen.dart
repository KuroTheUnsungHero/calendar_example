import 'package:calendar_sched/database/database_helper.dart';
import 'package:calendar_sched/model/event.dart';
import 'package:calendar_sched/screens/calendar_screen.dart';
import 'package:calendar_sched/services/date_time_service.dart';
import 'package:calendar_sched/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_material_color_picker/flutter_material_color_picker.dart';

class EditEventScreen extends StatefulWidget {
  final Event? event;
  const EditEventScreen({
    Key? key,
    this.event,
  }) : super(key: key);

  @override
  _EditEventScreenState createState() => _EditEventScreenState();
}

class _EditEventScreenState extends State<EditEventScreen> {
  final _formKey = GlobalKey<FormState>();
  final titleController = TextEditingController();
  final descriptionController = TextEditingController();
  late DateTime fromDate;
  late DateTime toDate;
  late Color eventColor;
  late bool isEdit;

  @override
  void initState() {
    super.initState();

    if (widget.event == null) {
      fromDate = DateTime.now();
      toDate = DateTime.now().add(Duration(hours: 2));
      eventColor = Colors.red;
      isEdit = false;
    } else {
      final event = widget.event!;

      titleController.text = event.title;
      descriptionController.text = event.description;
      fromDate = event.fromDate;
      toDate = event.toDate;
      eventColor = event.backgroundColor;
      isEdit = true;
    }
  }

  @override
  void dispose() {
    titleController.dispose();
    descriptionController.dispose();

    super.dispose();
  }

  void _setDateTime({required bool pickDate, required DateTime dateTime, required BuildContext context, required bool isFromDate}) async {
    final date = await DateTimeService().pickDateTime(
      pickDate: pickDate, 
      dateTime: dateTime, 
      context: context
    );

    if (date != null) {
      if (isFromDate) {
        setState(() => fromDate = date);
      } else {
        setState(() => toDate = date);
      }

      if (toDate.isBefore(fromDate)) {
        setState(() => toDate = fromDate);
      }
    }
  }

  Future saveForm() async {
    final isValid = _formKey.currentState!.validate();

    if (isValid) {
      final event = Event(
        title: titleController.text,
        description: descriptionController.text,
        fromDate: fromDate,
        toDate: toDate,
        backgroundColor: eventColor,
        isAllday: false
      );

      DatabaseHelper.instance.insertUpdate(event, widget.event!, isEdit);
    }

    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => CalendarScreen(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: CloseButton(),
        actions: _buildEditingActions(),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(12),
        child: Form (
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildTitle(),
              _buildDateTimePickers(),
              _buildColorPicker(),
              _buildTextArea(),
            ],
          ),
        ),
      ),
    );
  }

  List<Widget> _buildEditingActions() => [
    ElevatedButton.icon(
      style: ElevatedButton.styleFrom(
        primary: Colors.transparent,
        shadowColor: Colors.transparent,
      ),
      onPressed: saveForm, 
      icon: Icon(Icons.done), 
      label: Text('Save')
    )
  ];

  Widget _buildTitle() => TextFormField(
    style: TextStyle(fontSize: 24),
    decoration: InputDecoration(
      border: UnderlineInputBorder(),
      hintText: 'Add Title',
    ),
    onFieldSubmitted: (_) {},
    validator: (title) => title != null && title.isEmpty ? 'Title cannot be empty' : null,
    controller: titleController,
  );

  Widget _buildDateTimePickers() => Column(
    children: [
      Text(
        'FROM',
        style: TextStyle(height: 3, fontSize: 16, decoration: TextDecoration.none),
        textAlign: TextAlign.left,
      ),
      _buildFromDate(),
      Text(
        'TO',
        style: TextStyle(height: 3, fontSize: 16, decoration: TextDecoration.none),
        textAlign: TextAlign.left,
      ),
      _buildToDate(),
    ],
  );

  Widget _buildFromDate() => Row(
    children: [
      Expanded(
        flex: 2,
        child: _buildDropdownField(
          text: Utils.toDate(fromDate),
          onClicked: () => _setDateTime(
            pickDate: true, 
            dateTime: fromDate, 
            context: context, 
            isFromDate: true
          ),
        )
      ),
      Expanded(
        child: _buildDropdownField(
          text: Utils.toTime(fromDate),
          onClicked: () => _setDateTime(
            pickDate: false, 
            dateTime: fromDate, 
            context: context, 
            isFromDate: true
          ),
        )
      ),
    ],
  );

  Widget _buildToDate() => Row(
    children: [
      Expanded(
        flex: 2,
        child: _buildDropdownField(
          text: Utils.toDate(toDate),
          onClicked: () => _setDateTime(
            pickDate: true, 
            dateTime: toDate, 
            context: context, 
            isFromDate: false
          ),
        )
      ),
      Expanded(
        child: _buildDropdownField(
          text: Utils.toTime(toDate),
          onClicked: () => _setDateTime(
            pickDate: false, 
            dateTime: toDate, 
            context: context, 
            isFromDate: false
          ),
        )
      ),
    ],
  );

  Widget _buildDropdownField({
    required String text,
    required VoidCallback onClicked,
  }) => ListTile(
    title: Text(text),
    trailing: Icon(Icons.arrow_drop_down),
    onTap: onClicked,
  );

  Widget _buildColorPicker() => Column(
    children: [ 
      Text(
        'Event Color',
        style: TextStyle(height: 3, fontSize: 16, decoration: TextDecoration.none),
        textAlign: TextAlign.left,
      ),
      SizedBox(
        height: 75,
        child: MaterialColorPicker(
          allowShades: false,
          onColorChange: (Color color) {
            setState(() => eventColor = color);
          },
          onMainColorChange: (Color color) {
            setState(() => eventColor = color);
          },
          selectedColor: eventColor,
          colors: [
              Colors.red,
              Colors.deepOrange,
              Colors.yellow,
              Colors.lightGreen,
              Colors.blue,
              Colors.purple
          ],
        )
      )
    ]
  );

  Widget _buildTextArea() => Column(
    children: [ 
      Text(
        'Add details',
        style: TextStyle(height: 3, fontSize: 16, decoration: TextDecoration.none),
        textAlign: TextAlign.left,
      ),
      Card(
        color: Colors.transparent,
        child: Padding(
          padding: EdgeInsets.all(8.0),
          child: TextFormField(
            maxLines: 5,
            decoration: InputDecoration(
              hintText: 'Enter your text here',
              border: InputBorder.none,
              focusedBorder: InputBorder.none,
              enabledBorder: InputBorder.none,
              errorBorder: InputBorder.none,
              disabledBorder: InputBorder.none,
            ),
            onFieldSubmitted: (_) {},
            controller: descriptionController,
          )
        )
      )
    ]
  );
}