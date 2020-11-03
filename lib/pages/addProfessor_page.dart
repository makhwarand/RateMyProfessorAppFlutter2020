import 'package:flutter_login_demo/UI/AddedOverlay.dart';
import 'package:flutter_login_demo/UI/searchservice.dart';
import 'package:flutter_login_demo/services/authentication.dart';
import 'package:string_validator/string_validator.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'home_page.dart';

class AddProfessor extends StatefulWidget {

  AddProfessor({Key key, this.auth, this.email})
      : super(key: key);

  final BaseAuth auth;
  final String email;

  @override
  AddProfessorState createState() {
    return AddProfessorState();
  }
}

class AddProfessorState extends State<AddProfessor> {
  final db = Firestore.instance;
  final _formKey = GlobalKey<FormState>();
  String id, name, firstname, lastname, college, searchKey;

  TextFormField buildFirstNameTextFormField() {
    return TextFormField(
      decoration: InputDecoration(
        border: InputBorder.none,
        hintText: 'First Name',
        fillColor: Colors.grey[300],
        filled: true,
      ),
      validator: (value) {
        if (value.isEmpty) return 'Please enter some text';
        if (!isAlpha(value)) return 'Name can only include letters';
        if (!isUppercase(value.substring(0,1))) return 'Make sure the first letter is uppercase';
        if (!isLowercase(value.substring(1))) return 'Illegal Name!';
      },
      onSaved: (value) => {
        firstname = value,
        searchKey = value.substring(0,1).toUpperCase(),
        name = value
      },
    );
  }

  TextFormField buildLastNameTextFormField() {
    return TextFormField(
      decoration: InputDecoration(
        border: InputBorder.none,
        hintText: 'Last Name',
        fillColor: Colors.grey[300],
        filled: true,
      ),
      validator: (value) {
        if (value.isEmpty) return 'Please enter some text';
        if (!isAlpha(value)) return 'Name can only include letters';
        if (!isUppercase(value.substring(0,1))) return 'Make sure the first letter is uppercase';
        if (!isLowercase(value.substring(1))) return 'Illegal Name!';
      },
      onSaved: (value) => {
        firstname = value,
        name += ' ' + value,
        print(name)
      },
    );
  }


  DropdownButton<String> buildDropDown() {
    return DropdownButton<String>(
      items: [
        DropdownMenuItem<String>(
          child: Text('College of Education'),
          value: 'College of Education',
        ),
        DropdownMenuItem<String>(
          child: Text('College of Engineering'),
          value: 'College of Engineering',
        ),
        DropdownMenuItem<String>(
          child: Text('College of Humanities and Fine Arts'),
          value: 'College of Humanities and Fine Arts',
        ),
        DropdownMenuItem<String>(
          child: Text('College of Information and Computer Sciences'),
          value: 'College of Information and Computer Sciences',
        ),
        DropdownMenuItem<String>(
          child: Text('College of Natural Sciences'),
          value: 'College of Natural Sciences',
        ),
        DropdownMenuItem<String>(
          child: Text('College of Nursing'),
          value: 'College of Nursing',
        ),
        DropdownMenuItem<String>(
          child: Text('College of Social and Behavioral Sciences'),
          value: 'College of Social and Behavioral Sciences',
        ),
        DropdownMenuItem<String>(
          child: Text('Isenberg School of Management'),
          value: 'Isenberg School of Management',
        ),
        DropdownMenuItem<String>(
          child: Text('School of Public Health and Health Sciences'),
          value: 'School of Public Health and Health Sciences',
        ),
        DropdownMenuItem<String>(
          child: Text('Stockbridge School of Agriculture'),
          value: 'Stockbridge School of Agriculture',
        ),
        DropdownMenuItem<String>(
          child: Text('Commonwealth Honors College'),
          value: 'Commonwealth Honors College',
        ),
        DropdownMenuItem<String>(
          child: Text('Graduate School'),
          value: 'Graduate School',
        ),
      ],
      onChanged: (String value) {
        setState(() {
          college = value;
        });
      },
      style: TextStyle(fontSize: 17.5, color: Colors.black, fontWeight: FontWeight.bold),
      hint: Text('Select Your Department'),
      value: college,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Your Professor'),
        backgroundColor: Colors.blueGrey,
      ),
      body: ListView(
        padding: EdgeInsets.all(8),
        children: <Widget>[
          Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                buildFirstNameTextFormField(),
                buildLastNameTextFormField()
              ],
            ),
            //child: buildFirstNameTextFormField(),
          ),
          buildDropDown(),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              RaisedButton(
                onPressed: () {
                  createData();
                },
                child: Text('Create', style: TextStyle(color: Colors.white)),
                color: Colors.green
              ),
            ],
          ),
        ],
      ),
    );
  }

  void createData() async {

    if (_formKey.currentState.validate()) {
      _formKey.currentState.save();

      final QuerySnapshot result = await Firestore.instance
          .collection('professors')
          .where('name', isEqualTo: name)
          .getDocuments();
      print('${name} Woo hoo!');

      if (result.documents.length > 0) {
        Navigator.of(context).push(new MaterialPageRoute(builder: (BuildContext context) => new AddedOverlay(auth: widget.auth, goAdd: false)));
        print("Exists");
      }
      else {
        DocumentReference ref = await db.collection('professors').add({'name': '$name', 'college': '$college', 'searchKey': '$searchKey'});
        setState(() => id = ref.documentID);
        print(ref.documentID);
        Navigator.of(context).push(new MaterialPageRoute(builder: (BuildContext context) => new AddedOverlay(auth: widget.auth, goAdd: true)));
        print("Data Created");
      }
      print(result.documents.length);
    }
  }
}
