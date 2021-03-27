import 'package:recycle_game/app_data.dart';
import 'package:recycle_game/screens/slogan_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:package_info/package_info.dart';

void main() async {
  // debugPaintSizeEnabled = true;
  WidgetsFlutterBinding.ensureInitialized();
  PackageInfo packageInfo = await PackageInfo.fromPlatform();
  AppData.appVersion = packageInfo.version;
  runApp(App());
}

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
          brightness: Brightness.light,
          primaryColor: Colors.lightBlue[800],
          accentColor: Colors.cyan[600],
          fontFamily: 'tajawal'),
      builder: (context, child) {
        return MediaQuery(
          data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
          child: Directionality(
            textDirection: TextDirection.rtl,
            child: child,
          ),
        );
      },
      home: SloganScreen(),
    );
  }
}
