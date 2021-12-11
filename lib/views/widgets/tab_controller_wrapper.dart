import 'package:flutter/material.dart';
import 'package:qrcoder/views/screens/scan_screen.dart';
import 'package:qrcoder/views/screens/create_screen.dart';

class TabControllerWrapper extends StatelessWidget {
  const TabControllerWrapper();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          toolbarHeight: 0,
          bottom: const TabBar(
            indicatorPadding: const EdgeInsets.symmetric(
              horizontal: 20
            ),
            tabs: const <Tab> [
              const Tab(
                text: 'SCAN'
              ),
              const Tab(
                text: 'CREATE'
              )
            ]
          )
        ),
        body: const TabBarView(
          children: const <Widget> [
            const ScanScreen(),
            const CreateScreen()
          ]
        )
      )
    );
  }
}
