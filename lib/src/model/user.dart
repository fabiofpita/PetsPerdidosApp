import 'package:petsperdidos/src/model/foundpet.dart';
import 'package:petsperdidos/src/model/lostpet.dart';

class User {
  String id;
  String nome;
  String sobrenome;
  String email;
  String telefone;
  List<LostPet> lostPets;
  List<FoundPet> foundedPets;

  User(this.nome, this.sobrenome, this.email, this.telefone);

  User.fromJson(Map<String, dynamic> json)
      : id = json['id'] as String,
        nome = json['nome'] as String,
        sobrenome = json['sobrenome'] as String,
        email = json['email'] as String,
        telefone = json['telefone'] as String,
        lostPets = json['lostedPets']
            .map((value) => new LostPet.fromJson(value))
            .toList(),
        foundedPets = json['foundedPets']
            .map((value) => new FoundPet.fromJson(value))
            .toList();

  Map<String, dynamic> toJson() => {
        'id': id,
        'nome': nome,
        'sobrenome': sobrenome,
        'email': email,
        'telefone': telefone,
        'lostedPets': encondeLostedPetsToJson(lostPets),
        'foundedPets': encondeFoundePetsToJson(foundedPets)
      };

  void addLostPet(LostPet lostPet) {
    if (this.lostPets == null) {
      this.lostPets = new List();
    }
    this.lostPets.add(lostPet);
  }

  void addFoundPet(FoundPet foundPet) {
    if (this.foundedPets == null) {
      this.foundedPets = new List();
    }
    this.foundedPets.add(foundPet);
  }

  static List encondeLostedPetsToJson(List<LostPet> list) {
    List jsonList = List();

    if (list != null) {
      list.map((item) => jsonList.add(item.toJson())).toList();
    }

    return jsonList;
  }

  static List encondeFoundePetsToJson(List<FoundPet> list) {
    List jsonList = List();

    if (list != null) {
      list.map((item) => jsonList.add(item.toJson())).toList();
    }

    return jsonList;
  }
}
