import 'package:delivoo/Locale/locales.dart';
import 'package:flutter/material.dart';

import '../Components/common_app_nav_bar.dart';

class Addresses extends StatefulWidget {
  @override
  _AddressesState createState() => _AddressesState();
}

class _AddressesState extends State<Addresses> {
  List<String> list = ['1', '2', '3', 'Hey'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CommonAppNavBar(
        titleWidget: Text(AppLocalizations.of(context)!.address!),
      ),
      body: ListView.builder(
          itemCount: list.length,
          itemBuilder: (BuildContext context, int index) {
            return Text(list[index]);
          }),
    );
  }
}
