import 'package:equatable/equatable.dart';

class Server extends Equatable {
  final int id;
  final String address;
  final int port;

  Server({this.id, this.address, this.port});

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'address': address,
      'port': port,
    };
  }

  @override
  List<Object> get props => [id, address, port];
}