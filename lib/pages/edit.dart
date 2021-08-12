import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:date_format/date_format.dart';

import 'package:flutter/material.dart';

class UpdatePage extends StatefulWidget {
  const UpdatePage({Key? key, required this.id}) : super(key: key);
  final String id;

  @override
  _UpdatePageState createState() => _UpdatePageState();
}

class _UpdatePageState extends State<UpdatePage> {
  final _formKey = GlobalKey<FormState>();

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

  CollectionReference weight = FirebaseFirestore.instance.collection('weight');

  Future<void> updateUser(id, weight, time) {
    return weight
        .doc(id)
        .update({
          'weight': weight,
          'time': time,
        })
        .then((value) =>
            //print("User Updated");
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                backgroundColor: Colors.redAccent,
                content: Text(
                  "user update",
                  style: TextStyle(fontSize: 18.0),
                ),
              ),
            ))
        .catchError((error) =>
            // print("Failed to update user: $error")
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                backgroundColor: Colors.redAccent,
                content: Text(
                  "user not update",
                  style: TextStyle(fontSize: 18.0),
                ),
              ),
            ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Update weight"),
      ),
      body: Form(
        key: _formKey,
        // Getting Specific Data by ID
        child: FutureBuilder<DocumentSnapshot<Map<String, dynamic>>>(
            future: FirebaseFirestore.instance
                .collection('weight')
                .doc(widget.id)
                .get(),
            builder: (_, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(
                  child: CircularProgressIndicator(),
                );
              }
              var data = snapshot.data!.data();
              var weight = data!['weight'];
              var time = data['time'];

              return Padding(
                padding: EdgeInsets.symmetric(vertical: 20, horizontal: 30),
                child: ListView(
                  children: [
                    Container(
                      margin: EdgeInsets.symmetric(vertical: 10.0),
                      child: TextFormField(
                        initialValue: weight,
                        autofocus: false,
                        onChanged: (value) => weight = value,
                        decoration: InputDecoration(
                          labelText: 'Weight: ',
                          labelStyle: TextStyle(fontSize: 20.0),
                          border: OutlineInputBorder(),
                          errorStyle:
                              TextStyle(color: Colors.redAccent, fontSize: 15),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please Enter Weight';
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
                                  decoration:
                                      BoxDecoration(color: Colors.grey[200]),
                                  child: TextFormField(
                                    style: TextStyle(fontSize: 40),
                                    textAlign: TextAlign.center,
                                    initialValue: time,
                                    onChanged: (value) => time = value,
                                    /* onSaved: (String val) {
                        _setTime = val;
                      }, */

                                    enabled: false,
                                    keyboardType: TextInputType.text,
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
                                Navigator.pop(context);
                              }
                            },
                            child: Text(
                              'Update',
                              style: TextStyle(fontSize: 18.0),
                            ),
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              );
            }),
      ),
    );
  }
}
