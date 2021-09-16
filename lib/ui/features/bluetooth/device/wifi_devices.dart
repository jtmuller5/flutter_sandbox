import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:stacked/stacked.dart';

import '../bluetooth_view_model.dart';

class WifiDevices extends ViewModelWidget<BluetoothViewModel> {

  @override
  Widget build(BuildContext context, BluetoothViewModel model) {
    return ListView(
      children: [
        ListTile(
          leading: const FaIcon(FontAwesomeIcons.weight),
          title: const Text('iHealth Nexus Scale'),
          subtitle: const Text('Not Connected'),
          onTap: (){
            //model.connectToScale();
          },
        )
      ],
    );
  }

}
