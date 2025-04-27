import 'package:intl/intl.dart';
import 'package:pos_ticket/firebase.dart';
import 'package:pos_ticket/screens/add_category.dart';
import 'package:pos_ticket/screens/add_item.dart';
import 'package:pos_ticket/screens/pos_screen.dart';
import 'package:pos_ticket/utils/shared_preferences_helper.dart';
import 'package:pos_ticket/utils/utils.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'package:blue_thermal_printer/blue_thermal_printer.dart';
import 'package:flutter/services.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => new _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  BlueThermalPrinter bluetooth = BlueThermalPrinter.instance;
  List<BluetoothDevice> _devices = [];
  bool _connected = false;

  @override
  void initState() {
    super.initState();
    initPlatformState();
  }

  Future<void> initPlatformState() async {
    List<BluetoothDevice> devices = [];
    try {
      devices = await bluetooth.getBondedDevices();
    } on PlatformException {}

    bluetooth.onStateChanged().listen((state) {
      switch (state) {
        case BlueThermalPrinter.CONNECTED:
          setState(() {
            _connected = true;
            print("---------bluetooth device state: connected--------");
          });
          break;
        case BlueThermalPrinter.DISCONNECTED:
          setState(() {
            _connected = false;
            print("bluetooth device state: disconnected");
          });
          Navigator.of(context).pushAndRemoveUntil(
              MaterialPageRoute(builder: (context) => HomeScreen()),
              (route) => false);

          break;
        case BlueThermalPrinter.DISCONNECT_REQUESTED:
          setState(() {
            _connected = false;
            print("bluetooth device state: disconnect requested");
          });
          break;
        case BlueThermalPrinter.STATE_TURNING_OFF:
          setState(() {
            _connected = false;
            print("bluetooth device state: bluetooth turning off");
          });
          break;
        case BlueThermalPrinter.STATE_OFF:
          setState(() {
            _connected = false;
            print("bluetooth device state: bluetooth off");
          });

          break;
        case BlueThermalPrinter.STATE_ON:
          setState(() {
            //  _connected = false;
            print("bluetooth device state: bluetooth on");
          });
          break;
        case BlueThermalPrinter.STATE_TURNING_ON:
          setState(() {
            _connected = false;
            print("bluetooth device state: bluetooth turning on");
          });
          break;
        case BlueThermalPrinter.ERROR:
          setState(() {
            _connected = false;
            print("bluetooth device state: error");
          });
          break;
        default:
          print(state);
          break;
      }
    });

    if (!mounted) return;
    setState(() {
      _devices = devices;
    });

    connectToTermalPrinter();
  }

  connectToTermalPrinter() {
    if (_devices.isNotEmpty)
      _connect(_devices.firstWhere(
          (dev) => (dev.name ?? '').toLowerCase().contains('print')));
    else
      showSnack(context, 'Connect printer via bluetooth first');
  }

  Future<int> getTodayTotal() async {
    String todayDate = DateFormat('dd-MMM-yy').format(DateTime.now());
    return await SharedPreferencesHelper.getInt(todayDate) ?? 0;
  }

  Future<int> lastTicketPrice() async {
    String todayDate = DateFormat('dd-MMM-yy').format(DateTime.now());
    return await SharedPreferencesHelper.getInt('last_ticket_$todayDate') ?? 0;
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      floatingActionButton: FloatingActionButton(
          child: Icon(Icons.receipt),
          onPressed: () {
            Navigator.of(context)
                .push(MaterialPageRoute(builder: (context) => PosScreen()))
                .then((value) {
              setState(() {});
            });
          }),
      drawer: SafeArea(
        child: Drawer(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                Container(
                  child: Text('\n\nSri Ganesh Darshini\n\n\n'),
                ),
                ListTile(
                  tileColor: Colors.amber,
                  title: Text('Add Item'),
                  onTap: () {
                    Navigator.of(context).pop();
                    Navigator.of(context).push(
                        MaterialPageRoute(builder: (context) => AddItemPage()));
                  },
                ),
                SizedBox(
                  height: 10,
                ),
                ListTile(
                  tileColor: Colors.amber,
                  title: Text('Add Category'),
                  onTap: () {
                    Navigator.of(context).pop();
                    Navigator.of(context).push(
                        MaterialPageRoute(builder: (context) => AddCategory()));
                  },
                )
              ],
            ),
          ),
        ),
      ),
      appBar: AppBar(
        title: Text('Sri Ganesh Darshini'),
        actions: [
          _connected
              ? GestureDetector(
                  child: Row(
                    children: [
                      Text(
                        'Printer Connected',
                        style: TextStyle(
                          color: Colors.green,
                        ),
                      ),
                      Icon(
                        Icons.done,
                        color: Colors.green,
                      ),
                    ],
                  ),
                )
              : ElevatedButton(
                  child: Text('Connect'),
                  onPressed: () {
                    connectToTermalPrinter();
                  },
                ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(8.0),
        child: Padding(
          padding: const EdgeInsets.all(30),
          child: Wrap(
            children: <Widget>[
              Container(
                margin: EdgeInsets.all(12),
                constraints: BoxConstraints(minWidth: size.width * 0.28),
                padding: EdgeInsets.all(18),
                decoration: BoxDecoration(
                    color: Colors.green[200],
                    borderRadius: BorderRadius.circular(8)),
                child: FutureBuilder<int>(
                    future: getTodayTotal(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.done)
                        return Column(
                          children: [
                            Text(
                              'Today\'s Revenue',
                              style: TextStyle(fontSize: 15),
                            ),
                            Text(
                              '₹ ' + (snapshot.data?.toString() ?? ''),
                              style: TextStyle(fontSize: 40),
                            ),
                          ],
                        );
                      return SizedBox();
                    }),
              ),
              Container(
                margin: EdgeInsets.all(12),
                constraints: BoxConstraints(minWidth: size.width * 0.28),
                padding: EdgeInsets.all(18),
                decoration: BoxDecoration(
                    color: Colors.green[200],
                    borderRadius: BorderRadius.circular(8)),
                child: FutureBuilder<int>(
                    future: lastTicketPrice(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.done)
                        return Column(
                          children: [
                            Text(
                              'Latest Token Price',
                              style: TextStyle(fontSize: 15),
                            ),
                            Text(
                              '₹ ' + (snapshot.data?.toString() ?? ''),
                              style: TextStyle(fontSize: 40),
                            ),
                          ],
                        );
                      return SizedBox();
                    }),
              ),
              // ..._devices
              //     .map(
              //       (device) => ListTile(
              //           onTap: () {
              //             _connect(device);
              //           },
              //           tileColor: Colors.amber[100],
              //           title: Text(device.name ?? ''),
              //           subtitle: Text(device.connected ? 'Connected' : '')),
              //     )
              //     .toList(),
              const SizedBox(height: 10),
              // Padding(
              //   padding: const EdgeInsets.only(left: 10.0, right: 10.0, top: 50),
              //   child: ElevatedButton(
              //     style: ElevatedButton.styleFrom(backgroundColor: Colors.brown),
              //     onPressed: () async {
              //       TestPrint testPrint = TestPrint();
              //       testPrint.sample(context, bluetooth: bluetooth);
              //     },
              //     child: const Text('PRINT TEST',
              //         style: TextStyle(color: Colors.white)),
              //   ),
              // ),
              // Padding(
              //   padding: const EdgeInsets.only(left: 10.0, right: 10.0, top: 50),
              //   child: ElevatedButton(
              //     style: ElevatedButton.styleFrom(backgroundColor: Colors.brown),
              //     onPressed: () async {},
              //     child: const Text('Go to pos',
              //         style: TextStyle(color: Colors.white)),
              //   ),
              // ),
            ],
          ),
        ),
      ),
    );
  }

  void _connect(BluetoothDevice _device) {
    showSnack(context, 'Connecting to ${_device.name}');
    bluetooth.isConnected.then((isConnected) {
      if (isConnected == false) {
        bluetooth.connect(_device).catchError((error) {
          showSnack(context, 'Check printer');
          setState(() => _connected = false);
        });
        // print('-----set true here------');
        // setState(() => _connected = true);
      } else {
        setState(() {
          _connected = true;
        });
        showSnack(context, 'Already connected to ${_device.name}');
      }
    });
  }

  void _disconnect() {
    bluetooth.disconnect();
    setState(() => _connected = false);
  }
}
