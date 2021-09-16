import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';

import 'bluetooth_view_model.dart';

class BluetoothView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<BluetoothViewModel>.reactive(
      viewModelBuilder: () => BluetoothViewModel(),
      onModelReady: (model) {
        // model.initialize();
      },
      builder: (context, model, child) {
        return Scaffold(
         appBar: AppBar(
            title: Text('Title'),
          ),
            body: Column(
              children: [
                Container()
              ],
            )
        );
      },
    );
  }
}