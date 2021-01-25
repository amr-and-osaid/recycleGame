import 'package:flutter/material.dart';
import 'package:cleanWise/screens/ad_widget.dart';

class ContinueScreen extends StatefulWidget {
  ContinueScreen({Key key}) : super(key: key);

  @override
  _ContinueScreenState createState() => _ContinueScreenState();
}

class _ContinueScreenState extends State<ContinueScreen> {
  bool _showAd = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        body: SafeArea(
            child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            _showAd
                ? AdWidget()
                : GestureDetector(
                    onTap: () {
                      setState(() {
                        _showAd = true;
                      });
                    },
                    child: Container(
                      padding: EdgeInsets.all(50),
                      child: Image(
                        image: AssetImage('assets/continue.png'),
                      ),
                    )),
          ],
        )));
  }
}
