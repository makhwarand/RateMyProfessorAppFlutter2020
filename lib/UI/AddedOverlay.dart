import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_login_demo/pages/home_page.dart';
import 'package:flutter_login_demo/pages/root_page.dart';
import 'package:flutter_login_demo/services/authentication.dart';

class AddedOverlay extends StatefulWidget {

  AddedOverlay({Key key, this.auth, this.goAdd})
      : super(key: key);

  final BaseAuth auth;
  final bool goAdd;

  @override
  State createState() => new AddedOverlayState();
}

class AddedOverlayState extends State<AddedOverlay> with SingleTickerProviderStateMixin {

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
          onTap: () => Navigator.of(context).push(new MaterialPageRoute(builder: (BuildContext context) => new RootPage(auth: widget.auth))),
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
                  child: new Icon((widget.goAdd  == true ? Icons.done : Icons.clear), size: _iconAnimation.value * 80.0,),
                ),
              ),
              new Padding(
                  padding: new EdgeInsets.only(bottom: 15.0) //padding on bottom 20px
              ),
              new Text((widget.goAdd == true ? "New Professor Added" : "Professor Exists"),
                style: new TextStyle(color: Colors.white, fontSize: 30.0, fontWeight: FontWeight.bold),),
              new Text("Tap To Return", style: new TextStyle(color: Colors.white70, fontSize: 20.0, fontWeight: FontWeight.bold),),
            ],
          ),
        )
    );
  }
}