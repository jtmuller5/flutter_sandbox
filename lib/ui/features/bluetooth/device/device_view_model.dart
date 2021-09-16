import 'dart:async';

import 'package:flutter_blue/flutter_blue.dart';
import 'package:flutter_sandbox/services/services.dart';
import 'package:stacked/stacked.dart';

class DeviceViewModel extends ReactiveViewModel {
  List<ScanResult>? get scanResults {
    var bluetoothDeviceService;
    return bluetoothDeviceService.scanResults;
  }

  List<BluetoothDevice> get connectedDevices {
    return bluetoothDeviceService.connectedDevices;
  }

  Future<void> initialize() async {
    await bluetoothDeviceService.setupBluetooth();
    await searchDevices();

    notifyListeners();
  }

  Future<void> searchDevices() async {
    setBusy(true);
    await bluetoothDeviceService.searchDevices();
    setBusy(false);
  }

  Future<void> connectToDevice(BluetoothDevice device) async {
    await bluetoothDeviceService.connectToDevice(device);
  }

  /*Future<void> connectToScale() async {
    OAuth2Client iHealthClient = OAuth2Client(
      tokenUrl: '',
      authorizeUrl: 'https://api.ihealthlabs.com:8443/OpenApiV2/OAuthv2/userauthorization/',
      customUriScheme: '',
      redirectUri: 'com.turningpoint.care_navigation_test://',
    );

    OAuth2Helper oauth2Helper = OAuth2Helper(
      iHealthClient,
      grantType: OAuth2Helper.AUTHORIZATION_CODE,
      clientId: userService.uid!,
    );

    // clientSecret: 'your_client_secret',
    //scopes: ['https://www.googleapis.com/auth/drive.readonly']);

    http.Response resp = await oauth2Helper.get('https://www.googleapis.com/drive/v3/files');
  }*/

  @override
  void dispose() {
    super.dispose();
  }

  @override
  List<ReactiveServiceMixin> get reactiveServices => [bluetoothDeviceService];
}
