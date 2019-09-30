import 'dart:async';
import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:petsperdidos/src/model/foundpet.dart';
import 'package:petsperdidos/src/model/lostpet.dart';
import 'package:petsperdidos/src/model/user.dart';
import 'package:shared_preferences/shared_preferences.dart';

abstract class Data {
  Future<void> gravarUsuario(User usuario);

  Future<User> getUsuarioById(String id);

  Future<void> gravarUsuarioLocal(User usuario);

  Future<void> excluirUsuarioLocal();

  Future<User> getUsuarioLogado();

  Future<void> gravarAnimalPerdido(LostPet lostPet);

  Future<void> gravarAnimalEncontrado(FoundPet foundPet);
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

  @override
  Future<void> gravarUsuarioLocal(User usuario) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    prefs.setString("currentUser", jsonEncode(usuario));
  }

  @override
  Future<void> excluirUsuarioLocal() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    prefs.remove("currentUser");
  }

  @override
  Future<User> getUsuarioLogado() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    try {
      Map<String, dynamic> mapa = json.decode(prefs.getString("currentUser"));
      User user;

      if (mapa != null) {
        user = new User(
          mapa["nome"],
          mapa["sobrenome"],
          mapa["email"],
          mapa["telefone"],
        );

        user.id = mapa["id"];
      }

      return user;
    } catch (error) {
      return null;
    }
  }

  @override
  Future<void> gravarAnimalPerdido(LostPet lostPet) async {
    await _firestoreInstance.collection('animaisPerdidos').add({
      'titulo': lostPet.title,
      'descricao': lostPet.description,
      'tipo': lostPet.type,
      'raca': lostPet.breed,
      'nome': lostPet.name,
      'cor': lostPet.color,
      'recompensa': lostPet.reward,
      'ultimoLocalVisto': lostPet.lastAdress,
      'latitudeUltimoLocal': lostPet.latitudeLastAdress,
      'longitudeUltimoLocal': lostPet.longitudeLastAdress,
      'foto': lostPet.photoUrl
    });
  }

  @override
  Future<void> gravarAnimalEncontrado(FoundPet foundPet) async {
    await _firestoreInstance
        .collection('animaisEncontrados')
        .document()
        .setData({
      'titulo': foundPet.title,
      'descricao': foundPet.description,
      'tipo': foundPet.type,
      'raca': foundPet.breed,
      'cor': foundPet.color,
      'ultimoLocalVisto': foundPet.lastAdress,
      'latitudeUltimoLocal': foundPet.latitudeLastAdress,
      'longitudeUltimoLocal': foundPet.longitudeLastAdress,
      'foto': foundPet.photoUrl
    });
  }
}
