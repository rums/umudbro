import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:umudbro/blocs/blocs.dart';
import 'package:umudbro/models/models.dart';

class Servers extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ServersBloc, ServersState>(
      builder: (context, state) {
        if (state is ServersLoadSuccess) {
          final servers = state.servers;
          return ListView.builder(
            itemCount: servers.length,
            itemBuilder: (context, index) {
              final Server server = servers[index];
              return Card(
                  child: PopupMenuButton(
                      onSelected: (value) {
                        if (value == "delete") {
                          BlocProvider.of<ServersBloc>(context)..add(ServerDeleted(server));
                        }
                      },
                      itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
                        PopupMenuItem<String>(
                          value: "delete",
                          child: Row(children: <Widget>[
                            Icon(Icons.delete),
                            Text("Delete"),
                          ]),
                        )
                      ],
                      child: ListTile(
                          title: Text("Address: ${server.address}, Port: ${server.port}"))));
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
