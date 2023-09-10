import 'package:flutter/material.dart';

import 'package:qrcoder/views/screens/scan_screen.dart';
import 'package:qrcoder/views/screens/create_screen.dart';

class TabControllerWrapper extends StatelessWidget {
  const TabControllerWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          toolbarHeight: 0,
          bottom: const TabBar(
            indicatorPadding: EdgeInsets.symmetric(horizontal: 20),
            tabs: <Tab>[
              Tab(text: 'SCAN'),
              Tab(text: 'CREATE'),
            ],
          ),
        ),
        body: const TabBarView(
          children: <Widget>[
            ScanScreen(),
            CreateScreen(),
          ],
        ),
      ),
    );
  }
}
