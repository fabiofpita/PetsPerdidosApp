import 'dart:async';
import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:petsperdidos/src/model/foundpet.dart';
import 'package:petsperdidos/src/model/lostpet.dart';
import 'package:petsperdidos/src/model/user.dart';
import 'package:petsperdidos/src/pages/mypets_page.dart';
import 'package:shared_preferences/shared_preferences.dart';

abstract class Data {
  Future<void> gravarUsuario(User usuario);

  Future<User> getUsuarioById(String id);

  Future<void> gravarUsuarioLocal(User usuario);

  Future<void> excluirUsuarioLocal();

  Future<User> getUsuarioLogado();

  Future<LostPet> gravarAnimalPerdido(LostPet lostPet);

  Future<FoundPet> gravarAnimalEncontrado(FoundPet foundPet);

  Future<User> adicionarAnimalPerdidoUsuario(User user, LostPet lostPet);

  Future<User> adicionarAnimalEncontradoUsuario(User user, FoundPet foundPet);

  Future<List<LostPet>> buscarAnimaisPerdidos(int inicio);

  Future<List<FoundPet>> buscarAnimaisEncontrados(int inicio);

  Future<List<LostPet>> buscarAnimaisPerdidosByUser(String userId);

  Future<List<FoundPet>> buscarAnimaisEncontradosByUser(String userId);

  Future<void> excluirPet(String petId, TipoAnimal tipoAnimal);
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

    user.lostPets = await buscarAnimaisPerdidosByUser(user.id);
    user.foundedPets = await buscarAnimaisEncontradosByUser(user.id);

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
      JsonCodec codec = new JsonCodec();
      var json = prefs.getString("currentUser");
      var mapa = codec.decode(json);
      User user;

      if (mapa != null) {
        user = new User(
          mapa["nome"],
          mapa["sobrenome"],
          mapa["email"],
          mapa["telefone"],
        );

        user.id = mapa["id"];
        if (mapa["lostPets"] != null) {
          user.lostPets = mapa['lostPets'] as List<LostPet>;
        }

        if (mapa["foundedPets"] != null) {
          user.foundedPets = List<FoundPet>.from(mapa["foundedPets"]);
        }
      }

      return user;
    } catch (error) {
      return null;
    }
  }

  @override
  Future<LostPet> gravarAnimalPerdido(LostPet lostPet) async {
    lostPet.registerDate = DateTime.now();

    DocumentReference doc = await _firestoreInstance
        .collection('animaisPerdidos')
        .add(lostPet.toJson());

    lostPet.id = doc.documentID;

    return lostPet;
  }

  @override
  Future<FoundPet> gravarAnimalEncontrado(FoundPet foundPet) async {
    foundPet.registerDate = DateTime.now();

    DocumentReference doc = await _firestoreInstance
        .collection('animaisEncontrados')
        .add(foundPet.toJson());

    foundPet.id = doc.documentID;

    return foundPet;
  }

  @override
  Future<User> adicionarAnimalPerdidoUsuario(User user, LostPet lostPet) async {
    user.addLostPet(lostPet);

    await _firestoreInstance
        .collection("usuarios")
        .document(user.id)
        .updateData({
      'lostedPets': User.encondeLostedPetsToJson(user.lostPets),
    });

    return user;
  }

  @override
  Future<User> adicionarAnimalEncontradoUsuario(
      User user, FoundPet foundPet) async {
    user.addFoundPet(foundPet);

    await _firestoreInstance
        .collection("usuarios")
        .document(user.id)
        .updateData({
      'foundedPets': User.encondeFoundePetsToJson(user.foundedPets),
    });

    return user;
  }

  @override
  Future<List<FoundPet>> buscarAnimaisEncontrados(int inicio) async {
    List<FoundPet> foundedPets = new List();
    FoundPet _petAux;

    QuerySnapshot querySnapshots = await _firestoreInstance
        .collection("animaisEncontrados")
        .orderBy("registerDate")
        .startAt([inicio])
        .limit(7)
        .getDocuments();

    List<DocumentSnapshot> documents = querySnapshots.documents;

    for (var x = 0; x < documents.length; x++) {
      _petAux = FoundPet.fromJson(documents[x].data);
      _petAux.id = documents[x].documentID;
      foundedPets.add(_petAux);
    }

    return foundedPets;
  }

  @override
  Future<List<LostPet>> buscarAnimaisPerdidos(int inicio) async {
    List<LostPet> lostPets = new List();
    LostPet _petAux;

    QuerySnapshot querySnapshots = await _firestoreInstance
        .collection("animaisPerdidos")
        .orderBy("registerDate")
        .startAt([inicio])
        .limit(7)
        .getDocuments();
    List<DocumentSnapshot> documents = querySnapshots.documents;

    for (var x = 0; x < documents.length; x++) {
      _petAux = LostPet.fromJson(documents[x].data);
      _petAux.id = documents[x].documentID;
      lostPets.add(_petAux);
    }

    return lostPets;
  }

  @override
  Future<List<FoundPet>> buscarAnimaisEncontradosByUser(String userId) async {
    List<FoundPet> foundedPets = new List();
    FoundPet _petAux;

    QuerySnapshot querySnapshots = await _firestoreInstance
        .collection("animaisEncontrados")
        .where("user", isEqualTo: userId)
        .getDocuments();

    List<DocumentSnapshot> documents = querySnapshots.documents;

    for (var x = 0; x < documents.length; x++) {
      _petAux = FoundPet.fromJson(documents[x].data);
      _petAux.id = documents[x].documentID;
      foundedPets.add(_petAux);
    }

    return foundedPets;
  }

  @override
  Future<List<LostPet>> buscarAnimaisPerdidosByUser(String userId) async {
    List<LostPet> lostPets = new List();
    LostPet _petAux;

    QuerySnapshot querySnapshots = await _firestoreInstance
        .collection("animaisPerdidos")
        .where("user", isEqualTo: userId)
        .getDocuments();

    List<DocumentSnapshot> documents = querySnapshots.documents;

    for (var x = 0; x < documents.length; x++) {
      _petAux = LostPet.fromJson(documents[x].data);
      _petAux.id = documents[x].documentID;
      lostPets.add(_petAux);
    }

    return lostPets;
  }

  @override
  Future<void> excluirPet(String petId, TipoAnimal tipoAnimal) async {
    DocumentReference documentReference = _firestoreInstance
        .collection(tipoAnimal == TipoAnimal.encontrado
            ? "animaisEncontrados"
            : "animaisPerdidos")
        .document(petId);
    await Firestore.instance.runTransaction((Transaction myTransaction) async {
      await myTransaction.delete(documentReference);
    });
  }
}
