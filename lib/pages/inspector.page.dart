import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:happjadmin/model/Product.dart';

import 'admin.page.dart';
import 'detail.page.dart';

class InspectorPage extends StatefulWidget {
  List<Product> listProduct;

  InspectorPage({this.listProduct});

  @override
  _InspectorPageState createState() => _InspectorPageState();
}

class _InspectorPageState extends State<InspectorPage> {
  DatabaseReference itemRef;

  @override
  void initState() {
    super.initState();
    final FirebaseDatabase database = FirebaseDatabase
        .instance; //Rather then just writing FirebaseDatabase(), get the instance.
    itemRef = database.reference().child('products');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: new Text("Sản phẩm chưa xác nhận",
            style: TextStyle(color: Colors.black)),
        centerTitle: true,
        elevation: 0.0,
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: Colors.black,
          ),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        color: Colors.white,
        child: widget.listProduct.length == 0
            ? Center(
                child: Text("Empty"),
              )
            : ListView.builder(
                padding: const EdgeInsets.all(8),
                itemCount: widget.listProduct.length,
                itemBuilder: (BuildContext context, int index) {
                  return Container(
                      child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      Text("STT: ${index + 1}",
                          style: TextStyle(
                              fontSize: 15.0, fontWeight: FontWeight.bold)),
                      Row(
                        children: <Widget>[
                          Text("Tên sản phẩm: "),
                          Text(
                            widget.listProduct[index].name,
                            style: TextStyle(
                                fontWeight: FontWeight.w600, fontSize: 17.0),
                          )
                        ],
                      ),
                      Row(
                        children: <Widget>[
                          new RaisedButton(
                            color: Colors.greenAccent,
                            onPressed: () {
                              ShowDialog(index);

                            },
                            child: new Text("Duyệt"),
                          ),
                          SizedBox(
                            width: 5.0,
                          ),
                          new RaisedButton(
                            color: Colors.blueAccent,
                            onPressed: () {
                              moveToSecondPage(index);
                            },
                            child: new Text("Xem"),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 10.0,
                      ),
                      Divider(
                        color: Colors.black,
                        height: 1.0,
                        indent: 5.0,
                        endIndent: 5.0,
                      )
                    ],
                  ));
                }),
      ),
    );
  }

  void moveToSecondPage(int index) async {
    Product product = await Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => DetailPage(product: widget.listProduct[index])),
    );
    updateProduct(product);
  }

  void updateProduct(Product product) {
    for (int i = 0; i < widget.listProduct.length; i++) {
      if (product.key == widget.listProduct[i].key) {
        setState(() {
          widget.listProduct[i] = product;
        });
      }
    }
  }

  void DuyetSanPham(int index) async {
    await itemRef
        .child(widget.listProduct[index].key)
        .update({"inspector": true}).then((value) {
      setState(() {
        widget.listProduct.removeAt(index);
      });
      Fluttertoast.showToast(msg: "Duyệt thành công", textColor: Colors.black);
    });
  }

  ShowDialog(int index) {
    return AwesomeDialog(
        context: context,
        animType: AnimType.LEFTSLIDE,
        headerAnimationLoop: false,
        dialogType: DialogType.WARNING,
        title: 'Xác nhận',
        desc:
            'Nhấn ok để duyệt sản phẩm',
        btnOkOnPress: () {
          DuyetSanPham(index);
        },
        btnCancelOnPress: () {
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
}
