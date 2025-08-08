// ignore_for_file: unnecessary_null_comparison

import 'package:delivoo/Providers.dart/OrderProvider.dart';
import 'package:delivoo/Themes/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:provider/provider.dart';
import '../main.dart';

class CustomSearchDelegateOrders extends SearchDelegate {
  final List<String> allcaliforniaplacessuggestions =
      navigatorKey.currentState!.context.read<Orderprovider>().items;

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      Row(
        children: [
          PopupMenuButton<String>(
              icon: Icon(FeatherIcons.sliders, color: Colors.black),
              onSelected: (value) async {
                if (value.compareTo("First Date") == 0) {
                  FocusScope.of(context).unfocus();
                  showDatePicker(
                      helpText: "Select First Date",
                      context: context,
                      initialEntryMode: DatePickerEntryMode.calendarOnly,
                      initialDate: DateTime.now(),
                      firstDate: DateTime(1960),
                      lastDate: DateTime.now().add(Duration(seconds: 20)),
                      builder: (BuildContext context, child) {
                        return Theme(
                            data: Theme.of(context).copyWith(
                                colorScheme: ColorScheme.light(
                                    primary: kMainColor,
                                    onPrimary: Colors.white,
                                    onSurface: kMainColor)),
                            child: child!);
                      }).then((value) async {
                    context.read<Orderprovider>().lastDay = null;

                    await context
                        .read<Orderprovider>()
                        .DatePickerFirstDay(value);
                    await context.read<Orderprovider>().getorders(
                        context.read<Orderprovider>().firstDay ?? "",
                        context.read<Orderprovider>().lastDay ?? "",
                        "",
                        1);
                  });
                } else if (value.compareTo("Last Date") == 0) {
                  FocusScope.of(context).unfocus();
                  showDatePicker(
                      helpText: "Select Last Date",
                      context: context,
                      initialEntryMode: DatePickerEntryMode.calendarOnly,
                      initialDate: DateTime.now(),
                      firstDate: DateTime(1960),
                      lastDate: DateTime.now().add(Duration(seconds: 20)),
                      builder: (BuildContext context, child) {
                        return Theme(
                            data: Theme.of(context).copyWith(
                                colorScheme: ColorScheme.light(
                                    primary: kMainColor,
                                    onPrimary: Colors.white,
                                    onSurface: kMainColor)),
                            child: child!);
                      }).then((value) async {
                    await context
                        .read<Orderprovider>()
                        .DatePickerLastDay(value);

                    await context.read<Orderprovider>().getorders(
                        context.read<Orderprovider>().firstDay ?? "",
                        context.read<Orderprovider>().lastDay ?? "",
                        "",
                        1);
                  });
                } else if (value.compareTo("Search by Order No") == 0) {
                  showDialog(
                      context: context,
                      builder: (context) {
                        var _formkey = GlobalKey<FormState>();
                        TextEditingController orderController =
                            TextEditingController();
                        return AlertDialog(
                          title: Text(
                            "Search by Order No",
                          ),
                          content: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Form(
                                key: _formkey,
                                child: TextFormField(
                                  autovalidateMode:
                                      AutovalidateMode.onUserInteraction,
                                  validator: (value) => value!.length < 1
                                      ? 'Enter Order No'
                                      : null,
                                  textAlign: TextAlign.center,
                                  controller: orderController,
                                  decoration: InputDecoration(
                                    hintText: 'Enter Order No',
                                    suffixIcon: Padding(
                                      padding: const EdgeInsets.only(right: 8),
                                      child: Icon(
                                        Icons.edit,
                                        size: 16,
                                      ),
                                    ),
                                    enabledBorder: OutlineInputBorder(
                                        borderSide: BorderSide(width: 1)),
                                    border: new OutlineInputBorder(
                                      borderSide: const BorderSide(width: 2.0),
                                      borderRadius: BorderRadius.circular(5.0),
                                    ),
                                    contentPadding: EdgeInsets.only(),
                                  ),
                                ),
                              ),
                              Container(
                                child: ElevatedButton.icon(
                                    style: ButtonStyle(
                                        backgroundColor:
                                            MaterialStateProperty.all<Color>(
                                                kMainColor)),
                                    onPressed: () async {
                                      print(orderController.text);
                                      await context
                                          .read<Orderprovider>()
                                          .getorders("", "", "", 1);

                                      Navigator.pop(context);
                                      Navigator.pop(context);
                                    },
                                    icon: Icon(Icons.done),
                                    label: Text("ok")),
                              ),
                            ],
                          ),
                        );
                      });
                } else if (value.compareTo("Clear") == 0) {
                  FocusScope.of(context).unfocus();
                  query = '';
                  await context.read<Orderprovider>().getorders("", "", "", 1);
                }
              },
              itemBuilder: (BuildContext context) {
                return [
                  "First Date",
                  "Last Date",
                  "Search by Order No",
                  "Clear"
                ].map((options) {
                  return PopupMenuItem(
                    child: Text(options),
                    value: options,
                  );
                }).toList();
              }),
          IconButton(
              icon: Icon(
                Icons.clear,
                color: Colors.black,
              ),
              onPressed: () async {
                FocusScope.of(context).unfocus();
                query = '';
                await context.read<Orderprovider>().getorders("", "", "", 1);
              }),
        ],
      )
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: Icon(
        Icons.arrow_back,
        color: Colors.black,
      ),
      onPressed: () {
        close(context, query);
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    return buildSuggestions(context);
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    final List<String> locationsuggestions = allcaliforniaplacessuggestions
        .where(
          (placesuggestions) => placesuggestions.toLowerCase().contains(
                query.toLowerCase(),
              ),
        )
        .toList();

    return ListView.builder(
      itemCount: locationsuggestions.length,
      itemBuilder: (context, index) => ListTile(
        title: Text(
          locationsuggestions[index],
          style: TextStyle(
            color: Theme.of(context).textTheme.headlineLarge!.color,
          ),
        ),
        onTap: () async {
          query = locationsuggestions[index];
          print(query);
          await context.read<Orderprovider>().getorders(
              context.read<Orderprovider>().firstDay,
              context.read<Orderprovider>().lastDay,
              "",
              1);
          close(context, query);
        },
      ),
    );
  }
}

List<TextSpan> highlightOccurrences(String source, String query) {
  if (query == null ||
      query.isEmpty ||
      !source.toLowerCase().contains(query.toLowerCase())) {
    return [TextSpan(text: source)];
  }
  final matches = query.toLowerCase().allMatches(source.toLowerCase());

  int lastMatchEnd = 0;

  final List<TextSpan> children = [];
  for (var i = 0; i < matches.length; i++) {
    final match = matches.elementAt(i);

    if (match.start != lastMatchEnd) {
      children.add(TextSpan(
        text: source.substring(lastMatchEnd, match.start),
      ));
    }

    children.add(TextSpan(
      text: source.substring(match.start, match.end),
      style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black),
    ));

    if (i == matches.length - 1 && match.end != source.length) {
      children.add(TextSpan(
        text: source.substring(match.end, source.length),
      ));
    }

    lastMatchEnd = match.end;
  }
  return children;
}
