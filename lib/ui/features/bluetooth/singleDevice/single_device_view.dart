import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter_blue/flutter_blue.dart';
import 'package:flutter_sandbox/services/services.dart';
import 'package:flutter_sandbox/ui/features/bluetooth/singleDevice/singleDeviceWidgets/info_row.dart';
import 'package:flutter_sandbox/ui/features/bluetooth/singleDevice/single_device_view_model.dart';
import 'package:stacked/stacked.dart';
import 'package:convert/convert.dart';

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
                StreamBuilder<int>(
                  stream: device.mtu,
                  initialData: 0,
                  builder: (c, snapshot) => ListTile(
                    title: const Text('MTU Size'), // Maximum Transmission Unit
                    subtitle: Text('${snapshot.data} bytes'),
                    trailing: IconButton(
                      icon: const Icon(Icons.edit),
                      onPressed: () => device.requestMtu(223),
                    ),
                  ),
                ),
                ListTile(
                  title: Text(
                    'Services',
                    style: Theme.of(context).textTheme.headline5,
                  ),
                ),
                StreamBuilder<List<BluetoothService>>(
                    stream: device.services,
                    initialData: const [],
                    builder: (context, snapshot) {
                      return ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: snapshot.data!.length,
                        itemBuilder: (context, index) {
                          BluetoothService thisService = snapshot.data![index];

                          return Card(
                            child: ExpansionTile(
                              title: Text(
                                bluetoothDeviceService.getNameFromAllocation(thisService.uuid.toString().toLowerCase()) ??
                                    thisService.uuid.toString().toLowerCase(),
                              ),
                              leading: CircleAvatar(
                                child: const Text('S'),
                                backgroundColor: Colors.red.shade200,
                              ),
                              children: [
                                CharacteristicButtons(chars: thisService.characteristics),
                              ],
                            ),
                          );
                        },
                      );
                    }),
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
      title: Text(bluetoothDeviceService.getNameFromAllocation(char.uuid.toString().toLowerCase()) ?? char.uuid.toString().toLowerCase(),
      style: Theme.of(context).textTheme.subtitle1!.copyWith(fontWeight: FontWeight.w600),),
      subtitle: StreamBuilder<List<int>>(
        stream: char.value,
        initialData: char.lastValue,
        builder: (c, snapshot) => Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(String.fromCharCodes(snapshot.data!.toList())),
            Text(snapshot.data.toString()),
          ],
        )
      ),
      leading: CircleAvatar(
        child: const Text('C'),
        backgroundColor: Colors.blue.shade200,
      ),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          if (char.properties.read)
            IconButton(
              icon: Icon(
                Icons.file_download,
                color: Theme.of(context).iconTheme.color?.withOpacity(0.5),
              ),
              onPressed: () {
                char.read();
              },
            ),
          if (char.properties.write)
            IconButton(
              icon: Icon(Icons.file_upload, color: Theme.of(context).iconTheme.color?.withOpacity(0.5)),
              onPressed: () {
                //char.write(value);
              },
            ),
          if (char.properties.notify)
            IconButton(
              icon: Icon(char.isNotifying ? Icons.sync_disabled : Icons.sync, color: Theme.of(context).iconTheme.color?.withOpacity(0.5)),
              onPressed: () async {
                await char.setNotifyValue(!char.isNotifying);

                if (char.isNotifying) {
                  char.value.listen((value) {
                    print('Notifying characteristic value: ' + char.uuid.toString());
                    print('New value: ' + value.toString());
                    var result = hex.encode(value);

                    print('Hex value: ' + result.toString());
                  });
                }
                //await char.read();
              },
            )
        ],
      ),
      children: [
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

                  String descriptorType = bluetoothDeviceService.getNameFromAllocation(descriptor.uuid.toString()) ?? descriptor.uuid.toString();

                  return Card(
                      child: ListTile(
                    title: Text(descriptorType),
                    subtitle: StreamBuilder<List<int>>(
                      stream: descriptor.value,
                      initialData: descriptor.lastValue,
                      builder: (c, snapshot) => descriptorType == 'Characteristic User Description'
                          ? Text(String.fromCharCodes(snapshot.data!.toList()))
                          : Text(snapshot.data.toString()),
                    ),
                    onTap: () async {
                      //print('Descriptor: + ${descriptor.toString()}');

                      await model.readDescriptor(descriptor);
                    },
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        IconButton(
                          icon: Icon(
                            Icons.file_download,
                            color: Theme.of(context).iconTheme.color?.withOpacity(0.5),
                          ),
                          onPressed: () {
                            descriptor.read();
                          },
                        ),
                        IconButton(
                          icon: Icon(
                            Icons.file_upload,
                            color: Theme.of(context).iconTheme.color?.withOpacity(0.5),
                          ),
                          onPressed: () {},
                        )
                      ],
                    ),
                  ));
                },
              ),
            ],
          ),
        )
      ],
    );
  }
}
