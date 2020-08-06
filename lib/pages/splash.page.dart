
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
class SplashPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.blue,
      width: double.infinity,
      height: double.infinity,
      child: Center(
        child: Column(crossAxisAlignment: CrossAxisAlignment.center,mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            CircularProgressIndicator(valueColor: new AlwaysStoppedAnimation<Color>(Colors.white)),
            Text("loading", style: TextStyle(color: Colors.white,fontSize: 14.0),)
          ],
        )
      ),
    );
  }
}
