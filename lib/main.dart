import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';
import 'Pages/Anime/animes.dart';
import 'notifires/all_provider.dart';
import 'package:flutter/services.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
  runApp(MyApp());
}

final navigatorKey = GlobalKey<NavigatorState>();

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
        create: (context) => AllProvider()..init(),
        child: Sizer(
          builder: (context, orientation, deviceType) => MaterialApp(
            navigatorKey: navigatorKey,
            debugShowCheckedModeBanner: false,
            title: 'malb Beta',
            theme: ThemeData(
              primaryColor: Color(0xff2E51A1),
              accentColor: Color(0xFF8BABF5),
              visualDensity: VisualDensity.adaptivePlatformDensity,
              canvasColor: Colors.white60,
              dividerColor: Color(0xff2E51A1),
            ),
            home: Animes(),
          ),
        ));
  }
}
