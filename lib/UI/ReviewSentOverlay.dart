import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_login_demo/pages/home_page.dart';
import 'package:flutter_login_demo/pages/professorInfo.dart';
import 'package:flutter_login_demo/pages/root_page.dart';
import 'package:flutter_login_demo/services/authentication.dart';

class ReviewSentOverlay extends StatefulWidget {

  ReviewSentOverlay({Key key, this.auth, this.name, this.data, this.email, this.boolean, this.PostExists})
      : super(key: key);

  final BaseAuth auth;
  final data;
  final String name;
  final String email;
  final bool boolean;
  final bool PostExists;

  @override
  ReviewSentOverlayState createState() => new ReviewSentOverlayState();
}

class ReviewSentOverlayState extends State<ReviewSentOverlay> with SingleTickerProviderStateMixin {

  Animation<double> _iconAnimation;
  AnimationController _iconAnimationController;

  @override
  void initState() {
    super.initState();
    _iconAnimationController = new AnimationController(duration: new Duration(seconds: 2), vsync: this);
    _iconAnimation = new CurvedAnimation(parent: _iconAnimationController, curve: Curves.elasticOut);
    _iconAnimation.addListener(() => this.setState(() {}));
    _iconAnimationController.forward();
  }

  @override
  void dispose() {
    _iconAnimationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return new Material(
        color: Colors.black54,
        child: new InkWell(
          onTap: () => Navigator.of(context).push(new MaterialPageRoute(builder: (BuildContext context) => new ProfessorInfo(auth: widget.auth, data: widget.data, email: widget.email, backtoSearch: widget.boolean))),
          child: new Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              new Container(
                decoration: new BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle
                ),
                child: new Transform.rotate(
                  angle: _iconAnimation.value * 2 * pi,
                  child: new Icon((widget.PostExists == false ? Icons.done : Icons.clear), size: _iconAnimation.value * 80.0,),
                ),
              ),
              new Padding(
                  padding: new EdgeInsets.only(bottom: 15.0) //padding on bottom 20px
              ),
              new Text((widget.PostExists == false ? "Review Successfully Sent" : "Review Already Exists"),
                style: new TextStyle(color: Colors.white, fontSize: 30.0, fontWeight: FontWeight.bold),),
              new Text("Tap To Return", style: new TextStyle(color: Colors.white70, fontSize: 20.0, fontWeight: FontWeight.bold),),
            ],
          ),
        )
    );
  }
}