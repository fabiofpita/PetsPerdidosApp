import 'package:flutter/material.dart';

class PetTextBox extends StatefulWidget {
  final BorderRadius cornerRadius;
  final double width, height, wordSpacing;
  final Color backgroundColor, accentColor, textColor;
  final String placeholder, fontFamily;
  final Icon prefixIcon, suffixIcon;
  final TextInputType inputType;
  final EdgeInsets margin;
  final Duration duration;
  final VoidCallback onClickSuffix;
  final TextBaseline textBaseline;
  final FontStyle fontStyle;
  final FontWeight fontWeight;
  final bool autofocus, autocorrect, enabled, obscureText, isShadow;
  final FocusNode focusNode;
  final int maxLength, minLines, maxLines;
  final ValueChanged<String> onChanged, onSubmitted;
  final GestureTapCallback onTap;
  final Color hintColor;

  const PetTextBox(
      {@required this.width,
      @required this.height,
      @required this.prefixIcon,
      @required this.inputType,
      this.suffixIcon,
      this.duration = const Duration(milliseconds: 500),
      this.margin = const EdgeInsets.all(10),
      this.obscureText = false,
      this.backgroundColor = const Color(0xff111823),
      this.cornerRadius = const BorderRadius.all(Radius.circular(10)),
      this.textColor = const Color(0xff5c5bb0),
      this.accentColor = Colors.white,
      this.placeholder = "Placeholder",
      this.isShadow = true,
      this.onClickSuffix,
      this.wordSpacing,
      this.textBaseline,
      this.fontFamily,
      this.fontStyle,
      this.fontWeight,
      this.hintColor = Colors.white,
      this.autofocus = false,
      this.autocorrect = false,
      this.focusNode,
      this.enabled = true,
      this.maxLength,
      this.maxLines,
      this.minLines,
      this.onChanged,
      this.onTap,
      this.onSubmitted})
      : assert(width != null),
        assert(height != null),
        assert(prefixIcon != null),
        assert(inputType != null);

  @override
  _PetTextBoxState createState() => _PetTextBoxState();
}

class _PetTextBoxState extends State<PetTextBox> {
  bool isFocus = false;

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      width: widget.width,
      height: widget.height,
      margin: widget.margin,
      alignment: Alignment.centerRight,
      decoration: BoxDecoration(
          boxShadow: widget.isShadow
              ? [BoxShadow(color: Colors.grey, blurRadius: 2, spreadRadius: 1)]
              : BoxShadow(spreadRadius: 0, blurRadius: 0),
          borderRadius: widget.cornerRadius,
          color: widget.suffixIcon == null
              ? isFocus ? widget.accentColor : widget.backgroundColor
              : widget.backgroundColor),
      child: Stack(
        overflow: Overflow.visible,
        children: <Widget>[
          Positioned(
            child: Text(
              widget.placeholder,
              style: TextStyle(
                fontFamily: widget.fontFamily,
                fontStyle: widget.fontStyle,
                fontWeight: FontWeight.bold,
                wordSpacing: widget.wordSpacing,
                textBaseline: widget.textBaseline,
                fontSize: 15,
                color: widget.hintColor,
              ),
            ),
            top: -20,
          ),
          widget.suffixIcon == null
              ? Container()
              : Align(
                  alignment: Alignment.centerRight,
                  child: AnimatedContainer(
                    width: isFocus ? 500 : 40,
                    height: isFocus ? widget.height : 40,
                    margin: EdgeInsets.only(right: isFocus ? 0 : 7),
                    duration: widget.duration,
                    decoration: BoxDecoration(
                      borderRadius: isFocus
                          ? widget.cornerRadius
                          : BorderRadius.all(Radius.circular(60)),
                      color: widget.accentColor,
                    ),
                  ),
                ),
          widget.suffixIcon == null
              ? Container()
              : GestureDetector(
                  onTap: () {
                    setState(() {
                      isFocus ? isFocus = false : isFocus = true;
                      if (widget.onClickSuffix != null) {
                        widget.onClickSuffix();
                      }
                    });
                  },
                  child: Container(
                    margin: EdgeInsets.only(right: 15),
                    alignment: Alignment.centerRight,
                    child: Icon(
                      widget.suffixIcon.icon,
                      color: widget.textColor,
                    ),
                  ),
                ),
          Center(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                Expanded(
                  flex: 1,
                  child: Icon(
                    widget.prefixIcon.icon,
                    color: widget.prefixIcon.color,
                  ),
                ),
                Expanded(
                  flex: 5,
                  child: Container(
                    margin: EdgeInsets.only(right: 50, top: 3),
                    child: TextField(
                      cursorWidth: 2,
                      obscureText: widget.obscureText,
                      keyboardType: widget.inputType,
                      style: TextStyle(
                        fontFamily: widget.fontFamily,
                        fontStyle: widget.fontStyle,
                        fontWeight: widget.fontWeight,
                        wordSpacing: widget.wordSpacing,
                        textBaseline: widget.textBaseline,
                        fontSize: 15,
                        color: widget.textColor,
                      ),
                      autofocus: widget.autofocus,
                      autocorrect: widget.autocorrect,
                      focusNode: widget.focusNode,
                      enabled: widget.enabled,
                      maxLength: widget.maxLength,
                      maxLines: widget.maxLines,
                      minLines: widget.minLines,
                      onChanged: widget.onChanged,
                      onTap: () {
                        setState(() {
                          isFocus = true;
                        });
                        if (widget.onTap != null) {
                          widget.onTap();
                        }
                      },
                      onSubmitted: (t) {
                        setState(() {
                          isFocus = false;
                        });
                        widget.onSubmitted(t);
                      },
                      textInputAction: TextInputAction.done,
                      decoration: InputDecoration(
                          hintStyle:
                              TextStyle(color: Colors.grey, fontSize: 17),
                          hintText: widget.placeholder,
                          border: InputBorder.none),
                      cursorColor:
                          isFocus ? widget.accentColor : widget.backgroundColor,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      duration: widget.duration,
    );
  }
}
