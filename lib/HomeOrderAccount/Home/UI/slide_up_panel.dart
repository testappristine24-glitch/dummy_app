import 'package:animation_wrappers/animation_wrappers.dart';
import 'package:delivoo/Locale/locales.dart';
import 'package:delivoo/Providers.dart/OrderProvider.dart';
import 'package:delivoo/Themes/colors.dart';
import 'package:flutter/material.dart';
import 'package:provider/src/provider.dart';
import '../../../AppConstants.dart';

class SlideUpPanel extends StatefulWidget {
  final List<String> itemName;

  SlideUpPanel(this.itemName);

  @override
  _SlideUpPanelState createState() => _SlideUpPanelState();
}

class _SlideUpPanelState extends State<SlideUpPanel> {
  List<String> weight = [
    '1kg x 1',
    '1kg x 1',
    '1kg x 1',
  ];
  List<double> prices = [
    3.00,
    4.50,
    2.50,
  ];

  double sum() {
    double total = 0.00;
    for (int i = 0; i < prices.length; i++) {
      total += prices[i];
    }
    return total;
  }

  @override
  Widget build(BuildContext context) {
    final orderdetails = context.watch<Orderprovider>().orderdetails?.d;
    final orders = context.watch<Orderprovider>().orders?.d;
    return DraggableScrollableSheet(
      minChildSize: 0.15,
      initialChildSize: 0.15,
      maxChildSize: 0.975,
      builder: (context, controller) {
        return FadedSlideAnimation(
          child:
          Container(
            padding: EdgeInsets.only(left: 4.0),
            color: Theme.of(context).cardColor,
            child: SingleChildScrollView(
              controller: controller,
              child: Container(
                height: MediaQuery.of(context).size.height * 0.65,
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  children: <Widget>[
                    Container(
                      color: Theme.of(context).scaffoldBackgroundColor,
                      child: Stack(
                        children: <Widget>[
                          Hero(
                            tag: 'Delivery Boy',
                            child: Padding(
                              padding: EdgeInsets.only(bottom: 10.0, top: 14.0),
                              child: ListTile(
                                leading: CircleAvatar(
                                  radius: 22.0,
                                  backgroundImage:
                                      AssetImage('images/profile.png'),
                                ),
                                title: Text(
                                  'George Anderson',
                                  style: Theme.of(context).textTheme.headlineMedium,
                                ),
                                subtitle: Text(
                                  'Delivery Partner',
                                  style: Theme.of(context)
                                      .textTheme
                                      .headlineSmall!
                                      .copyWith(
                                          fontSize: 11.7,
                                          fontWeight: FontWeight.w500,
                                          color: Color(0xffc2c2c2)),
                                ),
                                /*  trailing: FittedBox(
                                  fit: BoxFit.fill,
                                  child: Row(
                                    children: <Widget>[
                                      IconButton(
                                        icon: Icon(Icons.message,
                                            color: kMainColor),
                                        onPressed: () {
                                          Navigator.pushNamed(
                                              context, PageRoutes.chatPage);
                                        },
                                      ),
                                      IconButton(
                                        icon: Icon(Icons.phone,
                                            color: kMainColor),
                                        onPressed: () {
                                          /*.......*/
                                        },
                                      ),
                                    ],
                                  ),
                                ), */
                              ),
                            ),
                          ),
                          Center(
                            child: Hero(
                              tag: 'arrow',
                              child: Icon(
                                Icons.keyboard_arrow_up,
                                color: kMainColor,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 6.0),
                    Expanded(
                      child: ListView.builder(
                        //physics: NeverScrollableScrollPhysics(),
                        itemCount:
                            orderdetails?.length, // widget.itemName.length,
                        itemBuilder: (BuildContext context, int index) {
                          return Container(
                            color: Theme.of(context).scaffoldBackgroundColor,
                            child: ListTile(
                              leading: orderdetails![index].imagename != ''
                                  ? CircleAvatar(
                                      radius: 25,
                                      backgroundColor: Colors.white,
                                      backgroundImage: NetworkImage(BaseUrl +
                                          'skuimages/' +
                                          orderdetails[index]
                                              .imagename!), //AssetImage(image),
                                      onBackgroundImageError:
                                          (exception, stackTrace) {
                                        orderdetails[index].imagename = '';
                                      },
                                    )
                                  : CircleAvatar(
                                      radius: 25,
                                      backgroundColor: Colors.white,
                                      backgroundImage: AssetImage(
                                          'images/logos/not-available.png'),
                                    ),
                              title: Text(
                                orderdetails[index].itemName!,
                                // widget.itemName[index],
                                style: Theme.of(context)
                                    .textTheme
                                    .headlineMedium!
                                    .copyWith(
                                        fontWeight: FontWeight.w500,
                                        fontSize: 15.0),
                              ),
                              subtitle: Text(
                                orderdetails[index].qty!,
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyMedium!
                                    .copyWith(fontSize: 13.3),
                              ),
                              trailing: Text(
                                '\u{20B9} ${orderdetails[index].totalamount!}',
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyMedium!
                                    .copyWith(fontSize: 13.3),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                    SizedBox(height: 6.0),
                    Container(
                      height: 50.0,
                      padding: EdgeInsets.symmetric(horizontal: 8.0),
                      color: Theme.of(context).scaffoldBackgroundColor,
                      child: Row(
                        children: [
                          ImageIcon(
                            AssetImage('images/custom/ic_instruction.png'),
                            color: kLightTextColor,
                            size: 20.0,
                          ),
                          SizedBox(
                            width: 10.0,
                          ),
                          Text(
                            AppLocalizations.of(context)!.instruction!,
                            style: Theme.of(context)
                                .textTheme
                                .bodyMedium!
                                .copyWith(color: kLightTextColor),
                          ),
                        ],
                      ),

//                    EntryField(
//                      image: 'images/custom/ic_instruction.png',
//                      imageColor: kLightTextColor,
//                      initialValue: AppLocalizations.of(context).instruction,
//                      readOnly: true,
//                      border: InputBorder.none,
//                    ),
                    ),
                    SizedBox(height: 6.0),
                    Container(
                      width: double.infinity,
                      padding:
                          EdgeInsets.symmetric(vertical: 8.0, horizontal: 20.0),
                      child: Text(AppLocalizations.of(context)!.paymentInfo!,
                          style: Theme.of(context)
                              .textTheme
                              .headlineMedium!
                              .copyWith(
                                  color: kDisabledColor,
                                  fontSize: 13.3,
                                  letterSpacing: 0.67)),
                      color: Theme.of(context).scaffoldBackgroundColor,
                    ),
                    Container(
                      color: Theme.of(context).scaffoldBackgroundColor,
                      padding:
                          EdgeInsets.symmetric(vertical: 8.0, horizontal: 20.0),
                      child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Text(
                              AppLocalizations.of(context)!.sub!,
                              style: Theme.of(context).textTheme.bodyMedium,
                            ),
                            Text(
                              //'\$ ${sum()}',
                              '\u{20B9}  ${orders?[context.watch<Orderprovider>().orderindex!].totalamount}',
                              style: Theme.of(context).textTheme.bodyMedium,
                            ),
                          ]),
                    ),
                    /*  Container(
                      color: Theme.of(context).scaffoldBackgroundColor,
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
                              '\$ 1.50',
                              style: Theme.of(context).textTheme.bodyMedium,
                            ),
                          ]),
                    ), */
                    /* Container(
                      color: Theme.of(context).scaffoldBackgroundColor,
                      padding:
                          EdgeInsets.symmetric(vertical: 8.0, horizontal: 20.0),
                      child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Text(
                              AppLocalizations.of(context)!.cod!,
                              style: Theme.of(context)
                                  .textTheme
                                  .headlineSmall!
                                  .copyWith(
                                    color:
                                        Theme.of(context).secondaryHeaderColor,
                                  ),
                            ),
                            Text(
                              '\u{20B9}  ${orders?[context.watch<Orderprovider>().orderindex!].totalamount}',
                              style: Theme.of(context).textTheme.bodyMedium,
                            ),
                          ]),
                    ), */
                  ],
                ),
              ),
            ),
          ),
          beginOffset: Offset(0, 0.3),
          endOffset: Offset(0, 0),
          slideCurve: Curves.linearToEaseOut,
        );
      },
    );
  }
}
