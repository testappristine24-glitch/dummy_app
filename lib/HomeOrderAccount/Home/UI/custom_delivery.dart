import 'package:animation_wrappers/animation_wrappers.dart';
import 'package:delivoo/Components/bottom_bar.dart';
import 'package:delivoo/Components/entry_field.dart';
import 'package:delivoo/Locale/locales.dart';
import 'package:delivoo/Routes/routes.dart';
import 'package:delivoo/Themes/colors.dart';
import 'package:flutter/material.dart';

class CustomDeliveryPage extends StatelessWidget {
  final String pageTitle;

  CustomDeliveryPage(this.pageTitle);

  @override
  Widget build(BuildContext context) {
    return CustomDelivery(pageTitle);
  }
}

class CustomDelivery extends StatefulWidget {
  final String pageTitle;

  CustomDelivery(this.pageTitle);

  @override
  _CustomDeliveryState createState() => _CustomDeliveryState();
}

class _CustomDeliveryState extends State<CustomDelivery> {
  // CustomDeliveryBloc _deliveryBloc;
  TextEditingController pickUpController = TextEditingController();
  TextEditingController dropController = TextEditingController();
  TextEditingController valuesController = TextEditingController();
  TextEditingController instructionController = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    pickUpController.dispose();
    dropController.dispose();
    valuesController.dispose();
    instructionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).cardColor,
      appBar: AppBar(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        title: Text(AppLocalizations.of(context)!.send!,
            style: Theme.of(context)
                .textTheme
                .headlineMedium!
                .copyWith(fontWeight: FontWeight.w500)),
        titleSpacing: 0.0,
      ),
      body: FadedSlideAnimation(
        child: ListView(
          children: <Widget>[
            Divider(
              thickness: 6.7,
              color: kCardBackgroundColor,
            ),
            Container(
              color: Theme.of(context).scaffoldBackgroundColor,
              width: MediaQuery.of(context).size.width,
              padding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
              child: Column(
                children: <Widget>[
                  EntryField(
                    controller: pickUpController,
                    image: 'images/custom/ic_pickup_pointact.png',
                    label: AppLocalizations.of(context)!.pickupAddress,
                    hint: AppLocalizations.of(context)!.pickupText,
                    onTap: () {
                      /*...........*/
                    },
                    readOnly: true,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 8.0),
                    child: EntryField(
                      controller: dropController,
                      image: 'images/custom/ic_droppointact.png',
                      label: AppLocalizations.of(context)!.drop,
                      hint: AppLocalizations.of(context)!.dropText,
                      readOnly: true,
                      onTap: () {
                        /*.......*/
                      },
                    ),
                  ),
                ],
              ),
            ),
            Divider(
              thickness: 6.7,
              color: Theme.of(context).cardColor,
            ),
            Container(
              color: Theme.of(context).scaffoldBackgroundColor,
              width: MediaQuery.of(context).size.width,
              padding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
              child: Padding(
                padding: EdgeInsets.only(bottom: 8.0),
                child: EntryField(
                  controller: valuesController,
                  image: 'images/custom/ic_packageact.png',
                  label: AppLocalizations.of(context)!.package,
                  hint: AppLocalizations.of(context)!.packageText,
                  readOnly: true,
                  suffixIcon: Icon(
                    Icons.keyboard_arrow_down,
                    color: kMainColor,
                  ),
                  onTap: () {
                    showModalBottomSheet(
                      context: context,
                      builder: (context) {
                        return ModalBottomWidget();
                      },
                    );
                  },
                ),
              ),
            ),
            Divider(
              thickness: 6.7,
              color: kCardBackgroundColor,
            ),
            Container(
              color: Theme.of(context).scaffoldBackgroundColor,
              width: MediaQuery.of(context).size.width,
              padding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
              child: EntryField(
                hint: AppLocalizations.of(context)!.instruction,
                image: 'images/custom/ic_instruction.png',
                imageColor: kLightTextColor,
                border: InputBorder.none,
              ),
            ),
            SizedBox(
              height: 100,
            ),
            Container(
              width: MediaQuery.of(context).size.width,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding:
                        EdgeInsets.symmetric(vertical: 16.0, horizontal: 20.0),
                    child: Text(AppLocalizations.of(context)!.paymentInfo!,
                        style: Theme.of(context)
                            .textTheme
                            .headlineSmall!
                            .copyWith(color: kDisabledColor)),
                  ),
                  Padding(
                    padding:
                        EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
                    child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Text(
                            AppLocalizations.of(context)!.deliveryCharge!,
                            style: Theme.of(context).textTheme.bodyMedium,
                          ),
                          Text(
                            '\$ 0.00',
                            style: Theme.of(context).textTheme.bodyMedium,
                          ),
                        ]),
                  ),
                  Divider(
                    color: Theme.of(context).cardColor,
                    thickness: 1.0,
                  ),
                  Padding(
                    padding:
                        EdgeInsets.symmetric(vertical: 8.0, horizontal: 20.0),
                    child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Text(
                            AppLocalizations.of(context)!.service!,
                            style: Theme.of(context).textTheme.bodyMedium,
                          ),
                          Text(
                            '\$ 0.00',
                            style: Theme.of(context).textTheme.bodyMedium,
                          ),
                        ]),
                  ),
                  Divider(
                    color: Theme.of(context).cardColor,
                    thickness: 1.0,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20.0, vertical: 12.0),
                    child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Text(
                            AppLocalizations.of(context)!.amount!,
                            style: Theme.of(context)
                                .textTheme
                                .bodyMedium!
                                .copyWith(fontWeight: FontWeight.bold),
                          ),
                          Text(
                            '\$ 0.00',
                            style: Theme.of(context).textTheme.bodyMedium,
                          ),
                        ]),
                  ),
                ],
              ),
              color: Theme.of(context).scaffoldBackgroundColor,
            ),
            BottomBar(
              text: AppLocalizations.of(context)!.continueText,
              onTap: () {
                Navigator.pushNamed(context, PageRoutes.paymentMethod);
              },
            ),
          ],
        ),
        beginOffset: Offset(0, 0.3),
        endOffset: Offset(0, 0),
        slideCurve: Curves.linearToEaseOut,
      ),
    );
  }
}

