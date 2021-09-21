// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// AutoRouteGenerator
// **************************************************************************

import 'package:auto_route/auto_route.dart' as _i1;
import 'package:flutter/cupertino.dart' as _i6;
import 'package:flutter/material.dart' as _i2;
import 'package:flutter_blue/flutter_blue.dart' as _i7;
import 'package:flutter_sandbox/ui/features/bluetooth/bluetooth_view.dart'
    as _i4;
import 'package:flutter_sandbox/ui/features/bluetooth/singleDevice/single_device_view.dart'
    as _i5;
import 'package:flutter_sandbox/ui/home/home_view.dart' as _i3;

class AppRouter extends _i1.RootStackRouter {
  AppRouter([_i2.GlobalKey<_i2.NavigatorState>? navigatorKey])
      : super(navigatorKey);

  @override
  final Map<String, _i1.PageFactory> pagesMap = {
    HomeViewRoute.name: (routeData) => _i1.AdaptivePage<dynamic>(
        routeData: routeData,
        builder: (_) {
          return _i3.HomeView();
        }),
    BluetoothViewRoute.name: (routeData) => _i1.AdaptivePage<dynamic>(
        routeData: routeData,
        builder: (_) {
          return _i4.BluetoothView();
        }),
    SingleDeviceViewRoute.name: (routeData) => _i1.AdaptivePage<dynamic>(
        routeData: routeData,
        builder: (data) {
          final args = data.argsAs<SingleDeviceViewRouteArgs>();
          return _i5.SingleDeviceView(key: args.key, device: args.device);
        })
  };

  @override
  List<_i1.RouteConfig> get routes => [
        _i1.RouteConfig(HomeViewRoute.name, path: '/'),
        _i1.RouteConfig(BluetoothViewRoute.name, path: '/bluetooth-view'),
        _i1.RouteConfig(SingleDeviceViewRoute.name, path: '/single-device-view')
      ];
}

class HomeViewRoute extends _i1.PageRouteInfo<void> {
  const HomeViewRoute() : super(name, path: '/');

  static const String name = 'HomeViewRoute';
}

class BluetoothViewRoute extends _i1.PageRouteInfo<void> {
  const BluetoothViewRoute() : super(name, path: '/bluetooth-view');

  static const String name = 'BluetoothViewRoute';
}

class SingleDeviceViewRoute
    extends _i1.PageRouteInfo<SingleDeviceViewRouteArgs> {
  SingleDeviceViewRoute({_i6.Key? key, required _i7.BluetoothDevice device})
      : super(name,
            path: '/single-device-view',
            args: SingleDeviceViewRouteArgs(key: key, device: device));

  static const String name = 'SingleDeviceViewRoute';
}

class SingleDeviceViewRouteArgs {
  const SingleDeviceViewRouteArgs({this.key, required this.device});

  final _i6.Key? key;

  final _i7.BluetoothDevice device;
}
