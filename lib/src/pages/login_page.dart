import 'package:flutter/material.dart';
import 'package:petsperdidos/src/components/pet_button.dart';
import 'package:petsperdidos/src/components/pet_textbox.dart';
import 'package:petsperdidos/src/pages/signup_page.dart';
import 'package:petsperdidos/src/service/authentication.dart';

class LoginPage extends StatefulWidget {
  LoginPage({this.auth, this.onSignedIn});

  final BaseAuth auth;
  final VoidCallback onSignedIn;

  @override
  State<StatefulWidget> createState() => new _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = new GlobalKey<FormState>();

  String _email;
  String _password;
  String _errorMessage;

  bool _isIos;
  bool _isLoading;

  // Check if form is valid before perform login or signup
  bool _validateAndSave() {
    final form = _formKey.currentState;
    if (form.validate()) {
      form.save();
      return true;
    }
    return false;
  }

  // Perform login or signup
  void _validateAndSubmit() async {
    setState(() {
      _errorMessage = "";
      _isLoading = true;
    });
    if (_validateAndSave()) {
      String userId = "";
      try {
        if (true) {
          //_formMode == FormMode.LOGIN
          userId = await widget.auth.signIn(_email, _password);
          print('Signed in: $userId');
        }
        setState(() {
          _isLoading = false;
        });

        if (userId.length > 0 && userId != null) {
          //_formMode == FormMode.LOGIN) {
          widget.onSignedIn();
        }
      } catch (e) {
        print('Error: $e');
        setState(() {
          _isLoading = false;
          if (_isIos) {
            _errorMessage = e.details;
          } else
            _errorMessage = e.message;
        });
      }
    }
  }

  @override
  void initState() {
    _errorMessage = "";
    _isLoading = false;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    _isIos = Theme.of(context).platform == TargetPlatform.iOS;
    return new Scaffold(
        backgroundColor: Colors.blue,
        body: Stack(
          children: <Widget>[
            _showBody(),
            _showCircularProgress(),
          ],
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
        padding: EdgeInsets.all(14.0),
        child: new Form(
          key: _formKey,
          child: new ListView(
            shrinkWrap: true,
            children: <Widget>[
              _showLogo(),
              _showEmailInput(),
              _showPasswordInput(),
              _showPrimaryButton(),
              _showFacebookButton(),
              _showSignUpLabel(),
              _showForgotPasswordLabel(),
              _showErrorMessage(),
            ],
          ),
        ));
  }

  Widget _showErrorMessage() {
    if (_errorMessage.length > 0 && _errorMessage != null) {
      return new Text(
        _errorMessage,
        style: TextStyle(
            fontSize: 13.0,
            color: Colors.red,
            height: 1.0,
            fontWeight: FontWeight.w300),
      );
    } else {
      return new Container(
        height: 0.0,
      );
    }
  }

  Widget _showLogo() {
    return new Hero(
      tag: 'hero',
      child: Padding(
          padding: EdgeInsets.fromLTRB(0.0, 40, 0.0, 0.0),
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
    );

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
    );

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
        onPressed: () {});
  }

  Widget _showFacebookButton() {
    final PetButton button = PetButton(
      onPressed: () => {},
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
    );

    return button;
  }
}
