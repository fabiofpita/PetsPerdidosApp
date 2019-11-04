import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:petsperdidos/src/model/pet.dart';
import 'package:petsperdidos/src/model/user.dart';
import 'package:petsperdidos/src/service/database.dart';
import 'package:share/share.dart';
import 'package:url_launcher/url_launcher.dart';

class DetailPage extends StatefulWidget {
  final DecorationImage type;
  final Pet pet;
  const DetailPage({Key key, this.type, @required this.pet}) : super(key: key);
  @override
  _DetailPageState createState() => new _DetailPageState(type: type, pet: pet);
}

enum AppBarBehavior { normal, pinned, floating, snapping }
enum TipoPet { perdido, encontrado }

class _DetailPageState extends State<DetailPage> with TickerProviderStateMixin {
  AnimationController _containerController;
  Animation<double> width;
  Animation<double> heigth;
  DecorationImage type;
  Pet pet;
  _DetailPageState({this.type, this.pet});

  double screenWidth;
  double screenHeigth;

  double _appBarHeight = 256.0;
  AppBarBehavior _appBarBehavior = AppBarBehavior.pinned;

  void initState() {
    _containerController = new AnimationController(
        duration: new Duration(milliseconds: 2000), vsync: this);
    super.initState();
    width = new Tween<double>(
      begin: 200.0,
      end: 220.0,
    ).animate(
      new CurvedAnimation(
        parent: _containerController,
        curve: Curves.ease,
      ),
    );
    heigth = new Tween<double>(
      begin: 400.0,
      end: 400.0,
    ).animate(
      new CurvedAnimation(
        parent: _containerController,
        curve: Curves.ease,
      ),
    );
    heigth.addListener(() {
      setState(() {
        if (heigth.isCompleted) {}
      });
    });
    _containerController.forward();
  }

