import 'package:socket_io_client/socket_io_client.dart';
import 'package:wordonline/client/socket_client.dart';
import 'package:wordonline/constants.dart';

class SocketRepository {
  final _socketClient = SocketClient();
  // Socket get socketClient => _socketClient;

  void joinRoom(String documentId) {
    try {
      _socketClient.socket!.emit('join', documentId);
      customPrint('came here at joinRoom');
    } catch (e) {
      customPrint("here is the error from socket repository");
      customPrint(e.toString());
    }
  }

  void typing(Map<String, dynamic> data) {
    _socketClient.socket!.emit('typing', data);
  }

  void autoSave(Map<String, dynamic> data) {
    _socketClient.socket!.emit('save', data);
  }

  void changeListner(Function(Map<String, dynamic>) fun) {
    _socketClient.socket!.on('changes', (data) => fun(data));
  }
}
