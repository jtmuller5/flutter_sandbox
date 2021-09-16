import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';

import 'app/app_router.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

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
        return MaterialApp.router(
          routerDelegate: appRouter.delegate(),
          routeInformationParser: appRouter.defaultRouteParser(),
        );
      },
    );
  }
}

class AppModel extends BaseViewModel {}
