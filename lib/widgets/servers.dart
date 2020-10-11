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
              return Text("Address: ${server.address}, Port: ${server.port}");
            },
          );
        }
        else {
          BlocProvider.of<ServersBloc>(context).add(ServersLoaded());
        }
        return Card(child: Text('Loading...'),);
      },
    );
  }
}
