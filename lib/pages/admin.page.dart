import 'package:bot_toast/bot_toast.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:happjadmin/model/Product.dart';
import 'package:hawk_fab_menu/hawk_fab_menu.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../main.dart';
import 'inspector.page.dart';

class AdminPage extends StatefulWidget {
  @override
  _AdminPageState createState() => _AdminPageState();
}

class _AdminPageState extends State<AdminPage> {
  List<Product> listProduct = new List();
  DatabaseReference itemRef, item;
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging();

  int soLuongSanPhamChuaKiemDuyet = 0;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    final FirebaseDatabase database = FirebaseDatabase
        .instance; //Rather then just writing FirebaseDatabase(), get the instance.
    itemRef = database.reference().child('products');
    _configureFirebase();
    _getToken();

    itemRef.orderByChild("inspector").equalTo(false).once().then((value) {
      Map data = value.value;
      data.forEach((key, data) {
        if ((DateTime.now().millisecondsSinceEpoch -
                int.parse(data['extraTime']) <
            0)) {
          soLuongSanPhamChuaKiemDuyet++;
          listProduct.add(Product(
              currentPrice: data['currentPrice'],
              hide: data['hide'],
              winner: data['winner'],
              name: data['nameProduct'],
              userId: data['userId'],
              played: data['played'],
              startPrice: data['startPriceProduct'],
              registerDate: data['registerDate'],
              nameType: data['nameProductType'],
              img: data['imageProduct'],
              description: data['description'],
              extraTime: data['extraTime'],
              status: data['status'],
              uyTin: data['uyTin'],
              key: key));
        }
      });
      setState(() {});
    });
  }

  _getToken() {
    _firebaseMessaging.getToken().then((deviceToken) {
      updateToken(deviceToken);
    });
  }

  _configureFirebase() {
    _firebaseMessaging.configure(
        onMessage: (Map<String, dynamic> message) async {
      print('onMessage: $message');
      final notification = message['notification'];
      final String body = notification['body'];
      botToast(body);
      CapNhatDuLieu();
    }, onLaunch: (Map<String, dynamic> message) async {
      print('onLaunch: $message');
    }, onResume: (Map<String, dynamic> message) async {
      print('onResume: $message');
    });
  }

  updateToken(String token) {
    final FirebaseDatabase database = FirebaseDatabase
        .instance; //Rather then just writing FirebaseDatabase(), get the instance.
    item = database.reference().child('admin/fcm/${token}');
    item.set({"token": token});
    setState(() {});
  }
  thoat()async{
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    sharedPreferences.setBool("trangthai", false);
  }
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      builder: BotToastInit(),
      navigatorObservers: [BotToastNavigatorObserver()],
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          actions: <Widget>[
            IconButton(
              icon: Icon(
                Icons.update,
                color: Colors.black,
              ),
              onPressed: () {
                CapNhatDuLieu();
              },
            )
          ],
          title: new Text("Admin Dashboard",
              style: TextStyle(color: Colors.black)),
          centerTitle: true,
          elevation: 0.0,
          backgroundColor: Colors.white,
        ),
        body: Builder(
          // builder is used only for the snackbar, if you don't want the snackbar you can remove
          // Builder from the tree
          builder: (BuildContext context) => HawkFabMenu(
            icon: AnimatedIcons.close_menu,
            fabColor: Colors.red,
            iconColor: Colors.black,
            items: [
              HawkFabMenuItem(
                label: 'Sign out',
                ontap: () {
                  thoat();
                  Navigator.of(context).push(MaterialPageRoute(builder: (context)=> MyApp()));
                },
                icon: Icon(Icons.close),
                color: Colors.red,
                labelColor: Colors.blue,
              ),
            ],
            body:  Column(
              children: <Widget>[
                Expanded(
                  child: GridView(
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2),
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.all(5.0),
                        child: Card(
                          child: ListTile(
                              title: FlatButton.icon(
                                  onPressed: () {
                                    moveInspectorPage();
                                  },
                                  icon: Icon(Icons.people_outline),
                                  label: Text("Chưa xác nhận",
                                      style: TextStyle(color: Colors.black))),
                              subtitle: Text(
                                soLuongSanPhamChuaKiemDuyet.toString(),
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    color: Colors.orange, fontSize: 60.0),
                              )),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(5.0),
                        child: Card(
                          child: ListTile(
                              title: FlatButton.icon(
                                  onPressed: null,
                                  icon: Icon(Icons.category),
                                  label: Text("Categories",
                                      style: TextStyle(color: Colors.black))),
                              subtitle: Text(
                                '23',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    color: Colors.orange, fontSize: 60.0),
                              )),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(5.0),
                        child: Card(
                          child: ListTile(
                              title: FlatButton.icon(
                                  onPressed: null,
                                  icon: Icon(Icons.track_changes),
                                  label: Text("Producs",
                                      style: TextStyle(color: Colors.black))),
                              subtitle: Text(
                                '120',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    color: Colors.orange, fontSize: 60.0),
                              )),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(5.0),
                        child: Card(
                          child: ListTile(
                              title: FlatButton.icon(
                                  onPressed: null,
                                  icon: Icon(Icons.tag_faces),
                                  label: Text("Sold",
                                      style: TextStyle(color: Colors.black))),
                              subtitle: Text(
                                '13',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    color: Colors.orange, fontSize: 60.0),
                              )),
                        ),
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  botToast(String text) {
    BotToast.showNotification(
        leading: (cancel) => SizedBox.fromSize(
            size: const Size(40, 40),
            child: IconButton(
              icon: Icon(Icons.add_alert, color: Colors.redAccent),
              onPressed: cancel,
            )),
        title: (_) => Text('Thông báo'),
        subtitle: (_) => Text(text),
        trailing: (cancel) => IconButton(
              icon: Icon(Icons.cancel),
              onPressed: cancel,
            ),
        onTap: () {
          BotToast.showText(text: 'Tap toast');
        },
        enableSlideOff: true,
        crossPage: true,
        duration: Duration(seconds: 5),
        animationDuration: Duration(milliseconds: 500),
        animationReverseDuration: Duration(milliseconds: 500),
        contentPadding: EdgeInsets.all(4));
  }

  void moveInspectorPage() async {
    await Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => InspectorPage(
                listProduct: listProduct,
              )),
    );
    CapNhatDuLieu();
  }

  void CapNhatDuLieu() async {
    await itemRef.orderByChild("inspector").equalTo(false).once().then((value) {
      soLuongSanPhamChuaKiemDuyet = 0;
      listProduct.clear();
      Map data = value.value;
      data.forEach((key, data) {
        if ((DateTime.now().millisecondsSinceEpoch -
                int.parse(data['extraTime']) <
            0)) {
          soLuongSanPhamChuaKiemDuyet++;
          listProduct.add(Product(
              currentPrice: data['currentPrice'],
              hide: data['hide'],
              winner: data['winner'],
              name: data['nameProduct'],
              userId: data['userId'],
              played: data['played'],
              startPrice: data['startPriceProduct'],
              registerDate: data['registerDate'],
              nameType: data['nameProductType'],
              img: data['imageProduct'],
              description: data['description'],
              extraTime: data['extraTime'],
              status: data['status'],
              uyTin: data['uyTin'],
              key: key));
        }
      });
      Fluttertoast.showToast(
          msg: "Cập nhật thành công", textColor: Colors.black);
      setState(() {});
    });
  }
}
