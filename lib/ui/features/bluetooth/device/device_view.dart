/*
import 'package:care_navigation_test/ui/profileView/device/wifi_devices.dart';
import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';

import 'bluetooth_devices.dart';
import 'device_view_model.dart';

class DeviceView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<DeviceViewModel>.reactive(
      viewModelBuilder: () => DeviceViewModel(),
      onModelReady: (model) async {
        await model.initialize();
      },
      builder: (context, model, child) {
        return DefaultTabController(
          length: 2,
          initialIndex: 0,
          child: Scaffold(
              appBar: AppBar(
                title: Text('Devices'),
                actions: [
                  IconButton(
                      onPressed: () async {
                        await model.searchDevices();
                      },
                      icon: Icon(Icons.bluetooth_searching))
                ],
                bottom: TabBar(
                  tabs: [
                    Tab(
                      child: Text('Wifi'),
                    ),
                    Tab(
                      child: Text('Bluetooth'),
                    )
                  ],
                ),
              ),
              body: TabBarView(
                children: [
                  WifiDevices(),
                  BluetoothDevices(),
                ],
              )),
        );
      },
    );
  }
}
*/
