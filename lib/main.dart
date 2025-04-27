import 'dart:async';

import 'package:firebase_core/firebase_core.dart';
import 'package:pos_ticket/home_screen.dart';
import 'package:pos_ticket/screens/turn_on_bluetooth.dart';
import 'package:pos_ticket/utils/shared_preferences_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
      options: FirebaseOptions(
    apiKey: 'AIzaSyAlvyq1UQfwZHxCqs4AEqCdwuUv26S0N4E',
    appId: '1:853661487867:android:1dda40d192f97eecd8965e',
    messagingSenderId: 'sendid',
    projectId: 'pos-ticket',
    storageBucket: 'pos-ticket.appspot.com',
  ));
  await SharedPreferencesHelper.init();
  runApp(const POSApp());
}

class POSApp extends StatefulWidget {
  const POSApp({Key? key}) : super(key: key);

  @override
  State<POSApp> createState() => _POSAppState();
}

class _POSAppState extends State<POSApp> {
  BluetoothAdapterState _adapterState = BluetoothAdapterState.unknown;

  late StreamSubscription<BluetoothAdapterState> _adapterStateStateSubscription;

  @override
  void initState() {
    super.initState();
    _adapterStateStateSubscription =
        FlutterBluePlus.adapterState.listen((state) {
      _adapterState = state;
      if (mounted) {
        setState(() {});
      }
    });
  }

  @override
  void dispose() {
    _adapterStateStateSubscription.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Widget screen = _adapterState == BluetoothAdapterState.on
        ? HomeScreen()
        : BluetoothOffScreen(adapterState: _adapterState);

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      color: Colors.green,
      theme: ThemeData(
          floatingActionButtonTheme: FloatingActionButtonThemeData(
            backgroundColor: Colors.green[200],
          ),
          primaryColor: Colors.greenAccent),
      home: screen,
      navigatorObservers: [BluetoothAdapterStateObserver()],
    );
  }
}

class BluetoothAdapterStateObserver extends NavigatorObserver {
  StreamSubscription<BluetoothAdapterState>? _adapterStateSubscription;

  @override
  void didPush(Route route, Route? previousRoute) {
    super.didPush(route, previousRoute);
    if (route.settings.name == '/DeviceScreen') {
      // Start listening to Bluetooth state changes when a new route is pushed
      _adapterStateSubscription ??=
          FlutterBluePlus.adapterState.listen((state) {
        if (state != BluetoothAdapterState.on) {
          // Pop the current route if Bluetooth is off
          navigator?.pop();
        }
      });
    }
  }

  @override
  void didPop(Route route, Route? previousRoute) {
    super.didPop(route, previousRoute);
    // Cancel the subscription when the route is popped
    _adapterStateSubscription?.cancel();
    _adapterStateSubscription = null;
  }
}
