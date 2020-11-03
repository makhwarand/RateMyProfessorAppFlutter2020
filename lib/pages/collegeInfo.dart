import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_login_demo/UI/searchfunction.dart';
import 'package:flutter_login_demo/pages/professorInfo.dart';
import 'package:flutter_login_demo/services/authentication.dart';

class CollegeInfo extends StatefulWidget {

  CollegeInfo({Key key, this.auth, this.collegeData, this.email})
      : super(key: key);

  final BaseAuth auth;
  final String collegeData;
  final String email;

  @override
  CollegeInfoState createState() => new CollegeInfoState();
}

class CollegeInfoState extends State<CollegeInfo> {

  @override
  void initState() {
    super.initState();
  }

  Future getPosts() async {

    var firestore = Firestore.instance;

    QuerySnapshot snap = await firestore.collection('professors').where('college', isEqualTo: widget.collegeData).getDocuments();

    return snap.documents;
  }
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: new AppBar(
        title: Text(widget.collegeData),
        backgroundColor: Colors.blueGrey,
        actions: <Widget>[
          IconButton(icon: Icon(Icons.search), onPressed: () {
            Navigator.of(context).push(new MaterialPageRoute(builder: (BuildContext context) => new SearchPage(auth: widget.auth, email: widget.email)));
          },),
        ],
      ),
      body: Container(
          child: FutureBuilder(
              future: getPosts(),
              builder: (_, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return CircularProgressIndicator();
                }
                else {
                  return ListView.builder(
                      itemCount: snapshot.data.length,
                      itemBuilder: (_, index) {
                        return InkWell(
                          onTap: () {
                            Navigator.of(context).push(new MaterialPageRoute(builder: (BuildContext context) => new ProfessorInfo(auth: widget.auth, data: snapshot.data[index], email: widget.email, backtoSearch: false)));
                          },
                          child: buildResultCard(snapshot.data[index]),
                        );
                      }
                  );
                }
              }),
      ),
    );
  }
}

Widget buildResultCard(data) {
  return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
      elevation: 2.0,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          ListTile(
            leading: Icon(Icons.person, size: 30),
            title: Text(data['name'],
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.black,
                fontSize: 20.0,
              ),
            ),
            subtitle: Text(data['college'],
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.grey,
                fontSize: 15.0,
              ),
            ),
          )
        ],
      )
  );
}