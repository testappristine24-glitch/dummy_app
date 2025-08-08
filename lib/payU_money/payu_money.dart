// import 'package:flutter/material.dart';
// import 'package:payu_checkoutpro_flutter/PayUConstantKeys.dart';
//
// import 'hash_service_model.dart';
//
// showAlertDialog(BuildContext context, String title, String content) {
//   Widget okButton = TextButton(
//     child: const Text("OK"),
//     onPressed: () {
//       Navigator.pop(context);
//     },
//   );
//
//   showDialog(
//       context: context,
//       builder: (BuildContext context) {
//         return AlertDialog(
//           title: Text(title),
//           content: SingleChildScrollView(
//             scrollDirection: Axis.vertical,
//             child: Text(content),
//           ),
//           actions: [okButton],
//         );
//       });
// }
//
// @override
//
// //Pass these values from your app to SDK, this data is only for test purpose
// class PayUParams {
//   static Map createPayUPaymentParams(PayUHashModel details, mob) {
//     print(details.d.amount);
//     print('mobile  ${mob}');
//
//     var additionalParam = {
//       PayUAdditionalParamKeys.udf1: details.d.udf1,
//       PayUAdditionalParamKeys.udf2: details.d.udf2,
//       PayUAdditionalParamKeys.udf3: details.d.udf3,
//       PayUAdditionalParamKeys.udf4: details.d.udf4,
//       PayUAdditionalParamKeys.udf5: details.d.udf5,
//     };
//
//     var payUPaymentParams = {
//       PayUPaymentParamKey.key: "Pry8yR",
//       PayUPaymentParamKey.transactionId: details.d.paymentforwordtraid,
//       PayUPaymentParamKey.amount: details.d.amount,
//       PayUPaymentParamKey.productInfo: details.d.productinfo,
//       PayUPaymentParamKey.firstName: details.d.memname,
//       PayUPaymentParamKey.email: details.d.mememail,
//       PayUPaymentParamKey.phone: mob,
//       PayUPaymentParamKey.ios_surl: details.d.surl,
//       PayUPaymentParamKey.ios_furl: details.d.furl,
//       PayUPaymentParamKey.android_surl: details.d.surl,
//       PayUPaymentParamKey.android_furl: details.d.furl,
//       PayUPaymentParamKey.environment: "0", //0 => Production 1 => Test
//       PayUPaymentParamKey.additionalParam: additionalParam,
//     };
//
//     return payUPaymentParams;
//   }
//
//   static Map createPayUConfigParams(String paymentType) {
//     var enforcePaymentList = paymentType != "UPI"
//         ? [
//             {"payment_type": "CARD"},
//           ]
//         : [
//             {"payment_type": "UPI"},
//           ];
//     var payUCheckoutProConfig = {
//       PayUCheckoutProConfigKeys.primaryColor: "#4994EC",
//       PayUCheckoutProConfigKeys.secondaryColor: "#FFFFFF",
//       PayUCheckoutProConfigKeys.merchantName: "Kisanserv",
//       PayUCheckoutProConfigKeys.showExitConfirmationOnCheckoutScreen: true,
//       PayUCheckoutProConfigKeys.showExitConfirmationOnPaymentScreen: true,
//       // PayUCheckoutProConfigKeys.paymentModesOrder: paymentModesOrder,
//       PayUCheckoutProConfigKeys.merchantResponseTimeout: 5000,
//       // PayUCheckoutProConfigKeys.autoSelectOtp: true,
//       PayUCheckoutProConfigKeys.enforcePaymentList: enforcePaymentList,
//       PayUCheckoutProConfigKeys.waitingTime: 30000,
//       PayUCheckoutProConfigKeys.autoApprove: true,
//       PayUCheckoutProConfigKeys.merchantSMSPermission: true,
//       PayUCheckoutProConfigKeys.showCbToolbar: true,
//     };
//     return payUCheckoutProConfig;
//   }
// }
