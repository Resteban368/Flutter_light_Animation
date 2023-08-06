// ignore_for_file: avoid_print

import 'package:flutter/material.dart';
import 'package:light_bulb_animation/wire.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool islighton = true;
  Offset initialPosition = const Offset(40, 387);

  Offset switchPosition = const Offset(40, 550);

  Offset finalPosition = const Offset(40, 400);
  double lightlength = 0;
  @override
  void didChangeDependencies() {
    initialPosition = const Offset(40, 387);
    finalPosition = const Offset(40, 600);

    if (islighton) {
      switchPosition = const Offset(40, 500);
    } else {
      switchPosition = const Offset(40, 650);
    }
    super.didChangeDependencies();
  }

  void _onDragUpdate(Offset details) {
    if (details.dy < 550) {
      setState(() {
        switchPosition = Offset(40, details.dy);
        islighton = !islighton;
        lightlength = 0;
      });
    } else {
      setState(() {
        islighton = !islighton;
        lightlength = 260;

        switchPosition = Offset(40, details.dy);

        if (details.dy > 700) {
          switchPosition = const Offset(40, 700);
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: const Color(0xff374151),
      body: Stack(
        fit: StackFit.expand,
        children: [
          Container(
            color: Colors.transparent,
            alignment: Alignment.centerLeft,
            child: Stack(
              children: [
                Positioned(
                  top: 100,
                  left: 0,
                  child: Image.asset(
                    "assets/lampara.png",
                    fit: BoxFit.cover,
                    height: 400,
                    width: 300,
                  ),
                ),
                Positioned(
                  top: 320,
                  right: 55,
                  child: ClipPath(
                    clipper: MySpotLightClipper(),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 100),
                      decoration: BoxDecoration(
                        color: Colors.amber,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      height: lightlength,
                      width: 150,
                    ),
                  ),
                ),
                const Positioned(
                    top: 550,
                    right: 78,
                    child: Text(
                      'Baneste Codes',
                      style: TextStyle(
                          color:
                              Color(0xff374151),
                          fontSize: 15),
                    ))
              ],
            ),
          ),
          Wire(
            initialPosition: initialPosition,
            toOffset: switchPosition,
          ),
          AnimatedPositioned(
            duration: const Duration(microseconds: 10),
            top: switchPosition.dy - size.width * 0.1 / 2,
            left: switchPosition.dx - size.width * 0.1 / 2,
            child: Draggable(
              feedback: Container(
                  height: size.height * .1,
                  width: size.width * .1,
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                  )),
              onDragUpdate: (details) {
                print('local position ${details.localPosition}');
                _onDragUpdate(details.localPosition);
              },
              child: Container(
                height: size.height * .1,
                width: size.width * .1,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.white, width: 3),
                  color: Colors.amber,
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}

class MySpotLightClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    Path path = Path();

    path.moveTo(size.width / 2 - 20, 0);
    path.lineTo(0, size.height);
    path.lineTo(size.width, size.height);
    path.lineTo(size.width / 2 + 25, 0);

    path.close();
    return path;
  }

  /// this must be true
  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) => true;
}