//bottom sheets that pops up on select package type field
class ModalBottomWidget extends StatefulWidget {
  @override
  _ModalBottomWidgetState createState() => _ModalBottomWidgetState();
}

class _ModalBottomWidgetState extends State<ModalBottomWidget> {
  List<String?> _selectedList = [];

  @override
  Widget build(BuildContext context) {
    var appLocalization = AppLocalizations.of(context)!;
    final List<String?> list = <String?>[
      appLocalization.paperDocuments,
      appLocalization.flowersChocolates,
      appLocalization.sports,
      appLocalization.clothes,
      appLocalization.electronic,
      appLocalization.household,
      appLocalization.glass,
    ];

    return FadedSlideAnimation(
      child: ListView(
        children: <Widget>[
          Container(
            color: Theme.of(context).cardColor,
            padding: EdgeInsets.symmetric(vertical: 12.0, horizontal: 24.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text(
                  AppLocalizations.of(context)!.packageText!,
                  style: Theme.of(context).textTheme.headlineMedium,
                ),
                TextButton(
                  child: Text(
                    AppLocalizations.of(context)!.done!,
                    style: TextStyle(color: kWhiteColor),
                  ),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  style: TextButton.styleFrom(
                    backgroundColor: Theme.of(context).primaryColor,
                    shape: RoundedRectangleBorder(
                        side: BorderSide(color: kTransparentColor),
                        borderRadius: BorderRadius.circular(30.0)),
                  ),
                ),
              ],
            ),
          ),
          ListView.builder(
            shrinkWrap: true,
            itemCount: list.length,
            itemBuilder: (context, index) => CheckboxListTile(
              title: Text(list[index]!),
              value: _selectedList.contains(list[index]),
              onChanged: (value) {
                if (value!) {
                  _selectedList.add(list[index]);
                } else {
                  _selectedList.remove(list[index]);
                }
                setState(() {});
              },
            ),
          ),
          // CheckboxGroup(
          //   labelStyle: Theme.of(context).textTheme.bodyMedium!,
          //   padding: EdgeInsets.only(top: 16.0),
          //   onSelected: (List<String> checked) {},
          //   labels: list as List<String>,
          // ),
        ],
      ),
      beginOffset: Offset(0, 0.3),
      endOffset: Offset(0, 0),
      slideCurve: Curves.linearToEaseOut,
    );
  }
}
