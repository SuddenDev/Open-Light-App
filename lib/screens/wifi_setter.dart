import 'dart:async';
import 'dart:convert' show utf8, json;

import 'package:flutter/material.dart';
import 'package:flutter_blue/flutter_blue.dart';
import 'package:loading/indicator/line_scale_pulse_out_indicator.dart';
import 'package:loading/loading.dart';



class WifiSetter extends StatefulWidget {
  @override
  _WifiSetterState createState() => _WifiSetterState();
}

class _WifiSetterState extends State<WifiSetter> {
    
  final String serviceUUID = "4fafc201-1fb5-459e-8fcc-c5c9c331914b";
  final String characteristicUUID = "beb5483e-36e1-4688-b7f5-ea07361b26a8";
  final String targetDeviceName = "aline";

  FlutterBlue flutterBlue = FlutterBlue.instance;
  StreamSubscription<ScanResult> scanSubscription;

  BluetoothDevice targetDevice;
  BluetoothCharacteristic targetCharacteristic;
  BluetoothDeviceState targetDeviceState;

  List connectionTexts = [
    "Searching for your light",
    "Did you plug your aline in?",
    "Still looking..."
  ];
  String connectionText = "";
  bool gotJson = false;

  String wifiString;
  Map<String, dynamic> wifiMap;
  Stream<List<int>> streamFromBle;

  @override
  void initState() {
    super.initState();
    startScan();
  }



  void _deviceStateSubscription() {
    targetDevice.state.listen((s) {
      setState(() {
        targetDeviceState = s;
      });
    });
  }

  /// Start scan for BLE
  void startScan() {

     // TODO: ADD TIMER FOR THE TEXT SWAP
    
    scanSubscription = flutterBlue.scan().listen((scanResult) {
      // print('scanning...');

      if (scanResult.device.name.contains(targetDeviceName)) {
        stopScan();

        targetDevice = scanResult.device;

        // Check device state
        _deviceStateSubscription();
        connectToDevice();
      }
    }, onDone: () => stopScan());
  }

  /// Stop scanning
  void stopScan() {
    scanSubscription?.cancel();
    scanSubscription = null;
  }

  /// Connect to device
  void connectToDevice() async {
    if (targetDevice == null) {
      return;
    }

    if(targetDeviceState != BluetoothDeviceState.connected) {
      await targetDevice.connect();
    }

    discoverServices();
  }

  /// Disconnect from device
  void disconnectFromDevice() {
    if (targetDevice == null) {
      return;
    }

    targetDevice.disconnect();
  }

  /// Discover services and connect to pre-defined service if available
  void discoverServices() async {
    if (targetDevice == null) {
      return;
    }

    List<BluetoothService> services = await targetDevice.discoverServices();
    services.forEach((service) {
      if (service.uuid.toString() == serviceUUID) {
        service.characteristics.forEach((characteristics) {
          if (characteristics.uuid.toString() == characteristicUUID) {
            targetCharacteristic = characteristics;
            
            // Getting wifi networks 
            targetCharacteristic.setNotifyValue(true);          
            streamFromBle = targetCharacteristic.value;
            streamFromBle.listen((data) {
              if(data != null && data.isNotEmpty) {
                mapWiFiNetworks(data);
              }
            });
          }
        });
      }
    });
  }

  // create and update WiFiMap 
  void mapWiFiNetworks(List<int> data) {
    String currentString = utf8.decode(data);

    if(currentString == "@@start@@") {
      setState(() {
        wifiString = "";
      });
      return;
    } else if(currentString  == "@@end@@") {
      setState(() {
        wifiMap = json.decode(wifiString);
        gotJson = true;
      });
    } else {
      setState(() {
        wifiString = wifiString + currentString;
      });
    }
  }



  void writeData(String data) async {
    if (targetCharacteristic == null) return;

    List<int> bytes = utf8.encode(data);
    await targetCharacteristic.write(bytes);
  }

  @override
  void dispose() {
    super.dispose();
    stopScan();
  }

  void submitAction() {
    var wifiData = '${wifiNameController.text},${wifiPasswordController.text}';
    writeData(wifiData);
  }

  TextEditingController wifiNameController = TextEditingController();
  TextEditingController wifiPasswordController = TextEditingController();

  @override
  Widget build(BuildContext context) {

    print(targetDeviceState);

    return Scaffold(
      appBar: PreferredSize(
          preferredSize: Size.fromHeight(120.0),
          child: Container(
              child: Padding(
                  padding: EdgeInsets.only(top: 56.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Image.asset(
                        'assets/logo_a_light.png',
                        fit: BoxFit.contain,
                        height: 40,
                      ),
                    ],
                  )),
            ),
        ),
      body: Container(
          margin: EdgeInsets.only(
            top: 100.0
          ),
          child: targetDeviceState == BluetoothDeviceState.connected
              ? ListView.builder(
                itemCount: gotJson ? wifiMap["networks"].length : 0 ,
                itemBuilder: (BuildContext context, int index) {
                    
                  if(!gotJson) {
                    return SearchingForBluetooth();
                  }

                  print(wifiMap["networks"][index]["ssid"]);

                  return GestureDetector(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: <Widget>[
                          Text(wifiMap["networks"][index]["ssid"]),
                          Text(wifiMap["networks"][index]["rssi"].toString()),
                          Text(wifiMap["networks"][index]["encryption"].toString()),
                        ],
                      ),
                    );
                 
                },
              )
              : SearchingForBluetooth()
        ),
    );

  }
}

class SearchingForBluetooth extends StatelessWidget {
  const SearchingForBluetooth({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 200.0,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Center(
            child: Loading(
              indicator: LineScalePulseOutIndicator(),
              size: 80.0,
              color: Theme.of(context).primaryColorLight,
            ),
          ),
          SizedBox(height: 20.0 ),
          Text(
            "Searching for your light",
            style: Theme.of(context).textTheme.title,
          )
        ],
      ),
    );
  }
}


/*
 Column(
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
                )
                */

                