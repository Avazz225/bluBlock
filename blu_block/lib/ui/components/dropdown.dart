import 'package:blu_block/classes/settings.dart';
import 'package:flutter/material.dart';

class DropdownComponent extends StatefulWidget {
  final int defaultValue;

  DropdownComponent({super.key, required this.defaultValue});

  @override
  _DropdownComponentState createState() => _DropdownComponentState();
}

class _DropdownComponentState extends State<DropdownComponent> {
  late int _selectedValue;
  final Settings settings = Settings();
  List options = ["Politiker/-in", "Influencer/-in", "Einzelperson"];

  @override
  void initState() {
    super.initState();
    _selectedValue = widget.defaultValue;
  }

  @override
  Widget build(BuildContext context) {
    return DropdownButton<int>(
      value: _selectedValue,
      onChanged: (newValue) {
        setState(() {
          _selectedValue = newValue!;
          settings.updateValue("blockLevel", newValue);
        });
      },
      items: <int>[1, 2, 3]
          .map<DropdownMenuItem<int>>((int value) {
        return DropdownMenuItem<int>(
          value: value,
          child: Text('${options[value-1]}'),
        );
      }).toList(),
    );
  }
}