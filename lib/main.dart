import 'dart:async';
import 'dart:convert' show utf8, json;


import 'package:flutter/material.dart';
import 'package:flutter_blue/flutter_blue.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Wifi Setter Via BLE',
      debugShowCheckedModeBanner: false,
      home: WifiSetter(),
      theme: ThemeData.dark(),
    );
  }
}

class WifiSetter extends StatefulWidget {
  @override
  _WifiSetterState createState() => _WifiSetterState();
}

class _WifiSetterState extends State<WifiSetter> {
  final String SERVICE_UUID = "4fafc201-1fb5-459e-8fcc-c5c9c331914b";
  final String CHARACTERISTIC_UUID = "beb5483e-36e1-4688-b7f5-ea07361b26a8";
  final String TARGET_DEVICE_NAME = "Open Light SSSL";

  FlutterBlue flutterBlue = FlutterBlue.instance;
  StreamSubscription<ScanResult> scanSubscription;

  BluetoothDevice targetDevice;
  BluetoothCharacteristic targetCharacteristic;

  String connectionText = "";
  String wifiString;
  Map<String, dynamic> wifiMap;

  Stream<List<int>> streamFromBle;

  @override
  void initState() {
    super.initState();
    startScan();
  }

  // start scan for BLE
  startScan() {
    setState(() {
      connectionText = "Start Scanning";
    });

    scanSubscription = flutterBlue.scan().listen((scanResult) {
      print(scanResult.device.name);
      if (scanResult.device.name.contains(TARGET_DEVICE_NAME)) {
        stopScan();

        setState(() {
          connectionText = "Found Target Device";
        });

        targetDevice = scanResult.device;
        connectToDevice();
      }
    }, onDone: () => stopScan());
  }

  // stop scanning
  stopScan() {
    scanSubscription?.cancel();
    scanSubscription = null;
  }

  // connect to device
  connectToDevice() async {
    if (targetDevice == null) {
      return;
    }

    setState(() {
      connectionText = "Device Connecting";
    });

    await targetDevice.connect();

    setState(() {
      connectionText = "Device Connected";
    });

    discoverServices();
  }

  // disconnect from device
  disconnectFromDeivce() {
    if (targetDevice == null) {
      return;
    }

    targetDevice.disconnect();

    setState(() {
      connectionText = "Device Disconnected";
    });
  }

  // discover services and connect to pre-defined service if available
  discoverServices() async {
    if (targetDevice == null) {
      return;
    }

    List<BluetoothService> services = await targetDevice.discoverServices();
    services.forEach((service) {
      if (service.uuid.toString() == SERVICE_UUID) {
        service.characteristics.forEach((characteristics) {
          if (characteristics.uuid.toString() == CHARACTERISTIC_UUID) {
            targetCharacteristic = characteristics;
            setState(() {
              connectionText = "All Ready with ${targetDevice.name}";
            });

            targetCharacteristic.setNotifyValue(true);          
            streamFromBle = targetCharacteristic.value;
            streamFromBle.listen((data) {
              if(data != null && data.isNotEmpty) {
                //print(utf8.decode(data));
                mapWiFiNetworks(data);
              }
            });
          }
        });
      }
    });
  }

  // create and update WiFiMap 
  mapWiFiNetworks(List<int> data) {
    String currentString = utf8.decode(data);

    if(currentString == "@@start@@") {
      setState(() {
        wifiString = "";
      });
      return;
    } else if(currentString  == "@@end@@") {
      setState(() {
        wifiMap = json.decode(wifiString);
      });
    } else {
      setState(() {
        wifiString = wifiString + currentString;
      });
    }
  }



  writeData(String data) async {
    if (targetCharacteristic == null) return;

    List<int> bytes = utf8.encode(data);
    await targetCharacteristic.write(bytes);
  }

  @override
  void dispose() {
    super.dispose();
    stopScan();
  }

  submitAction() {
    var wifiData = '${wifiNameController.text},${wifiPasswordController.text}';
    writeData(wifiData);
  }

  TextEditingController wifiNameController = TextEditingController();
  TextEditingController wifiPasswordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(connectionText),
      ),
      body: Container(
          child: targetCharacteristic == null
              ? Center(
                  child: Text(
                    "Waiting...",
                    style: TextStyle(fontSize: 34, color: Colors.red),
                  ),
                )
              : Column(
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.all(16),
                      child: TextField(
                        controller: wifiNameController,
                        decoration: InputDecoration(labelText: 'Wifi Name'),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(16),
                      child: TextField(
                        controller: wifiPasswordController,
                        decoration: InputDecoration(labelText: 'Wifi Password'),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(16),
                      child: RaisedButton(
                        onPressed: submitAction,
                        color: Colors.indigoAccent,
                        child: Text('Submit'),
                      ),
                    )
                  ],
                )),
    );
  }
}
