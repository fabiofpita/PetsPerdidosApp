import 'package:flutter/material.dart';
import 'package:petsperdidos/src/components/pet_alert.dart';
import 'package:petsperdidos/src/components/pet_loading.dart';
import 'package:petsperdidos/src/model/pet.dart';
import 'package:petsperdidos/src/model/user.dart';
import 'package:petsperdidos/src/pages/detail_page.dart';
import 'package:petsperdidos/src/pages/register_foundpet.dart';
import 'package:petsperdidos/src/pages/register_lostpet.dart';
import 'package:petsperdidos/src/service/database.dart';

class MyPetPage extends StatefulWidget {
  final User user;
  final TipoAnimal _tipoAnimal;
  MyPetPage(this.user, this._tipoAnimal);

  @override
  _MyPetPageState createState() => _MyPetPageState(this.user, this._tipoAnimal);
}

enum TipoAnimal { encontrado, perdido }

class _MyPetPageState extends State<MyPetPage> {
  Data _db = DataAcess();
  List<Pet> _pets = [];
  User _user;
  bool _excluding;
  TipoAnimal _tipoAnimal;
  _MyPetPageState(this._user, this._tipoAnimal);

  @override
  void initState() {
    super.initState();
    _listar();
    _excluding = false;
  }

  void _listar() async {
    try {
      if (_tipoAnimal == TipoAnimal.encontrado) {
        _db.buscarAnimaisEncontradosByUser(_user.id).then(
              (foundPets) => setState(() {
                _pets = foundPets;
              }),
            );
      } else {
        _db.buscarAnimaisPerdidosByUser(_user.id).then(
              (lostPets) => setState(() {
                _pets = lostPets;
              }),
            );
      }
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        title: Text(_tipoAnimal == TipoAnimal.encontrado
            ? "Meus animais encontrados"
            : "Meus animais perdidos"),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () {
          MaterialPageRoute route;
          if (_tipoAnimal == TipoAnimal.encontrado) {
            route = MaterialPageRoute(
              builder: (context) => RegisterFoundPet(
                user: _user,
              ),
            );
          } else {
            route = MaterialPageRoute(
              builder: (context) => RegisterLostPet(
                user: _user,
              ),
            );
          }

          Navigator.of(context).pop();
          Navigator.of(context).push(route);
        },
      ),
      body: _excluding == null || !_excluding
          ? Container(
              alignment: Alignment.center,
              child: _pets != null && _pets.length > 0
                  ? ListView.builder(
                      itemCount: _pets.length,
                      itemBuilder: (context, position) {
                        var p = _pets[position];
                        return Card(
                          margin: EdgeInsets.all(6),
                          child: ListTile(
                              title: Text(
                                p.title,
                              ),
                              leading:
                                  p.photoUrl != null && p.photoUrl.isNotEmpty
                                      ? Image.network(
                                          p.photoUrl,
                                          fit: BoxFit.fill,
                                          width: screenSize.width * 15 / 100,
                                        )
                                      : Image.asset(
                                          'assets/sherlock-dog.png',
                                          fit: BoxFit.fill,
                                          width: screenSize.width * 15 / 100,
                                        ),
                              trailing: new Container(
                                child: IconButton(
                                  icon: Icon(Icons.delete),
                                  onPressed: () {
                                    PetAlert.showDeletePetAlert(context,
                                        this._excluirPet, p, _tipoAnimal);
                                  },
                                  color: Colors.blue,
                                ),
                                padding:
                                    new EdgeInsets.fromLTRB(4.0, 4.0, 0, 4.0),
                              ),
                              subtitle: Text(p.description.length >= 40
                                  ? p.description.substring(0, 39) + " ..."
                                  : p.description),
                              onLongPress: () async {
                                PetAlert.showDeletePetAlert(
                                    context, this._excluirPet, p, _tipoAnimal);
                              },
                              onTap: () async {
                                Navigator.of(context).push(new PageRouteBuilder(
                                  pageBuilder: (_, __, ___) => new DetailPage(
                                    pet: p,
                                  ),
                                ));
                              }),
                        );
                      },
                    )
                  : Text(
                      "Nenhum pet cadastrado!",
                      textAlign: TextAlign.justify,
                      style: TextStyle(
                        color: Colors.blue,
                        fontSize: 20,
                      ),
                    ),
            )
          : PetLoading(),
    );
  }

  Future<void> _excluirPet(Pet pet, TipoAnimal tipoAnimal) async {
    setState(() {
      _excluding = true;
    });
    await _db.excluirPet(pet.id, tipoAnimal);
    _pets.remove(pet);

    setState(() {
      _excluding = false;
      _pets = _pets;
    });

    PetAlert.showAlert(
        context, "Pet excluído!", "O Pet foi excluído com sucesso!");
  }
}
