import 'package:csv/csv.dart';
import 'package:flutter/services.dart';
import 'package:flutter_blue/flutter_blue.dart';
import 'package:injectable/injectable.dart';
import 'package:stacked/stacked.dart';

@lazySingleton
class BluetoothDeviceService with ReactiveServiceMixin {
  FlutterBlue flutterBlue = FlutterBlue.instance;

  Stream<ScanResult>? scanStream;
  List<ScanResult>? scanResults;
  List<BluetoothDevice> connectedDevices = [];
  bool bluetoothAvailable = false;
  bool bluetoothOn = false;

  /// Adopted UUID : Name
  Map<String, String> allocationMap = {};

  Map<int, String> connectionStatus = {
    0: 'Disconnected',
    1: 'Connecting',
    2: 'Connected',
    3: 'Disconnecting',
  };

  Future<void> setupBluetooth() async {
    bluetoothAvailable = await flutterBlue.isAvailable;
    bluetoothOn = await flutterBlue.isOn;
    await loadGattNumbers();
    scanForInfo();
    await getConnectedDevices();
  }

  /// Will only return unconnected devices so we need to save off the connected ones
  void scanForInfo() {
    flutterBlue.scanResults.listen((results) {
      // do something with scan results
      for (ScanResult r in results) {
        print('Device Name: ${r.device.name}');
        print('Device Id: ${r.device.id.id}');
        print('RSSI: ${r.rssi}');
        print('Connectable: ${r.advertisementData.connectable}');
        print('Local Name: ${r.advertisementData.localName}');
        print('TX Power Level: ${r.advertisementData.txPowerLevel}');
        print('TX Power Level: ${r.advertisementData.txPowerLevel}');
        print('Manufacturer Data: ${r.advertisementData.manufacturerData.toString()}');
        print('Service Data: ${r.advertisementData.serviceData.toString()}');
        print('Service UUIDs: ${r.advertisementData.serviceUuids}');
      }
    });
  }

  /// https://btprodspecificationrefs.blob.core.windows.net/assigned-values/16-bit%20UUID%20Numbers%20Document.pdf
  /// https://gist.github.com/sam016/4abe921b5a9ee27f67b3686910293026
  /// https://www.bluetooth.com/specifications/assigned-numbers/
  /// Load 16-bit, adopted GATT numbers from CSV file
  Future<void> loadGattNumbers() async {
    String btNumbers = await rootBundle.loadString('assets/resources/Bluetooth_Numbers.csv');

    print('Starting to load BT numbers');

    // [type, UUID, for]
    List<List<dynamic>> allocations = const CsvToListConverter().convert(btNumbers);

    // Add each allocation to a type map
    allocations.forEach((allocation) {
      allocationMap.addAll({
        getAllocationUuid(allocation): getAllocationFor(allocation),
      });
    });

    print('Finished loading BT numbers');
  }

  /// allocation[0] = type
  /// allocation[1] = UUID
  /// allocation[2] = for
  String getAllocationUuid(List<dynamic> allocation) {
    String starter = allocation[1].toString();

    print('Adding : ' + starter + '0000-1000-8000-00805F9B34FB');
    return (starter + '0000-1000-8000-00805F9B34FB').toLowerCase();
  }

  String getAllocationType(List<dynamic> allocation) {
    return allocation[0];
  }

  String getAllocationFor(List<dynamic> allocation) {
    return allocation[2];
  }

  String? getNameFromAllocation(String uuid) {
    return allocationMap[uuid];
  }

  Future<void> searchDevices() async {
    scanResults = await flutterBlue.startScan(timeout: const Duration(seconds: 8));

    if (scanResults != null) {
      scanResults!.forEach((scanResult) {
        scanResult.device.state.listen((event) {
          // Device is connected
          if (event.index == 2) {
            // If this device hasn't already been added to the connected list add it
            if (!connectedDevices.contains(scanResult.device)) {
              connectedDevices.add(scanResult.device);
            }
          }
          // Device is disconnected
          else if (event.index == 1) {
            connectedDevices.remove(scanResult.device.id.id);
          }

          print('Connection status for ${scanResult.device.name} is ${connectionStatus[event.index]}');
          notifyListeners();
        });
      });
    }
  }

  Future<void> checkDeviceServices(BluetoothDevice device) async {
    try {
      List<BluetoothService> services = await device.discoverServices();

      services.forEach((service) {
        print('Service MAC: ' + service.uuid.toMac());

        print('Service Device ID: ' + service.deviceId.id);
        print('Service Primary?: ' + service.isPrimary.toString());
        service.characteristics.forEach((char) {
          print('Broadcast: ' + char.properties.broadcast.toString());
          print('Read: ' + char.properties.read.toString());
          print('Write: ' + char.properties.write.toString());
          print('Write without Respones: ' + char.properties.writeWithoutResponse.toString());
          print('Indicate: ' + char.properties.indicate.toString());
          print('Indicate Encryption Required: ' + char.properties.indicateEncryptionRequired.toString());
          print('Authenticated Signed Writes: ' + char.properties.authenticatedSignedWrites.toString());
          print('Extended Properties: ' + char.properties.extendedProperties.toString());
          print('Notify Encryption Required: ' + char.properties.notifyEncryptionRequired.toString());
        });
      });
    } catch (e) {
      print('Service read error: ' + e.toString());
    }
  }

  /// Index = disconnected, connecting, connected, disconnecting
  Future<void> connectToDevice(BluetoothDevice device) async {
    print('Trying to connect to device: ' + device.id.id);
    try {
      await device.connect();
      print('Connected to ' + device.id.id);
    } catch (e) {
      print('Connection error: ' + e.toString());
    }
  }

  Future<void> getConnectedDevices() async {
    connectedDevices = await flutterBlue.connectedDevices;
  }

  String getNiceManufacturerData(Map<int, List<int>> data) {
    if (data.isEmpty) {
      return 'N/A';
    }
    List<String> res = [];
    data.forEach((id, bytes) {
      res.add(
          '${id.toRadixString(16).toUpperCase()}: ${getNiceHexArray(bytes)}');
    });
    return res.join(', ');
  }

  String getNiceHexArray(List<int> bytes) {
    return '[${bytes.map((i) => i.toRadixString(16).padLeft(2, '0')).join(', ')}]'
        .toUpperCase();
  }
}
