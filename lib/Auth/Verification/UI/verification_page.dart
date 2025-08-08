// ignore_for_file: unnecessary_brace_in_string_interps, unused_field, unused_element

import 'dart:async';

import 'package:animation_wrappers/animation_wrappers.dart';
import 'package:delivoo/Api_Provider.dart';
import 'package:delivoo/Components/bottom_bar.dart';
import 'package:delivoo/Locale/locales.dart';
import 'package:delivoo/Providers.dart/login_provider.dart';
import 'package:delivoo/Themes/colors.dart';
import 'package:delivoo/geo/LocationProvider.dart';
import 'package:flutter/material.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:provider/provider.dart';
import '../../../main.dart';
//import 'package:sms_otp_auto_verify/sms_otp_auto_verify.dart';

//Verification page that sends otp to the phone number entered on phone number page
LoginProvider loginProvider = LoginProvider();

class VerificationPage extends StatelessWidget {
  //final VoidCallback onVerificationDone;
  final String mobile;

  //const VerificationPage(this.mobile);
  VerificationPage(this.mobile);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: Colors.black,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        automaticallyImplyLeading: true,
        backgroundColor: Colors.transparent,
        elevation: 0.0,
        title: Text(
          AppLocalizations.of(context)!.verification!,
          style: Theme.of(context).textTheme.bodyMedium!.copyWith(fontSize: 16.7),
        ),
      ),
      body: FadedSlideAnimation(
        child: OtpVerify(mobile),
        beginOffset: Offset(0, 0.3),
        endOffset: Offset(0, 0),
        slideCurve: Curves.linearToEaseOut,
      ),
    );
  }
}

//otp verification class
class OtpVerify extends StatefulWidget {
  //final VoidCallback onVerificationDone;
  final String mobileno;

  //const OtpVerify(this.mobileno);
  OtpVerify(this.mobileno);

  @override
  _OtpVerifyState createState() => _OtpVerifyState();
}

class _OtpVerifyState extends State<OtpVerify> {
  final TextEditingController _controller = TextEditingController(
      text: navigatorKey.currentState?.context
                  .read<LoginProvider>()
                  .isnumselected ==
              true
          ? navigatorKey.currentState?.context.watch<LoginProvider>().OTP
          : '');
  String _comingSms = 'Unknown';
  ApiProvider apiProvider = ApiProvider();

  bool isDialogShowing = false;
  int _counter = 60;
  late Timer _timer;
  LoginProvider loginProvider = LoginProvider();

  var isdone = false;

  int _otpCodeLength = 6;
  bool _isLoadingButton = false;
  bool _enableButton = false;
  String _otpCode = "";
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  final intRegex = RegExp(r'\d+', multiLine: true);
  String? signature;

