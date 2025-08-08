import 'dart:convert';
import 'dart:io';

import 'package:delivoo/Api_Provider.dart';
import 'package:delivoo/Auth/MobileNumber/UI/phone_number.dart';
import 'package:delivoo/Auth/Registration/UI/register_page.dart';
import 'package:delivoo/CommonWidget.dart';
import 'package:delivoo/HomeOrderAccount/home_order_account.dart';
import 'package:delivoo/Models/CityListModel.dart';
import 'package:delivoo/Models/LoadCityModel.dart';
import 'package:delivoo/Models/LoadLocationModel.dart';
import 'package:delivoo/Models/LoadStateModel.dart';
import 'package:delivoo/Models/PIncodeModel.dart';
import 'package:delivoo/Models/UserProfileModel.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:delivoo/AppConstants.dart' as Appconstants;
import 'package:flutter/services.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:platform_device_id_plus/platform_device_id.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../Models/CityListModel.dart';
import '../Models/CityListModel.dart';
import '../Models/CityListModel.dart';
import '../Models/GetMapFlag.dart';
import '../Models/check_refferal_available_model.dart';
import '../Pages/get_location_on_start.dart';

String? _fcmToken;
String? _os;
String? _deviceId;

class LoginProvider extends ChangeNotifier with DiagnosticableTreeMixin {
  final ApiProvider _apiProvider = ApiProvider();
  // final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  // MobileInput mobileInput = MobileInput();
  String? mno;
  get getmno => mno;
  late String comid;
  get getid => comid;

  CityListModel? cityListModel;

  LoadState? state;
  LoadState? get getstate => state;

  LoadCity? city;
  LoadCity? get getcity => city;

  Loadlocation? loc;
  Loadlocation? get getloc => loc;

  String? OTP;
  bool isnumselected = false;

  UserProfileModel? profile;
  PincodeModel? pincodes;
  CheckReferalavailableModel? checkReferalavailable;
  var totalOnlineOrders = "";

  refresh() {
    notifyListeners();
  }

