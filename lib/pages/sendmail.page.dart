import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_email_sender/flutter_email_sender.dart';
import 'package:happjadmin/model/Product.dart';
import 'package:image_picker/image_picker.dart';

class SendMail extends StatefulWidget {
  String email;
  bool check;
  List<String> imageRemoved;
  String nameProductBefore, statusProductBefore, descriptionProductBefore;
  Product product;

  SendMail(
      {this.email,
      this.check,
      this.imageRemoved,
      this.nameProductBefore,
      this.statusProductBefore,
      this.descriptionProductBefore,
      this.product});

  @override
  _SendMailState createState() => _SendMailState();
}

class _SendMailState extends State<SendMail> {
  List<String> attachments = [];
  bool isHTML = false;

  TextEditingController _recipientController = TextEditingController(
    text: 'example@example.com',
  );

  TextEditingController _subjectController = TextEditingController(
      text: 'Thông báo về nội dung sản phẩm của bạn từ Info Happj Admin');

  TextEditingController _bodyController = TextEditingController(
    text: 'Mail body.',
  );

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    if (widget.email != null) {
      if (widget.imageRemoved.length == 0) {
        _recipientController = new TextEditingController(text: widget.email);
        _bodyController = new TextEditingController(
            text: "Chào bạn chúng tôi đến từ Happj App!\n"
                "Với vai trò người kiểm duyệt thông tin sản phẩm cho Happj App chúng tôi cho rằng những thông tin sản "
                "phẩm của bạn đang vi phạm tiêu chuẩn cộng đồng chúng tôi. (* đọc thêm ở phần thông tin ).\n"
                "Vì thế chúng tôi sẽ sửa đổi 1 vài thông tin với chi tiết sau đây: \n"
                "- Tên sản phẩm: \n${widget.nameProductBefore} --> ${widget.product.name.toString()}\n"
                "- Trạng thái: \n${widget.statusProductBefore} --> ${widget.product.status.toString()}\n"
                "- Thông tin chi tiết:\n${widget.descriptionProductBefore} --> \n${widget.product.description.toString()}\n"
                "Chúng tôi xin chân thành cảm ơn bạn! ");
      } else {
        _recipientController = new TextEditingController(text: widget.email);
        String textExample = "Chào bạn chúng tôi đến từ Happj App!\n"
            "Với vai trò người kiểm duyệt thông tin sản phẩm cho Happj App chúng tôi cho rằng những thông tin sản "
            "phẩm của bạn đang vi phạm tiêu chuẩn cộng đồng chúng tôi. (* đọc thêm ở phần thông tin ).\n"
            "Vì thế chúng tôi sẽ sửa đổi 1 vài thông tin với chi tiết sau đây: \n"
            "- Tên sản phẩm: \n${widget.nameProductBefore} --> ${widget.product.name.toString()}\n"
            "- Trạng thái: \n${widget.statusProductBefore} --> ${widget.product.status.toString()}\n"
            "- Thông tin chi tiết:\n${widget.descriptionProductBefore} --> \n${widget.product.description.toString()}\n"
            "Và xóa 1 số hình sau đây: ";
        int index = 1 ;
        widget.imageRemoved.forEach((element) {
          textExample = textExample +"\n${index.toString()} "+ "https://api-backend-daugia-2.herokuapp.com/uploads/" + element;
          index++;
        });
        textExample = textExample + "\nChúng tôi xin chân thành cảm ơn bạn! ";
        _bodyController = new TextEditingController(text: textExample);
      }
    }
  }

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  Future<void> send() async {
    final Email email = Email(
      body: _bodyController.text,
      subject: _subjectController.text,
      recipients: [_recipientController.text],
      attachmentPaths: attachments,
      isHTML: isHTML,
    );

    String platformResponse;

    try {
      await FlutterEmailSender.send(email);
      platformResponse = 'success';
    } catch (error) {
      platformResponse = error.toString();
    }

    if (!mounted) return;

    _scaffoldKey.currentState.showSnackBar(SnackBar(
      content: Text(platformResponse),
    ));
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(primaryColor: Colors.red),
      home: Scaffold(
        key: _scaffoldKey,
        appBar: AppBar(
          title: Text('Plugin example app'),
          actions: <Widget>[
            IconButton(
              onPressed: send,
              icon: Icon(Icons.send),
            )
          ],
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.all(8.0),
            child: Column(
              mainAxisSize: MainAxisSize.max,
              // mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.all(8.0),
                  child: TextField(
                    controller: _recipientController,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Recipient',
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(8.0),
                  child: TextField(
                    controller: _subjectController,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Subject',
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(8.0),
                  child: TextField(
                    controller: _bodyController,
                    maxLines: 19,
                    decoration: InputDecoration(
                        labelText: 'Body', border: OutlineInputBorder()),
                  ),
                ),
                CheckboxListTile(
                  title: Text('HTML'),
                  onChanged: (bool value) {
                    setState(() {
                      isHTML = value;
                    });
                  },
                  value: isHTML,
                ),
                ...attachments.map(
                  (item) => Text(
                    item,
                    overflow: TextOverflow.fade,
                  ),
                ),
              ],
            ),
          ),
        ),
        floatingActionButton: FloatingActionButton.extended(
          icon: Icon(Icons.camera),
          label: Text('Add Image'),
          onPressed: _openImagePicker,
        ),
      ),
    );
  }

  void _openImagePicker() async {
    File pick = await ImagePicker.pickImage(source: ImageSource.gallery);
    setState(() {
      attachments.add(pick.path);
    });
  }
}
