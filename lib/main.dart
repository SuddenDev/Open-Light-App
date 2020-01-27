import 'package:flutter/material.dart';
//import 'package:flutter_blue/flutter_blue.dart';

// import 'package:open_light_app/screens/wifi_setter.dart';
// import 'package:open_light_app/screens/bluetooth_off.dart';
import 'package:open_light_app/screens/home/home.dart';

void main() => runApp(OpenLightApp());

class OpenLightApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Wifi Setter Via BLE',
      debugShowCheckedModeBanner: false,
     
      home: Home(),
       /*StreamBuilder<BluetoothState>(
          stream: FlutterBlue.instance.state,
          initialData: BluetoothState.unknown,
          builder: (c, snapshot) {
            final state = snapshot.data;
            if (state == BluetoothState.on) {
              return WifiSetter();
            }
            return BluetoothOffScreen(state: state);
          }),*/
      theme: ThemeData(
        primaryColor: Colors.blueGrey[100],
        accentColor: new Color(0xffFFBE61),
        scaffoldBackgroundColor: Colors.blueGrey[200],
      ),
      darkTheme: ThemeData.dark().copyWith(
        primaryColor: Colors.grey[850],
        accentColor: new Color(0xffFFBE61),
        scaffoldBackgroundColor: Colors.grey[900],
      )
    );
  }
}



