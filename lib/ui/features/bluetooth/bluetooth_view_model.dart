import 'package:flutter_blue/flutter_blue.dart';
import 'package:flutter_sandbox/services/services.dart';
import 'package:stacked/stacked.dart';

class BluetoothViewModel extends ReactiveViewModel {

  String? infoResult;

  Future<void> initialize() async {
    setBusy(true);
    await bluetoothDeviceService.setupBluetooth();
    await searchDevices();
    setBusy(false);
  }

  Future<void> searchDevices() async {
    await bluetoothDeviceService.searchDevices();
      }

  Future<void> connectToDevice(BluetoothDevice device) async {
    await bluetoothDeviceService.connectToDevice(device);
  }

  void showResultInfo(String? id){
    infoResult = id;
    notifyListeners();
  }

  @override
  List<ReactiveServiceMixin> get reactiveServices => [bluetoothDeviceService];
}
