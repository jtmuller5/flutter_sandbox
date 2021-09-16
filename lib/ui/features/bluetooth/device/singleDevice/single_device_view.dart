import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_blue/flutter_blue.dart';
import 'package:flutter_sandbox/services/services.dart';
import 'package:flutter_sandbox/ui/features/bluetooth/device/singleDevice/singleDeviceWidgets/info_row.dart';
import 'package:flutter_sandbox/ui/features/bluetooth/device/singleDevice/single_device_view_model.dart';
import 'package:stacked/stacked.dart';

class SingleDeviceView extends StatelessWidget {
  final BluetoothDevice device;

  const SingleDeviceView({
    Key? key,
    required this.device,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<SingleDeviceViewModel>.reactive(
      viewModelBuilder: () => SingleDeviceViewModel(device),
      onModelReady: (model) async {
        await model.initialize();
      },
      builder: (context, model, child) {
        return Scaffold(
            appBar: AppBar(
              title: Text(device.name),
            ),
            body: ListView(
              shrinkWrap: true,
              children: [
                InfoRow(label: 'Device Name', value: device.name),
                InfoRow(label: 'Device ID', value: device.id.id),
                InfoRow(label: 'Device Type', value: device.type.toString()),
                ListTile(
                  title: Text(
                    'Services',
                    style: Theme.of(context).textTheme.headline5,
                  ),
                ),
                ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: model.services.length,
                  itemBuilder: (context, index) {
                    BluetoothService thisService = model.services[index];

                    return Card(
                      child: ExpansionTile(
                        title: Text(
                          bluetoothDeviceService.getNameFromAllocation(thisService.uuid.toString().toLowerCase()) ??
                              thisService.uuid.toString().toLowerCase(),
                        ),
                        leading: CircleAvatar(
                          child: Text('S'),
                          backgroundColor: Colors.red.shade200,
                        ),
                        children: [
                          CharacteristicButtons(chars: thisService.characteristics),
                        ],
                      ),
                    );
                  },
                ),
                 ListTile(
                  title: Text(
                    'Values',
                    style: Theme.of(context).textTheme.headline5,
                  ),
                ),
                ListView.builder(
                  physics: const NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: model.readValues.keys.length,
                  itemBuilder: (context, index) {
                    Guid guid = model.readValues.keys.toList()[index];
                    List<int> value = model.readValues[guid] ?? [];

                    return ListTile(
                      title: Text(bluetoothDeviceService.getNameFromAllocation(guid.toString()) ?? guid.toString()),
                      subtitle: Text('Value: ' + String.fromCharCodes(value)),
                    );
                  },
                )
              ],
            ));
      },
    );
  }
}

class CharacteristicButtons extends StatelessWidget {
  final List<BluetoothCharacteristic> chars;

  const CharacteristicButtons({
    Key? key,
    required this.chars,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        ListTile(
          title: Text(
            'Characteristics',
            style: Theme.of(context).textTheme.headline6,
          ),
        ),
        for (BluetoothCharacteristic char in chars) CharButton(char)
      ],
    );
  }
}

class CharButton extends ViewModelWidget<SingleDeviceViewModel> {
  final BluetoothCharacteristic char;

  CharButton(this.char);

  @override
  Widget build(BuildContext context, model) {
    print('Encryption required : ' + char.properties.notifyEncryptionRequired.toString());
    return ExpansionTile(
      title: Text(bluetoothDeviceService.getNameFromAllocation(char.uuid.toString().toLowerCase()) ?? char.uuid.toString().toLowerCase()),
      leading: CircleAvatar(
        child: const Text('C'),
        backgroundColor: Colors.blue.shade200,
      ),
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: Row(
            children: [
              if (char.properties.write)
                ElevatedButton(
                    onPressed: () {
                      model.writeCharacteristic(char);
                    },
                    child: const Text('Write')),
              if (char.properties.read)
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: ElevatedButton(
                      onPressed: () async {
                        await model.readCharacteristic(char);
                      },
                      child: const Text('Read')),
                ),
              if (char.properties.notify)
                ElevatedButton(
                    onPressed: () async {
                      await model.notifyCharacteristic(char);
                    },
                    child: const Text('Notify')),
            ],
          ),
        ),
        Card(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListView.builder(
                physics: const NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemCount: char.descriptors.length,
                itemBuilder: (context, index) {
                  BluetoothDescriptor descriptor = char.descriptors[index];
                  return Card(
                      child: ListTile(
                    title: Text(bluetoothDeviceService.getNameFromAllocation(descriptor.uuid.toString()) ?? descriptor.uuid.toString()),
                    subtitle: const Text('Descriptor'),
                    onTap: () async {

                    //print('Descriptor: + ${descriptor.toString()}');

                      await model.readDescriptor(descriptor);
                    },
                  ));
                },
              ),
            ],
          ),
        )
      ],
    );
    ;
  }
}
