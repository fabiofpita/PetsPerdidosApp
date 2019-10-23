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

  Future<LostPet> gravarAnimalPerdido(LostPet lostPet);

  Future<FoundPet> gravarAnimalEncontrado(FoundPet foundPet);

  Future<User> adicionarAnimalPerdidoUsuario(User user, LostPet lostPet);

  Future<User> adicionarAnimalEncontradoUsuario(User user, FoundPet foundPet);

  Future<List<LostPet>> buscarAnimaisPerdidos();

  Future<List<FoundPet>> buscarAnimaisEncontrados();
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
      }

      return user;
    } catch (error) {
      return null;
    }
  }

  @override
  Future<LostPet> gravarAnimalPerdido(LostPet lostPet) async {
    DocumentReference doc =
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
      'foto': lostPet.photoUrl,
      'user': lostPet.user
    });

    lostPet.id = doc.documentID;

    return lostPet;
  }

  @override
  Future<FoundPet> gravarAnimalEncontrado(FoundPet foundPet) async {
    DocumentReference doc =
        await _firestoreInstance.collection('animaisEncontrados').add({
      'titulo': foundPet.title,
      'descricao': foundPet.description,
      'tipo': foundPet.type,
      'raca': foundPet.breed,
      'cor': foundPet.color,
      'ultimoLocalVisto': foundPet.lastAdress,
      'latitudeUltimoLocal': foundPet.latitudeLastAdress,
      'longitudeUltimoLocal': foundPet.longitudeLastAdress,
      'foto': foundPet.photoUrl,
      'user': foundPet.user,
    });

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
  Future<List<FoundPet>> buscarAnimaisEncontrados() async {
    List<FoundPet> foundedPets = new List();
    FoundPet _petAux;

    CollectionReference collectionReference =
        _firestoreInstance.collection("animaisEncontrados");

    QuerySnapshot querySnapshots = await collectionReference.getDocuments();
    List<DocumentSnapshot> documents = querySnapshots.documents;

    for (var x = 0; x < documents.length; x++) {
      _petAux = FoundPet.fromJson(documents[x].data);

      foundedPets.add(_petAux);
    }

    return foundedPets;
  }

  @override
  Future<List<LostPet>> buscarAnimaisPerdidos() async {
    List<LostPet> lostPets = new List();
    LostPet _petAux;

    CollectionReference collectionReference =
        _firestoreInstance.collection("animaisPerdidos");

    QuerySnapshot querySnapshots = await collectionReference.getDocuments();
    List<DocumentSnapshot> documents = querySnapshots.documents;

    for (var x = 0; x < documents.length; x++) {
      _petAux = LostPet.fromJson(documents[x].data);

      lostPets.add(_petAux);
    }

    return lostPets;
  }
}
