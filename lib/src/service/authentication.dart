import 'dart:async';
import 'dart:convert';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'package:flutter_facebook_login/flutter_facebook_login.dart';
import 'package:petsperdidos/src/model/user.dart';
import 'package:http/http.dart' as http;

abstract class BaseAuth {
  Future<String> signIn(String email, String password);

  Future<String> signUp(String email, String password);

  Future<FirebaseUser> getCurrentUser();

  Future<void> sendEmailVerification();

  Future<void> signOut();

  Future<bool> isEmailVerified();

  String getAuthenticationError(PlatformException error);

  Future<User> signInWithFacebook();

  Future<void> sendResetPassword(String email);
}

class Auth implements BaseAuth {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final facebookLogin = FacebookLogin();

  Future<String> signIn(String email, String password) async {
    String id = "";
    AuthResult user = await _firebaseAuth.signInWithEmailAndPassword(
        email: email, password: password);

    if (user.user != null) {
      id = user.user.uid;
    }

    return id;
  }

  Future<String> signUp(String email, String password) async {
    String id = "";

    AuthResult user = await _firebaseAuth.createUserWithEmailAndPassword(
        email: email, password: password);

    if (user.user != null) {
      id = user.user.uid;
    }

    return id;
  }

  Future<FirebaseUser> getCurrentUser() async {
    FirebaseUser user = await _firebaseAuth.currentUser();
    return user;
  }

  Future<void> signOut() async {
    return _firebaseAuth.signOut();
  }

  Future<void> sendEmailVerification() async {
    FirebaseUser user = await _firebaseAuth.currentUser();
    user.sendEmailVerification();
  }

  Future<bool> isEmailVerified() async {
    FirebaseUser user = await _firebaseAuth.currentUser();
    return user.isEmailVerified;
  }

  @override
  String getAuthenticationError(PlatformException error) {
    String message = "";

    switch (error.code) {
      case "ERROR_INVALID_EMAIL":
        message = "E-mail ou senha inválido(s)!";
        break;
      case "ERROR_WRONG_PASSWORD":
        message = "E-mail ou senha inválido(s)!";
        break;
      case "ERROR_USER_NOT_FOUND":
        message = "Não existe um usuário cadastrado para o E-mail informado!";
        break;
      case "ERROR_USER_DISABLED":
        message = "Usuário inativado pelos moderadores!";
        break;
      case "ERROR_TOO_MANY_REQUESTS":
        message = "Ocorreu um erro inesperado em nosso sistema!";
        break;
      case "ERROR_OPERATION_NOT_ALLOWED":
        message = "Ocorreu um erro inesperado em nosso sistema!";
        break;
      case "ERROR_INVALID_EMAIL":
        message = "O e-mail informado é inválido!";
        break;
      case "ERROR_EMAIL_ALREADY_IN_USE":
        message = "Já existe um usuário cadastrado para o e-mail informado!";
        break;
      case "ERROR_WEAK_PASSWORD":
        message = "A senha informada é muito fraca!";
        break;
      default:
        message = "Ocorreu um erro inesperado em nosso sistema!";
        break;
    }

    return message;
  }

  Future<User> signInWithFacebook() async {
    final result = await facebookLogin.logInWithReadPermissions(['email']);
    final token = result.accessToken.token;
    final graphResponse = await http.get(
        'https://graph.facebook.com/v2.12/me?fields=name,first_name,last_name,email&access_token=$token');
    final profile = json.decode(graphResponse.body);

    final AuthCredential credential =
        FacebookAuthProvider.getCredential(accessToken: token);

    AuthResult res = await _firebaseAuth.signInWithCredential(credential);

    try {
      User user = new User(
          profile["first_name"], profile["last_name"], profile["email"], "");

      user.id = res.user.uid;

      return user;
    } catch (ex) {
      print(ex);
      return null;
    }
  }

  @override
  Future<void> sendResetPassword(String email) {
    return _firebaseAuth.sendPasswordResetEmail(email: email);
  }
}
