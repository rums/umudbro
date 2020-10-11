import 'package:equatable/equatable.dart';

class Server extends Equatable {
  final int id;
  final String name;
  final String address;
  final int port;

  Server({this.id, this.name, this.address, this.port});

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'address': address,
      'port': port,
    };
  }

  @override
  List<Object> get props => [id, name, address, port];
}