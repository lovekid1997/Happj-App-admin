import 'package:flutter/material.dart';
import 'package:happjadmin/pages/admin.page.dart';

import 'package:happjadmin/pages/login.page.dart';
import 'package:happjadmin/pages/splash.page.dart';
import 'package:shared_preferences/shared_preferences.dart';


void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: HomeController(),
      debugShowCheckedModeBanner: false,
    );
  }

}
class HomeController extends StatelessWidget {
  SharedPreferences sharedPreferences;

  Future<bool> checkLoginStatus() async {
    sharedPreferences = await SharedPreferences.getInstance();
    return sharedPreferences.getBool("trangthai");
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: checkLoginStatus(),
      // ignore: missing_return
      builder: (context, AsyncSnapshot<bool> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting)
          return SplashPage();
        else {
          bool trangthai = snapshot.data;
          print(trangthai);
          return trangthai == true ? AdminPage() : LoginPage();
        }
      },
    );
  }
}

