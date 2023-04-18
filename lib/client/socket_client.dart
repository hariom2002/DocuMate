import 'dart:io';

import 'package:socket_io_client/socket_io_client.dart' as io;
import 'package:wordonline/constants.dart';

class SocketClient {
  io.Socket? socket;
  static SocketClient? _instance;

  SocketClient._internal() {
    socket = io.io(host, <String, dynamic>{
      'transports': ['websocket'],
      'autoConnect': false
    });
    socket!.connect();
  }

  // static io.Socket get instance {
  //   _instance ??= SocketClient._internal();
  //   return _instance!.socket!;
  // }

  factory SocketClient(){
        _instance ??= SocketClient._internal();
    return _instance!;
  }
}
