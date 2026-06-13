import 'dart:io';

void main() async {
  // ignore: avoid_print
  print('Connecting to Websocket...');
  final socket = await WebSocket.connect('wss://stream.binance.us:9443/ws/btcusdt@trade');
  // ignore: avoid_print
  print('Connected! Waiting for events...');
  
  socket.listen((event) {
    // ignore: avoid_print
    print('Received: $event');
    socket.close();
  });
}
