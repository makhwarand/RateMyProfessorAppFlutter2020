import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_login_demo/UI/searchfunction.dart';
import 'package:flutter_login_demo/pages/addProfessor_page.dart';
import 'package:flutter_login_demo/services/authentication.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:timeago/timeago.dart' as timeago;

import 'addPost.dart';
import 'root_page.dart';

class ProfessorInfo extends StatefulWidget {

  ProfessorInfo({Key key, this.auth, this.data, this.email, this.backtoSearch})
      : super(key: key);

  final BaseAuth auth;
  final data; //get the data for the professor selected
  final String email;
  final bool backtoSearch;

  State createState() => new ProfessorInfoState();
}

class ProfessorInfoState extends State<ProfessorInfo> {

  final GlobalKey<FormState> _formkey = new GlobalKey();
  String name, user;
  int reviews;
  bool rating;

  @override
  void initState() {
    super.initState();
  }

  getPosts() async {
    var firestore = Firestore.instance;
    QuerySnapshot snap = await firestore.collection('reviews').orderBy('date', descending: true).where('name', isEqualTo: '${widget.data['name']}').getDocuments();
    return snap.documents;
  }

  getResult() async {
    final QuerySnapshot result = await Firestore.instance
        .collection('stats')
        .where('name', isEqualTo: widget.data['name'])
        .getDocuments();
    return result.documents;
  }
  
  leading(double rating) {
    if (rating == 1.0) return Icon(Icons.sentiment_very_dissatisfied, color: Colors.red, size: 40.0);
    if (rating == 2.0) return Icon(Icons.sentiment_dissatisfied, color: Colors.redAccent, size: 40.0);
    if (rating == 3.0) return Icon(Icons.sentiment_neutral, color: Colors.amber, size: 40.0);
    if (rating == 4.0) return Icon(Icons.sentiment_satisfied, color: Colors.lightGreen, size: 40.0);
    else return Icon(Icons.sentiment_very_satisfied, color: Colors.green, size: 40.0);
  }
  leadingx2(double rating) {
    if (rating == 1.0) return Icon(Icons.sentiment_very_dissatisfied, color: Colors.red, size: 80.0);
    if (rating == 2.0) return Icon(Icons.sentiment_dissatisfied, color: Colors.redAccent, size: 80.0);
    if (rating == 3.0) return Icon(Icons.sentiment_neutral, color: Colors.amber, size: 80.0);
    if (rating == 4.0) return Icon(Icons.sentiment_satisfied, color: Colors.lightGreen, size: 80.0);
    else return Icon(Icons.sentiment_very_satisfied, color: Colors.green, size: 80.0);
  }

  @override
  Widget build(BuildContext context) {

    name = widget.data['name'];
    print('${name}');

    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(icon: Icon(Icons.arrow_back), onPressed:() {
          if (widget.backtoSearch) Navigator.of(context).push(new MaterialPageRoute(builder: (BuildContext context) => new SearchPage(auth: widget.auth, email: widget.email)));
          else Navigator.of(context).push(new MaterialPageRoute(builder: (BuildContext context) => new RootPage(auth: widget.auth)));
        },),
        title: Text(widget.data['name']),
        backgroundColor: Colors.blueGrey,
        actions: <Widget>[
          IconButton(icon: Icon(Icons.add), onPressed: () {
            Navigator.of(context).push(new MaterialPageRoute(builder: (BuildContext context) => new AddPost(auth: widget.auth, name: name, data: widget.data, email: widget.email, boolean: widget.backtoSearch)));
          },),
        ],
      ),
      body: Column(
        children: <Widget>[
          SizedBox(
            height: 180,
              child: FutureBuilder(
                  future: getResult(),
                  builder: (_, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return CircularProgressIndicator();
                    }
                    if (snapshot.data.length == 0) {
                      return Column(
                        children: <Widget>[
                          Padding(
                            padding: EdgeInsets.only(top: 40.0, bottom: 15.0),
                            child: Icon(Icons.star, size: 30.0,),
                          ),
                          Center(
                            child: Text("0 Reviews",
                              style: TextStyle(fontSize: 30.0, fontWeight: FontWeight.bold),),
                          ),
                        ],
                      );
                    }
                    else {
                      return ListView.builder(
                          itemCount: snapshot.data.length,
                          itemBuilder: (_, index) {
                            return Column(
                              children: <Widget>[
                                Padding(
                                  padding: EdgeInsets.only(top: 20.0, bottom: 15.0),
                                  child: leadingx2(snapshot.data[index].data['averageRating']),
                                ),
                                Center(
                                  child: Text("Reviews: " + snapshot.data[index].data['numberOfReviews'].toString(),
                                    style: TextStyle(fontSize: 30.0, fontWeight: FontWeight.bold),),
                                ),
                              ],
                            );
                          }
                      );
                    }
                  })
            ),
            Expanded(
                child: FutureBuilder(
                    future: getPosts(),
                    builder: (_, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return CircularProgressIndicator();
                      }
                      if (!snapshot.hasData) {
                        return Text("No Reviews Have Been Made On This Professor...Yet :)");
                      }
                      else {
                        return ListView.builder(
                            itemCount: snapshot.data.length,
                            itemBuilder: (_, index) {
                              return buildResultCard(snapshot.data[index]);
                            }
                        );
                      }
                    })
              ),
        ],
      )
    );
  }


  Widget buildResultCard(data) {

    user = data['user'];

    if (data['hideName'] == true) {
      user = "Anonymous";
    }

    return Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
        elevation: 2.0,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            ListTile(
              leading: leading(data['rating']),
              title: Text(data['title'],
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 20.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
              subtitle: Text(data['body'],
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.grey,
                  fontSize: 15.0,
                ),
              ),
            ),
            new Divider(color:  Colors.black, indent: 16.0,),
            new ListTile(
              leading: new Icon(Icons.perm_identity),
              title: Text(user,
              style: TextStyle(fontSize: 15.0, fontWeight: FontWeight.bold),
              ),
              trailing: Text(
                  timeago.format(DateTime.fromMillisecondsSinceEpoch(data['date'])),
                  style: TextStyle(fontSize: 14.0, color: Colors.grey)
              ),
            )
          ],
        )
    );
  }

}