import 'package:flutter/material.dart';
import 'package:petsperdidos/src/model/user.dart';
import 'package:petsperdidos/src/pages/login_page.dart';
import 'package:petsperdidos/src/pages/register_foundpet.dart';
import 'package:petsperdidos/src/pages/register_lostpet.dart';
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

class _HomePageState extends State<HomePage> {
  _HomePageState({@required this.userId});
  final String userId;
  User _user;
  final BaseAuth auth = new Auth();
  final Data db = new DataAcess();

  @override
  void initState() {
    this._user = new User("", "", "", "");

    db.getUsuarioLogado().then((user) {
      if (user != null) {
        setState(() {
          this._user = user;
        });
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Pets Perdidos"),
      ),
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
                  _user.nome.substring(0, 1) + _user.sobrenome.substring(0, 1),
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
            ),
            ListTile(
              title: Text("Animais que encontrei"),
              trailing: Icon(Icons.pets),
            ),
          ],
        ),
      ),
      body: Stack(
        children: <Widget>[
          Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Center(
                child: Text("Olá " + _user.nome),
              ),
              Center(
                child: new RaisedButton(
                  onPressed: () {
                    auth.signOut();
                    Navigator.of(context).pushReplacement(
                        MaterialPageRoute(builder: (context) => LoginPage()));
                  },
                  child: Text('Logout'),
                ),
              ),
              Center(
                child: new RaisedButton(
                  onPressed: () {
                    auth.signOut();
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => RegisterLostPet()));
                  },
                  child: Text('Perdido'),
                ),
              ),
              Center(
                child: new RaisedButton(
                  onPressed: () {
                    auth.signOut();
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => RegisterFoundPet()));
                  },
                  child: Text('Encontrado'),
                ),
              )
            ],
          )
        ],
      ),
      backgroundColor: Colors.blue,
    );
  }
}
