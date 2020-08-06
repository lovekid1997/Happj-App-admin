import 'package:crypt/crypt.dart';

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:happjadmin/pages/splash.page.dart';

import 'package:happjadmin/widget/textLogin.dart';
import 'package:happjadmin/widget/verticalText.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'admin.page.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  String userId = "";
  String passWord = "";
  DatabaseReference itemRef;
  String userInDB;
  String passWordInDB;
  bool load = false;
  var h;
    luuDangNhap()async{
      SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
      sharedPreferences.setBool("trangthai", true);
    }
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    final FirebaseDatabase database = FirebaseDatabase
        .instance; //Rather then just writing FirebaseDatabase(), get the instance.
    itemRef = database.reference().child('admin');
    itemRef.once().then((value) {
      passWordInDB = value.value['admin'];
      userInDB = value.key.toString();
       h = Crypt(passWordInDB);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: (load == false)
            ? Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                      begin: Alignment.topRight,
                      end: Alignment.bottomLeft,
                      colors: [Colors.blueGrey, Colors.lightBlueAccent]),
                ),
                child: ListView(
                  children: <Widget>[
                    Column(
                      children: <Widget>[
                        Row(children: <Widget>[
                          VerticalText(),
                          TextLogin(),
                        ]),
                        Padding(
                          padding: const EdgeInsets.only(
                              top: 50, left: 50, right: 50),
                          child: Container(
                            height: 60,
                            width: MediaQuery.of(context).size.width,
                            child: TextField(
                              onChanged: (value) {
                                userId = value.trim().toString();
                              },
                              style: TextStyle(
                                color: Colors.white,
                              ),
                              decoration: InputDecoration(
                                border: InputBorder.none,
                                fillColor: Colors.lightBlueAccent,
                                labelText: 'Name',
                                labelStyle: TextStyle(
                                  color: Colors.white70,
                                ),
                              ),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(
                              top: 20, left: 50, right: 50),
                          child: Container(
                            height: 60,
                            width: MediaQuery.of(context).size.width,
                            child: TextField(
                              onChanged: (value) {
                                passWord = value.toString();
                              },
                              style: TextStyle(
                                color: Colors.white,
                              ),
                              obscureText: true,
                              decoration: InputDecoration(
                                border: InputBorder.none,
                                labelText: 'Password',
                                labelStyle: TextStyle(
                                  color: Colors.white70,
                                ),
                              ),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(
                              top: 40, right: 50, left: 200),
                          child: Container(
                            alignment: Alignment.bottomRight,
                            height: 50,
                            width: MediaQuery.of(context).size.width,
                            decoration: BoxDecoration(
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.blue[300],
                                  blurRadius: 10.0,
                                  // has the effect of softening the shadow
                                  spreadRadius: 1.0,
                                  // has the effect of extending the shadow
                                  offset: Offset(
                                    5.0, // horizontal, move right 10
                                    5.0, // vertical, move down 10
                                  ),
                                ),
                              ],
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(30),
                            ),
                            child: FlatButton(
                              // ignore: missing_return
                              onPressed: () =>
                                  buttonSignin(userId, passWord),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  Text(
                                    'OK',
                                    style: TextStyle(
                                      color: Colors.lightBlueAccent,
                                      fontSize: 14,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                  Icon(
                                    Icons.arrow_forward,
                                    color: Colors.lightBlueAccent,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              )
            : SplashPage());
  }

  buttonSignin(String id, ps) {
    print('begin button signin');
    setState(() {
      load = true;
    });
    if (id == userInDB) {
      if (h.match(ps)) {
        setState(() {
          load = false;
        });
        Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context) =>
            AdminPage()), (Route<dynamic> route) => false);
        luuDangNhap();
        Fluttertoast.showToast(msg: "Đăng nhập thành công", textColor: Colors.black);
      } else {
        setState(() {
          load = false;
        });

        Fluttertoast.showToast(msg: "Sai mật khẩu", textColor: Colors.black);
      }
    } else {
      setState(() {
        load = false;
      });
      Fluttertoast.showToast(msg: "Sai tên đăng nhập", textColor: Colors.black);
    }
  }
}
