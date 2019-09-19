import 'package:flutter/material.dart';
import 'package:petsperdidos/src/components/pet_alert.dart';
import 'package:petsperdidos/src/components/pet_button.dart';
import 'package:petsperdidos/src/components/pet_loading.dart';
import 'package:petsperdidos/src/components/pet_textbox.dart';
import 'package:flutter_masked_text/flutter_masked_text.dart';
import 'package:petsperdidos/src/model/user.dart';
import 'package:petsperdidos/src/pages/login_page.dart';
import 'package:petsperdidos/src/service/authentication.dart';
import 'package:petsperdidos/src/service/database.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

class SignUpPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => new _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final _formKey = new GlobalKey<FormState>();
  final Data db = new DataAcess();
  final BaseAuth auth = new Auth();
  //bool _isIos;
  bool _isLoading;
  String _errorMessage;
  String _name;
  String _lastName;
  String _phone;
  String _email;
  String _password;

  var controller = new MaskedTextController(mask: '(00) 00000-0000');

  @override
  void initState() {
    _errorMessage = "";
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
        padding: EdgeInsets.all(5.0),
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
              _showErrorMessage(),
              _showButton()
            ],
          ),
        ));
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
      onChanged: (text) => setState(() {
        _name = text;
      }),
      hintStyle: _getHintTextStyle(),
      textCapitalization: TextCapitalization.words,
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
        onChanged: (text) => setState(() {
              _lastName = text;
            }),
        hintStyle: _getHintTextStyle(),
        textCapitalization: TextCapitalization.words);

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
      onChanged: (text) => setState(() {
        _phone = text;
      }),
      hintStyle: _getHintTextStyle(),
      controller: controller,
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
      onChanged: (text) => setState(() {
        _email = text;
      }),
      hintStyle: _getHintTextStyle(),
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
      margin: EdgeInsets.fromLTRB(5, 0, 5, 0),
      onChanged: (text) => setState(() {
        _password = text;
      }),
      hintStyle: _getHintTextStyle(),
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
      padding: EdgeInsets.fromLTRB(0, 10, 0, 0),
    );

    return button;
  }

  TextStyle _getHintTextStyle() {
    return (_errorMessage.length > 0 && _errorMessage != null)
        ? TextStyle(color: Colors.red, fontSize: 17)
        : TextStyle(color: Colors.grey, fontSize: 17);
  }

  Widget _showErrorMessage() {
    if (_errorMessage.length > 0 && _errorMessage != null) {
      return new Padding(
        padding: EdgeInsets.fromLTRB(0, 10, 0, 0),
        child: Center(
          child: Text(
            _errorMessage,
            style: TextStyle(
                fontSize: 13.0,
                color: Colors.red,
                height: 1.0,
                fontWeight: FontWeight.bold),
          ),
        ),
      );
    } else {
      return new Padding(
        padding: EdgeInsets.fromLTRB(0, 10, 0, 0),
      );
    }
  }

  void _showModalMessage(
      String _modalTitle, String _modalMessage, bool sucess) {
    PetAlert.showAlert(
      context,
      _modalTitle,
      _modalMessage,
      onPressed: sucess
          ? () => Navigator.push(
              context, MaterialPageRoute(builder: (context) => LoginPage()))
          : null,
      alertType: AlertType.success,
      titleColor: sucess ? Color.fromRGBO(26, 5, 178, 1) : Colors.red,
    );
  }

  void _validateAndSubmit() async {
    if (_validateAndSave()) {
      setState(() {
        _errorMessage = "";
        _isLoading = true;
      });

      try {
        User user =
            new User(this._name, this._lastName, this._email, this._phone);

        String id = await auth.signUp(user.email, this._password);

        user.id = id;

        await db.gravarUsuario(user);

        auth.sendEmailVerification();

        _showModalMessage(
            "Cadastrado com sucesso!",
            "Cadastrado com sucesso! Um e-mail de confirmação foi enviado para " +
                user.email,
            true);
      } catch (error) {
        print(error);
        List<String> errors = error.toString().split(',');
        _showModalMessage("Ocorreu um erro!", errors[1], false);
      } finally {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  bool _validateAndSave() {
    String message = "";
    bool validate = true;

    if (_name == null || _name.isEmpty) {
      message = "Preencha o campo Nome corretamente";
      validate = false;
    } else if (_lastName == null || _lastName.isEmpty) {
      message = "Preencha o campo Sobrenome corretamente";
      validate = false;
    } else if (_phone == null || _phone.isEmpty) {
      message = "Preencha o campo Telefone corretamente";
      validate = false;
    } else if (_email == null || _email.isEmpty) {
      message = "Preencha o campo E-Mail corretamente";
      validate = false;
    } else if (_password == null || _password.isEmpty) {
      message = "Preencha o campo Senha corretamente";
      validate = false;
    } else if (!_validatePhoneNumber()) {
      message = "Telefone inválido!";
      validate = false;
    } else if (!_validateEmail()) {
      message = "E-mail inválido!";
      validate = false;
    } else if (!_validatePassword()) {
      message = "A senha deve conter no mínimo 6 caracteres!";
      validate = false;
    }

    if (!validate) {
      setState(() {
        _errorMessage = message;
      });
    }

    return validate;
  }

  bool _validatePhoneNumber() {
    if (_phone.length != 15) {
      return false;
    }
    return true;
  }

  bool _validateEmail() {
    //TODO
    return true;
  }

  bool _validatePassword() {
    if (_password.length < 6) {
      return false;
    }
    return true;
  }
}
