import 'package:delivoo/Providers.dart/login_provider.dart';
import 'package:delivoo/Themes/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';

import '../../AppConstants.dart';
import '../../CommonWidget.dart';
import '../../Components/common_app_nav_bar.dart';

class ReferralSceen extends StatelessWidget {
  const ReferralSceen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var refferal = context.watch<LoginProvider>().checkReferalavailable?.d;
    return Scaffold(
      appBar: CommonAppNavBar(
          titleWidget: const Text(
        'My Referral',
        style: TextStyle(fontSize: 20),
      )),
      body: ListView(
        // crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            decoration: BoxDecoration(color: kCardBackgroundColor),
            child: Padding(
              padding: const EdgeInsets.all(0.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Stack(
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.grey.shade400,
                          borderRadius: BorderRadius.circular(0),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(3.0),
                          child: Center(
                            child: Image.network(
                              BaseUrl + "Couponimg/referral_banner_inside.png",
                            ),
                          ),
                        ),
                      ),
                      Positioned(
                          right: 80,
                          top: 7,
                          child: Transform(
                              transform: new Matrix4.identity()
                                ..rotateZ(15 * 3.1415927 / 180),
                              child: refferal == null ||
                                      refferal.rewardAmount == null
                                  ? Text("")
                                  : Text(
                                      '₹ ${double.parse(refferal.rewardAmount ?? "").toStringAsFixed(2).replaceFirst(RegExp(r'\.?0*$'), '')}',
                                      style: TextStyle(
                                        color: Colors.black,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 12.0,
                                      ),
                                    ))),
                    ],
                  ),

                  const SizedBox(
                    height: 10,
                  ),

                  // Row(
                  //   children: [
                  //     InkWell(
                  //       onTap: () {
                  //         showDialog(
                  //             barrierColor: Colors.white.withOpacity(0),
                  //             barrierDismissible: false,
                  //             context: context,
                  //             builder: (context) => Scaffold(
                  //                   appBar: AppBar(),
                  //                   body: Column(
                  //                     children: [
                  //                       const SizedBox(
                  //                         height: 10,
                  //                       ),
                  //                       const Text('How My Referal Works'),
                  //                       const Text(
                  //                           'Steps to Successfully Refer and earn'),
                  //                       const Spacer(),
                  //                       Center(
                  //                         child: Container(
                  //                           height: 60,
                  //                           width: MediaQuery.of(context)
                  //                                   .size
                  //                                   .width *
                  //                               0.8,
                  //                           decoration: BoxDecoration(
                  //                               borderRadius:
                  //                                   BorderRadius.circular(10),
                  //                               color: Colors.lightGreen),
                  //                           child: const Center(
                  //                             child: Text('Share via Whatsapp'),
                  //                           ),
                  //                         ),
                  //                       )
                  //                     ],
                  //                   ),
                  //                 ));
                  //       },
                  //       child: const Text(
                  //         'How it works',
                  //         style: TextStyle(
                  //             fontSize: 13,
                  //             color: Colors.teal,
                  //             decoration: TextDecoration.underline),
                  //       ),
                  //     )
                  //   ],
                  // )
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Icon(
                  Icons.arrow_circle_right,
                  color: Colors.green.shade900,
                  size: 50,
                ),
                const SizedBox(
                  width: 5,
                ),
                Text('Referral Code - ${refferal?.referalcode ?? ""} ',
                    style: TextStyle(fontSize: 14)),
                InkWell(
                  onTap: () {
                    Clipboard.setData(
                        ClipboardData(text: refferal?.referalcode ?? ""));
                    showSnackBar(
                        context: context,
                        content:
                            "${refferal?.referalcode ?? ""}, 'Code Copied to clipboard.'");
                  },
                  child: Icon(
                    Icons.copy,
                    size: 20,
                  ),
                ),
                const Spacer(),
                InkWell(
                  onTap: () {
                    Share.share(
                        '${refferal?.msgtext ?? ""}  https://play.google.com/store/apps/details?id=com.kisanserv.alphaexpress \nHere my code(${refferal?.referalcode})');
                  },
                  child: Row(
                    children: [
                      const Text('Share',
                          style: TextStyle(
                              fontSize: 14,
                              color: Colors.blue,
                              fontWeight: FontWeight.bold)),
                      Icon(
                        Icons.share,
                        size: 18,
                        color: Colors.blue,
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),
          InkWell(
            onTap: () {
              showMessage(
                  "Referral Code is only applicable on minimum Cart Value of ₹${double.parse(refferal?.invoiceamount ?? "").toStringAsFixed(2).replaceFirst(RegExp(r'\.?0*$'), '')}* in Kisanserv Express App only");
            },
            child: Stack(
              children: [
                Container(
                  decoration: BoxDecoration(
                    color: Colors.grey.shade200,
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Image.network(
                      BaseUrl + "Couponimg/${refferal?.imgpath}",
                    ),
                  ),
                ),
                Positioned(
                    left: 150,
                    top: 90,
                    child: Text(
                      ' ${refferal?.couponcode ?? ""}',
                      style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                          fontSize: 17.0),
                    )),
                Positioned(
                    left: 125,
                    top: 115,
                    child: Text(
                      'Referral Code: ${refferal?.referalcode} \nAmount: ₹${refferal?.rewardAmount != null ? double.parse(refferal?.rewardAmount ?? "").toStringAsFixed(2).replaceFirst(RegExp(r'\.?0*$'), '') : ""} ',
                      style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                          fontSize: 14.0),
                    )),
                Positioned(
                    right: 85,
                    bottom: 20,
                    child: Text(
                      'Click Here to know T&C*',
                      style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                          fontSize: 9.0),
                    )),
              ],
            ),
          ),
          SizedBox(
            height: 5,
          ),
        ],
      ),
    );
  }
}
