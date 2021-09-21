import 'package:flutter/material.dart';
import 'package:flutter_blue/flutter_blue.dart';
import 'package:flutter_sandbox/ui/features/bluetooth/widgets/connected_device_tile.dart';
import 'package:flutter_sandbox/ui/features/bluetooth/widgets/detected_device_tile.dart';
import 'package:stacked/stacked.dart';

import '../bluetooth_view_model.dart';

class BluetoothDevices extends ViewModelWidget<BluetoothViewModel> {
  @override
  Widget build(BuildContext context, BluetoothViewModel model) {
    return ListView(
      shrinkWrap: true,
      children: [
        ListTile(
          title: Text('Connected Devices',
            style: Theme.of(context).textTheme.headline4,),
        ),
        StreamBuilder<List<BluetoothDevice>>(
            stream: Stream.periodic(const Duration(seconds: 2)).asyncMap((_) => FlutterBlue.instance.connectedDevices),
            initialData: const [],
            builder: (context, snapshot) {
              return ListView.separated(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: snapshot.data!.length,
                itemBuilder: (context, index) {
                  BluetoothDevice device = snapshot.data![index];

                  return ConnectedDeviceTile(device);
                },
                separatorBuilder: (BuildContext context, int index) {
                  return const Divider();
                },
              );
            }),
        ListTile(
          title: Text('Unconnected Devices',
          style: Theme.of(context).textTheme.headline4,),
        ),
        StreamBuilder<List<ScanResult>>(
            stream: FlutterBlue.instance.scanResults,
            initialData: const [],
            builder: (context, snapshot) {
              return ListView.separated(
                physics: const NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemCount: snapshot.data!.length,
                itemBuilder: (context, index) {
                  ScanResult scanResult = snapshot.data![index];

                  return DetectedDeviceTile(scanResult);
                },
                separatorBuilder: (BuildContext context, int index) {
                  return const Divider();
                },
              );
            }),
      ],
    );
  }
}
