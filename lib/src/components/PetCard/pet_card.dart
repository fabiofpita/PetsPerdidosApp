import 'dart:math';

import 'package:flutter/material.dart';
import 'package:petsperdidos/src/pages/detail_page.dart';

Positioned petCard(
    DecorationImage img,
    double bottom,
    double right,
    double left,
    double cardWidth,
    double rotation,
    double skew,
    BuildContext context,
    Function dismissImg,
    int flag,
    Function addImg,
    Function swipeRight,
    Function swipeLeft) {
  Size screenSize = MediaQuery.of(context).size;
  return Positioned(
    bottom: 20,
    right: flag == 0 ? right != 0.0 ? right : null : null,
    left: flag == 1 ? right != 0.0 ? right : null : null,
    child: Dismissible(
      key: Key(Random().toString()),
      crossAxisEndOffset: -0.3,
      onDismissed: (DismissDirection direction) {
        if (direction == DismissDirection.endToStart)
          dismissImg(img);
        else
          addImg(img);
      },
      child: Transform(
        alignment: flag == 0 ? Alignment.bottomRight : Alignment.bottomLeft,
        transform: Matrix4.skewX(skew),
        child: RotationTransition(
          turns: AlwaysStoppedAnimation(
              flag == 0 ? rotation / 360 : -rotation / 360),
          child: Hero(
            tag: "img",
            child: GestureDetector(
              onTap: () {
                Navigator.of(context).push(new PageRouteBuilder(
                  pageBuilder: (_, __, ___) => new DetailPage(type: img),
                ));
              },
              child: Card(
                color: Colors.transparent,
                elevation: 4.0,
                child: Container(
                  alignment: Alignment.center,
                  width: screenSize.width - (screenSize.width * 0.1),
                  height: screenSize.height - 180,
                  decoration: BoxDecoration(
                    color: Colors.blueAccent[100],
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  child: Column(
                    children: <Widget>[
                      Container(
                        alignment: Alignment.center,
                        child: Text(
                          "12345678901234567890123456789012345678901234567890",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 17,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 0.5,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        margin: EdgeInsets.fromLTRB(3, 10, 3, 10),
                      ),
                      Container(
                        width: screenSize.width / 1.2 + cardWidth,
                        height: screenSize.height / 2.2,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(8.0),
                              topRight: Radius.circular(8.0)),
                          image: img,
                        ),
                      ),
                      Container(
                        height: 45,
                        child: Text(
                          "Lorem ipsum",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 15,
                            letterSpacing: 0.5,
                          ),
                        ),
                        margin: EdgeInsets.fromLTRB(0, 10, 0, 2),
                      ),
                      Container(
                        width: screenSize.width / 1.2 + cardWidth,
                        alignment: Alignment.center,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: <Widget>[
                            FlatButton(
                                padding: EdgeInsets.all(0.0),
                                onPressed: () {
                                  swipeLeft();
                                },
                                child: Container(
                                  height: 40.0,
                                  width: 130.0,
                                  alignment: Alignment.center,
                                  decoration: BoxDecoration(
                                    color: Colors.red,
                                    borderRadius: BorderRadius.circular(60.0),
                                  ),
                                  child: Text(
                                    "Não conheço :(",
                                    style: TextStyle(color: Colors.white),
                                  ),
                                )),
                            FlatButton(
                                padding: EdgeInsets.all(0.0),
                                onPressed: () {
                                  swipeRight();
                                },
                                child: Container(
                                  height: 40.0,
                                  width: 130.0,
                                  alignment: Alignment.center,
                                  decoration: BoxDecoration(
                                    color: Colors.blue,
                                    borderRadius: BorderRadius.circular(60.0),
                                  ),
                                  child: Text(
                                    "Conheço esse Pet!",
                                    style: TextStyle(color: Colors.white),
                                  ),
                                ))
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    ),
  );
}
