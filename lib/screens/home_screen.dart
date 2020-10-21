import 'package:convex_bottom_bar/convex_bottom_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:umudbro/blocs/blocs.dart';
import 'package:umudbro/widgets/widgets.dart';

class HomeScreen extends StatefulWidget {
  HomeScreen({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String getTitle(state) => state is TerminalConnectSuccess
      ? "${widget.title}: ${state.server.name}"
      : widget.title;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TerminalBloc, TerminalState>(
      builder: (context, state) => Scaffold(
        bottomNavigationBar: ConvexAppBar(
          initialActiveIndex: 1,
          items: [
            TabItem(icon: Icons.toggle_off, title: 'Overlays'),
            TabItem(
                icon: state is TerminalConnectSuccess && state.showOverlay
                    ? Icons.toggle_on
                    : Icons.toggle_off,
                title: 'Buttons'),
            TabItem(icon: Icons.toggle_on, title: 'Settings'),
          ],
          onTap: (int i) {
            switch (i) {
              case 0:
              case 1:
                BlocProvider.of<TerminalBloc>(context)
                    .add(TerminalToggleOverlay());
                break;
            }
          },
        ),
        appBar: AppBar(
          title: Text(getTitle(state)),
          actions: [
            IconButton(
              icon: Icon(Icons.list),
              onPressed: () {
                Navigator.pushNamed(context, '/servers');
              },
            )
          ],
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              TerminalStack(),
            ],
          ),
        ),
      ),
    );
  }
}
