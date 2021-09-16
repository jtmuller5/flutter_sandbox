import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';

import 'bluetooth_view_model.dart';
import 'device/bluetooth_devices.dart';
import 'device/wifi_devices.dart';

class BluetoothView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<BluetoothViewModel>.reactive(
      viewModelBuilder: () => BluetoothViewModel(),
      onModelReady: (model) async {
        await model.initialize();
      },
      builder: (context, model, child) {
        return DefaultTabController(
          length: 2,
          initialIndex: 0,
          child: Scaffold(
              appBar: AppBar(
                title: const Text('Devices'),
                actions: [
                  IconButton(
                      onPressed: () async {
                        await model.searchDevices();
                      },
                      icon: const Icon(Icons.bluetooth_searching))
                ],
                bottom: const TabBar(
                  tabs: [
                    Tab(
                      child: Text('Bluetooth'),
                    ),
                    Tab(
                      child: Text('Wifi'),
                    ),
                  ],
                ),
              ),
              body: TabBarView(
                children: [
                  BluetoothDevices(),
                  WifiDevices(),
                ],
              )),
        );
      },
    );
  }
}