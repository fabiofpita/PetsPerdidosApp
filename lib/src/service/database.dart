import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:petsperdidos/src/model/user.dart';

abstract class Data {
  Future<void> gravarUsuario(User usuario);

  Future<User> getUsuarioById(String id);
}

class DataAcess implements Data {
  final Firestore _firestoreInstance = Firestore.instance;

  Future<void> gravarUsuario(User usuario) async {
    await _firestoreInstance
        .collection('usuarios')
        .document(usuario.id)
        .setData({
      'email': usuario.email,
      'nome': usuario.nome,
      'sobrenome': usuario.sobrenome,
      'telefone': usuario.telefone
    });
  }

  @override
  Future<User> getUsuarioById(String id) async {
    User user;

    DocumentReference documentReference =
        _firestoreInstance.collection("usuarios").document(id);

    DocumentSnapshot snapshot =
        await documentReference.get(source: Source.serverAndCache);

    if (snapshot.data != null) {
      user = new User(snapshot.data['nome'], snapshot.data['sobrenome'],
          snapshot.data['email'], snapshot.data['telefone']);
    }

    user.id = id;

    return user;
  }
}
