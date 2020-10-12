import 'package:equatable/equatable.dart';

class Server extends Equatable {
  final int id;
  final String name;
  final String address;
  final int port;
  final bool doConnect;

  Server({this.id, this.name, this.address, this.port, this.doConnect});

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'address': address,
      'port': port,
      'do_connect': doConnect,
    };
  }

  static Server from(Server server, {name, address, port, doConnect}) {
    return new Server(
        id: server.id,
        name: name ?? server.name,
        address: address ?? server.address,
        port: port ?? server.port,
        doConnect: doConnect ?? server.doConnect);
  }

  static Server fromMap(Map<String, dynamic> map) {
    return new Server(
      id: map['id'],
      name: map['name'],
      address: map['address'],
      port: map['port'],
      doConnect: map['do_connect'],
    );
  }

  @override
  List<Object> get props => [id, name, address, port, doConnect];
}
