import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class PetImageLoader extends StatefulWidget {
  final double width, height, wordSpacing;
  final Duration duration;
  final EdgeInsets margin;
  final Color backgroundColor, textColor, accentColor, hintColor;
  final BorderRadius cornerRadius;
  final String hintText;
  final TextStyle hintStyle;

  const PetImageLoader({
    @required this.width,
    @required this.height,
    this.duration = const Duration(milliseconds: 500),
    this.margin = const EdgeInsets.all(5),
    this.backgroundColor = Colors.white,
    this.textColor = Colors.black,
    this.accentColor = Colors.blue,
    this.wordSpacing,
    this.cornerRadius = const BorderRadius.all(Radius.circular(10)),
    this.hintColor = Colors.white,
    this.hintText,
    this.hintStyle = const TextStyle(
        color: Colors.white, fontSize: 15, fontWeight: FontWeight.bold),
  })  : assert(width != null),
        assert(height != null);
  @override
  _PetImageLoaderState createState() => _PetImageLoaderState();
}

class _PetImageLoaderState extends State<PetImageLoader> {
  File _image;

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: widget.duration,
      width: widget.width,
      height: widget.height,
      margin: widget.margin,
      alignment: Alignment.centerRight,
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(color: Colors.grey, blurRadius: 2, spreadRadius: 1)
        ],
        borderRadius: BorderRadius.circular(5),
        color: widget.backgroundColor,
      ),
      child: Stack(
        overflow: Overflow.visible,
        children: <Widget>[
          Positioned(
            child: Text(
              widget.hintText,
              style: widget.hintStyle,
            ),
            top: -20,
          ),
          Align(
            alignment: Alignment.centerRight,
            child: AnimatedContainer(
              width: 500,
              height: widget.height,
              margin: EdgeInsets.only(right: 0),
              duration: widget.duration,
              decoration: BoxDecoration(
                borderRadius: widget.cornerRadius,
                color: widget.backgroundColor,
              ),
            ),
          ),
          Center(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                IconButton(
                  icon: Icon(Icons.add_a_photo),
                  color: widget.accentColor,
                  onPressed: () {
                    _getImage();
                  },
                ),
                Container(
                  margin: EdgeInsets.only(right: 50, top: 3),
                  child: FlatButton(
                    child: Text("Buscar imagem"),
                    onPressed: () {
                      _getImage();
                    },
                  ),
                ),
                Container(
                  child: IconButton(
                    color: widget.accentColor,
                    onPressed: () {
                      setState(() {
                        _image = null;
                      });
                    },
                    icon: Icon(Icons.delete),
                  ),
                ),
              ],
            ),
          ),
          _image == null
              ? Container(
                  color: Colors.transparent,
                )
              : Container(
                  width: 100,
                  height: 200,
                  color: Colors.white,
                  child: Image.file(
                    _image,
                    fit: BoxFit.cover,
                  ),
                )
        ],
      ),
    );
  }

  Future<void> _getImage() async {
    var image = await ImagePicker.pickImage(source: ImageSource.gallery);

    setState(() {
      _image = image;
    });
  }
}
