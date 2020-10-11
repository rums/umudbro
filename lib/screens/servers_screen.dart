import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:umudbro/blocs/blocs.dart';
import 'package:umudbro/repositories/sqlite_umudbro_repository.dart';
import 'package:umudbro/widgets/widgets.dart';

class ServersScreen extends StatefulWidget {
  @override
  _ServersScreenState createState() => _ServersScreenState();
}

class _ServersScreenState extends State<ServersScreen> {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ServersBloc(umudbroRepository: new SqliteUmudbroRepository())..add(ServersLoaded()),
      child: Scaffold(
        appBar: AppBar(
          // Here we take the value from the MyHomePage object that was created by
          // the App.build method, and use it to set our appbar title.
          title: Text("Servers"),
          actions: [
            IconButton(
              icon: Icon(Icons.home),
              onPressed: () {
                Navigator.pushNamed(context, '/'); },
            )
          ],
        ),
        body: Center(
          // Center is a layout widget. It takes a single child and positions it
          // in the middle of the parent.
          child: Servers(),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () async {
            final result = await showDialog<bool>(
              context: context,
              builder: (BuildContext context) {
                return BlocProvider(
                  create: (context) => ServersBloc(umudbroRepository: new SqliteUmudbroRepository())..add(ServersLoaded()),
                  child: AddServer(),
                );
              });
            if (result) {
              setState(() => {});
            }
          },
          tooltip: 'Add server',
          child: Icon(Icons.add),
        ), // This trailing comma makes auto-formatting nicer for build methods.
      ),
    );
  }
}