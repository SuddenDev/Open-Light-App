import 'package:flutter/material.dart';
import 'package:flutter_blue/flutter_blue.dart';

import 'package:open_light_app/screens/wifi_setter.dart';
import 'package:open_light_app/screens/bluetooth_off.dart';

void main() => runApp(OpenLightApp());

class OpenLightApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Wifi Setter Via BLE',
      debugShowCheckedModeBanner: false,
      home: StreamBuilder<BluetoothState>(
          stream: FlutterBlue.instance.state,
          initialData: BluetoothState.unknown,
          builder: (c, snapshot) {
            final state = snapshot.data;
            if (state == BluetoothState.on) {
              return WifiSetter();
            }
            return BluetoothOffScreen(state: state);
          }),
      theme: ThemeData.dark(),
    );
  }
}



