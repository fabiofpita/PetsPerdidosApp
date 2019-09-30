import 'package:flutter/material.dart';
import 'package:petsperdidos/src/components/pet_button.dart';
import 'package:petsperdidos/src/components/pet_textbox.dart';
import 'package:petsperdidos/src/model/user.dart';

class UserProfilePage extends StatefulWidget {
  final User user;

  UserProfilePage({this.user});

  @override
  State<StatefulWidget> createState() =>
      new _UserProfilePageState(user: this.user);
}

class _UserProfilePageState extends State<UserProfilePage> {
  _UserProfilePageState({@required this.user});

  final User user;

  TextEditingController nameController = new TextEditingController();
  TextEditingController phoneController = new TextEditingController();
  TextEditingController emailController = new TextEditingController();

  @override
  void initState() {
    nameController.text = user.nome + " " + user.sobrenome;
    phoneController.text = user.telefone;
    emailController.text = user.email;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      backgroundColor: Colors.blue,
      body: Stack(
        children: <Widget>[
          _showBody(),
        ],
      ),
    );
  }

  Widget _showHeader() {
    final center = Center(
      child: Text(
        'Dados do usuário',
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
          _showName(),
          _showEmail(),
          _showPhone(),
          _showOkButton(),
          //_showImagePicker(),
        ],
      ),
    );
  }

  Widget _showName() {
    final PetTextBox textBox = new PetTextBox(
      width: 100,
      height: 60,
      prefixIcon: Icon(Icons.people, color: Colors.blue),
      inputType: TextInputType.text,
      backgroundColor: Colors.white,
      placeholder: 'Nome',
      textColor: Colors.black,
      cornerRadius: BorderRadius.circular(5),
      margin: EdgeInsets.fromLTRB(5, 0, 5, 25),
      enabled: false,
      controller: nameController,
    );

    return Padding(
      padding: const EdgeInsets.fromLTRB(0.0, 30.0, 0.0, 0.0),
      child: textBox,
    );
  }

  Widget _showEmail() {
    final PetTextBox textBox = new PetTextBox(
      width: 100,
      height: 60,
      prefixIcon: Icon(Icons.people, color: Colors.blue),
      inputType: TextInputType.text,
      backgroundColor: Colors.white,
      placeholder: 'E-Mail',
      textColor: Colors.black,
      cornerRadius: BorderRadius.circular(5),
      margin: EdgeInsets.fromLTRB(5, 0, 5, 25),
      enabled: false,
      controller: emailController,
    );

    return Padding(
      padding: const EdgeInsets.fromLTRB(0.0, 30.0, 0.0, 0.0),
      child: textBox,
    );
  }

  Widget _showPhone() {
    final PetTextBox textBox = new PetTextBox(
      width: 100,
      height: 60,
      prefixIcon: Icon(Icons.people, color: Colors.blue),
      inputType: TextInputType.text,
      backgroundColor: Colors.white,
      placeholder: 'Telefone',
      textColor: Colors.black,
      cornerRadius: BorderRadius.circular(5),
      margin: EdgeInsets.fromLTRB(5, 0, 5, 25),
      enabled: false,
      controller: phoneController,
    );

    return Padding(
      padding: const EdgeInsets.fromLTRB(0.0, 30.0, 0.0, 0.0),
      child: textBox,
    );
  }

  _showOkButton() {
    final PetButton button = PetButton(
      onPressed: () {
        Navigator.of(context).pop();
      },
      text: 'OK',
      color: Color.fromRGBO(26, 5, 178, 1),
      textStyle: TextStyle(fontSize: 20.0, color: Colors.white),
      padding: EdgeInsets.fromLTRB(0, 10, 0, 0),
    );

    return button;
  }
}
