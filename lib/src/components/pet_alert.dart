import 'package:flutter/material.dart';
import 'package:petsperdidos/src/components/pet_textbox.dart';
import 'package:petsperdidos/src/service/authentication.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

class PetAlert {
  static BaseAuth auth = new Auth();

  static showAlert(
    BuildContext context,
    String title,
    String message, {
    AlertType alertType = AlertType.error,
    bool isCloseButton = false,
    Color titleColor = Colors.red,
    VoidCallback onPressed,
    Duration duration = const Duration(microseconds: 500),
  }) {
    var alertStyle = AlertStyle(
      animationType: AnimationType.grow,
      isCloseButton: isCloseButton,
      isOverlayTapDismiss: true,
      descStyle: TextStyle(fontWeight: FontWeight.w500, fontSize: 17),
      animationDuration: duration,
      alertBorder: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
        side: BorderSide(
          color: Colors.black,
        ),
      ),
      titleStyle: TextStyle(
        color: titleColor,
      ),
    );

    Alert(
      context: context,
      style: alertStyle,
      type: alertType,
      title: title,
      desc: message,
      buttons: [
        DialogButton(
          child: Text(
            "OK",
            style: TextStyle(color: Colors.white, fontSize: 20),
          ),
          onPressed:
              onPressed == null ? () => Navigator.pop(context) : onPressed,
          color: Colors.blue,
          radius: BorderRadius.circular(10),
        ),
      ],
    ).show();
  }

  static showForgotPasswordAlert(BuildContext context) {
    String _email;

    var alertStyle = AlertStyle(
      animationType: AnimationType.grow,
      isCloseButton: true,
      descStyle: TextStyle(fontWeight: FontWeight.w500, fontSize: 17),
      animationDuration: Duration(milliseconds: 500),
      alertBorder: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
        side: BorderSide(
          color: Colors.black,
        ),
      ),
      titleStyle: TextStyle(
        color: Color.fromRGBO(26, 5, 178, 1),
      ),
      constraints: BoxConstraints.expand(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width),
    );

    Alert(
        context: context,
        type: AlertType.none,
        desc:
            "Insira seu e-mail cadastrado para redefinição da senha de sua conta!",
        title: "Esqueci minha senha",
        style: alertStyle,
        content: Column(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.fromLTRB(0.0, 10, 0.0, 0.0),
              child: PetTextBox(
                width: MediaQuery.of(context).size.width,
                height: 60,
                prefixIcon: Icon(Icons.email, color: Colors.blue),
                inputType: TextInputType.emailAddress,
                backgroundColor: Colors.white,
                placeholder: 'E-mail',
                textColor: Colors.black,
                cornerRadius: BorderRadius.circular(5),
                margin: EdgeInsets.fromLTRB(5, 0, 5, 0),
                onChanged: (text) => _email = text,
                fontSize: 12,
              ),
            ),
          ],
        ),
        buttons: [
          DialogButton(
            onPressed: () {
              if (_email != null && _email.isNotEmpty && validarEmail(_email)) {
                auth.sendResetPassword(_email);
                Navigator.of(context).pop();
                PetAlert.showAlert(
                  context,
                  "Redefina sua senha!",
                  "Foi enviado um e-mail para " +
                      _email +
                      " para a redefinição de sua senha!",
                  alertType: AlertType.info,
                  titleColor: Colors.blue,
                  duration: Duration(microseconds: 800),
                );
              } else {
                Navigator.of(context).pop();
                PetAlert.showAlert(
                  context,
                  "E-Mail incorreto!",
                  "O E-mail informado é inválido!",
                );
              }
            },
            child: Text(
              "Enviar",
              style: TextStyle(color: Colors.white, fontSize: 20),
            ),
            color: Colors.blue,
          )
        ]).show();
  }

  static bool validarEmail(String email) {
    bool emailValid =
        RegExp(r"^[a-zA-Z0-9.]+@[a-zA-Z0-9]+\.[a-zA-Z]+").hasMatch(email);
    return emailValid;
  }
}
