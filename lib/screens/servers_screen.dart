import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:umudbro/blocs/blocs.dart';
import 'package:umudbro/repositories/sqlite_umudbro_repository.dart';
import 'package:umudbro/widgets/widgets.dart';

class ServersScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ServersBloc(umudbroRepository: new SqliteUmudbroRepository())..add(ServersLoaded()),
      child: Servers(),
    );
  }
}
