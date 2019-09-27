import 'package:flutter/material.dart';

class PetComboBox extends StatefulWidget {
  final double width, height, wordSpacing;
  final Icon prefixIcon;
  final Duration duration;
  final EdgeInsets margin;
  final Color backgroundColor, textColor, accentColor, hintColor;
  final BorderRadius cornerRadius;
  final String hintText;
  final FontWeight fontWeight;
  final bool enabled, showHint;
  final TextStyle hintStyle, fontStyle;
  final List<String> items;

  const PetComboBox({
    @required this.width,
    @required this.height,
    this.prefixIcon,
    this.duration = const Duration(milliseconds: 500),
    this.margin = const EdgeInsets.all(5),
    this.backgroundColor = Colors.white,
    this.cornerRadius = const BorderRadius.all(Radius.circular(10)),
    this.textColor = Colors.black,
    this.accentColor = Colors.blue,
    this.hintText = "",
    this.wordSpacing,
    this.fontWeight = FontWeight.bold,
    this.hintColor = Colors.white,
    this.enabled = true,
    this.hintStyle = const TextStyle(
        color: Colors.white, fontSize: 15, fontWeight: FontWeight.bold),
    this.showHint = true,
    this.items,
    this.fontStyle = const TextStyle(color: Colors.black, fontSize: 15),
  })  : assert(width != null),
        assert(height != null);

  @override
  _PetComboBoxState createState() => _PetComboBoxState();
}

class _PetComboBoxState extends State<PetComboBox> {
  String _value;

  @override
  void initState() {
    _value = "Cachorro";
    super.initState();
  }

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
            child: widget.showHint
                ? Text(
                    widget.hintText,
                    style: widget.hintStyle,
                  )
                : Container(
                    color: Colors.transparent,
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
                Expanded(
                  flex: 1,
                  child: widget.prefixIcon,
                ),
                Expanded(
                  flex: 5,
                  child: Container(
                    margin: EdgeInsets.only(right: 20, top: 3),
                    child: new DropdownButton<String>(
                      items: widget.items.map((String value) {
                        return new DropdownMenuItem<String>(
                          value: value,
                          child: new Text(value),
                        );
                      }).toList(),
                      onChanged: (_text) {
                        setState(() {
                          _value = _text;
                        });
                      },
                      style: widget.fontStyle,
                      value: _value,
                      isExpanded: true,
                      underline: Container(
                        color: widget.backgroundColor,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
