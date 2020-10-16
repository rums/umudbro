import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:umudbro/blocs/blocs.dart';
import 'package:umudbro/models/models.dart';
import 'package:umudbro/widgets/widgets.dart';

class ServerItem extends StatelessWidget {
  final Server server;

  const ServerItem(this.server);

  @override
  Widget build(BuildContext context) {
    return Card(
        child: PopupMenuButton(
            onSelected: (value) {
              if (value == "connect") {
                BlocProvider.of<ServersBloc>(context)
                  ..add(ServerConnected(
                      Server.from(server, doConnect: 1)));
                Navigator.pop(context);
              } else if (value == "disconnect") {
                BlocProvider.of<ServersBloc>(context)
                  ..add(ServerDisconnected(
                      Server.from(server, doConnect: 0)));
              } else if (value == "edit") {
                showDialog(
                    context: context,
                    builder: (_) {
                      return BlocProvider.value(
                        value: BlocProvider.of<ServersBloc>(context),
                        child:
                        AddServer(editing: true, server: server),
                      );
                    });
              } else if (value == "delete") {
                BlocProvider.of<ServersBloc>(context)
                  ..add(ServerDeleted(server));
              }
            },
            itemBuilder: (BuildContext context) =>
            <PopupMenuEntry<String>>[
              PopupMenuItem<String>(
                value: "connect",
                child: Row(children: <Widget>[
                  Icon(Icons.play_arrow),
                  Text(
                    "Connect",
                    style: TextStyle(color: Colors.blue),
                  ),
                ]),
              ),
              PopupMenuItem<String>(
                value: "disconnect",
                child: Row(children: <Widget>[
                  Icon(Icons.stop),
                  Text(
                    "Disconnect",
                    style: TextStyle(color: Colors.red),
                  ),
                ]),
              ),
              PopupMenuItem<String>(
                value: "edit",
                child: Row(children: <Widget>[
                  Icon(Icons.edit),
                  Text("Edit"),
                ]),
              ),
              PopupMenuItem<String>(
                  value: "delete",
                  child: Row(children: <Widget>[
                    Icon(Icons.delete),
                    Text("Delete"),
                  ])),
            ],
            child: ListTile(
                title: Text(server.name))));
  }
}
