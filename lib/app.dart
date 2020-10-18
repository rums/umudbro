import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'blocs/blocs.dart';
import 'repositories/repositories.dart';
import 'screens/screens.dart';

class MyApp extends StatefulWidget {
  // This widget is the root of your application.
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  UmudbroRepository _umudbroRepository;
  ServersBloc _serversBloc;
  TerminalBloc _terminalBloc;
  MudCommandsBloc _mudCommandsBloc;

  @override
  void initState() {
    _umudbroRepository = new SqliteUmudbroRepository();
    _serversBloc = ServersBloc(umudbroRepository: _umudbroRepository);
    _mudCommandsBloc = MudCommandsBloc(MudCommandsInitial(), umudbroRepository: _umudbroRepository);
    _terminalBloc = TerminalBloc(_serversBloc);
    _serversBloc.getDefaultServer().then((server) {
      if (server != null) {
        _terminalBloc.add(TerminalStarted(server: server));
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<ServersBloc>(
          create: (context) => _serversBloc,
        ),
        BlocProvider<MudCommandsBloc>(
          create: (context) => _mudCommandsBloc,
        ),
        BlocProvider<TerminalBloc>(
          create: (context) => _terminalBloc,
        ),
      ],
      child: MaterialApp(
          title: 'umudbro',
          theme: ThemeData(
            primarySwatch: Colors.blue,
            visualDensity: VisualDensity.adaptivePlatformDensity,
          ),
          initialRoute: "/",
          routes: {
            '/':(context) => HomeScreen(title: 'umudbro',),
            '/servers': (context) => BlocProvider.value(
                  value: _serversBloc,
                  child: ServersScreen(),
                )
          }),
    );
  }
}
