import 'package:flutter/material.dart';
import 'package:petsperdidos/src/components/pet_button.dart';
import 'package:petsperdidos/src/components/pet_textbox.dart';

class SignUpPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => new _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final _formKey = new GlobalKey<FormState>();
  //bool _isIos;
  bool _isLoading;

  @override
  void initState() {
    _isLoading = false;
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
        ));
  }

  Widget _showBody() {
    return new Container(
        padding: EdgeInsets.all(14.0),
        child: new Form(
          key: _formKey,
          child: new ListView(
            shrinkWrap: true,
            children: <Widget>[
              _showNameInput(),
              _showLastNameInput(),
              _showPhoneInput(),
              _showEmailInput(),
              _showPasswordInput(),
              _showButton()
            ],
          ),
        ));
  }

  Widget _showCircularProgress() {
    if (_isLoading) {
      return Center(child: CircularProgressIndicator());
    }
    return Container(
      height: 0.0,
      width: 0.0,
    );
  }

  Widget _showNameInput() {
    final PetTextBox textBox = new PetTextBox(
      width: 100,
      height: 60,
      prefixIcon: Icon(Icons.person, color: Colors.blue),
      inputType: TextInputType.text,
      backgroundColor: Colors.white,
      placeholder: 'Nome',
      textColor: Colors.black,
      cornerRadius: BorderRadius.circular(5),
      margin: EdgeInsets.fromLTRB(5, 0, 5, 10),
    );

    return Padding(
        padding: const EdgeInsets.fromLTRB(0.0, 30.0, 0.0, 35), child: textBox);
  }

  Widget _showLastNameInput() {
    final PetTextBox textBox = new PetTextBox(
      width: 100,
      height: 60,
      prefixIcon: Icon(Icons.person, color: Colors.blue),
      inputType: TextInputType.text,
      backgroundColor: Colors.white,
      placeholder: 'Sobrenome',
      textColor: Colors.black,
      cornerRadius: BorderRadius.circular(5),
      margin: EdgeInsets.fromLTRB(5, 0, 5, 10),
    );

    return Padding(
        padding: const EdgeInsets.fromLTRB(0.0, 0, 0.0, 35), child: textBox);
  }

  Widget _showPhoneInput() {
    final PetTextBox textBox = new PetTextBox(
      width: 100,
      height: 60,
      prefixIcon: Icon(Icons.phone, color: Colors.blue),
      inputType: TextInputType.phone,
      backgroundColor: Colors.white,
      placeholder: 'Telefone',
      textColor: Colors.black,
      cornerRadius: BorderRadius.circular(5),
      margin: EdgeInsets.fromLTRB(5, 0, 5, 10),
    );

    return Padding(
        padding: const EdgeInsets.fromLTRB(0.0, 0, 0.0, 35), child: textBox);
  }

  Widget _showEmailInput() {
    final PetTextBox textBox = new PetTextBox(
      width: 100,
      height: 60,
      prefixIcon: Icon(Icons.email, color: Colors.blue),
      inputType: TextInputType.emailAddress,
      backgroundColor: Colors.white,
      placeholder: 'E-Mail',
      textColor: Colors.black,
      cornerRadius: BorderRadius.circular(5),
      margin: EdgeInsets.fromLTRB(5, 0, 5, 10),
    );

    return Padding(
        padding: const EdgeInsets.fromLTRB(0.0, 0, 0.0, 35), child: textBox);
  }

  Widget _showPasswordInput() {
    final PetTextBox textBox = new PetTextBox(
      width: 100,
      height: 60,
      prefixIcon: Icon(Icons.lock, color: Colors.blue),
      inputType: TextInputType.text,
      obscureText: true,
      backgroundColor: Colors.white,
      placeholder: 'Senha',
      textColor: Colors.black,
      cornerRadius: BorderRadius.circular(5),
      margin: EdgeInsets.fromLTRB(5, 0, 5, 10),
    );

    return Padding(
        padding: const EdgeInsets.fromLTRB(0.0, 0, 0.0, 0), child: textBox);
  }

  Widget _showButton() {
    final PetButton button = PetButton(
      onPressed: _validateAndSubmit,
      text: 'Cadastrar',
      color: Color.fromRGBO(26, 5, 178, 1),
      textStyle: TextStyle(fontSize: 20.0, color: Colors.white),
    );

    return button;
  }

  void _validateAndSubmit() async {}
}
