import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:umudbro/blocs/blocs.dart';
import 'package:umudbro/models/models.dart';
import 'package:umudbro/widgets/widgets.dart';

class Servers extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ServersBloc, ServersState>(
      builder: (context, state) {
        if (state is ServersLoadSuccess) {
          final servers = state.servers;
          return ListView.builder(
            itemCount: servers.length,
            itemBuilder: (_, index) {
              final Server server = servers[index];
              return Card(
                  child: PopupMenuButton(
                      onSelected: (value) {
                        if (value == "connect") {
                          BlocProvider.of<ServersBloc>(context)
                            ..add(ServerConnected(
                                Server.from(server, doConnect: true)));
                          Navigator.pop(context);
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
                                Text("Connect"),
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
                          title: Text(
                              "${server.name != null ? "Name: ${server.name}, " : ""}Address: ${server.address}, Port: ${server.port}"))));
            },
          );
        } else {
          BlocProvider.of<ServersBloc>(context).add(ServersLoaded());
        }
        return Card(
          child: Text('Loading...'),
        );
      },
    );
  }
}