  @override
  void dispose() {
    _containerController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    screenWidth = MediaQuery.of(context).size.width;
    timeDilation = 0.7;
    //print("detail");
    return new Theme(
      data: new ThemeData(
        brightness: Brightness.light,
        primaryColor: Colors.blue,
        platform: Theme.of(context).platform,
      ),
      child: new Container(
        width: width.value,
        height: heigth.value,
        color: Colors.blue,
        child: new Hero(
          tag: "img",
          child: new Card(
            color: Colors.transparent,
            child: new Container(
              alignment: Alignment.center,
              width: width.value,
              height: heigth.value,
              decoration: new BoxDecoration(
                color: Colors.white,
                borderRadius: new BorderRadius.circular(10.0),
              ),
              child: new Stack(
                alignment: AlignmentDirectional.bottomCenter,
                children: <Widget>[
                  new CustomScrollView(
                    shrinkWrap: false,
                    slivers: <Widget>[
                      new SliverAppBar(
                        elevation: 0.0,
                        forceElevated: true,
                        leading: new IconButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          icon: new Icon(
                            Icons.arrow_back,
                            color: Colors.cyan,
                            size: 30.0,
                          ),
                        ),
                        expandedHeight: _appBarHeight,
                        pinned: _appBarBehavior == AppBarBehavior.pinned,
                        floating: _appBarBehavior == AppBarBehavior.floating ||
                            _appBarBehavior == AppBarBehavior.snapping,
                        snap: _appBarBehavior == AppBarBehavior.snapping,
                        flexibleSpace: new FlexibleSpaceBar(
                          background: new Stack(
                            fit: StackFit.expand,
                            children: <Widget>[
                              new Container(
                                width: width.value,
                                height: _appBarHeight,
                                decoration: new BoxDecoration(
                                  image: new DecorationImage(
                                    image: (pet.photoUrl == null ||
                                            pet.photoUrl.isEmpty)
                                        ? new ExactAssetImage(
                                            'assets/sherlock-dog.png')
                                        : new NetworkImage(pet.photoUrl),
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      new SliverList(
                        delegate: new SliverChildListDelegate(
                          <Widget>[
                            new Container(
                              color: Colors.white,
                              child: new Padding(
                                padding: const EdgeInsets.all(35.0),
                                child: new Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    new Padding(
                                      padding: const EdgeInsets.only(
                                          top: 0, bottom: 14.0),
                                      child: new Text(
                                        pet.title,
                                        style: new TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 18,
                                        ),
                                        textAlign: TextAlign.center,
                                      ),
                                    ),
                                    new Text(
                                      pet.description,
                                    ),
                                    new Container(
                                      margin: new EdgeInsets.only(top: 25.0),
                                      padding: new EdgeInsets.only(
                                        bottom: 10.0,
                                      ),
                                      height: 300,
                                      width: screenWidth,
                                      decoration: new BoxDecoration(
                                        color: Colors.white,
                                        border: new Border(
                                          top: new BorderSide(
                                              color: Colors.black12),
                                        ),
                                      ),
                                      child: new Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: <Widget>[
                                          SizedBox(
                                            height: 20,
                                          ),
                                          new Text(
                                            "Visto por último em: " +
                                                pet.lastAdress,
                                            style: new TextStyle(
                                                fontWeight: FontWeight.bold),
                                          ),
                                          SizedBox(
                                            height: 10,
                                          ),
                                          new Text(
                                            pet.type != null &&
                                                    pet.type.isNotEmpty
                                                ? "Tipo de animal: " + pet.type
                                                : "",
                                            style: new TextStyle(
                                                fontWeight: FontWeight.bold),
                                          ),
                                          SizedBox(
                                            height: pet.type != null &&
                                                    pet.type.isNotEmpty
                                                ? 10
                                                : 0,
                                          ),
                                          new Text(
                                            pet.breed != null &&
                                                    pet.breed.isNotEmpty
                                                ? "Raça: " + pet.breed
                                                : "",
                                            style: new TextStyle(
                                                fontWeight: FontWeight.bold),
                                          ),
                                          SizedBox(
                                            height: 10,
                                          ),
                                          new Text(
                                            pet.color != null &&
                                                    pet.color.isNotEmpty
                                                ? "Cor predominante: " +
                                                    pet.color
                                                : "",
                                            style: new TextStyle(
                                                fontWeight: FontWeight.bold),
                                          ),
                                          SizedBox(
                                            height: 10,
                                          ),
                                          new Text(
                                            pet.reward != null &&
                                                    !pet.reward.isNaN
                                                ? "Recompensa: " +
                                                    pet.reward.toString()
                                                : "",
                                            style: new TextStyle(
                                                fontWeight: FontWeight.bold),
                                          ),
                                          SizedBox(
                                            height: pet.reward != null &&
                                                    !pet.reward.isNaN
                                                ? 10
                                                : 0,
                                          ),
                                          new Text(
                                            pet.name != null &&
                                                    pet.name.isNotEmpty
                                                ? "Atende pelo nome de: " +
                                                    pet.name
                                                : "",
                                            style: new TextStyle(
                                                fontWeight: FontWeight.bold),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  new Container(
                    width: 600.0,
                    height: 80.0,
                    decoration: new BoxDecoration(
                      color: Colors.blueAccent[100],
                    ),
                    alignment: Alignment.center,
                    child: new Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: <Widget>[
                        new FlatButton(
                          padding: new EdgeInsets.all(0.0),
                          onPressed: () {
                            String textShare = "";
                            textShare += pet.title + "\n";
                            textShare += pet.description + "\n";
                            textShare +=
                                pet.photoUrl.isNotEmpty && pet.photoUrl != null
                                    ? "Você viu esse " +
                                        pet.type +
                                        "?\n" +
                                        pet.photoUrl
                                    : "";
                            textShare +=
                                "Se souber de alguma informação, por favor nos repasse!";
                            Share.share(textShare);
                          },
                          child: new Container(
                            height: 60.0,
                            width: 150,
                            alignment: Alignment.center,
                            decoration: new BoxDecoration(
                              color: Colors.orange,
                              borderRadius: new BorderRadius.circular(60.0),
                            ),
                            child: new Text(
                              "Ajude compartilhando!",
                              style: new TextStyle(color: Colors.white),
                            ),
                          ),
                        ),
                        new FlatButton(
                          padding: new EdgeInsets.all(0.0),
                          onPressed: () async {
                            Data db = DataAcess();
                            User user = await db.getUsuarioById(pet.user);
                            if (user != null && user.telefone != null) {
                              launch('tel:' + user.telefone);
                            }
                          },
                          child: new Container(
                            height: 60.0,
                            width: 150,
                            alignment: Alignment.center,
                            decoration: new BoxDecoration(
                              color: Colors.green,
                              borderRadius: new BorderRadius.circular(60.0),
                            ),
                            child: new Text(
                              "Contatar anunciante!",
                              style: new TextStyle(color: Colors.white),
                            ),
                          ),
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
