// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// AutoRouteGenerator
// **************************************************************************

import 'package:auto_route/auto_route.dart' as _i1;
import 'package:flutter/material.dart' as _i2;
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
        })
  };

  @override
  List<_i1.RouteConfig> get routes =>
      [_i1.RouteConfig(HomeViewRoute.name, path: '/')];
}

class HomeViewRoute extends _i1.PageRouteInfo<void> {
  const HomeViewRoute() : super(name, path: '/');

  static const String name = 'HomeViewRoute';
}
