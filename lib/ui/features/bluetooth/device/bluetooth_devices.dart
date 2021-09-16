import 'package:flutter/material.dart';
import 'package:flutter_blue/flutter_blue.dart';
import 'package:flutter_sandbox/app/app_router.dart';
import 'package:flutter_sandbox/app/app_router.gr.dart';
import 'package:stacked/stacked.dart';

import 'device_view_model.dart';

class BluetoothDevices extends ViewModelWidget<DeviceViewModel> {
  @override
  Widget build(BuildContext context, DeviceViewModel model) {
    return model.isBusy
        ? const Center(
            child: CircularProgressIndicator(color: Colors.white),
          )
        : ListView(
            shrinkWrap: true,
            children: [
              const ListTile(
                title: Text('Connected Devices'),
              ),
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: (model.connectedDevices).length,
                itemBuilder: (context, index) {
                  BluetoothDevice device = model.connectedDevices[index];

                  return Card(
                    child: ListTile(
                      leading: Icon(
                        model.connectedDevices.contains(device) ? Icons.bluetooth_connected : Icons.bluetooth_disabled,
                      ),
                      title: Text(device.name),
                      subtitle: Text(device.id.id),
                      onTap: () async {
                        appRouter.push(SingleDeviceViewRoute(device: device));
                      },
                    ),
                  );
                },
              ),
              const ListTile(
                title: Text('Unconnected Devices'),
              ),
              ListView.builder(
                physics: const NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemCount: (model.scanResults ?? []).length,
                itemBuilder: (context, index) {
                  ScanResult scanResult = model.scanResults![index];

                  if (model.connectedDevices.contains(scanResult.device)) {
                    return Container();
                  } else {
                    return Card(
                      child: ListTile(
                        leading: Icon(
                          model.connectedDevices.contains(scanResult.device) ? Icons.bluetooth_connected : Icons.bluetooth_disabled,
                        ),
                        title: Text(scanResult.device.name),
                        subtitle: Text(scanResult.device.id.id),
                        trailing: Text(scanResult.rssi.toString()),
                        onTap: () async {
                          await model.connectToDevice(scanResult.device);
                          //await model.checkDeviceServices(scanResult.device);
                        },
                      ),
                    );
                  }
                },
              ),
            ],
          );
  }
}
