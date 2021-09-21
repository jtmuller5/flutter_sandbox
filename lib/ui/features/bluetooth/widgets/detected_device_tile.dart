import 'package:flutter/material.dart';
import 'package:flutter_blue/flutter_blue.dart';
import 'package:flutter_portal/flutter_portal.dart';
import 'package:flutter_sandbox/services/services.dart';
import 'package:flutter_sandbox/ui/features/bluetooth/bluetooth_view_model.dart';
import 'package:stacked/stacked.dart';

class DetectedDeviceTile extends ViewModelWidget<BluetoothViewModel> {
  const DetectedDeviceTile(this.scanResult, {Key? key}) : super(key: key);

  final ScanResult scanResult;

  @override
  Widget build(BuildContext context, BluetoothViewModel model) {
    return ListTile(
      selectedTileColor: Colors.blue.shade100,
      selected: model.infoResult ==scanResult.device.id.id,
      title: Text(scanResult.device.name),
      subtitle: Text(scanResult.device.id.id),
      leading: scanResult.advertisementData.connectable ? IconButton(icon: const Icon(Icons.connect_without_contact),
      onPressed: () async {
        scanResult.advertisementData.connectable ? await model.connectToDevice(scanResult.device) : null;
      },) : const Icon(Icons.block),
      trailing: PortalEntry(
        visible: model.infoResult == scanResult.device.id.id,
        portalAnchor: Alignment.centerRight,
        childAnchor: Alignment.centerLeft,
        portal: Card(
          child: SizedBox(
            width: 250,
            child: InkWell(
              onTap: () {
                model.showResultInfo(null);
              },
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    InfoItem(
                      label: 'RSSI', // Received Signal Strength Indicator
                      value: scanResult.rssi.toString(),
                      context: context,
                    ),
                    InfoItem(
                      label: 'Tx Power Level',
                      value: scanResult.advertisementData.txPowerLevel.toString(),
                      context: context,
                    ),
                    InfoItem(
                      label: 'Manufacturer Data',
                      value: bluetoothDeviceService.getNiceManufacturerData(scanResult.advertisementData.manufacturerData),
                      context: context,
                    ),
                    InfoItem(
                      label: 'Local Name',
                      value: scanResult.advertisementData.localName,
                      context: context,
                    ),
                    InfoItem(
                      label: 'Connectable',
                      value: scanResult.advertisementData.connectable.toString(),
                      context: context,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
        child: IconButton(
          icon: const Icon(Icons.info_outline),
          onPressed: () {
            model.showResultInfo(scanResult.device.id.id);
          },
        ),
      ),

    );
  }

  Widget InfoItem({
    required String label,
    required String value,
    required BuildContext context,
  }) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: Theme.of(context).textTheme.headline6),
        Text(value, style: Theme.of(context).textTheme.subtitle1),
      ],
    );
  }
}
