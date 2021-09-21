import 'package:flutter_blue/flutter_blue.dart';
import 'package:flutter_sandbox/services/services.dart';
import 'package:stacked/stacked.dart';
import 'package:convert/convert.dart';


class SingleDeviceViewModel extends ReactiveViewModel {
  final BluetoothDevice device;

  Map<Guid, List<int>> readValues = {};

  SingleDeviceViewModel(this.device);

  Future<void> initialize() async {
    await device.discoverServices();
    notifyListeners();
  }

  /// Read value from a characteristic within a bluetooth service
  Future<void> readCharacteristic(BluetoothCharacteristic char) async {
    var sub = char.value.listen((value) {
      print('Updating characteristic value: ' + char.uuid.toString());
      readValues[char.uuid] = value;
      notifyListeners();
    });
    await char.read().then((value) {
      readValues[char.uuid] = value;
      notifyListeners();
    });

    sub.cancel();
  }

  void writeCharacteristic(BluetoothCharacteristic char) {}

  Future<void> notifyCharacteristic(BluetoothCharacteristic char) async {
    await char.setNotifyValue(true);
    print('last value: ' + char.lastValue.toString());

    char.value.listen((value) {
      print('Notifying characteristic value: ' + char.uuid.toString());
      print('New value: ' + value.toString());
      var result = hex.encode(value);

      print('Hex value: ' + result.toString());
      //Uint8List bytes = Uint8List.fromList(value);
      //print('Byte value: ' + bytes.toString());
      readValues[char.uuid] = value;
      notifyListeners();
    });

  }

  Future<void> readDescriptor(BluetoothDescriptor descriptor) async {
    print('last value: ' + descriptor.lastValue.toString());
    List<int> value = await descriptor.read();
    //print(String.fromCharCodes(value));
    print(value);
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  List<ReactiveServiceMixin> get reactiveServices => [bluetoothDeviceService];
}