  _startTimer() async {
    //shows timer
    _counter = 60; //time counter

    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      setState(() {
        _counter > 0 ? _counter-- : _timer.cancel();
      });
    });
  }

  @override
  void initState() {
    super.initState();
    // _controller =
    //     TextEditingController(text: context.watch<LoginProvider>().OTP);
    _getSignatureCode();
    _startListeningSms();
    if (context.read<LoginProvider>().isnumselected == true) {
      context.read<LoginProvider>().verifyOtp(widget.mobileno, _controller.text,
          context, context.read<LocationServiceProvider>().getAddress);
    }
    verifyPhoneNumber();
  }

  void verifyPhoneNumber() {
    //verify phone number method using otp
    _startTimer();
  }

  _getSignatureCode() async {
    // signature = await SmsVerification.getAppSignature();
    print("signature $signature");
  }

  _startListeningSms() {
    // SmsVerification.startListeningSms().then((message) {
    //   setState(() {
    //     _otpCode = SmsVerification.getCode(message, intRegex);
    //     _controller.text = _otpCode;
    //     _onOtpCallBack(_otpCode, true);
    //   });
    // });
  }

  _onOtpCallBack(String otpCode, bool isAutofill) {
    //setState(() {
    this._otpCode = otpCode;
    if (otpCode.length == _otpCodeLength && isAutofill) {
      _enableButton = false;
      _isLoadingButton = true;
    } else if (otpCode.length == _otpCodeLength && !isAutofill) {
      _enableButton = true;
      _isLoadingButton = false;
    } else {
      _enableButton = false;
    }
    //  });
  }

  @override
  void dispose() {
    _timer.cancel();
    // SmsVerification.stopListening();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        ListView(
          children: <Widget>[
            Divider(
              color: Theme.of(context).cardColor,
              thickness: 8.0,
            ),
            Padding(
              padding: EdgeInsets.all(20.0),
              child: Text(
                AppLocalizations.of(context)!.enterVerification!,
                style: Theme.of(context).textTheme.headlineSmall!.copyWith(
                    fontSize: 22,
                    color: Theme.of(context).secondaryHeaderColor),
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.0),
              child: PinCodeTextField(
                appContext: context,
                pastedTextStyle: TextStyle(
                  color: Colors.green.shade600,
                  fontWeight: FontWeight.bold,
                ),
                length: 6,
                obscureText: false,
                animationType: AnimationType.fade,
                pinTheme: PinTheme(
                  shape: PinCodeFieldShape.box,
                  borderRadius: BorderRadius.circular(10),
                  fieldHeight: 50,
                  fieldWidth: 40,
                  inactiveFillColor: Colors.white,
                  inactiveColor: Colors.grey,
                  selectedColor: Colors.black,
                  selectedFillColor: Colors.white,
                  activeFillColor: Colors.white,
                  activeColor: Colors.black,
                ),
                cursorColor: Colors.black,
                animationDuration: Duration(milliseconds: 300),
                enableActiveFill: true,
                controller: _controller,
                keyboardType: TextInputType.number,
                boxShadows: [
                  BoxShadow(
                    offset: Offset(0, 1),
                    color: Colors.black12,
                    blurRadius: 10,
                  )
                ],
                onCompleted: (v) {
                  context.read<LoginProvider>().verifyOtp(
                      widget.mobileno,
                      _controller.text,
                      context,
                      context.read<LocationServiceProvider>().getAddress);
                  //do something or move to next screen when code complete
                },
                onChanged: (value) {
                  print(value);
                  /* setState(() {
                    print('$value');
                  }); */
                },
              ), /* EntryField(
                controller: _controller,
                readOnly: false,
                label: AppLocalizations.of(context)!.verificationCode,
                maxLength: 6,
                keyboardType: TextInputType.number,
                //initialValue: '------',
              ), */
            ),
          ],
        ),
        PositionedDirectional(
          bottom: 0,
          start: 0,
          end: 0,
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16.0),
                    child: Text(
                      '$_counter sec',
                      style: Theme.of(context).textTheme.headlineMedium,
                    ),
                  ),
                  _counter < 1
                      ? TextButton(
                          style: TextButton.styleFrom(
                            shape:
                                RoundedRectangleBorder(side: BorderSide.none),
                            padding: EdgeInsets.all(24.0),
                          ),
                          child: Text(
                            AppLocalizations.of(context)!.resend!,
                            style: TextStyle(fontSize: 16.7, color: kMainColor),
                          ),
                          onPressed: _counter < 1
                              ? () {
                                  // initSmsListener();
                                  _controller.text = '';
                                  _startListeningSms();
                                  _startTimer();
                                  context
                                      .read<LoginProvider>()
                                      .sendOtp(widget.mobileno, signature);
                                }
                              : null)
                      : Container(),
                ],
              ),
              BottomBar(
                  text: AppLocalizations.of(context)!.continueText,
                  onTap: () {
                    loginProvider.verifyOtp(
                        widget.mobileno,
                        _controller.text,
                        context,
                        context.read<LocationServiceProvider>().getAddress);
                    //widget.onVerificationDone();
                  }),
            ],
          ),
        )
      ],
    );
  }
}
