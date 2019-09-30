import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:petsperdidos/src/components/pet_alert.dart';
import 'package:petsperdidos/src/components/pet_button.dart';
import 'package:petsperdidos/src/components/pet_combobox.dart';
import 'package:petsperdidos/src/components/pet_imageloader.dart';
import 'package:petsperdidos/src/components/pet_loading.dart';
import 'package:petsperdidos/src/components/pet_maps_textbox.dart';
import 'package:petsperdidos/src/components/pet_textbox.dart';
import 'package:petsperdidos/src/model/foundpet.dart';
import 'package:petsperdidos/src/pages/home_page.dart';
import 'package:petsperdidos/src/service/authentication.dart';
import 'package:petsperdidos/src/service/database.dart';
import 'package:petsperdidos/src/service/storage.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

class RegisterFoundPet extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => new _RegisterFoundPetState();
}

class _RegisterFoundPetState extends State<RegisterFoundPet> {
  bool _isLoading;
  String _errorMessage;
  String _title;
  String _description;
  String _adress;
  String _type;
  String _breed;
  File _image;
  String _name;
  String _color;
  TextEditingController textController = new TextEditingController();
  final BaseAuth auth = new Auth();

  @override
  void initState() {
    _errorMessage = "";
    _isLoading = false;
    _title = "";
    _breed = "";
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

  Widget _showHeader() {
    final center = Center(
      child: Text(
        'Cadastre um animal encontrado',
        style: TextStyle(
            color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
      ),
    );

    return Container(
      padding: EdgeInsets.all(2.0),
      child: center,
    );
  }

  Widget _showBody() {
    return new Container(
      padding: EdgeInsets.all(6.0),
      child: new ListView(
        shrinkWrap: true,
        children: <Widget>[
          _showHeader(),
          _showTitle(),
          _showDescription(),
          _showCombo(),
          _showBreed(),
          _showColor(),
          _showMapsText(),
          _showSignfoundPetButton(),
          //_showImagePicker(),
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
          _description = text;
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
      onChanged: (text) => setState(
        () {
          _type = text;
        },
      ),
    );
  }

  Widget _showBreed() {
    final PetTextBox textBox = new PetTextBox(
      width: 100,
      height: 60,
      prefixIcon: Icon(Icons.pets, color: Colors.blue),
      inputType: TextInputType.text,
      backgroundColor: Colors.white,
      placeholder: 'Raça',
      textColor: Colors.black,
      cornerRadius: BorderRadius.circular(5),
      margin: EdgeInsets.fromLTRB(5, 0, 5, 25),
      onChanged: (text) => setState(
        () {
          _breed = text;
        },
      ),
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
          _adress = text;
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
      padding: const EdgeInsets.fromLTRB(0.0, 15.0, 0.0, 0.0),
      child: textBox,
    );
  }

  Widget _showColor() {
    final PetTextBox textBox = new PetTextBox(
      width: 100,
      height: 60,
      prefixIcon: Icon(Icons.color_lens, color: Colors.blue),
      inputType: TextInputType.text,
      backgroundColor: Colors.white,
      placeholder: 'Cor predominante',
      textColor: Colors.black,
      cornerRadius: BorderRadius.circular(5),
      margin: EdgeInsets.fromLTRB(5, 0, 5, 25),
      onChanged: (text) => setState(
        () {
          _color = text;
        },
      ),
      hintStyle: _getHintTextStyle(),
      formatters: [
        LengthLimitingTextInputFormatter(30),
      ],
      textCapitalization: TextCapitalization.sentences,
    );

    return Padding(
      padding: const EdgeInsets.fromLTRB(0.0, 15.0, 0.0, 0.0),
      child: textBox,
    );
  }

  Widget _showSignfoundPetButton() {
    final PetButton button = PetButton(
      onPressed: _validateAndSubmit,
      text: 'Cadastrar',
      color: Colors.green,
      padding: EdgeInsets.fromLTRB(0, 10, 0, 0),
      textStyle: TextStyle(fontSize: 20.0, color: Colors.white),
    );

    return button;
  }

  void _validateAndSubmit() async {
    if (_validateFields()) {
      setState(() {
        _errorMessage = "";
        _isLoading = true;
      });

      try {
        final Storage storage = new StorageData();

        FoundPet foundPet = new FoundPet();
        foundPet.title = _title;
        foundPet.description = _description;
        foundPet.type = _type;
        foundPet.breed = _breed;
        foundPet.color = _color;
        foundPet.lastAdress = _adress;
        foundPet.photoUrl = await storage.gravarArquivo(_image);

        final Data db = new DataAcess();

        await db.gravarAnimalEncontrado(foundPet);

        _showModalMessage(
            "Cadastrado com sucesso!",
            "Animal cadastrado com sucesso! Obrigado por colaborar! Você é incrível e ajuda o mundo a ser um lugar melhor!",
            true);
      } catch (error) {
        _showModalMessage(
            "Ocorreu um erro!",
            "Ocorreu um erro ao tentar gravar os dados, por favor tente novamente mais tarde.",
            false);
      } finally {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  Widget _showImagePicker() {
    return PetImageLoader(
      height: 60,
      width: 100,
      backgroundColor: Colors.white,
      hintText: 'Adicione uma foto',
    );
  }

  bool _validateFields() {
    String message = "";
    bool validate = true;

    if (_title == null || _title.isEmpty) {
      message = "Preencha o campo Título corretamente";
      validate = false;
    } else if (_description == null || _description.isEmpty) {
      message = "Preencha o campo Descrição corretamente";
      validate = false;
    } else if (_adress == null || _adress.isEmpty) {
      message = "Preencha o campo Último local visto corretemente";
      validate = false;
    } else if (_color == null || _color.isEmpty) {
      message = "Preencha o campo Cor predominante corretemente";
      validate = false;
    }

    if (!validate) {
      setState(() {
        _errorMessage = message;
      });
      _showModalMessage("Atenção!", message, false);
    }

    return validate;
  }

  void _showModalMessage(
      String _modalTitle, String _modalMessage, bool sucess) {
    PetAlert.showAlert(
      context,
      _modalTitle,
      _modalMessage,
      onPressed: sucess
          ? () => Navigator.pushReplacement(
              context, MaterialPageRoute(builder: (context) => HomePage()))
          : null,
      alertType: sucess ? AlertType.success : AlertType.error,
      titleColor: sucess ? Color.fromRGBO(26, 5, 178, 1) : Colors.red,
    );
  }
}
