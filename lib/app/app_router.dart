import 'package:auto_route/annotations.dart';
import 'package:flutter_sandbox/ui/home/home_view.dart';

import 'app_router.gr.dart';

final appRouter = AppRouter();

@AdaptiveAutoRouter(routes: <AutoRoute>[
  /// TESTING
  AutoRoute(
    page: HomeView,
    initial: true,
  ),
])

class $AppRouter {}
