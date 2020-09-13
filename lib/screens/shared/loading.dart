import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter/material.dart';

const spinkit = Center(
  child: SpinKitRotatingCircle(
    color: Colors.limeAccent,
    size: 50.0,
  ),
);

const spinkit2 = Center(
  child: SpinKitChasingDots(
    color: Colors.limeAccent,
    size: 50.0,
  ),
);

const spinkit3 = Center(
  child: SpinKitDoubleBounce(
    color: Colors.limeAccent,
  ),
);
