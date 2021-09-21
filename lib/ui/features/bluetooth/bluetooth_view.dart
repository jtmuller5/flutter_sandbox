import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';
import 'bluetooth_view_model.dart';
import 'widgets/bluetooth_devices.dart';

class BluetoothView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<BluetoothViewModel>.reactive(
      viewModelBuilder: () => BluetoothViewModel(),
      onModelReady: (model) async {
        await model.initialize();
      },
      builder: (context, model, child) {
        return Scaffold(
          appBar: AppBar(
            title: const Text('Devices'),
            actions: [
              IconButton(
                onPressed: () async {
                  await model.searchDevices();
                },
                icon: const Icon(Icons.bluetooth_searching),
              )
            ],
          ),
          body: GestureDetector(
              onTap: (){
                model.showResultInfo(null);
              },
              onHorizontalDragStart: (details) {
                model.showResultInfo(null);
              },
              onVerticalDragStart: (details) {
                model.showResultInfo(null);
              },
              child: BluetoothDevices()),
        );
      },
    );
  }
}
