import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:stacked/stacked.dart';

import 'device_view_model.dart';

class WifiDevices extends ViewModelWidget<DeviceViewModel> {

  @override
  Widget build(BuildContext context, DeviceViewModel model) {
    return ListView(
      children: [
        ListTile(
          leading: const FaIcon(FontAwesomeIcons.weight),
          title: Text('iHealth Nexus Scale'),
          subtitle: Text('Not Connected'),
          onTap: (){
            //model.connectToScale();
          },
        )
      ],
    );
  }

}
