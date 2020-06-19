import 'package:flutter/material.dart';
import '../shared.dart/constants.dart';

import '../services/firestoreDatabaseService.dart';

import '../widgets/successAlertDialog.dart';
import '../widgets/failureAlertDialog.dart';

class DeleteStudent extends StatefulWidget {
  @override
  _DeleteStudentState createState() => _DeleteStudentState();
}

class _DeleteStudentState extends State<DeleteStudent> {
  final _formKey3 = GlobalKey<FormState>();
  

  final _fNameCtrl = new TextEditingController();
  final _lNameCtrl = new TextEditingController();

  FirestoreDatabaseService fds = new FirestoreDatabaseService();

  String error = '';

  String fName = '';
  String lName = '';
  String batchDropdownValue = 'M1';
  String gender = '';
  String _resultGender = '';

  void _handleRadioValueChange(int value) {
    setState(() {
      _groupValue = value;

      switch (_groupValue) {
        case 0:
          _resultGender = 'male';
          break;
        case 1:
          _resultGender = 'female';
          break;
      }
    });
  }

  // final String _genderValue1 = 'male';
  // final String _genderValue2 = 'female';
  int _groupValue = -1;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10),
      child: Form(
        key: _formKey3,
        child: Column(
          children: <Widget>[
            TextFormField(
              controller: _fNameCtrl,
              decoration:
                  textFormFieldDecoration.copyWith(hintText: 'first name'),
              validator: (value) =>
                  value.isEmpty ? 'first name can\'t be empty' : null,
              onChanged: (val) {
                setState(() {
                  fName = val;
                });
              },
            ),
            SizedBox(height: 20),
            TextFormField(
              controller: _lNameCtrl,
              decoration:
                  textFormFieldDecoration.copyWith(hintText: 'last name'),
              validator: (value) =>
                  value.isEmpty ? 'last name can\'t be empty' : null,
              onChanged: (val) {
                setState(() {
                  lName = val;
                });
              },
            ),
            SizedBox(height: 20),
            Row(
              children: <Widget>[
                Text('Batch: '),
                DropdownButton<String>(
                  value: batchDropdownValue,
                  icon: Icon(Icons.arrow_downward),
                  iconSize: 24,
                  elevation: 16,
                  style: TextStyle(
                    fontFamily: 'Nunito',
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.deepPurpleAccent,
                  ),
                  underline: Container(
                    height: 2,
                    color: Colors.deepPurpleAccent,
                  ),
                  onChanged: (String newValue) {
                    setState(() {
                      batchDropdownValue = newValue;
                    });
                  },
                  items: <String>[
                    'M1',
                    'M2',
                    'M3',
                    'M4',
                    'M5',
                    'M6',
                    'M7',
                  ].map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                ),
              ],
            ),
            SizedBox(
              height: 20,
            ),
            Row(
              children: <Widget>[
                Text('Gender: '),
                Radio(
                  value: 0,
                  groupValue: _groupValue,
                  onChanged: _handleRadioValueChange,
                ),
                Text('male'),
                SizedBox(
                  width: 20,
                ),
                Radio(
                  value: 1,
                  groupValue: _groupValue,
                  onChanged: _handleRadioValueChange,
                ),
                Text('female'),
              ],
            ),
            SizedBox(
              height: 20,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                RaisedButton(
                  child: Text('Delete Student'),
                  onPressed: () async {
                    if (_formKey3.currentState.validate()) {
                      dynamic result = await fds.deleteStudent(fName, lName,
                          batchDropdownValue.toLowerCase(), _resultGender);
                      if (result) {
                        setState(() {
                          error = 'Student deleted Successfully';
                          showSuccessAlertDialog(context, error);
                          _fNameCtrl.clear();
                          _lNameCtrl.clear();
                          batchDropdownValue = 'M1';
                          _groupValue = -1;
                        });
                      } else {
                        setState(() {
                          error = 'sorry, specified student do not exist';
                          showFailureAlertDialog(context, error);
                          _fNameCtrl.clear();
                          _lNameCtrl.clear();
                          batchDropdownValue = 'M1';
                          _groupValue = -1;
                        });
                      }
                    }
                  },
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}