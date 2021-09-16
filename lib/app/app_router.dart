import 'package:auto_route/annotations.dart';
import 'package:flutter_sandbox/ui/features/bluetooth/bluetooth_view.dart';
import 'package:flutter_sandbox/ui/features/bluetooth/device/singleDevice/single_device_view.dart';
import 'package:flutter_sandbox/ui/home/home_view.dart';

import 'app_router.gr.dart';

final appRouter = AppRouter();

@AdaptiveAutoRouter(routes: <AutoRoute>[
  /// TESTING
  AutoRoute(page: HomeView, initial: true),
  AutoRoute(page: BluetoothView),
  AutoRoute(page: SingleDeviceView),
])
class $AppRouter {}
