import 'package:flutter/material.dart';
import 'package:hidden_drawer_menu/hidden_drawer_menu.dart';
import 'package:umudbro/widgets/add_mud_command.dart';

import 'mud_buttons.dart';

class MudButtonsWithMenu extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SimpleHiddenDrawer(
        menu: Menu(),
        screenSelectedBuilder: (position, controller) {
          Widget screenCurrent;
          switch (position) {
            case 0:
              screenCurrent = MudButtons();
              break;
            case 1:
              screenCurrent = AddMudCommand();
              break;
          }
          return GestureDetector(
            onPanDown: (details) => controller.toggle(),
            child: screenCurrent,
          );
        });
  }
}

class Menu extends StatefulWidget {
  @override
  _MenuState createState() => _MenuState();
}

class _MenuState extends State<Menu> {
  SimpleHiddenDrawerController controller;

  @override
  void didChangeDependencies() {
    controller = SimpleHiddenDrawerController.of(context);
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.maxFinite,
      height: double.maxFinite,
      color: Colors.cyan,
      padding: const EdgeInsets.all(8.0),
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            RaisedButton(
              onPressed: () {
                controller.setSelectedMenuPosition(0);
              },
              child: Text("Show Commands"),
            ),
            RaisedButton(
              onPressed: () {
                controller.setSelectedMenuPosition(1);
              },
              child: Text("Page Settings"),
            )
          ],
        ),
      ),
    );
  }
}
