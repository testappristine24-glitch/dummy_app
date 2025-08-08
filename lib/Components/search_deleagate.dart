// ignore_for_file: unnecessary_null_comparison
import 'package:delivoo/Providers.dart/ProductProvider.dart';
import 'package:delivoo/main.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CustomSearchDelegate extends SearchDelegate {
  final List<String> allcaliforniaplacessuggestions =
      navigatorKey.currentState!.context.read<ProductProvider>().items;

  //     CustomSearchDelegate({
  //   required String hintText,
  // }) : super(
  //   searchFieldLabel: hintText,
  //   keyboardType: TextInputType.text,
  //   textInputAction: TextInputAction.search,);

  @override
  Future<void> showResults(BuildContext context) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    super.showResults(context);
    print(query);

    await context.read<ProductProvider>().getProductsByCategory(
        catId: prefs.getString(
          'catId',
        ),
        sectiontId: prefs.getString(
          'sectionId',
        ),
        searchtxt: query);
    close(context, query);
  }

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      Row(
        children: [
          IconButton(
              icon: Icon(
                Icons.clear,
                color: Colors.black,
              ),
              onPressed: () {
                query = '';
              }),
        ],
      ),
      Row(
        children: [
          IconButton(
              icon: Icon(
                Icons.search,
                color: Colors.black,
              ),
              onPressed: () async {
                SharedPreferences prefs = await SharedPreferences.getInstance();
                print(query);
                await context.read<ProductProvider>().getProductsByCategory(
                    catId: prefs.getString(
                      'catId',
                    ),
                    sectiontId: prefs.getString(
                      'sectionId',
                    ),
                    searchtxt: query);
                close(context, query);
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
    /* final List<String> allcaliforniaplacessuggestions = navigatorKey.currentState!.context
        .read<ProductProvider>()
        .getProductsByCategory('', query); */
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
          SharedPreferences prefs = await SharedPreferences.getInstance();
          query = locationsuggestions[index];
          print(query);
          await context.read<ProductProvider>().getProductsByCategory(
              catId: prefs.getString(
                'catId',
              ),
              sectiontId: prefs.getString(
                'sectionId',
              ),
              searchtxt: query);
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
