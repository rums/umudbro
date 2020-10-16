import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:umudbro/blocs/blocs.dart';
import 'package:umudbro/widgets/widgets.dart';

class ServersScreen extends StatefulWidget {
  @override
  _ServersScreenState createState() => _ServersScreenState();
}

class _ServersScreenState extends State<ServersScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Servers'),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          showDialog(
              context: context,
              builder: (BuildContext context) {
                return AddServer();
              });
        },
        tooltip: 'Add server',
        child: Icon(Icons.add),
      ),
      body: BlocBuilder<ServersBloc, ServersState>(
        builder: (context, state) => Center(
            // Center is a layout widget. It takes a single child and positions it
            // in the middle of the parent.
            child: Servers(),
          ), // This trailing comma makes auto-formatting nicer for build methods.
        ),
      );
  }
}
