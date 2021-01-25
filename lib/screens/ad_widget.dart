import 'dart:async';
import 'dart:ui';

import 'package:flutter/material.dart';

class AdWidget extends StatefulWidget {
  AdWidget({Key key}) : super(key: key);

  @override
  _AdWidgetState createState() => _AdWidgetState();
}

class _AdWidgetState extends State<AdWidget> {
  int _adDurationInSec = 5;
  Timer _timer;

  @override
  void initState() {
    super.initState();

    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      if (_adDurationInSec <= 0) {
        _timer.cancel();
        Navigator.pop(context);
      } else
        setState(() {
          _adDurationInSec--;
        });
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return getAd();
  }

  Widget getAd() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text('Ad'),
          Text(
            _adDurationInSec.toString(),
            style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 80,
                color: Colors.orange),
          )
        ],
      ),
    );
  }
}
