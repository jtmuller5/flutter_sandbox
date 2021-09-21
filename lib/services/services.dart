import 'package:flutter_sandbox/app/get_it.dart';
import 'package:mullr_components/services/toast_service.dart';
import 'bluetooth_device_service.dart';

BluetoothDeviceService get bluetoothDeviceService{
  return getIt.get<BluetoothDeviceService>();
}

ToastService get toastService {
  return getIt.get<ToastService>();
}