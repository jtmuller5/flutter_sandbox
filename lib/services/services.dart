import 'package:flutter_sandbox/app/get_it.dart';
import 'bluetooth_device_service.dart';

BluetoothDeviceService get bluetoothDeviceService{
  return getIt.get<BluetoothDeviceService>();
}