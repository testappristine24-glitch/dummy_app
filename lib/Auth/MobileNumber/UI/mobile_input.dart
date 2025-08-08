// ignore_for_file: must_be_immutable, non_constant_identifier_names, unused_local_variable

import 'dart:convert';
import 'package:country_code_picker/country_code_picker.dart';
import 'package:delivoo/Api_Provider.dart';
import 'package:delivoo/Auth/Verification/UI/verification_page.dart';
import 'package:delivoo/CommonWidget.dart';
import 'package:delivoo/Locale/locales.dart';
import 'package:delivoo/Providers.dart/login_provider.dart';
import 'package:delivoo/Themes/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
//import 'package:sms_otp_auto_verify/sms_otp_auto_verify.dart';

class MobileInput extends StatefulWidget with ChangeNotifier {
  late String m;
  get getm => m;

  @override
  _MobileInputState createState() => _MobileInputState();
}

class _MobileInputState extends State<MobileInput> {
  ApiProvider apiProvider = ApiProvider();

  // MobileNumberPicker mobileNumber = MobileNumberPicker();
  // MobileNumber mobileNumberObject = MobileNumber();

  final TextEditingController _controller = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  fk() => _formKey;
  String? isoCode;
  int? m_no;
  late String m;
  LoginProvider loginProvider = LoginProvider();

  get inputFormatters => null;

  String? signature;
  @override
  void initState() {
    super.initState();
    _getSignatureCode();
    context.read<LoginProvider>().isnumselected = false;
    // WidgetsBinding.instance
    //     .addPostFrameCallback((timeStamp) => mobileNumber.mobileNumber());
    // mobileNumber.getMobileNumberStream.listen((event) {
    //   if (event!.states == PhoneNumberStates.PhoneNumberSelected) {
    //     setState(() {
    //       mobileNumberObject = event;
    //     });
    //     _controller.text = mobileNumberObject.phoneNumber!;
    //     context.read<LoginProvider>().isnumselected = true;
    //   }
    // });
  }

  _getSignatureCode() async {
    //signature = await SmsVerification.getAppSignature();
    print("signature $signature");
  }

  @override
  void dispose() {
    // mobileNumber.dispose();
    _controller.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.baseline,
      textBaseline: TextBaseline.alphabetic,
      children: <Widget>[
        CountryCodePicker(
          onChanged: (value) {
            isoCode = value.code;
          },
          builder: (value) => buildButton(value),
          initialSelection: '+91',
          textStyle: Theme.of(context).textTheme.bodyMedium,
          showFlag: false,
          showFlagDialog: true,
          favorite: ['+91', 'US'],
        ),
        SizedBox(
          width: 10.0,
        ),
        //takes phone number as input
        Expanded(
          child: Form(
            key: _formKey,
            // autovalidateMode: AutovalidateMode.onUserInteraction,
            child: TextFormField(
              style: Theme.of(context).textTheme.headlineMedium,
              controller: _controller,
              keyboardType: TextInputType.number,
              readOnly: false,
              decoration: InputDecoration(
                  border: InputBorder.none,
                  hintText: AppLocalizations.of(context)!.mobileText,
                  hintStyle: TextStyle(color: Colors.grey),
                  counterText: ''),
              //hint: AppLocalizations.of(context)!.mobileText,
              //maxLength:  11 ,
              onChanged: (value) async {
                context.read<LoginProvider>().isnumselected = false;

                if (value.indexOf('1') == 0) {
                  setState(() {
                    m_no = 11;
                  });
                } else
                  setState(() {
                    m_no = 10;
                  });
                print(m_no);
              },

              inputFormatters: <TextInputFormatter>[
                FilteringTextInputFormatter.digitsOnly,
                LengthLimitingTextInputFormatter(m_no),
              ],

              validator: (value) {
                if (value!.isEmpty) {
                  //showMessage('Enter a Mobile Number');
                  return 'Enter a Mobile Number';
                }
                if (value.length < 10 || value.startsWith(RegExp(r'[0]'))) {
                  //showMessage('Enter a valid Mobile Number');
                  return 'Invalid Mobile Number';
                }
                return null;
              },
              //border: InputBorder.none,
            ),
          ),
        ),

        //if phone number is valid, button gets enabled and takes to register screen
        TextButton(
          child: Text(
            AppLocalizations.of(context)!.continueText!,
            style: Theme.of(context).textTheme.bodyLarge,
          ),
          style: TextButton.styleFrom(
            padding:
                const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
            backgroundColor: kMainColor,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30.0),
            ),
          ),
          onPressed: () async {
            if (_formKey.currentState!.validate()) {
              print(_controller.text.substring(_controller.text.length - 10));

              widget.m =
                  _controller.text.substring(_controller.text.length - 10);

              var result = await context
                  .read<LoginProvider>()
                  .sendOtp(_controller.text, signature);
              if (context.read<LoginProvider>().isnumselected == true) {
                await context.read<LoginProvider>().getOTP();
              }
              if (result == '1') {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => VerificationPage(_controller.text),
                    ));
              } else {
                showMessage(
                    'This Number is already registered with Kisanserv($result).Kindly use another Number.');
              }
            }
            //FocusScope.of(context).unfocus();
          },
        ),
      ],
    );
  }

  /* getmobileno() {
    m = _controller.text;
    return m;
  } */

  buildButton(CountryCode? isoCode) {
    return Row(
      children: <Widget>[
        Text(
          '$isoCode',
          style: Theme.of(context).textTheme.bodyMedium,
        ),
      ],
    );
  }

  authUser() {
    if (_formKey.currentState!.validate()) {
      String requestJson = jsonEncode({
        'membermobileno': _controller.text,
      });
      //Navigator.pushNamed(context, LoginRoutes.signUp);
      // APIHandler(context, AppConstants.Login, requestJson, this).auth();

    }
  }
}
