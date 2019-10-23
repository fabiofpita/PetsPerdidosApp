import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:petsperdidos/src/components/pet_alert.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

class PetImageLoader extends StatefulWidget {
  final double width, height, wordSpacing;
  final Duration duration;
  final EdgeInsets margin;
  final Color backgroundColor, textColor, accentColor, hintColor;
  final BorderRadius cornerRadius;
  final String hintText;
  final TextStyle hintStyle;
  final ValueChanged<File> onImageChanged;

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
      color: Colors.white,
      fontSize: 15,
      fontWeight: FontWeight.bold,
    ),
    this.onImageChanged,
  })  : assert(width != null),
        assert(height != null);
  @override
  _PetImageLoaderState createState() => _PetImageLoaderState();
}

class _PetImageLoaderState extends State<PetImageLoader> {
  File _image;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: widget.width,
      height: _image == null ? 60 : 300,
      margin: widget.margin,
      alignment: Alignment.centerRight,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(5),
        color: widget.backgroundColor,
      ),
      child: Column(
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              IconButton(
                icon: Icon(Icons.add_a_photo),
                color: widget.accentColor,
                onPressed: () async {
                  await _getImage();
                  widget.onImageChanged(_image);
                },
              ),
              FlatButton(
                child: Text(
                  "Adicione uma imagem do pet",
                  style: TextStyle(color: Colors.grey),
                ),
                onPressed: () async {
                  await _getImage();
                  widget.onImageChanged(_image);
                },
              ),
              IconButton(
                icon: Icon(Icons.delete),
                color: widget.accentColor,
                onPressed: () {
                  setState(() {
                    _image = null;
                  });
                  widget.onImageChanged(_image);
                },
              ),
            ],
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
                    fit: BoxFit.contain,
                  ),
                )
        ],
      ),
    );

    // child: Stack(
    //   overflow: Overflow.visible,
    //   children: <Widget>[
    //     Positioned(
    //       child: Text(
    //         widget.hintText,
    //         style: widget.hintStyle,
    //       ),
    //       top: -20,
    //     ),

    //     Center(
    //       child: Row(
    //         mainAxisAlignment: MainAxisAlignment.spaceEvenly,
    //         children: <Widget>[

    //           Container(
    //             child: IconButton(
    //               color: widget.accentColor,
    //               onPressed: () {
    //                 setState(() {
    //                   _image = null;
    //                 });
    //               },
    //               icon: Icon(Icons.delete),
    //             ),
    //           ),
    //         ],
    //       ),
    //     ),
    //     _image == null
    //         ? Container(
    //             color: Colors.transparent,
    //           )
    //         : Container(
    //             width: 100,
    //             height: 200,
    //             color: Colors.white,
    //             child: Image.file(
    //               _image,
    //               fit: BoxFit.cover,
    //             ),
    //           )
  }

  Future<void> _getImage() async {
    try {
      var image = await ImagePicker.pickImage(source: ImageSource.gallery);

      setState(
        () {
          _image = image;
        },
      );
    } catch (error) {
      setState(
        () {
          _image = null;
        },
      );
      PetAlert.showAlert(
        context,
        "Ops!",
        "Ocorreu um erro ao tentar carregar a imagem, por favor tente novamente mais tarde!",
        onPressed: null,
        alertType: AlertType.error,
        titleColor: Colors.red,
      );
    }
  }
}
