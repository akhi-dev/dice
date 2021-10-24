import 'dart:async';
import 'dart:ui';
import 'package:flutter/services.dart';

import 'fire.dart';
import 'goat.dart';
import 'leaf.dart';
import 'package:flutter/material.dart';

class GoatPage extends StatefulWidget {
  const GoatPage({Key? key}) : super(key: key);

  @override
  _GoatPageState createState() => _GoatPageState();
}

class _GoatPageState extends State<GoatPage> {
  static double goatX = 0;
  static double goatY = 1;
  double leafX = 0.7;
  double leafY = 1;
  double goatNomoSize = 75;
  double time = 0;
  double height = 0;
  double initalHeight = goatY;

  String direction = "right";
  static bool holding = false;

  void eatLeaf() {
    if ((goatX - leafX).abs() < 0.05 && (goatY - leafY).abs() < 0.05) {
      setState(() {
        leafX = 2;
        goatNomoSize = 1.5 * goatNomoSize;
      });
    }
  }

  bool userHoldButton() {
    return holding;
  }

  void beforeJump() {
    time = 0;
    initalHeight = goatY;
  }

  void jump() {
    beforeJump();
    Timer.periodic(Duration(microseconds: 50), (timer) {
      time += 0.05;
      height = -4.9 * time * time + 5 * time;

      if (initalHeight - height > 1) {
        setState(() {
          goatY = 1;
        });
        timer.cancel();
      } else {
        setState(() {
          goatY = initalHeight - height;
        });
      }
    });
  }

  void moveLeft() {
    direction = "left";

    Timer.periodic(Duration(milliseconds: 50), (timer) {
      eatLeaf();
      if (userHoldButton() == true && (goatX - 0.02) > -1) {
        setState(() {
          goatX -= 0.02;
        });
      } else {
        timer.cancel();
      }
    });
  }

  void moveRight() {
    direction = "right";

    Timer.periodic(Duration(milliseconds: 50), (timer) {
      eatLeaf();
      if (userHoldButton() == true && (goatX + 0.02) < 1) {
        setState(() {
          goatX += 0.02;
        });
      } else {
        timer.cancel();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
      DeviceOrientation.portraitDown,
      DeviceOrientation.portraitUp
    ]);

    return Scaffold(
      body: Column(children: [
        Expanded(
            flex: 4,
            child: Stack(
              children: [
                Container(
                  color: Colors.pink,
                  child: AnimatedContainer(
                    alignment: Alignment(goatX, goatY),
                    duration: Duration(milliseconds: 0),
                    child: Goat(direction, goatNomoSize),
                  ),
                ),
                Container(
                  alignment: Alignment(0.3, 0),
                  child: Fire(),
                ),
                Container(
                  alignment: Alignment(leafX, leafY),
                  child: Leaf(),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 25.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Column(
                        children: [
                          Text(
                            "GOAT LEVEL",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                            ),
                          ),
                          Text(
                            "00",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                            ),
                          ),
                        ],
                      ),
                      Column(
                        children: [
                          Text(
                            "DRIFT LEVEL",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                            ),
                          ),
                          Text(
                            "111",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                            ),
                          )
                        ],
                      ),
                      Column(
                        children: [
                          Text(
                            "TIME",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                            ),
                          ),
                          Text(
                            "00001",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                            ),
                          )
                        ],
                      ),
                    ],
                  ),
                )
              ],
            )),
        Expanded(
            flex: 1,
            child: Container(
              color: Colors.brown,
              child: Row(
                mainAxisAlignment: MainAxisAlignment
                    .spaceEvenly, //this is the one that gave padding betweeen the containers
                children: [
                  Expanded(
                    child: GestureDetector(
                      // onTap: moveLeft,

                      onTapDown: (details) {
                        holding = true;
                        moveLeft();
                      },
                      onTapUp: (details) {
                        holding = false;
                      },
                      child: Container(
                        padding: EdgeInsets.all(10),
                        color: Colors.white70,
                        child: Icon(Icons.arrow_back),
                      ),
                    ),
                  ),
                  Expanded(
                    child: GestureDetector(
                      onTap: jump,
                      child: Container(
                          padding: EdgeInsets.all(6),
                          color: Colors.white54,
                          child: Icon(Icons.arrow_upward)),
                    ),
                  ),
                  Expanded(
                    child: GestureDetector(
                      // onTap: moveRight,
                      onTapDown: (details) {
                        holding = true;
                        moveRight();
                      },
                      onTapUp: (details) {
                        holding = false;
                      },
                      child: Container(
                        padding: EdgeInsets.all(9),
                        color: Colors.white,
                        child: Icon(
                          Icons.arrow_forward,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ))
      ]),
    );
  }
}
