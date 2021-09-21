import 'package:flutter/material.dart';
import 'package:flutter_portal/flutter_portal.dart';
import 'package:flutter_sandbox/app/get_it.dart';
import 'package:stacked/stacked.dart';

import 'app/app_router.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  configureDependencies();
  runApp(App());
}

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<AppModel>.reactive(
      viewModelBuilder: () => AppModel(),
      onModelReady: (model) async {
        //await model.initialise();
      },
      builder: (context, model, child) {
        return Portal(
          child: MaterialApp.router(
            routerDelegate: appRouter.delegate(),
            routeInformationParser: appRouter.defaultRouteParser(),
          ),
        );
      },
    );
  }
}

class AppModel extends BaseViewModel {}
