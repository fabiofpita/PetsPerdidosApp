import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/widgets.dart';
import 'package:petsperdidos/src/components/PetCard/pet_card.dart';
import 'package:petsperdidos/src/components/PetCard/pet_dummyCard.dart';
import 'package:petsperdidos/src/model/lostpet.dart';
import 'package:petsperdidos/src/model/user.dart';
import 'package:petsperdidos/src/service/database.dart';

class LostPetsPage extends StatefulWidget {
  final User user;

  const LostPetsPage({Key key, @required this.user}) : super(key: key);

  @override
  State<StatefulWidget> createState() =>
      new _LostPetsPageState(user: this.user);
}

class _LostPetsPageState extends State<LostPetsPage>
    with TickerProviderStateMixin {
  _LostPetsPageState({@required this.user});

  Data db = new DataAcess();

  final User user;
  int flag = 0;

  AnimationController _buttonController;
  Animation<double> rotate;
  Animation<double> right;
  Animation<double> bottom;
  Animation<double> width;

  List<DecorationImage> data = [];
  List selectedData = [];

  void initState() {
    super.initState();

    _buttonController = AnimationController(
        duration: Duration(milliseconds: 1000), vsync: this);

    rotate = Tween<double>(
      begin: -0.0,
      end: -40.0,
    ).animate(
      CurvedAnimation(
        parent: _buttonController,
        curve: Curves.ease,
      ),
    );
    rotate.addListener(() {
      setState(() {
        if (rotate.isCompleted) {
          var i = data.removeLast();
          data.insert(0, i);

          _buttonController.reset();
        }
      });
    });

    right = Tween<double>(
      begin: 0.0,
      end: 400.0,
    ).animate(
      new CurvedAnimation(
        parent: _buttonController,
        curve: Curves.ease,
      ),
    );
    bottom = Tween<double>(
      begin: 15.0,
      end: 100.0,
    ).animate(
      CurvedAnimation(
        parent: _buttonController,
        curve: Curves.ease,
      ),
    );
    width = Tween<double>(
      begin: 20.0,
      end: 25.0,
    ).animate(
      CurvedAnimation(
        parent: _buttonController,
        curve: Curves.bounceOut,
      ),
    );

    buildCards();
  }

  @override
  void dispose() {
    _buttonController.dispose();
    super.dispose();
  }

  Future<Null> _swipeAnimation() async {
    try {
      await _buttonController.forward();
    } on TickerCanceled {}
  }

  dismissImg(DecorationImage img) {
    setState(() {
      data.remove(img);
    });
  }

  addImg(DecorationImage img) {
    setState(() {
      data.remove(img);
      selectedData.add(img);
    });
  }

  swipeRight() {
    if (flag == 0)
      setState(() {
        flag = 1;
      });
    _swipeAnimation();
  }

  swipeLeft() {
    if (flag == 1)
      setState(() {
        flag = 0;
      });
    _swipeAnimation();
  }

  Future<List<LostPet>> findLostPets() async {
    return await db.buscarAnimaisPerdidos();
  }

  buildCards() async {
    List<LostPet> foundedPets = await findLostPets();
    List<DecorationImage> cards = new List<DecorationImage>();

    foundedPets.forEach(
      (pet) => cards.add(
        new DecorationImage(
          image: (pet.photoUrl == null || pet.photoUrl.isEmpty)
              ? new ExactAssetImage('assets/sherlock-dog.png')
              : new NetworkImage(pet.photoUrl),
          fit: BoxFit.cover,
        ),
      ),
    );

    setState(() {
      data = cards;
    });
  }

  @override
  Widget build(BuildContext context) {
    timeDilation = 0.4;

    var dataLength = data.length;

    return Scaffold(
      body: Container(
        color: Colors.white,
        alignment: Alignment.center,
        child: dataLength > 0
            ? new Stack(
                alignment: AlignmentDirectional.center,
                overflow: Overflow.visible,
                children: getCards(),
              )
            : Align(
                alignment: Alignment.center,
                child: Text("Nenhum pet encontrado!",
                    style: TextStyle(color: Colors.blue, fontSize: 20)),
              ),
      ),
    );
  }

  List<Widget> getCards() {
    List<Widget> cards = new List<Widget>();
    var dataLength = data.length;
    double initialBottom = 15.0;
    double backCardPosition = initialBottom + (dataLength - 1) * 10 + 10;
    double backCardWidth = -10.0;

    for (var x = 0; x < 4; x++) {
      if (x == 3) {
        cards.add(petCard(
            data[x],
            bottom.value,
            right.value,
            0.0,
            backCardWidth + 10,
            rotate.value,
            rotate.value < -10 ? 0.1 : 0.0,
            context,
            dismissImg,
            flag,
            addImg,
            swipeRight,
            swipeLeft));
      } else {
        backCardPosition = backCardPosition - 10;
        backCardWidth = backCardWidth + 10;

        cards.add(petCardDummy(data[x], backCardPosition, 0.0, 0.0,
            backCardWidth, 0.0, 0.0, context));
      }
    }

    return cards;
  }
}
