// @dart=2.9
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

import 'package:qrcoder/themes/themes.dart';
import 'package:qrcoder/views/widgets/tab_controller_wrapper.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load();
  MobileAds.instance.initialize();

  runApp(const App());
}

class App extends StatelessWidget {
  const App();

  void dismissKeyboard(BuildContext context) {
    FocusScope.of(context).requestFocus(FocusNode());
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(
        statusBarIconBrightness: Brightness.light,
        statusBarColor: const Color(0xFFC00C00),
        systemNavigationBarColor: const Color(0xFFC00C00),
      ),
    );
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);

    return MaterialApp(
      title: 'Qr Coder',
      theme: Dark().theme,
      home: DefaultTabController(
        length: 2,
        child: GestureDetector(
          onTap: () => dismissKeyboard(context),
          child: const TabControllerWrapper(),
        ),
      ),
    );
  }
}
