import 'package:flutter/material.dart';
import 'package:petsperdidos/src/components/pet_loading.dart';
import 'package:petsperdidos/src/model/user.dart';
import 'package:petsperdidos/src/pages/foundpet_page.dart';
import 'package:petsperdidos/src/pages/login_page.dart';
import 'package:petsperdidos/src/pages/lostpets_page.dart';
import 'package:petsperdidos/src/pages/mypets_page.dart';
import 'package:petsperdidos/src/pages/userProfile_page.dart';

import 'package:petsperdidos/src/service/authentication.dart';
import 'package:petsperdidos/src/service/database.dart';

class HomePage extends StatefulWidget {
  HomePage({Key key, this.auth, this.userId, this.onSignedOut})
      : super(key: key);

  final BaseAuth auth;
  final VoidCallback onSignedOut;
  final String userId;

  @override
  State<StatefulWidget> createState() =>
      new _HomePageState(userId: this.userId);
}

class _HomePageState extends State<HomePage>
    with SingleTickerProviderStateMixin {
  _HomePageState({@required this.userId});
  final String userId;
  User _user;
  final BaseAuth auth = new Auth();
  final Data db = new DataAcess();
  int _cIndex = 0;
  String tabName;
  List<Widget> _children = [];

  @override
  void initState() {
    this._user = new User("", "", "", "");

    db.getUsuarioLogado().then((user) {
      this._user = user;
      setState(() {
        this._children = [
          LostPetsPage(
            user: this._user,
          ),
          FoundPetsPage(
            user: this._user,
          ),
        ];
      });
    });

    tabName = "Animais Perdidos";

    super.initState();
  }

  void _incrementTab(index) {
    setState(() {
      _cIndex = index;
      tabName = index == 0 ? "Animais Perdidos" : "Animais Encontrados";
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(tabName),
      ),
      body: _children == null || _children.isEmpty
          ? Container(
              color: Colors.white,
              child: PetLoading(),
            )
          : _children[_cIndex],
      drawer: Drawer(
        child: ListView(
          children: <Widget>[
            UserAccountsDrawerHeader(
              accountName: Text(_user.nome),
              accountEmail: Text(_user.email),
              currentAccountPicture: CircleAvatar(
                backgroundColor:
                    Theme.of(context).platform == TargetPlatform.iOS
                        ? Colors.blue
                        : Colors.white,
                child: Text(
                  _user != null &&
                          _user.nome.isNotEmpty &&
                          _user.sobrenome.isNotEmpty
                      ? _user.nome.substring(0, 1) +
                          _user.sobrenome.substring(0, 1)
                      : "",
                  style: TextStyle(fontSize: 40.0),
                ),
              ),
            ),
            ListTile(
              title: Text("Meus dados"),
              trailing: Icon(Icons.account_box),
              onTap: () {
                Navigator.of(context).pop();
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => UserProfilePage(
                      user: _user,
                    ),
                  ),
                );
              },
            ),
            ListTile(
              title: Text("Meus animais perdidos"),
              trailing: Icon(Icons.pets),
              onTap: () {
                Navigator.of(context).pop();
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) =>
                        MyPetPage(this._user, TipoAnimal.perdido),
                  ),
                );
              },
            ),
            ListTile(
              title: Text("Animais que encontrei"),
              trailing: Icon(Icons.pets),
              onTap: () {
                Navigator.of(context).pop();
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) =>
                        MyPetPage(_user, TipoAnimal.encontrado),
                  ),
                );
              },
            ),
            ListTile(
                title: Text("Sair"),
                trailing: Icon(Icons.exit_to_app),
                onTap: () {
                  Navigator.of(context).pop();
                  new Auth().signOut();
                  Navigator.of(context).pushReplacement(
                    MaterialPageRoute(builder: (context) => LoginPage()),
                  );
                })
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _cIndex,
        items: [
          BottomNavigationBarItem(
              icon: Icon(Icons.search),
              title: new Text(
                'Animais perdidos',
              ),
              backgroundColor: Colors.white),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.priority_high,
            ),
            title: new Text(
              'Animais encontrados',
            ),
            backgroundColor: Colors.white,
          ),
        ],
        backgroundColor: Colors.blue,
        selectedLabelStyle: TextStyle(color: Colors.white),
        selectedItemColor: Colors.white,
        unselectedItemColor: Colors.white54,
        showUnselectedLabels: true,
        onTap: (index) {
          _incrementTab(index);
        },
      ),
    );
  }
}
