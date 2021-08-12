import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'package:date_format/date_format.dart';

import 'package:intl/intl.dart';
import 'package:weighttrackerapp/pages/listpage.dart';

class WeightTracker extends StatefulWidget {
  const WeightTracker({Key? key}) : super(key: key);

  @override
  _WeightTrackerState createState() => _WeightTrackerState();
}

class _WeightTrackerState extends State<WeightTracker> {
  final _formKey = GlobalKey<FormState>();

  var weight = '';
  var _setTime = '';

  String _hour = '', _minute = '', _time = '';

  String dateTime = '';

  TimeOfDay selectedTime = TimeOfDay(hour: 00, minute: 00);

  final weightController = TextEditingController();

  final _timeController = TextEditingController();

  Future<Null> _selectTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: selectedTime,
    );
    if (picked != null)
      setState(() {
        selectedTime = picked;
        _hour = selectedTime.hour.toString();
        _minute = selectedTime.minute.toString();
        _time = _hour + ' : ' + _minute;
        _timeController.text = _time;
        _timeController.text = formatDate(
            DateTime(2019, 08, 1, selectedTime.hour, selectedTime.minute),
            [hh, ':', nn, " ", am]).toString();
      });
  }

  @override
  void initState() {
    _timeController.text = formatDate(
        DateTime(2019, 08, 1, DateTime.now().hour, DateTime.now().minute),
        [hh, ':', nn, " ", am]).toString();
    super.initState();
  }

  CollectionReference weights = FirebaseFirestore.instance.collection('weight');

  Future<void> addUser() {
    // Call the user's CollectionReference to add a new user
    return weights
        .add({
          'weight': weight,
          'time': _setTime,
        })
        .then((value) => //print("User Added")
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                backgroundColor: Colors.redAccent,
                content: Text(
                  "user weight Tracker is added",
                  style: TextStyle(fontSize: 18.0),
                ),
              ),
            ))
        .catchError((error) => //print("Failed to add user: $error")

            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                backgroundColor: Colors.redAccent,
                content: Text(
                  "There are error",
                  style: TextStyle(fontSize: 18.0),
                ),
              ),
            ));
  }

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.

    _timeController.dispose();
    weightController.dispose();
    super.dispose();
  }

  clearText() {
    weightController.clear();
  }

  Widget build(BuildContext context) {
    dateTime = DateFormat.yMd().format(DateTime.now());
    return Scaffold(
      appBar: AppBar(
        title: Text("Add New weight"),
      ),
      body: Form(
        key: _formKey,
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 20, horizontal: 30),
          child: ListView(
            children: [
              Container(
                margin: EdgeInsets.symmetric(vertical: 10.0),
                child: TextFormField(
                  keyboardType: TextInputType.text,
                  autofocus: false,
                  decoration: InputDecoration(
                    labelText: 'weight: ',
                    labelStyle: TextStyle(fontSize: 20.0),
                    border: OutlineInputBorder(),
                    errorStyle:
                        TextStyle(color: Colors.redAccent, fontSize: 15),
                  ),
                  controller: weightController,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please Enter weight';
                    }
                    return null;
                  },
                ),
              ),
              Container(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: <Widget>[
                    Column(
                      children: <Widget>[
                        Text(
                          'Choose Time',
                          style: TextStyle(
                              fontStyle: FontStyle.italic,
                              fontWeight: FontWeight.w600,
                              letterSpacing: 0.5),
                        ),
                        InkWell(
                          onTap: () {
                            _selectTime(context);
                          },
                          child: Container(
                            margin: EdgeInsets.only(top: 30),
                            alignment: Alignment.center,
                            decoration: BoxDecoration(color: Colors.grey[200]),
                            child: TextFormField(
                              style: TextStyle(fontSize: 40),
                              textAlign: TextAlign.center,
                              /* onSaved: (String val) {
                        _setTime = val;
                      }, */
                              enabled: false,
                              keyboardType: TextInputType.text,
                              controller: _timeController,
                              decoration: InputDecoration(
                                  disabledBorder: UnderlineInputBorder(
                                      borderSide: BorderSide.none),
                                  // labelText: 'Time',
                                  contentPadding: EdgeInsets.all(5)),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Container(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        // Validate returns true if the form is valid, otherwise false.
                        if (_formKey.currentState!.validate()) {
                          setState(() {
                            weight = weightController.text;

                            _setTime = _timeController.text;

                            addUser();
                            clearText();
                          });
                        }
                      },
                      child: Text(
                        'AddWeight',
                        style: TextStyle(fontSize: 18.0),
                      ),
                    ),
                    ElevatedButton(
                      onPressed: () => {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ListPage(),
                            )),
                      },
                      child: Text(
                        'GoToList',
                        style: TextStyle(fontSize: 18.0),
                      ),
                      style: ElevatedButton.styleFrom(primary: Colors.blue),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
