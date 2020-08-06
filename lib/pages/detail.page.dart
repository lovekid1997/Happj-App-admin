import 'dart:convert';

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_money_formatter/flutter_money_formatter.dart';

import 'package:happjadmin/model/Product.dart';
import 'package:happjadmin/pages/sendmail.page.dart';
import 'package:intl/intl.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'imageFullScreen.page.dart';

class DetailPage extends StatefulWidget {
  Product product;

  DetailPage({this.product});

  @override
  _DetailPageState createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {
  TextEditingController tenSanPham = TextEditingController();
  TextEditingController trangThai = TextEditingController();
  TextEditingController thongTinChiTiet = TextEditingController();
  DatabaseReference itemRef;
  String email;
  List<dynamic> indexImageSelect = new List();
  String getEmail = "https://api-backend-daugia-2.herokuapp.com/users/emailer/";
  SharedPreferences sharedPreferences;

  String nameProductBefore,statusProductBefore,descriptionProductBefore;
  List<String> imageRemoved = new List();
  Future<dynamic> GETandSaveEmail() async {
    try {
      String url = getEmail + widget.product.userId;
      final response = await http.get(url);
      var a = json.decode(response.body);
      email = a['email'];
      if(email == null){
        print("Người dùng chưa thêm email vào tài khoản");
      }else{
        print(email);
      }
      return ;
    } catch (e) {
      print(e);
    }
  }

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    tenSanPham.dispose();
    trangThai.dispose();
    thongTinChiTiet.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    nameProductBefore = widget.product.name.toString();
    statusProductBefore = widget.product.status.toString();
    descriptionProductBefore = widget.product.description.toString();
    tenSanPham =
        new TextEditingController(text: widget.product.name.toString());
    trangThai =
        new TextEditingController(text: widget.product.status.toString());
    thongTinChiTiet =
        new TextEditingController(text: widget.product.description.toString());
    final FirebaseDatabase database = FirebaseDatabase
        .instance; //Rather then just writing FirebaseDatabase(), get the instance.
    itemRef = database.reference().child('products');
    GETandSaveEmail();

  }

  formatMoney(var amount) {
    FlutterMoneyFormatter fmf = FlutterMoneyFormatter(amount: amount);

    MoneyFormatterOutput fo = fmf.output;

    return (fo.withoutFractionDigits + " VND");
  }

  var format = new DateFormat.yMd().add_jm();
  bool visibility = false;

