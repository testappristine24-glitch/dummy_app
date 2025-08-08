import 'package:delivoo/AppConstants.dart';
import 'package:delivoo/CommonWidget.dart';
import 'package:delivoo/Components/common_app_nav_bar.dart';
import 'package:delivoo/Providers.dart/ProductProvider.dart';
import 'package:delivoo/Themes/colors.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';

class CouponScreen extends StatefulWidget {
  final app_Bar, refferal;
  CouponScreen({Key? key, this.app_Bar, this.refferal}) : super(key: key);

  @override
  State<CouponScreen> createState() => _CouponScreenState();
}

class _CouponScreenState extends State<CouponScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  @override
  void initState() {
    _animationController = AnimationController(
      vsync: this,
      duration: Duration(seconds: 3),
    );
    _animationController.addStatusListener((status) async {
      if (status == AnimationStatus.completed) {
        Navigator.pop(context);
        _animationController.reset();
        await context.read<ProductProvider>().getcarttotal();
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var coupons = context.watch<ProductProvider>().loadCouponList?.d;
    return Scaffold(
      appBar: widget.app_Bar == true
          ? CommonAppNavBar(
              titleWidget: Text(
                "Coupons for you",
                style: TextStyle(fontSize: 20, color: Colors.white),
              ))
          : null,
      body: ListView(
        // shrinkWrap: true,
        // physics: NeverScrollableScrollPhysics(),
        children: [
          widget.app_Bar != true
              ? SizedBox.shrink()
              : Container(
                  decoration: BoxDecoration(color: kCardBackgroundColor),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const Text(
                          'BEST OFFERS FOR YOU',
                          style: TextStyle(color: Colors.black),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                      ],
                    ),
                  ),
                ),
          coupons == null || coupons.length == 0
              ? Center(
                  child: Container(
                      height: MediaQuery.of(context).size.height * 0.7,
                      child: Center(child: Text("No Coupons Found"))))
              : ListView.builder(
                  shrinkWrap: true,
                  itemCount: coupons.length,
                  physics: ScrollPhysics(),
                  itemBuilder: (BuildContext context, index) {
                    return InkWell(
                      onTap: widget.app_Bar != true
                          ? null
                          : () async {
                              if (coupons[index].couponStatus == "0") {
                                var res = await context
                                    .read<ProductProvider>()
                                    .applyCoupon(
                                        coupon: "",
                                        couponamt: coupons[index].couponamt,
                                        rewardId: coupons[index].rewardid);
                                if (res == "1") {
                                  showDialog(
                                      barrierDismissible: false,
                                      context: context,
                                      builder: (context) => Dialog(
                                            child: Column(
                                              mainAxisSize: MainAxisSize.min,
                                              children: [
                                                Lottie.asset(
                                                  'assets/applied.json',
                                                  repeat: false,
                                                  controller:
                                                      _animationController,
                                                  onLoaded: (composition) {
                                                    _animationController
                                                        .forward();
                                                  },
                                                ),
                                              ],
                                            ),
                                          ));
                                  context
                                      .read<ProductProvider>()
                                      .loadCoupons(action: "2");
                                }
                              } else if (coupons[index].couponStatus == "2") {
                                showMessage(
                                    "Coupon Code is only applicable on minimum Cart Value of ₹${double.parse(coupons[index].mininvamt ?? "").toStringAsFixed(2).replaceFirst(RegExp(r'\.?0*$'), '')}* in Kisanserv Express App only");
                              }
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
                                BaseUrl + "Couponimg/" + coupons[index].imgpath,
                                colorBlendMode: BlendMode.saturation,
                                color: Colors.black.withOpacity(
                                    coupons[index].couponStatus != "2" &&
                                            coupons[index].couponStatus != "3"
                                        ? 0
                                        : 1),
                                // 0 = Colored, 1 = Black & White
                              ),
                            ),
                          ),
                          Positioned(
                              left:
                                  coupons[index].rewardtype != "0" ? 125 : 110,
                              top: coupons[index].rewardtype != "0" ? 89 : 48,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    '${coupons[index].coupons.toString().replaceAll("|", "\n")} ',
                                    style: TextStyle(
                                        color: coupons[index].rewardtype != "0"
                                            ? Colors.black
                                            : coupons[index].couponStatus == "2"
                                                ? Colors.grey
                                                : Colors.white,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 11.0),
                                  ),
                                  coupons[index].usedOrderid == null ||
                                          coupons[index].usedOrderid == ""
                                      ? SizedBox.shrink()
                                      : Text(
                                          'Order Id - ${coupons[index].usedOrderid.toString().replaceAll("|", "\n")} ',
                                          style: TextStyle(
                                              color: coupons[index]
                                                          .rewardtype !=
                                                      "0"
                                                  ? Colors.black
                                                  : coupons[index]
                                                              .couponStatus ==
                                                          "2"
                                                      ? Colors.grey
                                                      : Colors.white,
                                              fontWeight: FontWeight.bold,
                                              fontSize: 12.0),
                                        ),
                                  coupons[index].mobileNo == null ||
                                          coupons[index].mobileNo == ""
                                      ? SizedBox.shrink()
                                      : Text(
                                          'Referred by - ${coupons[index].mobileNo.toString().replaceAll("|", "\n")} ',
                                          style: TextStyle(
                                              color: widget.refferal == true
                                                  ? Colors.black
                                                  : coupons[index]
                                                              .couponStatus ==
                                                          "2"
                                                      ? Colors.grey
                                                      : Colors.white,
                                              fontWeight: FontWeight.bold,
                                              fontSize: 12.0),
                                        ),
                                ],
                              )),
                          coupons[index].rewardtype != "0" &&
                                  coupons[index].couponStatus == "3"
                              ? Positioned(
                                  right: 70,
                                  top: 100,
                                  child: Transform(
                                      transform: new Matrix4.identity()
                                        ..rotateZ(-15 * 3.1415927 / 180),
                                      child: Column(
                                        children: [
                                          Text(
                                            "---------------------------",
                                            style: TextStyle(
                                              color: Colors.red,
                                              fontWeight: FontWeight.bold,
                                              fontSize: 22.0,
                                            ),
                                          ),
                                          Text(
                                            'Un-Used Referral',
                                            style: TextStyle(
                                              color: Colors.red,
                                              fontWeight: FontWeight.bold,
                                              fontSize: 22.0,
                                            ),
                                          ),
                                          Text(
                                            "---------------------------",
                                            style: TextStyle(
                                              color: Colors.red,
                                              fontWeight: FontWeight.bold,
                                              fontSize: 22.0,
                                            ),
                                          ),
                                        ],
                                      )))
                              : SizedBox.shrink(),
                          widget.refferal == true &&
                                  coupons[index].couponStatus == "2"
                              ? Positioned(
                                  right: 20,
                                  top: 50,
                                  child: Icon(
                                    Icons.done,
                                    color: Colors.green,
                                    size: 100,
                                  ))
                              : SizedBox.shrink(),
                          Positioned(
                              right: 70,
                              bottom: 30,
                              child: Text(
                                'Terms and Conditions Apply*',
                                style: TextStyle(
                                    color: coupons[index].rewardtype != "0"
                                        ? Colors.black
                                        : Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 8.0),
                              )),
                          widget.app_Bar == true
                              ? coupons[index].couponStatus != "1"
                                  ? SizedBox.shrink()
                                  : Positioned(
                                      right: 8,
                                      bottom: 8,
                                      child: Container(
                                        decoration: BoxDecoration(
                                            color: Colors.yellow,
                                            // kMainColor,
                                            borderRadius: BorderRadius.only(
                                                topLeft: Radius.circular(7),
                                                bottomRight:
                                                    Radius.circular(0))),
                                        child: Text(
                                          ' ${"Applied"}',
                                          style: TextStyle(
                                              color: Colors.green,
                                              fontSize: 20.0),
                                        ),
                                      ))
                              : SizedBox.shrink(),
                        ],
                      ),
                    );
                  }),
        ],
      ),
    );
  }
}
