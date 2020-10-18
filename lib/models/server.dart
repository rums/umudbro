import 'dart:convert';

import 'package:equatable/equatable.dart';

import 'models.dart';

class Server extends Equatable {
  final int id;
  final String name;
  final String address;
  final int port;
  final int doConnect;
  final List<BufferItem> buffer;

  Server(
      {this.id,
      this.name,
      this.address,
      this.port,
      this.doConnect,
      this.buffer});

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'address': address,
      'port': port,
      'do_connect': doConnect,
      'buffer': buffer != null ? json.encode(buffer) : null,
    };
  }

  static Server from(Server server, {name, address, port, doConnect, buffer}) {
    return new Server(
      id: server.id,
      name: name ?? server.name,
      address: address ?? server.address,
      port: port ?? server.port,
      doConnect: doConnect ?? server.doConnect,
      buffer: buffer ?? server.buffer,
    );
  }

  static Server fromMap(Map<String, dynamic> map) {
    return new Server(
      id: map['id'],
      name: map['name'],
      address: map['address'],
      port: map['port'],
      doConnect: map['do_connect'],
      buffer: (json.decode(map['buffer']) as List).map((i) => BufferItem.fromJson(BufferItemType.fromString(i['itemType']), i)).toList(),
    );
  }

  @override
  List<Object> get props => [id, name, address, port, doConnect, buffer];
}
