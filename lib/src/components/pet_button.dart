import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class PetButton extends StatefulWidget {
  final EdgeInsets padding;
  final BorderRadius borderRadius;
  final Color color;
  final String text;
  final TextStyle textStyle;
  final Function onPressed;
  final double height, width;

  const PetButton(
      {@required this.text,
      @required this.color,
      @required this.onPressed,
      this.padding = const EdgeInsets.fromLTRB(0.0, 40, 0.0, 0.0),
      this.borderRadius = const BorderRadius.all(Radius.circular(10)),
      this.textStyle = const TextStyle(fontSize: 20.0, color: Colors.blue),
      this.height = 50,
      this.width = 100})
      : assert(text != null),
        assert(color != null),
        assert(onPressed != null);

  @override
  _PetButtonState createState() => _PetButtonState();
}

class _PetButtonState extends State<PetButton> {
  @override
  Widget build(BuildContext context) {
    return new Padding(
        padding: widget.padding,
        child: SizedBox(
          height: widget.height,
          width: widget.width,
          child: new RaisedButton(
            elevation: 10,
            shape:
                new RoundedRectangleBorder(borderRadius: widget.borderRadius),
            color: widget.color,
            child: new Text(widget.text, style: widget.textStyle),
            onPressed: widget.onPressed,
          ),
        ));
  }
}