  @override
  Widget build(BuildContext context) {
//    List<Widget> imageSliders = widget.product.img
//        .map((item) => Container(
//              child: Container(
//                margin: EdgeInsets.all(5.0),
//                child: ClipRRect(
//                    borderRadius: BorderRadius.all(Radius.circular(5.0)),
//                    child: Stack(
//                      children: <Widget>[
//                        Stack(
//                          alignment: Alignment.center,
//                          children: <Widget>[
//                            GestureDetector(
//                              onTap: () {
//                                Navigator.of(context).push(MaterialPageRoute(
//                                    builder: (context) => FullScreenImage(
//                                          list: widget.product.img,
//                                        )));
//                              },
//                              child: Image.network(item,
//                                  fit: BoxFit.cover, width: 1000.0),
//                            ),
//                            Visibility(
//                                visible: visibility,
//                                child: Container(
//                                  child: IconButton(
//                                    onPressed: () {
//                                      setState(() {
//                                        if (indexImageSelect.contains(item)) {
//                                          indexImageSelect.remove(item);
//                                        } else {
//                                          indexImageSelect.add(item);
//                                        }
//                                        print(indexImageSelect);
//                                      });
//                                    },
//                                    icon: Icon(
//                                      Icons.cancel,
//                                      color: indexImageSelect.contains(item)
//                                          ? Colors.red
//                                          : Colors.white,
//                                      size: 55.0,
//                                    ),
//                                  ),
//                                  width: 70.0,
//                                  height: 70.0,
//                                  decoration: new BoxDecoration(
//                                    shape: BoxShape.circle,
//                                    color: Colors.black,
//                                  ),
//                                ))
//                          ],
//                        ),
//                        Positioned(
//                          bottom: 0.0,
//                          left: 0.0,
//                          right: 0.0,
//                          child: Container(
//                            decoration: BoxDecoration(
//                              gradient: LinearGradient(
//                                colors: [
//                                  Color.fromARGB(200, 0, 0, 0),
//                                  Color.fromARGB(0, 0, 0, 0)
//                                ],
//                                begin: Alignment.bottomCenter,
//                                end: Alignment.topCenter,
//                              ),
//                            ),
//                            padding: EdgeInsets.symmetric(
//                                vertical: 10.0, horizontal: 20.0),
//                            child: Text(
//                              'No. ${widget.product.img.indexOf(item) + 1}',
//                              style: TextStyle(
//                                color: Colors.white,
//                                fontSize: 20.0,
//                                fontWeight: FontWeight.bold,
//                              ),
//                            ),
//                          ),
//                        ),
//                      ],
//                    )),
//              ),
//            ))
//        .toList();
    return Scaffold(
        appBar: AppBar(
          actions: <Widget>[
            Visibility(
              child: IconButton(
                icon: Icon(
                  Icons.check,
                  color: Colors.black,
                ),
                onPressed: () {
                  ShowDialog();
                },
              ),
              visible: visibility,
            ),
          ],
          title: new Text("Chi tiết", style: TextStyle(color: Colors.black)),
          centerTitle: true,
          elevation: 0.0,
          backgroundColor: Colors.white,
          leading: IconButton(
            icon: Icon(
              Icons.arrow_back,
              color: Colors.black,
            ),
            onPressed: () {
              Navigator.of(context).pop(widget.product);
            },
          ),
        ),
        body: Container(
          width: double.infinity,
          height: double.infinity,
          child: Column(
            children: <Widget>[
              carousel(widget.product.img),
              SizedBox(
                height: 20.0,
              ),
              Expanded(
                child: SingleChildScrollView(
                  child: Container(
                    margin: EdgeInsets.only(left: 10.0, right: 5.0),
                    color: Colors.white,
                    width: double.infinity,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        text(
                            text: widget.product.name.toString(),
                            textTitle: "Tên sản phẩm: ",
                            confirm: 1,
                            big: 0,
                            controller: tenSanPham),
                        sizedBox(),
                        text(
                            textTitle: "Thể loại: ",
                            text: widget.product.nameType.toString(),
                            confirm: 0,
                            big: 0),
                        sizedBox(),
                        text(
                            textTitle: "Giá khởi điểm: ",
                            text: formatMoney(
                                double.parse(widget.product.currentPrice)),
                            confirm: 0,
                            big: 0),
                        sizedBox(),
                        text(
                            textTitle: "Trạng thái: ",
                            text: widget.product.status.toString(),
                            confirm: 1,
                            big: 1,
                            controller: trangThai),
                        sizedBox(),
                        text(
                            textTitle: "Thông tin chi tiết: ",
                            text: widget.product.description.toString(),
                            controller: thongTinChiTiet,
                            confirm: 1,
                            big: 1),
                        sizedBox(),
                        text(
                            textTitle: "Uy tín: ",
                            text: widget.product.uyTin.toString(),
                            confirm: 0,
                            big: 0),
                        sizedBox(),
                        text(
                            textTitle: "Ngày tạo: ",
                            text: format
                                .format(DateTime.fromMillisecondsSinceEpoch(
                                    widget.product.registerDate))
                                .toString(),
                            confirm: 0,
                            big: 0),
                        sizedBox(),
                        text(
                            textTitle: "Ngày kết thúc: ",
                            text: format
                                .format(DateTime.fromMillisecondsSinceEpoch(
                                    int.parse(widget.product.extraTime)))
                                .toString(),
                            confirm: 0,
                            big: 0),
                      ],
                    ),
                  ),
                ),
              )
            ],
          ),
        ));
  }
  ShowDialog() {
    return AwesomeDialog(
        context: context,
        animType: AnimType.LEFTSLIDE,
        headerAnimationLoop: false,
        dialogType: DialogType.WARNING,
        title: 'Xác nhận',
        desc:
        'Nhấn ok để tạo biểu mẫu thông báo!\n'
            'Cancel để hủy và lưu dữ liệu',
        btnOkOnPress: () {
          XuLyDuLieu();
          if(email == null){
            _onAlertButtonsPressed(context);
          }else{
            Navigator.of(context).push(MaterialPageRoute(builder: (context) =>
                SendMail(email: email,
                    check: true,
                product: widget.product,
                descriptionProductBefore: descriptionProductBefore,
                imageRemoved: imageRemoved,
                nameProductBefore: nameProductBefore,
                statusProductBefore: statusProductBefore,)));
          }
        },
        btnCancelOnPress: () {
          XuLyDuLieu();
          print('cancle click');
        },
        btnOkIcon: Icons.check_circle,
        btnCancelIcon: Icons.cancel,
        btnCancelText: "Cancel",
        onDissmissCallback: () {
          debugPrint('Dialog Dissmiss from callback');
        })
      ..show();
  }

  Widget sizedBox() {
    return SizedBox(
      height: 15.0,
    );
  }

  Widget text(
      {String textTitle,
      text,
      int confirm,
      int big,
      TextEditingController controller}) {
    controller == null ? controller == null : controller = controller;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          textTitle,
          style: TextStyle(
            color: Colors.grey[700],
            fontSize: 16,
          ),
        ),
        SizedBox(
          height: 3.0,
        ),
        confirm == 0
            ? GestureDetector(
                onTap: () {
                  setState(() {
                    visibility = !visibility;
                  });
                },
                child: Text(
                  text,
                  style: TextStyle(
                      color: Colors.black,
                      fontSize: 18,
                      fontWeight: FontWeight.w600),
                ),
              )
            : (visibility == false
                ? GestureDetector(
                    onTap: () {
                      setState(() {
                        visibility = !visibility;
                      });
                    },
                    child: Text(
                      text,
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: 18,
                          fontWeight: FontWeight.w600),
                    ),
                  )
                : Container(
                    height: big == 1 ? 100.0 : 50.0,
                    decoration: new BoxDecoration(
                        color: Colors.white,
                        border: new Border.all(color: Colors.blue),
                        borderRadius:
                            new BorderRadius.all(new Radius.circular(4.0))),
                    child: new Padding(
                      padding: const EdgeInsets.only(left: 8.0, right: 8.0),
                      child: new TextField(
                        controller: controller,
                        keyboardType: TextInputType.multiline,
                        maxLines: null,
                        autocorrect: true,
                        decoration:
                            new InputDecoration(border: InputBorder.none),
                      ),
                    ),
                  ))
      ],
    );
  }

  void XuLyDuLieu() async {
    widget.product.name = tenSanPham.text;
    widget.product.status = trangThai.text;
    widget.product.description = thongTinChiTiet.text;
    setState(() {
      visibility = !visibility;
    });
    if (indexImageSelect.length == 0) {
      print("not thing");
    } else {
      for (int i = 0; i < indexImageSelect.length; i++) {
        imageRemoved.add(indexImageSelect[i].toString());
        for (int j = 0; j < widget.product.img.length; j++) {
          if (indexImageSelect[i].toString() ==
              widget.product.img[j].toString()) {
            setState(() {
              widget.product.img[j] =
                  "http://sumeyyaarar.com/wp-content/uploads/2018/07/empty_baslik.png";
            });
          }
        }
      }
      print(widget.product.img);
    }
    List a = new List();
    a.addAll(widget.product.img);
    for (int i = 0; i < widget.product.img.length; i++) {
      if (widget.product.img[i] ==
          "http://sumeyyaarar.com/wp-content/uploads/2018/07/empty_baslik.png") {
        a.remove(
            "http://sumeyyaarar.com/wp-content/uploads/2018/07/empty_baslik.png");
      }
    }
    await itemRef.child(widget.product.key).update({
      "nameProduct": widget.product.name,
      "status": widget.product.status,
      "description": widget.product.description,
      "imageProduct": a
    }).then((value) => Fluttertoast.showToast(
        msg: "Cập nhật thành công", textColor: Colors.black));
    indexImageSelect.clear();
    a.clear();
  }

  Widget carousel(List<dynamic> list) {
    return CarouselSlider(
      options: CarouselOptions(
        autoPlay: false,
        aspectRatio: 2.0,
        enlargeCenterPage: true,
      ),
      items: list
          .map((item) => Container(
                child: Container(
                  margin: EdgeInsets.all(5.0),
                  child: ClipRRect(
                      borderRadius: BorderRadius.all(Radius.circular(5.0)),
                      child: Stack(
                        children: <Widget>[
                          Stack(
                            alignment: Alignment.center,
                            children: <Widget>[
                              GestureDetector(
                                onTap: () {
                                  Navigator.of(context).push(MaterialPageRoute(
                                      builder: (context) => FullScreenImage(
                                            list: widget.product.img,
                                          )));
                                },
                                child: Image.network("https://api-backend-daugia-2.herokuapp.com/uploads/"+item,
                                    fit: BoxFit.cover, width: 1000.0),
                              ),
                              Visibility(
                                  visible: visibility,
                                  child: Container(
                                    child: IconButton(
                                      onPressed: () {
                                        setState(() {
                                          if (indexImageSelect.contains(item)) {
                                            indexImageSelect.remove(item);
                                          } else {
                                            indexImageSelect.add(item);
                                          }
                                          print(indexImageSelect);
                                        });
                                      },
                                      icon: Icon(
                                        Icons.cancel,
                                        color: indexImageSelect.contains(item)
                                            ? Colors.red
                                            : Colors.white,
                                        size: 55.0,
                                      ),
                                    ),
                                    width: 70.0,
                                    height: 70.0,
                                    decoration: new BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: Colors.black,
                                    ),
                                  ))
                            ],
                          ),
                          Positioned(
                            bottom: 0.0,
                            left: 0.0,
                            right: 0.0,
                            child: Container(
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  colors: [
                                    Color.fromARGB(200, 0, 0, 0),
                                    Color.fromARGB(0, 0, 0, 0)
                                  ],
                                  begin: Alignment.bottomCenter,
                                  end: Alignment.topCenter,
                                ),
                              ),
                              padding: EdgeInsets.symmetric(
                                  vertical: 10.0, horizontal: 20.0),
                              child: Text(
                                'No. ${widget.product.img.indexOf(item) + 1}',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 20.0,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                        ],
                      )),
                ),
              ))
          .toList(),
    );
  }

  _onAlertButtonsPressed(context) {
    Alert(
      context: context,
      type: AlertType.none,
      title: "Thông báo",
      desc: "Vì người dùng chưa thêm email nên chúng tôi chỉ gửi tin nhắn thông báo!\nOk để hoàn tất.",
      buttons: [
        DialogButton(
          child: Text(
            "Ok",
            style: TextStyle(color: Colors.white, fontSize: 20),
          ),
          onPressed: () {
            Navigator.of(context).pop();
          },
          gradient: LinearGradient(colors: [
            Color.fromRGBO(116, 116, 191, 1.0),
            Color.fromRGBO(52, 138, 199, 1.0)
          ]),
        )
      ],
    ).show();
  }
}
