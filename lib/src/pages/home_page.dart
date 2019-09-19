import 'package:flutter/material.dart';
import 'package:petsperdidos/src/model/user.dart';
import 'package:petsperdidos/src/pages/login_page.dart';

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

    db.getUsuarioById(this.userId).then((user) {
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
            ],
          )
        ],
      ),
      backgroundColor: Colors.blue,
    );
  }
}
