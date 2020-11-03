import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_login_demo/UI/ReviewSentOverlay.dart';
import 'package:flutter_login_demo/UI/searchfunction.dart';
import 'package:flutter_login_demo/pages/professorInfo.dart';
import 'package:flutter_login_demo/services/authentication.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

class AddPost extends StatefulWidget{

  AddPost({Key key, this.auth, this.name, this.data, this.email, this.boolean})
      : super(key: key);

  final BaseAuth auth;
  final String name;
  final data;
  final String email;
  final bool boolean;

  _AddPostState createState() => new _AddPostState();
}

class _AddPostState extends State<AddPost> {
  final db = Firestore.instance;
  final _formKey = GlobalKey<FormState>();
  String id, title, body, username;
  double _rating, totalRatingAverage;
  bool postExist = false;
  bool Anonymous = false;
  bool createStatDoc = false;
  int totalReviews = 0;

  @override
  void initState() {
    super.initState();
    _rating = 0.0;
  }

  TextFormField buildTitle() {
    return TextFormField(
      decoration: InputDecoration(
        border: InputBorder.none,
        hintText: 'Your Title',
        fillColor: Colors.grey[300],
        filled: true,
      ),
      validator: (value) {
        if (value.isEmpty) return 'Please enter some text';
        if (value.length > 30) return 'Please make your title shorter than 30 characters';
      },
      onSaved: (value) => {
        title = value
      },
    );
  }

  TextFormField buildBody() {
    return TextFormField(
      decoration: InputDecoration(
        border: InputBorder.none,
        hintText: 'Type Your Review Here',
        fillColor: Colors.grey[300],
        filled: true,
      ),
      validator: (value) {
        if (value.isEmpty) return 'Please enter some text';
      },
      onSaved: (value) => {
        body = value
      },
    );
  }

  Checkbox returnCheck() {
    return Checkbox(
          value: Anonymous,
          onChanged: (bool value) {
            setState(() {
              Anonymous = value;
            });
          },
        );
  }

  faceRating() {
    return RatingBar(
      initialRating: 0,
      itemCount: 5,
      itemBuilder: (context, index) {
        switch (index) {
          case 0:
            return Icon(
              Icons.sentiment_very_dissatisfied,
              color: Colors.red,
            );
          case 1:
            return Icon(
              Icons.sentiment_dissatisfied,
              color: Colors.redAccent,
            );
          case 2:
            return Icon(
              Icons.sentiment_neutral,
              color: Colors.amber,
            );
          case 3:
            return Icon(
              Icons.sentiment_satisfied,
              color: Colors.lightGreen,
            );
          case 4:
            return Icon(
              Icons.sentiment_very_satisfied,
              color: Colors.green,
            );
        }
      },
      onRatingUpdate: (rating) {
        _rating = rating;
        print(_rating);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          leading: IconButton(icon: Icon(Icons.arrow_back), onPressed:() {
            Navigator.of(context).push(new MaterialPageRoute(builder: (BuildContext context) => new ProfessorInfo(auth: widget.auth, data: widget.data, email: widget.email, backtoSearch: widget.boolean)));
          },),
          title: Text('Post Your Review'),
          backgroundColor: Colors.blueGrey,
        ),
        body: Container(
          child: Column(
            children: <Widget>[
              Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    faceRating(),
                    buildTitle(),
                    buildBody(),
                    Text("Anonymous"),
                    returnCheck(),
                  ],
                ),
                //child: buildFirstNameTextFormField(),
              ),
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
        )
    );
  }


  void createData() async {

    if (_formKey.currentState.validate()) {
      _formKey.currentState.save();

      List<String> buffer = widget.email.split('@');
      String _user = buffer[0];

      final QuerySnapshot result = await Firestore.instance
          .collection('reviews')
          .where('user', isEqualTo: _user)
          .getDocuments();
      print('${_user} Oh yeah!');

      final QuerySnapshot nameresult = await Firestore.instance
          .collection('reviews')
          .where('name', isEqualTo: widget.data['name'])
          .getDocuments();
      print('${widget.data['name']} Oh yeah!');

      final QuerySnapshot reviewresult = await Firestore.instance
          .collection('stats')
          .where('name', isEqualTo: widget.data['name'])
          .getDocuments();
      print('${widget.data['name']} Oh yeah!');

      if (result.documents.length > 0 && nameresult.documents.length > 0) {
        postExist = true;
      }

      if (reviewresult.documents.length == 0) {
        createStatDoc = true;
        totalReviews = 1;
        totalRatingAverage = _rating;
      }
      if (reviewresult.documents.length > 0) {
        createStatDoc = false;
        totalReviews = reviewresult.documents[0].data['numberOfReviews'];
        totalRatingAverage = (_rating + reviewresult.documents[0].data['averageRating']) / 2;
        totalReviews++;
      }

        if (!postExist) {
          DocumentReference ref = await db.collection('reviews').add({'name': '${widget.name}', 'title': title, 'body': body, 'user': _user, 'rating': _rating, "date": DateTime.now().millisecondsSinceEpoch, 'hideName': Anonymous});
          if (createStatDoc) {
            await db.collection('stats').add({'name': '${widget.name}', 'numberOfReviews': totalReviews++, 'averageRating': totalRatingAverage});
          }
          if (!createStatDoc) {
            String docId = reviewresult.documents[0].documentID;
            await db.collection('stats').document('${docId}').updateData({'name': '${widget.name}', 'numberOfReviews': totalReviews++, 'averageRating': totalRatingAverage});
          }
          setState(() => id = ref.documentID);
          print(ref.documentID);
          Navigator.of(context).push(new MaterialPageRoute(builder: (BuildContext context) => new ReviewSentOverlay(auth: widget.auth, name: widget.name, data: widget.data, email: widget.email, boolean: widget.boolean, PostExists: postExist)));
        }
        else {
          Navigator.of(context).push(new MaterialPageRoute(builder: (BuildContext context) => new ReviewSentOverlay(auth: widget.auth, name: widget.name, data: widget.data, email: widget.email, boolean: widget.boolean, PostExists: postExist)));
        }
    }
  }
}