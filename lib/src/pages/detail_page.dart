import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

class DetailPage extends StatefulWidget {
  final DecorationImage type;
  const DetailPage({Key key, this.type}) : super(key: key);
  @override
  _DetailPageState createState() => new _DetailPageState(type: type);
}

enum AppBarBehavior { normal, pinned, floating, snapping }

class _DetailPageState extends State<DetailPage> with TickerProviderStateMixin {
  AnimationController _containerController;
  Animation<double> width;
  Animation<double> heigth;
  DecorationImage type;
  _DetailPageState({this.type});

  double screenWidth;
  double screenHeigth;

  List data = [
    DecorationImage(
      image: ExactAssetImage('assets/sherlock-dog.png'),
      fit: BoxFit.cover,
    ),
    DecorationImage(
      image: NetworkImage(
          "https://www.medicalnewstoday.com/content/images/articles/322/322868/golden-retriever-puppy.jpg"),
      fit: BoxFit.cover,
    ),
    DecorationImage(
      image: NetworkImage(
          'https://www.nationalgeographic.com/content/dam/animals/thumbs/rights-exempt/mammals/d/domestic-dog_thumb.jpg'),
      fit: BoxFit.cover,
    ),
  ];
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
    int img = data.indexOf(type);
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
                                  image: data[img],
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
                                        "Animal encontrado próximo ao IFSP",
                                        style: new TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 18,
                                        ),
                                        textAlign: TextAlign.center,
                                      ),
                                    ),
                                    new Text(
                                      "Animal encontrado próximo ao IFSP. Bem dócil, com coleira. Está dentro do campus aos cuidados do pessoal da administração.",
                                    ),
                                    new Container(
                                      margin: new EdgeInsets.only(top: 25.0),
                                      padding: new EdgeInsets.only(
                                        bottom: 10.0,
                                      ),
                                      height: 60.0,
                                      width: screenWidth,
                                      decoration: new BoxDecoration(
                                        color: Colors.white,
                                        border: new Border(
                                          top: new BorderSide(
                                              color: Colors.black12),
                                        ),
                                      ),
                                      child: new Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceEvenly,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: <Widget>[
                                          new Text(
                                            "Encontrado em",
                                            style: new TextStyle(
                                                fontWeight: FontWeight.bold),
                                          ),
                                        ],
                                      ),
                                    ),
                                    new Container(
                                      margin: new EdgeInsets.only(top: 10.0),
                                      padding: new EdgeInsets.only(
                                        bottom: 10.0,
                                      ),
                                      width: screenWidth,
                                      height: 150,
                                      decoration: new BoxDecoration(
                                        color: Colors.white,
                                        border: new Border(
                                          top: new BorderSide(
                                              color: Colors.black12),
                                        ),
                                      ),
                                      child: new Column(
                                        children: <Widget>[
                                          SizedBox(
                                            height: 10,
                                          ),
                                          new Text(
                                            "Mais informações",
                                            style: new TextStyle(
                                              fontWeight: FontWeight.bold,
                                            ),
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
                          onPressed: () {},
                          child: new Container(
                            height: 60.0,
                            width: 300.0,
                            alignment: Alignment.center,
                            decoration: new BoxDecoration(
                              color: Colors.orange,
                              borderRadius: new BorderRadius.circular(60.0),
                            ),
                            child: new Text(
                              "Não conhece? Ajude compartilhando!",
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