  sendOtp(String mobile, appid) async {
    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        showLoading();
        //String requestJson = jsonEncode({'Mobileno': mobile, "appid": "1"});
        String requestJson = jsonEncode(
            {"membermobileno": mobile, "ApplicationId": appid, "appid": "1"});
        mno = mobile;
        SharedPreferences prefs = await SharedPreferences.getInstance();
        prefs.setString("mob_no", mobile);
        notifyListeners();
        final response =
            await _apiProvider.post(Appconstants.SEND_OTP, requestJson);
        print('---------------sendotp');
        // if (response["d"] == '1') {
        // Navigator.pushNamed(context, LoginRoutes.verification);
        print('response is ${response["d"]}');
        // }
        print('zzzzzzzzzzzzzzzzz');
        hideLoading();
        return response["d"];
      }
    } on SocketException catch (e) {
      noInternet();
      // showMessage('No Internet connection');
      print(e);
    } on Exception catch (e) {
      print(e.toString());
    }
  }

  verifyOtp(String mobile, String otp, BuildContext context, address) async {
    //showLoading(); //issue with showloading
    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        showLoading();
        String requestJson = jsonEncode({"Mobilenonew": mobile, "votp": otp});
        // APIHandler(context, AppConstants.Login, requestJson, this).auth();
        final response =
            await _apiProvider.post(Appconstants.VERIFY_OTP, requestJson);
        print('---------------verifyotp');

        //hideLoading();
        if (response["d"] == '0') {
          hideLoading();
          print(response["d"] + "wrong otp");
          showMessage('Wrong OTP');
        } else if (response["d"] == '') {
          hideLoading();
          Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (context) => RegisterPage(mobile)),
              (route) => false);
        } else {
          comid = response["d"];
          SharedPreferences prefs = await SharedPreferences.getInstance();
          prefs.setString("com_id", comid);
          print(comid + '-----------id');
          hideLoading();
          // Future.delayed(Duration(milliseconds: 1000), () {
          address == null || address == ""
              ? Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (context) => HomeOrderAccount()),
                  (route) => false)
              : Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (context) => MyCurrentLocation(flag: false)),
                  (route) => false);
        }
      }
      // });
    } on SocketException catch (e) {
      noInternet();
      // showMessage('No Internet connection');
      print(e);
    } on Exception catch (e) {
      print(e.toString());
    }
  }

  getOTP() async {
    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        showLoading();
        SharedPreferences prefs = await SharedPreferences.getInstance();
        String requestJson =
            jsonEncode({"Mobileno": prefs.getString("mob_no")});
        final response =
            await _apiProvider.post(Appconstants.GET_OTP, requestJson);
        print('---------------getotp');

        OTP = response["d"];
        hideLoading();
      }
    } on SocketException catch (e) {
      noInternet();
      // showMessage('No Internet connection');
      print(e);
    } on Exception catch (e) {
      print(e.toString());
    }
  }

  checkAvailablePincode(pincode) async {
    print('pincode is $pincode');

    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        String requestJson = jsonEncode({"Pincode": pincode});
        showLoading();
        final response = await _apiProvider.post(
            Appconstants.CHECK_AVAILABLE_PINCODE, requestJson);
        print('---------------pincode location check ');
        print("pincode availability    ${response["d"]}");
        if (response["d"].length == 0) {
          hideLoading();
          pincodes = null;
          showMessage(
              ' "Apologies...we are currently not serving the area of the PIN code entered!"');
          return "0";
        } else {
          hideLoading();
          pincodes = PincodeModel.fromJson(response);
          notifyListeners();
        }
        notifyListeners();
      }
    } on SocketException catch (e) {
      noInternet();
      print(e);
    }
  }

  register({lat, long, name, pincode, email, refferal, cityId, mapaddress}) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        showLoading();
        prefs.getString("mob_no");
        String requestJson = jsonEncode({
          "Mobileno": prefs.getString("mob_no"),
          "Latitude": lat.toString(),
          "Logitude": long.toString(),
          "MemberName": name,
          "Pincode": pincode,
          "Email_id": email,
          "referralcode": refferal ?? "",
          "cityId": cityId,
          "mapaddress": mapaddress,
          "LocationId": prefs.getString('LocationId')
        });
        print("Register $requestJson");
        final response =
            await _apiProvider.post(Appconstants.REGISTER_NEW, requestJson);
        print('---------------register');

        if (response["d"] != '') {
          prefs.setString("com_id", response["d"]);
          return 'success';
        } else {
          showMessage(response["Message"]);
        }
        hideLoading();
      }
    } on SocketException catch (e) {
      noInternet();
      // showMessage('No Internet connection');
      print(e);
    } on Exception catch (e) {
      print(e.toString());
    }
  }

  getMapFlag() async {

    GetMapFlag? mGetMapFlag;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        showLoading();
        prefs.getString("mob_no");
        String requestJson = jsonEncode({});
        final response =
        await _apiProvider.post(Appconstants.GET_MAP_FLAG_URL, requestJson);
        if (response != null && response["d"] != null) {
          mGetMapFlag = GetMapFlag.fromJson(response);
          return mGetMapFlag.d?.MapName;
        }
      }
    } on SocketException catch (e) {
      noInternet();
      print(e);
    } on Exception catch (e) {
      print(e.toString());
    }
  }

  checkpincode(pincode) async {
    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        String requestJson = jsonEncode({"Pincode": pincode});
        final response =
            await _apiProvider.post(Appconstants.CHECK_PINCODE, requestJson);
        print('---------------pincode');
        if (response["d"] != "1") {
          showMessage(
              ' "Apologies...we are currently not serving the area of the PIN code "${pincode}" entered!"');
          return "0";
        }
        notifyListeners();
      }
    } on SocketException {
      noInternet();
    } on Exception catch (e) {
      print(e.toString());
    }
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(StringProperty('mno', getmno));
  }

  getdevicedetails(loginstatus) async {
    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {

        PackageInfo packageInfo = await PackageInfo.fromPlatform();

        SharedPreferences prefs = await SharedPreferences.getInstance();
        String requestJson = jsonEncode({
          "membershipno": prefs.getString("com_id"),
          "MobileNo": prefs.getString("mob_no"),
          "MobiledevId": _deviceId,
          "fcmId": _fcmToken,
          "Os": _os == 'Android' ? "1" : "2",
          "appid": "1",
          "loginstatus": loginstatus,
          "appversion": packageInfo.version
        });
        print(requestJson);
        final response =
            await _apiProvider.post(Appconstants.DEVICE_DETAILS, requestJson);
        print('$response---------------device details');
      }
    } on SocketException catch (e) {
      noInternet();
      // showMessage('No Internet connection');
      print(e);
    } on Exception catch (e) {
      print(e.toString());
    }
  }

  loadState() async {
    try {
      String requestJson = jsonEncode({"status": "5"});
      final response =
          await _apiProvider.post(Appconstants.LOAD_STATE, requestJson);

      state = LoadState.fromJson(response);
      notifyListeners();
      print(state);
    } on Exception catch (e) {
      print("bbbbbbbbbbbbbbbbb");
      print(e);
    }
  }

  loadcity(String? stateid) async {
    try {
      String requestJson = jsonEncode({"status": "5", "State_Id": stateid});
      final response =
          await _apiProvider.post(Appconstants.LOAD_CITY, requestJson);

      city = LoadCity.fromJson(response);
      notifyListeners();
      print(city);
    } on SocketException catch (e) {
      noInternet();
      // showMessage('No Internet connection');
      print(e);
    } on Exception catch (e) {
      print("bbbbbbbbbbbbbbbbb");
      print(e);
    }
  }

  loadlocation(String? cityid) async {
    try {
      String requestJson = jsonEncode({"status": "5", "City_Id": cityid});
      final response =
          await _apiProvider.post(Appconstants.LOAD_LOCATION, requestJson);

      loc = Loadlocation.fromJson(response);
      notifyListeners();
      print(loc);
    } on SocketException catch (e) {
      noInternet();
      // showMessage('No Internet connection');
      print(e);
    } on Exception catch (e) {
      print("bbbbbbbbbbbbbbbbb");
      print(e);
    }
  }

  getFcmToken() async {
    await FirebaseMessaging.instance.getToken().then((value) {
      _fcmToken = value;
      print("fcm token->  $_fcmToken");
    });
    return _fcmToken;
  }

  getOS() {
    if (Platform.isAndroid) {
      _os = 'Android';
    } else if (Platform.isIOS) {
      _os = 'IOS';
    }
    print('Os -> $_os');
    return _os;
  }

  initPlatformState() async {
    String? deviceId;
    try {
      deviceId = await PlatformDeviceId.getDeviceId;
    } on PlatformException {
      deviceId = 'Failed to get deviceId.';
    }
    _deviceId = deviceId;
    print("deviceId-> $_deviceId");
    return _deviceId;
  }

  pushNotifications(fcmToken, deviceId, os) async {
    try {
      showLoading();
      // final response = await _apiProvider.put(
      //     Notifications + fcmToken + "/" + deviceId + "/" + os, null);
      // if (response != null) {
      //   hideLoading();
      //   notifyListeners();
      // }
    } on Exception catch (e) {
      print(e.toString());
    }
  }

  getprofile() async {
    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        SharedPreferences prefs = await SharedPreferences.getInstance();
        String requestJson = jsonEncode({
          "Action": "5",
          "membeshipno": prefs.getString("com_id"),
          "MemberName": "",
          "EmailId": ""
        });
        final response =
            await _apiProvider.post(Appconstants.GET_PROFILE, requestJson);
        profile = UserProfileModel.fromJson(response);
        notifyListeners();
      }
    } on SocketException catch (e) {
      noInternet();
      // showMessage('No Internet connection');
      print(e);
    } on Exception catch (e) {
      print(e.toString());
    }
  }

  updateprofile(name, email) async {
    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        SharedPreferences prefs = await SharedPreferences.getInstance();
        String requestJson = jsonEncode({
          "Action": "2",
          "membeshipno": prefs.getString("com_id"),
          "MemberName": "$name",
          "EmailId": "$email"
        });
        final response =
            await _apiProvider.post(Appconstants.GET_PROFILE, requestJson);
        profile = UserProfileModel.fromJson(response);
        notifyListeners();
      }
    } on SocketException catch (e) {
      noInternet();
      // showMessage('No Internet connection');
      print(e);
    } on Exception catch (e) {
      print(e.toString());
    }
  }

  deleteprofile() async {
    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        SharedPreferences prefs = await SharedPreferences.getInstance();
        String requestJson =
            jsonEncode({"membershipId": prefs.getString("com_id")});
        final response =
            await _apiProvider.post(Appconstants.DELETE_USER, requestJson);
        profile = UserProfileModel.fromJson(response);
        notifyListeners();
      }
    } on SocketException catch (e) {
      noInternet();
      // showMessage('No Internet connection');
      print(e);
    } on Exception catch (e) {
      print(e.toString());
    }
  }

  logoutUser(context) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.clear();
    print(prefs.getString('com_id'));

    Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (BuildContext context) => PhoneNumber()),
            (Route<dynamic> route) => false
    );

    // Navigator.of(context).pushAndRemoveUntil(
    //     MaterialPageRoute(builder: (context) => PhoneNumber()), (Route route) => false);
  }

  checkRefferalCode(refferalCode) async {
    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        String requestJson = jsonEncode({"ReferenceCode": refferalCode});
        final response = await _apiProvider.post(
            Appconstants.CHECKREFFERAL_CODE, requestJson);
        notifyListeners();
        return response["d"];
      }
    } on SocketException {
      noInternet();
    } on Exception catch (e) {
      print(e.toString());
    }
  }

  checkAvailableRefferalNew({cityId, pincode, membershipno}) async {
    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        String requestJson = jsonEncode({
          "CityId":cityId,
          "Pincode": pincode,
          "coupontype": "1",
          "membershipno": membershipno,
          "Action": "1"
        });
        showLoading();
        final response = await _apiProvider.post(
            Appconstants.CHECK_AVAILABLE_REFFERAL_NEW, requestJson);
        print('---------------pincode location check ');
        print("pincode availability    ${response["d"]}");
        if (response != null && response["d"] != null) {
          hideLoading();
          checkReferalavailable = CheckReferalavailableModel.fromJson(response);
          notifyListeners();
          return "0";
        } else {
          hideLoading();
        }
        notifyListeners();
      }
    } on SocketException catch (e) {
      noInternet();
      print(e);
    }
  }

  checkAvailableRefferal({pincode, membershipno}) async {
    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        String requestJson = jsonEncode({
          "Pincode": pincode,
          "coupontype": "1",
          "membershipno": membershipno,
          "Action": "1"
        });
        showLoading();
        final response = await _apiProvider.post(
            Appconstants.CHECK_AVAILABLE_REFFERAL, requestJson);
        print('---------------pincode location check ');
        print("pincode availability    ${response["d"]}");
        if (response != null && response["d"] != null) {
          hideLoading();
          checkReferalavailable = CheckReferalavailableModel.fromJson(response);
          notifyListeners();
          return "0";
        } else {
          hideLoading();
        }
        notifyListeners();
      }
    } on SocketException catch (e) {
      noInternet();
      print(e);
    }
  }

  getCityList() async {
    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        String requestJson = jsonEncode({"storetype": "1"});
        showLoading();
        final response = await _apiProvider.post(
            Appconstants.GET_CITY_LIST, requestJson);
        if (response != null && response['d'] != null) {
          cityListModel?.cityData = [];
          cityListModel = CityListModel.fromJson(response);
        } else {
          cityListModel?.cityData = [];
        }
        hideLoading();
        notifyListeners();
      }
    } on SocketException catch (e) {
      noInternet();
      print(e);
      notifyListeners();
    }
  }
}
