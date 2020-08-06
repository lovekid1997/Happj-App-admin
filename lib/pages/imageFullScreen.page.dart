

import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';

class FullScreenImage extends StatefulWidget {
  List<dynamic> list;

  FullScreenImage({this.list});

  @override
  _FullScreenImageState createState() => _FullScreenImageState();
}

class _FullScreenImageState extends State<FullScreenImage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(

      body: Builder(
        builder: (context) {
          final double height = MediaQuery.of(context).size.height;
          return CarouselSlider(
            options: CarouselOptions(
              height: height,
              viewportFraction: 1.0,
              enlargeCenterPage: false,
              // autoPlay: false,
            ),
            items: widget.list.map((item) => Container(
              child: Center(
                  child:GestureDetector(
                    onTap: (){Navigator.of(context).pop();},
                    child:  Image.network(item, fit: BoxFit.cover, height: height,),
                  )
              ),
            )).toList(),
          );
        },
      ),
    );
  }
}
