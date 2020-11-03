import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_login_demo/pages/addProfessor_page.dart';
import 'package:flutter_login_demo/pages/root_page.dart';
import 'package:flutter_login_demo/services/authentication.dart';
import 'package:firebase_database/firebase_database.dart';
import '../UI/searchfunction.dart';
import 'collegeInfo.dart';


class HomePage extends StatefulWidget {
  HomePage({Key key, this.auth, this.userId, this.email, this.logoutCallback})
      : super(key: key);

  final BaseAuth auth;
  final VoidCallback logoutCallback;
  final String userId;
  final String email;

  @override
  State<StatefulWidget> createState() => new HomePageState();
}

class HomePageState extends State<HomePage> {

  final FirebaseDatabase _database = FirebaseDatabase.instance;
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  String _email;

  bool _isEmailVerified = false;

  @override
  void initState() {
    super.initState();
    _email = widget.email;
    //_checkEmailVerification();
  }

  void _checkEmailVerification() async {
    _isEmailVerified = await widget.auth.isEmailVerified();
    if (!_isEmailVerified) {
      _showVerifyEmailDialog();
    }
  }

  void _resentVerifyEmail(){
    widget.auth.sendEmailVerification();
    _showVerifyEmailSentDialog();
  }

   void _showVerifyEmailDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          title: new Text("Verify your account"),
          content: new Text("Please verify account in the link sent to email"),
          actions: <Widget>[
            new FlatButton(
              child: new Text("Resent link"),
              onPressed: () {
                Navigator.of(context).pop();
                _resentVerifyEmail();
                signOut();
              },
            ),
            new FlatButton(
              child: new Text("Dismiss"),
              onPressed: () {
                Navigator.of(context).pop();
                signOut();
              },
            ),
          ],
        );
      },
    );
  }

  void _showVerifyEmailSentDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          title: new Text("Verify your account"),
          content: new Text("Link to verify account has been sent to your email"),
          actions: <Widget>[
            new FlatButton(
              child: new Text("Dismiss"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }


  signOut() async {
    try {
      await widget.auth.signOut();
      widget.logoutCallback();
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        appBar: new AppBar(
          title: new Text("UMassProfessorRating"),
          backgroundColor: Colors.blueGrey,
          actions: <Widget>[
            IconButton(icon: Icon(Icons.search), onPressed: () {
              Navigator.of(context).push(new MaterialPageRoute(builder: (BuildContext context) => new SearchPage(auth: widget.auth, email: _email,)));
            },),
          ],
        ),
        drawer: Drawer(
          child: ListView(
            padding: EdgeInsets.zero,
            children: <Widget>[
              DrawerHeader(
                child: Center(
                  child: Text('Welcome! ' + '$_email',
                      style: new TextStyle(fontSize: 25.0, color: Colors.black, fontWeight: FontWeight.bold)
                  ),
                ),
                decoration: BoxDecoration(
                    color: Colors.greenAccent
                ),
              ),
              InkWell(
                child: ListTile(
                  title: Text('Add New Professor',
                      style: new TextStyle(fontSize: 17.0, color: Colors.black)
                  ),
                  onTap: () {
                    Navigator.of(context).push(new MaterialPageRoute(builder: (BuildContext context) => new AddProfessor(auth: widget.auth)));
                  },
                ),
              ),
              InkWell(
                child: ListTile(
                  title: Text('Log Out',
                      style: new TextStyle(fontSize: 17.0, color: Colors.black)
                  ),
                  onTap: () {
                    signOut();
                  },
                ),
              )
            ],
          ),
        ),
      body: GridView.count(
        padding: EdgeInsets.only(left: 10.0, right: 10.0),
        crossAxisCount: 2,
        crossAxisSpacing: 4.0,
        mainAxisSpacing: 4.0,
        primary: false,
        shrinkWrap: true,
        children: <Widget>[
          InkWell(
            onTap: () {
              Navigator.of(context).push(new MaterialPageRoute(builder: (BuildContext context) => new CollegeInfo(auth: widget.auth, collegeData: "College of Education", email: widget.email)));
            },
            child: Container(
              padding: const EdgeInsets.all(32.0),
              decoration: BoxDecoration(
                border: Border.all(
                    width: 2.0
                ),
                borderRadius: BorderRadius.all(
                    Radius.circular(5.0) //                 <--- border radius here
                ),
                color: Colors.yellowAccent,
              ),
              child: new Center(
                  child: Text("College of Education", style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),)
              ),
            ),
          ),
          InkWell(
            onTap: () {
              Navigator.of(context).push(new MaterialPageRoute(builder: (BuildContext context) => new CollegeInfo(auth: widget.auth, collegeData: "College of Engineering", email: widget.email)));
            },
            child: Container(
              padding: const EdgeInsets.all(27.0),
              decoration: BoxDecoration(
                border: Border.all(
                    width: 2.0
                ),
                borderRadius: BorderRadius.all(
                    Radius.circular(5.0) //                 <--- border radius here
                ),
                color: Colors.orangeAccent,
              ),
              child: new Center(
                  child: Text("College of Engineering", style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),)
              ),
            ),
          ),
          InkWell(
            onTap: () {
              Navigator.of(context).push(new MaterialPageRoute(builder: (BuildContext context) => new CollegeInfo(auth: widget.auth, collegeData: "College of Humanities and Fine Arts", email: widget.email)));
            },
            child: Container(
              padding: const EdgeInsets.all(32.0),
              decoration: BoxDecoration(
                border: Border.all(
                    width: 2.0
                ),
                borderRadius: BorderRadius.all(
                    Radius.circular(5.0) //                 <--- border radius here
                ),
                color: Colors.redAccent,
              ),
              child: new Center(
                  child: Text("College of Humanities and Fine Arts", style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),)
              ),
            ),
          ),
          InkWell(
            onTap: () {
              Navigator.of(context).push(new MaterialPageRoute(builder: (BuildContext context) => new CollegeInfo(auth: widget.auth, collegeData: "College of Information and Computer Sciences", email: widget.email)));
            },
            child: Container(
              padding: const EdgeInsets.all(25.0),
              decoration: BoxDecoration(
                border: Border.all(
                    width: 2.0
                ),
                borderRadius: BorderRadius.all(
                    Radius.circular(5.0) //                 <--- border radius here
                ),
                color: Colors.blueAccent,
              ),
              child: new Center(
                  child: Text("College of Information and Computer Sciences", style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),)
              ),
            ),
          ),
          InkWell(
            onTap: () {
              Navigator.of(context).push(new MaterialPageRoute(builder: (BuildContext context) => new CollegeInfo(auth: widget.auth, collegeData: "College of Natural Sciences", email: widget.email)));
            },
            child: Container(
              padding: const EdgeInsets.all(30.0),
              decoration: BoxDecoration(
                border: Border.all(
                    width: 2.0
                ),
                borderRadius: BorderRadius.all(
                    Radius.circular(5.0) //                 <--- border radius here
                ),
                color: Colors.green,
              ),
              child: new Center(
                  child: Text("College of Natural Sciences", style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),)
              ),
            ),
          ),
          InkWell(
            onTap: () {
              Navigator.of(context).push(new MaterialPageRoute(builder: (BuildContext context) => new CollegeInfo(auth: widget.auth, collegeData: "College of Nursing", email: widget.email)));
            },
            child: Container(
              padding: const EdgeInsets.all(35.0),
              decoration: BoxDecoration(
                border: Border.all(
                    width: 2.0
                ),
                borderRadius: BorderRadius.all(
                    Radius.circular(5.0) //                 <--- border radius here
                ),
                color: Colors.pinkAccent,
              ),
              child: new Center(
                  child: Text("College of Nursing", style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),)
              ),
            ),
          ),
          InkWell(
            onTap: () {
              Navigator.of(context).push(new MaterialPageRoute(builder: (BuildContext context) => new CollegeInfo(auth: widget.auth, collegeData: "College of Social and Behavioral Sciences", email: widget.email)));
            },
            child: Container(
              padding: const EdgeInsets.all(26.0),
              decoration: BoxDecoration(
                border: Border.all(
                    width: 2.0
                ),
                borderRadius: BorderRadius.all(
                    Radius.circular(5.0) //                 <--- border radius here
                ),
                color: Colors.greenAccent,
              ),
              child: new Center(
                  child: Text("College of Social and Behavioral Sciences", style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),)
              ),
            ),
          ),
          InkWell(
            onTap: () {
              Navigator.of(context).push(new MaterialPageRoute(builder: (BuildContext context) => new CollegeInfo(auth: widget.auth, collegeData: "Isenberg School of Management", email: widget.email)));
            },
            child: Container(
              padding: const EdgeInsets.all(20.0),
              decoration: BoxDecoration(
                border: Border.all(
                    width: 2.0
                ),
                borderRadius: BorderRadius.all(
                    Radius.circular(5.0) //                 <--- border radius here
                ),
                color: Colors.grey,
              ),
              child: new Center(
                  child: Text("Isenberg School of Management", style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),)
              ),
            ),
          ),
          InkWell(
            onTap: () {
              Navigator.of(context).push(new MaterialPageRoute(builder: (BuildContext context) => new CollegeInfo(auth: widget.auth, collegeData: "School of Public Health and Health Sciences", email: widget.email)));
            },
            child: Container(
              padding: const EdgeInsets.all(22.0),
              decoration: BoxDecoration(
                border: Border.all(
                    width: 2.0
                ),
                borderRadius: BorderRadius.all(
                    Radius.circular(5.0) //                 <--- border radius here
                ),
                color: Colors.red,
              ),
              child: new Center(
                  child: Text("School of Public Health and Health Sciences", style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),)
              ),
            ),
          ),
          InkWell(
            onTap: () {
              Navigator.of(context).push(new MaterialPageRoute(builder: (BuildContext context) => new CollegeInfo(auth: widget.auth, collegeData: "Stockbridge School of Agriculture", email: widget.email)));
            },
            child: Container(
              padding: const EdgeInsets.all(25.0),
              decoration: BoxDecoration(
                border: Border.all(
                    width: 2.0
                ),
                borderRadius: BorderRadius.all(
                    Radius.circular(5.0) //                 <--- border radius here
                ),
                color: Colors.blueGrey,
              ),
              child: new Center(
                  child: Text("Stockbridge School of Agriculture", style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),)
              ),
            ),
          ),
          InkWell(
            onTap: () {
              Navigator.of(context).push(new MaterialPageRoute(builder: (BuildContext context) => new CollegeInfo(auth: widget.auth, collegeData: "Commonwealth Honors College", email: widget.email)));
            },
            child: Container(
              padding: const EdgeInsets.all(10.0),
              decoration: BoxDecoration(
                border: Border.all(
                    width: 2.0
                ),
                borderRadius: BorderRadius.all(
                    Radius.circular(5.0) //                 <--- border radius here
                ),
                color: Colors.deepOrangeAccent,
              ),
              child: new Center(
                  child: Text("Commonwealth Honors College", style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),)
              ),
            ),
          ),
          InkWell(
            onTap: () {
              Navigator.of(context).push(new MaterialPageRoute(builder: (BuildContext context) => new CollegeInfo(auth: widget.auth, collegeData: "Graduate School", email: widget.email)));
            },
            child: Container(
              padding: const EdgeInsets.all(40.0),
              decoration: BoxDecoration(
                border: Border.all(
                    width: 2.0
                ),
                borderRadius: BorderRadius.all(
                    Radius.circular(5.0) //                 <--- border radius here
                ),
                color: Colors.black,
              ),
              child: new Center(
                  child: Text("Graduate School", style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold, color: Colors.white),)
              ),
            ),
          ),
        ],
      ),
    );
  }
}
