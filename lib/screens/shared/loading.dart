import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter/material.dart';

const spinkit = Center(
  child: SpinKitCircle(
    color: Color.fromARGB(255, 248, 90, 44),
    size: 50.0,
  ),
);

const spinkit2 = Center(
  child: SpinKitChasingDots(
    color: Color.fromARGB(255, 248, 90, 44),
    size: 50.0,
  ),
);

const spinkit3 = Center(
  child: SpinKitDoubleBounce(
    color: Color.fromARGB(255, 248, 90, 44),
  ),
);
