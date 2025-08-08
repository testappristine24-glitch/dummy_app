import 'package:delivoo/Providers.dart/store_provider.dart';
import 'package:delivoo/Themes/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_emoji_feedback/flutter_emoji_feedback.dart';
import 'package:provider/provider.dart';

import '../../../Components/common_app_nav_bar.dart';
import '../../../Providers.dart/OrderProvider.dart';

class feedbackScreen extends StatefulWidget {
  final orderid;
  const feedbackScreen({this.orderid, Key? key}) : super(key: key);

  @override
  State<feedbackScreen> createState() => _feedbackScreenState();
}

class _feedbackScreenState extends State<feedbackScreen> {

  bool questionType = false;
  bool? value = true;
  final selectedIndexes = [];
  final selectedIndexess = [];
  List multipleSelected = [];

  bool isChecked = true;
  bool viewVisible = true;
  double Rating = 0.0;

  double rating = 0.0;

  String emoji = 'rating';

  @override
  void initState() {
    context.read<StoreProvider>().rating = 0;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CommonAppNavBar(
        titleWidget: Text(
          "Feedback",
          style: TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.w900,
            color: Colors.white
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: 4,
            ),
            Padding(
              padding: const EdgeInsets.all(5.0),
              child: Center(
                child: Container(
                  child: EmojiFeedback(
                    labelTextStyle: TextStyle(fontSize: 15),
                    animDuration: const Duration(milliseconds: 100),
                    curve: Curves.bounceIn,
                    inactiveElementScale: .5,
                    onChanged: (rating) async {
                      context.read<StoreProvider>().updateEmoji(rating);
                      await context
                          .read<StoreProvider>()
                          .submitratings(rating, widget.orderid);
                      setState(() {
                        rating = context.read<StoreProvider>().rating;
                      });
                      print(rating);
                    },
                  ),
                ),
              ),
            ),
            context.watch<StoreProvider>().rating == 0
                ? SizedBox.fromSize()
                : Divider(
                    color: Colors.grey,
                    thickness: 2,
                  ),
            context.watch<StoreProvider>().rating == 0
                ? SizedBox.shrink()
                : Container(
                    width: (MediaQuery.of(context).size.width),
                    color: BackgColor,
                    child: Padding(
                      padding: const EdgeInsets.only(left: 10),
                      child: Column(
                        children: [
                          Text(
                            "What Delights me and makes me buy at Kisanserv:",
                            textAlign: TextAlign.left,
                            style: TextStyle(
                                fontSize: 19,
                                fontWeight: FontWeight.bold,
                                color: Colors.black87),
                          ),
                        ],
                      ),
                    ),
                  ),
            // SizedBox(
            //   height: 5,
            // ),
            context.watch<StoreProvider>().rating == 0
                ? SizedBox.fromSize()
                : Divider(
                    color: Colors.grey,
                    thickness: 2,
                  ),
            context.watch<StoreProvider>().rating == 0
                ? SizedBox.fromSize()
                : Container(
                    width: (MediaQuery.of(context).size.width),
                    child: ListView.builder(
                        itemCount:
                            context.read<StoreProvider>().feedbacks?.d.length,
                        physics: NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        itemBuilder: (_, index) {
                          var question =
                              context.read<StoreProvider>().feedbacks?.d;
                          return Container(
                            child: Row(
                              children: [
                                SizedBox(width: 10),
                                Checkbox(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10.0),
                                  ),
                                  side: MaterialStateBorderSide.resolveWith(
                                    (states) => BorderSide(
                                      width: 1.0,
                                    ),
                                  ),
                                  value: selectedIndexes.contains(index),
                                  onChanged: (value) async {
                                    if (selectedIndexes.contains(index)) {
                                      selectedIndexes.remove(index);
                                      await context
                                          .read<StoreProvider>()
                                          .submitfeedback(
                                              question?[index].qid,
                                              "0",
                                              question?[index].questiontype,
                                              widget.orderid);
                                    } else {
                                      selectedIndexes.add(index);
                                      await context
                                          .read<StoreProvider>()
                                          .submitfeedback(
                                              question?[index].qid,
                                              "1",
                                              question?[index].questiontype,
                                              widget.orderid);
                                    }
                                    setState(() {
                                      isChecked = !isChecked;
                                      print(isChecked);
                                    });
                                  },
                                  checkColor: Colors.greenAccent,
                                  activeColor: Colors.black,
                                  visualDensity: VisualDensity(
                                      horizontal: -4, vertical: -4),
                                ),
                                Container(
                                  width:
                                      MediaQuery.of(context).size.width * 0.80,
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        '${question![index].question}',
                                        style: TextStyle(fontSize: 15.0),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          );
                        }),
                  ),
            // SizedBox(
            //   height: 3,
            // ),
            context.watch<StoreProvider>().rating == 0 ||
                    context.watch<StoreProvider>().rating > 3
                ? SizedBox.fromSize()
                : Divider(
                    color: Colors.grey,
                    thickness: 4,
                  ),
            context.watch<StoreProvider>().rating == 0 ||
                    context.watch<StoreProvider>().rating > 3
                ? SizedBox.shrink()
                : Container(
                    width: (MediaQuery.of(context).size.width),
                    color: BackgColor,
                    child: Padding(
                      padding: const EdgeInsets.only(right: 30.0),
                      child: Column(
                        children: [
                          Text(
                            "What drives me away from Kisanserv:",
                            textAlign: TextAlign.left,
                            style: TextStyle(
                                fontSize: 19,
                                fontWeight: FontWeight.bold,
                                color: Colors.black87),
                          ),
                        ],
                      ),
                    ),
                  ),
            // SizedBox(
            //   height: 3,
            // ),
            Divider(
              color: Colors.grey,
              thickness: 2,
            ),
            context.watch<StoreProvider>().rating == 0 ||
                    context.watch<StoreProvider>().rating > 3
                ? SizedBox.shrink()
                : Container(
                    width: (MediaQuery.of(context).size.width),
                    child: ListView.builder(
                        itemCount:
                            context.read<StoreProvider>().feedback?.d.length,
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        itemBuilder: (_, index) {
                          var questions =
                              context.read<StoreProvider>().feedback?.d;
                          return Container(
                            child: Row(
                              children: [
                                SizedBox(width: 10),
                                Checkbox(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10.0),
                                  ),
                                  side: MaterialStateBorderSide.resolveWith(
                                    (states) => BorderSide(
                                      width: 1.0,
                                    ),
                                  ),
                                  onChanged: (value) async {
                                    if (selectedIndexess.contains(index)) {
                                      await context
                                          .read<StoreProvider>()
                                          .submitfeedback(
                                              questions?[index].qid,
                                              "0",
                                              questions?[index].questiontype,
                                              widget.orderid);
                                      selectedIndexess.remove(index);
                                    } else {
                                      await context
                                          .read<StoreProvider>()
                                          .submitfeedback(
                                              questions?[index].qid,
                                              "1",
                                              questions?[index].questiontype,
                                              widget.orderid);
                                      selectedIndexess.add(index);
                                    }
                                    setState(() {
                                      isChecked = !isChecked;
                                      print(isChecked);
                                    });
                                  },
                                  checkColor: Colors.greenAccent,
                                  activeColor: Colors.black,
                                  value: selectedIndexess.contains(index),
                                  visualDensity: VisualDensity(
                                      horizontal: -4, vertical: -4),
                                ),
                                Container(
                                  width:
                                      MediaQuery.of(context).size.width * 0.80,
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        '${questions?[index].question}',
                                        style: TextStyle(fontSize: 15.0),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          );
                        }),
                  ),
          ],
        ),
      ),
      bottomNavigationBar: Container(
        height: 60,
        color: Theme.of(context).colorScheme.secondary,
        child: InkWell(
          onTap: () async {
            // context.read<StoreProvider>().submitratings(Rating);
            // await context.read<StoreProvider>().submitratings();
            await context
                .read<StoreProvider>()
                .finalsubmitratings(widget.orderid);
            await context.read<Orderprovider>().getorders('', '', '', 0);
            Navigator.pop(context);
          },
          child: Padding(
            padding: EdgeInsets.only(top: 14.0),
            child: Column(
              children: <Widget>[
                Text(
                  "Submit",
                  style: TextStyle(
                      fontSize: 19,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
