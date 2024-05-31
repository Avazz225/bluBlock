import 'package:BluBlock/classes/settings.dart';
import 'package:flutter/material.dart';

class TimePickerComponent extends StatefulWidget {
  final int initialSeconds;
  final String variableName;

  const TimePickerComponent({super.key, required this.initialSeconds, required this.variableName});

  @override
  _TimePickerComponentState createState() => _TimePickerComponentState();
}

class _TimePickerComponentState extends State<TimePickerComponent> {
  late TimeOfDay _selectedTime;
  final Settings settings = Settings();

  @override
  void initState() {
    super.initState();
    _selectedTime = _secondsToTimeOfDay(widget.initialSeconds);
  }

  TimeOfDay _secondsToTimeOfDay(int seconds) {
    final int hours = seconds ~/ 3600;
    final int minutes = (seconds % 3600) ~/ 60;
    return TimeOfDay(hour: hours, minute: minutes);
  }

  int _timeOfDayToSeconds(TimeOfDay time) {
    return time.hour * 3600 + time.minute * 60;
  }

  Future<void> _selectTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: _selectedTime,
      builder: (BuildContext context, Widget? child) {
        return MediaQuery(
          data: MediaQuery.of(context).copyWith(alwaysUse24HourFormat: true),
          child: child ?? Container(),
        );
      },
    );
    if (picked != null && picked != _selectedTime) {
      setState(() {
        _selectedTime = picked;
        settings.updateValue(widget.variableName, _timeOfDayToSeconds(picked));
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        ElevatedButton(
          onPressed: () => _selectTime(context),
          child: Text(_selectedTime.format(context)),
        ),
      ],
    );
  }
}