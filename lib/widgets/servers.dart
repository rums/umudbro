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
        if (state is ServerLoadListSuccess) {
          final servers = state.servers;
          return ListView.builder(
            itemCount: servers.length,
            itemBuilder: (_, index) {
              final Server server = servers[index];
              return ServerItem(server);
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
