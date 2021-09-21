import 'package:flutter/material.dart';
import 'package:flutter_blue/flutter_blue.dart';
import 'package:flutter_sandbox/app/app_router.dart';
import 'package:flutter_sandbox/app/app_router.gr.dart';
import 'package:flutter_sandbox/ui/features/bluetooth/bluetooth_view_model.dart';
import 'package:stacked/stacked.dart';

class ConnectedDeviceTile extends ViewModelWidget<BluetoothViewModel> {
  const ConnectedDeviceTile(this.device, {Key? key}) : super(key: key);

  final BluetoothDevice device;

  @override
  Widget build(BuildContext context, BluetoothViewModel model) {
    return ListTile(
      title: Text(device.name),
      subtitle: Text(device.id.id),
      onTap: () async {
        appRouter.push(SingleDeviceViewRoute(device: device));
      },
      trailing: StreamBuilder<BluetoothDeviceState>(
        stream: device.state,
        initialData: BluetoothDeviceState.disconnected,
        builder: (c, snapshot) {
          if (snapshot.data == BluetoothDeviceState.connected) {
            return ElevatedButton(
              child: const Text('OPEN'),
              onPressed: () => appRouter.push(SingleDeviceViewRoute(device: device)),
            );
          }
          return Text(snapshot.data.toString());
        },
      ),
    );
  }
}
