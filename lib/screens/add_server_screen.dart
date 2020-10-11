import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:umudbro/blocs/servers/servers.dart';
import 'package:umudbro/widgets/widgets.dart';

class AddServerScreen extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ServersBloc, ServersState>(
        builder: (context, state) {
          return AddServer();
        });
  }
}