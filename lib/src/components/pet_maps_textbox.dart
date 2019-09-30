import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_google_places/flutter_google_places.dart';
import 'package:google_maps_webservice/places.dart';
import 'package:flutter/services.dart' show rootBundle;

class PetMapsTextBox extends StatefulWidget {
  final BorderRadius cornerRadius;
  final double width, height, wordSpacing, fontSize;
  final Color backgroundColor, accentColor, textColor;
  final String placeholder, fontFamily;
  final Icon prefixIcon;
  final TextInputType inputType;
  final EdgeInsets margin;
  final Duration duration;
  final TextBaseline textBaseline;
  final FontStyle fontStyle;
  final FontWeight fontWeight;
  final bool autofocus, autocorrect, obscureText, isShadow, showPlaceHolder;
  final FocusNode focusNode;

  final ValueChanged<String> onChanged;
  final GestureTapCallback onTap;
  final Color hintColor;
  final TextStyle hintStyle;
  final List<TextInputFormatter> formatters;
  final TextEditingController controller;
  final TextCapitalization textCapitalization;

  const PetMapsTextBox(
      {@required this.width,
      @required this.height,
      @required this.prefixIcon,
      @required this.inputType,
      this.duration = const Duration(milliseconds: 500),
      this.margin = const EdgeInsets.all(10),
      this.obscureText = false,
      this.backgroundColor = const Color(0xff111823),
      this.cornerRadius = const BorderRadius.all(Radius.circular(10)),
      this.textColor = const Color(0xff5c5bb0),
      this.accentColor = Colors.white,
      this.placeholder = "Placeholder",
      this.isShadow = true,
      this.wordSpacing,
      this.textBaseline,
      this.fontFamily,
      this.fontStyle,
      this.fontWeight,
      this.hintColor = Colors.white,
      this.autofocus = false,
      this.autocorrect = false,
      this.focusNode,
      this.onChanged,
      this.onTap,
      this.hintStyle = const TextStyle(color: Colors.grey, fontSize: 17),
      this.formatters,
      this.controller,
      this.textCapitalization = TextCapitalization.none,
      this.fontSize = 15,
      this.showPlaceHolder = true})
      : assert(width != null),
        assert(height != null),
        assert(prefixIcon != null),
        assert(
          inputType != null,
        );

  @override
  _PetMapsTextBoxState createState() => _PetMapsTextBoxState();
}

class _PetMapsTextBoxState extends State<PetMapsTextBox> {
  bool isFocus = false;
  String _placeid;

  get placeId {
    return _placeid;
  }

  String apiKey;
  GoogleMapsPlaces _places;

  Future<String> _getApiKey() async {
    String content = await rootBundle.loadString("assets/credentials.json");

    var credentials = jsonDecode(content);

    apiKey = credentials["googlePlacesApiKey"];
    _places = GoogleMapsPlaces(apiKey: apiKey);

    return credentials["googlePlacesApiKey"];
  }

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
          color: isFocus ? widget.accentColor : widget.backgroundColor),
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
          Align(
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
                      textCapitalization: widget.textCapitalization,
                      cursorWidth: 2,
                      obscureText: widget.obscureText,
                      keyboardType: widget.inputType,
                      style: TextStyle(
                        fontFamily: widget.fontFamily,
                        fontStyle: widget.fontStyle,
                        fontWeight: widget.fontWeight,
                        wordSpacing: widget.wordSpacing,
                        textBaseline: widget.textBaseline,
                        fontSize: widget.fontSize,
                        color: widget.textColor,
                      ),
                      autofocus: widget.autofocus,
                      autocorrect: widget.autocorrect,
                      focusNode: widget.focusNode,
                      onChanged: widget.onChanged,
                      onTap: () async {
                        Prediction p;
                        p = await PlacesAutocomplete.show(
                            context: context,
                            apiKey: apiKey == null || apiKey.isEmpty
                                ? await _getApiKey()
                                : apiKey,
                            hint: "Pesquisar",
                            language: "pt_BR",
                            onError: (error) =>
                                print("ERROOOOOO: " + error.errorMessage));
                        if (p != null) {
                          setState(() {
                            _placeid = p.placeId;
                          });

                          widget.controller.value =
                              TextEditingValue(text: p.description);
                          widget.onChanged(p.description);
                        }
                      },
                      textInputAction: TextInputAction.done,
                      decoration: widget.showPlaceHolder
                          ? InputDecoration(
                              hintStyle: widget.hintStyle,
                              hintText: widget.placeholder,
                              border: InputBorder.none,
                            )
                          : null,
                      cursorColor:
                          isFocus ? Colors.blue : widget.backgroundColor,
                      inputFormatters: widget.formatters,
                      controller: widget.controller,
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

  // Future<Null> displayPrediction(Prediction p) async {
  //   if (p != null) {
  //     PlacesDetailsResponse detail =
  //         await _places.getDetailsByPlaceId(p.placeId);

  //     var placeId = p.placeId;
  //     double lat = detail.result.geometry.location.lat;
  //     double lng = detail.result.geometry.location.lng;

  //     var address = await Geocoder.local.findAddressesFromQuery(p.description);

  //     print(lat);
  //     print(lng);
  //   }
  // }
}
