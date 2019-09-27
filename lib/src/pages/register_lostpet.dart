import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:petsperdidos/src/components/pet_combobox.dart';
import 'package:petsperdidos/src/components/pet_loading.dart';
import 'package:petsperdidos/src/components/pet_maps_textbox.dart';
import 'package:petsperdidos/src/components/pet_textbox.dart';

class RegisterLostPet extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => new _RegisterLostPet();
}

class _RegisterLostPet extends State<RegisterLostPet> {
  bool _isLoading;
  String _errorMessage;
  String _title;
  TextEditingController textController = new TextEditingController();

  @override
  void initState() {
    _errorMessage = "";
    _isLoading = false;
    _title = "";
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      backgroundColor: Colors.blue,
      body: Stack(
        children: <Widget>[
          _showBody(),
          _showCircularProgress(),
        ],
      ),
    );
  }

  Widget _showBody() {
    return new Container(
      padding: EdgeInsets.all(6.0),
      child: new ListView(
        shrinkWrap: true,
        children: <Widget>[
          _showTitle(),
          _showDescription(),
          _showCombo(),
          _showMapsText(),
        ],
      ),
    );
  }

  Widget _showCircularProgress() {
    if (_isLoading) {
      return PetLoading();
    }
    return Container(
      height: 0.0,
      width: 0.0,
    );
  }

  TextStyle _getHintTextStyle() {
    return (_errorMessage.length > 0 && _errorMessage != null)
        ? TextStyle(color: Colors.red, fontSize: 17)
        : TextStyle(color: Colors.grey, fontSize: 17);
  }

  Widget _showTitle() {
    final PetTextBox textBox = new PetTextBox(
      width: 100,
      height: 60,
      prefixIcon: Icon(Icons.label_important, color: Colors.blue),
      inputType: TextInputType.text,
      backgroundColor: Colors.white,
      placeholder: 'Título',
      textColor: Colors.black,
      cornerRadius: BorderRadius.circular(5),
      margin: EdgeInsets.fromLTRB(5, 0, 5, 25),
      onChanged: (text) => setState(
        () {
          _title = text;
        },
      ),
      hintStyle: _getHintTextStyle(),
      formatters: [
        LengthLimitingTextInputFormatter(30),
      ],
      textCapitalization: TextCapitalization.sentences,
    );

    return Padding(
      padding: const EdgeInsets.fromLTRB(0.0, 30.0, 0.0, 0.0),
      child: textBox,
    );
  }

  Widget _showDescription() {
    final PetTextBox textBox = new PetTextBox(
      width: 100,
      height: 200,
      prefixIcon: Icon(Icons.info_outline, color: Colors.blue),
      maxLines: 10,
      inputType: TextInputType.text,
      backgroundColor: Colors.white,
      placeholder: 'Descrição',
      textColor: Colors.black,
      cornerRadius: BorderRadius.circular(5),
      margin: EdgeInsets.fromLTRB(5, 0, 5, 25),
      onChanged: (text) => setState(
        () {
          _title = text;
        },
      ),
      hintStyle: _getHintTextStyle(),
      formatters: [
        LengthLimitingTextInputFormatter(500),
      ],
      textCapitalization: TextCapitalization.sentences,
      showPlaceHolder: false,
      fontSize: 16,
    );

    return Padding(
      padding: const EdgeInsets.fromLTRB(0.0, 30.0, 0.0, 0.0),
      child: textBox,
    );
  }

  Widget _showCombo() {
    return PetComboBox(
      width: 100,
      height: 60,
      prefixIcon: Icon(
        Icons.pets,
        color: Colors.blue,
      ),
      hintText: "Tipo de animal",
      items: ['Cachorro', 'Gato', 'Outros'],
    );
  }

  Widget _showMapsText() {
    final PetMapsTextBox textBox = new PetMapsTextBox(
      width: 100,
      height: 60,
      prefixIcon: Icon(Icons.map, color: Colors.blue),
      inputType: TextInputType.text,
      backgroundColor: Colors.white,
      placeholder: 'Último local visto',
      textColor: Colors.black,
      cornerRadius: BorderRadius.circular(5),
      margin: EdgeInsets.fromLTRB(5, 0, 5, 25),
      onChanged: (text) => setState(
        () {
          _title = text;
        },
      ),
      hintStyle: _getHintTextStyle(),
      formatters: [
        LengthLimitingTextInputFormatter(30),
      ],
      textCapitalization: TextCapitalization.sentences,
      controller: textController,
    );

    return Padding(
      padding: const EdgeInsets.fromLTRB(0.0, 30.0, 0.0, 0.0),
      child: textBox,
    );
  }
}
