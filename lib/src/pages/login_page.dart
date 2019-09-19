import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:petsperdidos/src/components/pet_alert.dart';
import 'package:petsperdidos/src/components/pet_button.dart';
import 'package:petsperdidos/src/components/pet_loading.dart';
import 'package:petsperdidos/src/components/pet_textbox.dart';
import 'package:petsperdidos/src/model/user.dart';
import 'package:petsperdidos/src/pages/home_page.dart';
import 'package:petsperdidos/src/pages/signup_page.dart';
import 'package:petsperdidos/src/service/authentication.dart';
import 'package:petsperdidos/src/service/database.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

class LoginPage extends StatefulWidget {
  LoginPage({this.auth, this.onSignedIn});

  final BaseAuth auth;
  final VoidCallback onSignedIn;

  @override
  State<StatefulWidget> createState() => new _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  String _email;
  String _password;
  String _errorMessage;
  final BaseAuth auth = new Auth();
  final Data db = new DataAcess();

  bool _isLoading;

  @override
  void initState() {
    _errorMessage = "";
    _isLoading = false;
    _email = "";
    _password = "";
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

  Widget _showCircularProgress() {
    if (_isLoading) {
      return PetLoading();
    }
    return Container(
      height: 0.0,
      width: 0.0,
    );
  }

  // void _showVerifyEmailSentDialog() {
  //   showDialog(
  //     context: context,
  //     builder: (BuildContext context) {
  //       // return object of type Dialog
  //       return AlertDialog(
  //         title: new Text("Verify your account"),
  //         content:
  //             new Text("Link to verify account has been sent to your email"),
  //         actions: <Widget>[
  //           new FlatButton(
  //             child: new Text("Dismiss"),
  //             onPressed: () {
  //               Navigator.of(context).pop();
  //             },
  //           ),
  //         ],
  //       );
  //     },
  //   );
  // }

  Widget _showBody() {
    return new Container(
        padding: EdgeInsets.all(6.0),
        child: new Form(
          child: new ListView(
            shrinkWrap: true,
            children: <Widget>[
              _showLogo(),
              _showEmailInput(),
              _showPasswordInput(),
              _showErrorMessage(),
              _showPrimaryButton(),
              _showFacebookButton(),
              _showSignUpLabel(),
              _showForgotPasswordLabel(),
            ],
          ),
        ));
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
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      );
    } else {
      return new Padding(
        padding: EdgeInsets.fromLTRB(0, 10, 0, 0),
      );
    }
  }

  Widget _showLogo() {
    return new Hero(
      tag: 'hero',
      child: Padding(
          padding: EdgeInsets.fromLTRB(0.0, 10, 0.0, 0.0),
          child: Center(
            child: Container(
              child: Image.asset(
                'assets/sherlock-dog.png',
                fit: BoxFit.contain,
              ),
              width: 180.0,
              height: 150.0,
            ),
          )),
    );
  }

  Widget _showEmailInput() {
    final PetTextBox textBox = new PetTextBox(
        width: 100,
        height: 60,
        prefixIcon: Icon(Icons.email, color: Colors.blue),
        inputType: TextInputType.emailAddress,
        backgroundColor: Colors.white,
        placeholder: 'E-mail',
        textColor: Colors.black,
        cornerRadius: BorderRadius.circular(5),
        margin: EdgeInsets.fromLTRB(5, 0, 5, 25),
        onChanged: (text) => setState(() {
              _email = text;
            }),
        hintStyle: _getHintTextStyle());

    return Padding(
        padding: const EdgeInsets.fromLTRB(0.0, 30.0, 0.0, 0.0),
        child: textBox);
  }

  Widget _showPasswordInput() {
    final PetTextBox textBox = new PetTextBox(
        width: 100,
        height: 60,
        prefixIcon: Icon(Icons.lock, color: Colors.blue),
        inputType: TextInputType.text,
        backgroundColor: Colors.white,
        placeholder: 'Senha',
        textColor: Colors.black,
        obscureText: true,
        cornerRadius: BorderRadius.circular(5),
        margin: EdgeInsets.fromLTRB(5, 0, 5, 0),
        onChanged: (text) => setState(() {
              _password = text;
            }),
        hintStyle: _getHintTextStyle());

    return Padding(
        padding: const EdgeInsets.fromLTRB(0.0, 10, 0.0, 0.0), child: textBox);
  }

  Widget _showSignUpLabel() {
    return new FlatButton(
        child: new Text('Não tem uma conta? Cadastre-se!',
            style: new TextStyle(
                fontSize: 16.0,
                fontWeight: FontWeight.bold,
                color: Colors.white)),
        onPressed: () {
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => SignUpPage()));
        });
  }

  Widget _showForgotPasswordLabel() {
    return new FlatButton(
        child: new Text('Esqueci minha senha',
            style: new TextStyle(
                fontSize: 16.0,
                fontWeight: FontWeight.bold,
                color: Colors.white,
                decoration: TextDecoration.underline)),
        onPressed: () {
          PetAlert.showForgotPasswordAlert(context);
        });
  }

  Widget _showFacebookButton() {
    final PetButton button = PetButton(
      onPressed: _facebookLogin,
      color: Color.fromRGBO(59, 89, 152, 2),
      text: 'Entrar com o Facebook',
      textStyle: TextStyle(color: Colors.white, fontSize: 20),
      padding: EdgeInsets.fromLTRB(0, 15, 0, 5),
    );

    return button;
  }

  Widget _showPrimaryButton() {
    final PetButton button = PetButton(
      onPressed: _validateAndSubmit,
      text: 'Entrar',
      color: Colors.white,
      padding: EdgeInsets.fromLTRB(0, 10, 0, 0),
    );

    return button;
  }

  void _showModalMessage(String _modalTitle, String _modalMessage,
      {AlertType alertType = AlertType.error}) {
    PetAlert.showAlert(
      context,
      _modalTitle,
      _modalMessage,
      alertType: alertType,
    );
  }

  TextStyle _getHintTextStyle() {
    return (_errorMessage.length > 0 && _errorMessage != null)
        ? TextStyle(color: Colors.red, fontSize: 17)
        : TextStyle(color: Colors.grey, fontSize: 17);
  }

  void _validateAndSubmit() async {
    if (_validateFields()) {
      setState(() {
        _errorMessage = "";
        _isLoading = true;
      });

      try {
        String id = await auth.signIn(_email, _password);

        bool userConfirmed = await auth.isEmailVerified();
        if (userConfirmed) {
          Navigator.of(context).pushReplacement(MaterialPageRoute(
            builder: (context) => HomePage(
              userId: id,
            ),
          ));
        } else {
          _showModalMessage(
            "Confirme seu e-mail!",
            "Você ainda não confirmou seu conta! Confira sua caixa de entrada e confirme sua conta para prosseguir!",
            alertType: AlertType.info,
          );
        }
      } on PlatformException catch (error) {
        _showModalMessage(
            "Ocorreu um erro!", auth.getAuthenticationError(error));
      } finally {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  bool _validateFields() {
    bool validate = true;
    String message = "";

    if (_email == null || _email.isEmpty) {
      validate = false;
      message = "Preencha o campo E-mail!";
    } else if (_password == null || _password.isEmpty) {
      validate = false;
      message = "Preencha o campo Senha!";
    }

    if (!validate) {
      setState(() {
        _errorMessage = message;
      });
    }

    return validate;
  }

  void _facebookLogin() async {
    try {
      setState(() {
        _isLoading = true;
      });

      User user = await auth.signInWithFacebook();

      if (user != null) {
        await db.gravarUsuario(user);

        Navigator.of(context).pushReplacement(MaterialPageRoute(
          builder: (context) => HomePage(
            userId: user.id,
          ),
        ));
      } else {
        _showModalMessage("Ocorreu um erro!",
            "Ocorreu um erro ao tentar se logar com o Facebook. Tente novamente mais tarde!");
      }

      setState(() {
        _isLoading = false;
      });
    } on PlatformException catch (error) {
      setState(() {
        _isLoading = false;
      });
      _showModalMessage("Ocorreu um erro!", auth.getAuthenticationError(error));
    }
  }
}
