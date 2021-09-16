import 'package:flutter/material.dart';
import 'package:flutter_sandbox/app/app_router.dart';
import 'package:flutter_sandbox/app/app_router.gr.dart';
import 'package:stacked/stacked.dart';

import 'home_view_model.dart';

class HomeView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<HomeViewModel>.reactive(
      viewModelBuilder: () => HomeViewModel(),
      onModelReady: (model) {
        // model.initialize();
      },
      builder: (context, model, child) {
        return Scaffold(
         appBar: AppBar(
            title: const Text('Home'),
          ),
            body: ListView(
              children: [
                ListTile(
                  title: const Text('Bluetooth'),
                  onTap: (){
                    appRouter.push(const BluetoothViewRoute());
                  },
                )
              ],
            )
        );
      },
    );
  }
}