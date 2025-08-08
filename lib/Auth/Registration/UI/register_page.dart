// ignore_for_file: must_be_immutable, unused_local_variable, body_might_complete_normally_nullable

import 'package:animation_wrappers/animation_wrappers.dart';
import 'package:delivoo/Auth/login_navigator.dart';
import 'package:delivoo/CommonWidget.dart';
import 'package:delivoo/Components/bottom_bar.dart';
import 'package:delivoo/Components/entry_field.dart';
import 'package:delivoo/Locale/locales.dart';
import 'package:delivoo/Providers.dart/login_provider.dart';
import 'package:delivoo/geo/LocationProvider.dart';
import 'package:dropdown_button2/dropdown_button2.dart';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../Models/CityListModel.dart';
import '../../../Pages/get_location_on_start.dart';
import '../../../Themes/colors.dart';

//register page for registration of a new user
class RegisterPage extends StatelessWidget {

  late String mobile;
  get getmobile => mobile;

  RegisterPage(this.mobile);
  @override
  Widget build(BuildContext context) {
    //final loginProvider = context.read<LoginProvider>();
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: true,
        title: Text(
          AppLocalizations.of(context)!.register!,
          style: Theme.of(context).textTheme.bodyMedium!
              .copyWith(fontSize: 16.7, color: Colors.white),
        ),
      ),

      //this column contains 3 textFields and a bottom bar
      body: FadedSlideAnimation(
        child: RegisterForm(mobile),
        beginOffset: Offset(0, 0.3),
        endOffset: Offset(0, 0),
        slideCurve: Curves.linearToEaseOut,
      ),
    );
  }
}

class RegisterForm extends StatefulWidget {
  String? mobile;
  RegisterForm(this.mobile);
  @override
  _RegisterFormState createState() => _RegisterFormState();
}

class _RegisterFormState extends State<RegisterForm> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _pincodeController = TextEditingController();
  final TextEditingController _refferalController = TextEditingController();
  String? svalue, cvalue, location, account, tev;
  List? stateitems = loginProvider.getstate?.d!;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  int i = 0;
  String? selectedValue;
  String? selectedCityId = "";

  @override
  void initState()  {
    getLocation();
    selectedCityId= "";
    super.initState();
    getCityList();
    // _registerBloc = BlocProvider.of<RegisterBloc>(context);
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _refferalController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);

    var cityList = context.watch<LoginProvider>().cityListModel;

    return Stack(
      children: [
        ListView(
          children: <Widget>[
            Padding(
              padding: EdgeInsets.fromLTRB(12.0, 0, 12.0, 80),
              child: Form(
                key: _formKey,
                autovalidateMode: AutovalidateMode.onUserInteraction,
                child: Column(
                  children: <Widget>[
                    Divider(
                      color: Theme.of(context).cardColor,
                      thickness: 8.0,
                    ),
                    EntryField(
                      textCapitalization: TextCapitalization.words,
                      keyboardType: TextInputType.name,
                      controller: _nameController,
                      //initialValue: 'Samantha Smith',
                      label: 'Name' + '*',
                      image: 'images/icons/ic_name.png',
                      validator: (value) {
                        if (value!.isEmpty || value.startsWith(RegExp(r'[\s]')))
                          return 'Enter Your Name';
                        else if (RegExp(r'[!@#<>$?":_`~;[\]\\|=+)(*&^%0-9-]')
                            .hasMatch(value))
                          return 'Enter correct name';
                        else
                          return null;
                      },
                    ),
                    EntryField(
                      textCapitalization: TextCapitalization.none,
                      controller: _emailController,
                      label: 'Email',
                      image: 'images/icons/ic_mail.png',
                      keyboardType: TextInputType.emailAddress,
                      //initialValue: 'samanthasmith@mail.com',
                      validator: (value) {
                        if (value == null || value.isEmpty || value == '')
                          return null;
                        else {
                          if (!value.contains('@') || !value.contains('.')) {
                            return "Please correct your Email";
                          }
                        }
                      },
                    ),
                    EntryField(
                      enabled: false,
                      style: TextStyle(color: Colors.grey, fontSize: 13),
                      label: AppLocalizations.of(context)!
                          .mobileNumber!
                          .toUpperCase(),
                      image: 'images/icons/ic_phone.png',
                      keyboardType: TextInputType.number,
                      initialValue: (widget.mobile),
                    ),
                    Padding(padding: EdgeInsets.only(left: 8, top: 10),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Image.asset(
                            'images/skyline.png',
                            width: 22.0,
                            height: 22.0,
                            fit: BoxFit.cover,
                          ),
                          Padding(padding: EdgeInsets.only(left: 13, top: 3),
                            child: Text(
                              'City',
                              style: TextStyle(
                                fontSize: 10,
                                fontWeight: FontWeight.w600,
                                color: Colors.black,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),)
                        ],
                      ),),
                    cityList == null
                        ? SizedBox.shrink()
                        : Padding(padding: EdgeInsets.only(left: 30, right: 10),
                      child: Container(
                        child: DropdownButtonHideUnderline(
                          child: DropdownButton2<String>(
                            isExpanded: true,
                            hint: Row(
                              children: [
                                Expanded(
                                  child: Text(
                                    'Select ',
                                    style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w500,
                                      color: Colors.black,
                                    ),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ],
                            ),
                            items: cityList.cityData!.map((CityData item) => DropdownMenuItem<String>(
                              value: item.CityName,
                              child: Text(
                                item.CityName!,
                                style: const TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black,
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                            )).toList(),
                            value: selectedValue,
                            onChanged: (String? value) async {
                              setState(() {
                                for (int i = 0; i < cityList.cityData!.length; i++) {
                                  if(cityList.cityData?[i].CityName == value) {
                                    selectedCityId = cityList.cityData?[i].CityId;
                                  }
                                }
                                selectedValue = value;
                              });

                              await context
                                  .read<LoginProvider>()
                                  .checkAvailableRefferalNew(
                                  cityId: selectedCityId,
                                  pincode: _pincodeController.text,
                                  membershipno: "");

                            },
                            buttonStyleData: ButtonStyleData(
                              height: 50,
                              padding: const EdgeInsets.only(left: 0, right: 14),
                            ),
                            iconStyleData: const IconStyleData(
                              icon: Icon(
                                Icons.arrow_forward_ios_outlined,
                              ),
                              iconSize: 14,
                              iconEnabledColor: Colors.black,
                              iconDisabledColor: Colors.grey,
                            ),
                            dropdownStyleData: DropdownStyleData(
                              maxHeight: 200,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(14),
                                color: Colors.white,
                              ),
                              offset: const Offset(0, 0),
                              scrollbarTheme: ScrollbarThemeData(
                                radius: const Radius.circular(40),
                                thickness: MaterialStateProperty.all<double>(6),
                                thumbVisibility: MaterialStateProperty.all<bool>(true),
                              ),
                            ),
                            menuItemStyleData: const MenuItemStyleData(
                              height: 40,
                              padding: EdgeInsets.only(left: 10, right: 14),
                            ),
                          ),
                        ),
                      ),),
                    cityList == null
                        ? SizedBox.shrink() :
                    Divider(
                      color: Theme.of(context).cardColor,
                      thickness: 1.0,
                    ),
                    context
                        .watch<LoginProvider>()
                        .checkReferalavailable
                        ?.d
                        .couponcode !=
                        null
                        ? EntryField(
                      textCapitalization: TextCapitalization.none,
                      controller: _refferalController,
                      label: 'Refferal Code',
                      icon: Icon(
                        Icons.discount,
                        color: kMainColor,
                      ),
                    )
                        : SizedBox.shrink(),
                  ],
                ),
              ),
            ),

            //continue button bar
          ],
        ),
        PositionedDirectional(
          bottom: 0,
          start: 0,
          end: 0,
          child: BottomBar(
              text: AppLocalizations.of(context)!.continueText,
              onTap: () async {
                SharedPreferences prefs = await SharedPreferences.getInstance();

                print("refferal ${_refferalController.text}");
                if (_refferalController.text.isNotEmpty) {
                  var refferalResult = await context
                      .read<LoginProvider>()
                      .checkRefferalCode(_refferalController.text);
                  if (await refferalResult == "1") {
                    await registerApis();
                  } else {
                    showDialog(
                        context: context,
                        builder: (context) => Center(
                            child: AlertDialog(
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20)),
                              backgroundColor: Theme.of(context).cardColor,
                              content: Material(
                                color: Theme.of(context).cardColor,
                                child: Text("Invalid Refferal Code",
                                    textAlign: TextAlign.center,
                                    style: Theme.of(context).textTheme.bodyMedium),
                              ),
                              actions: [
                                ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                        backgroundColor: Colors.red),
                                    onPressed: () {
                                      Navigator.pop(context);
                                    },
                                    child: Text("No")),
                                ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                        backgroundColor: Colors.green),
                                    onPressed: () async {
                                      await registerApis();
                                    },
                                    child: Text("Continue"))
                              ],
                            )));
                  }
                } else if (_refferalController.text.isEmpty) {
                  await registerApis();
                }
              }),
        )
      ],
    );
  }

  registerApis() async {
    // SharedPreferences prefs = await SharedPreferences.getInstance();
    // var response = await context
    //     .read<LoginProvider>()
    //     .checkAvailablePincode(_pincodeController.text);
    // print(_refferalController.text);
    // if (response != "0") {
    //   if (await prefs.getString('LocationId') == null) {
    //     showMessage("Select Location");
    //   } else if (_formKey.currentState!.validate()) {
    //     var result = await context.read<LoginProvider>().register(
    //           lat: context.read<LocationServiceProvider>().getLatitude(),
    //           long: context.read<LocationServiceProvider>().getLongitude(),
    //           name: _nameController.text,
    //           pincode: _pincodeController.text,
    //           email: _emailController.text,
    //           refferal: _refferalController.text,
    //         );
    //     if (result == 'success') {
    //       Navigator.pushAndRemoveUntil(
    //           context,
    //           MaterialPageRoute(builder: (context) => MyCurrentLocation()),
    //           (route) => false);
    //       print("sucesss");
    //     }
    //   }
    // }

    if (_formKey.currentState!.validate()) {
      print("${selectedCityId}");
      if (selectedCityId == "") {
        showMessage("Select City");
      } else {
        var result = await context.read<LoginProvider>().register(
            lat: context.read<LocationServiceProvider>().getLatitude(),
            long: context.read<LocationServiceProvider>().getLongitude(),
            name: _nameController.text,
            pincode: _pincodeController.text,
            email: _emailController.text,
            refferal: _refferalController.text,
            cityId: selectedCityId
        );
        if (result == 'success') {
          Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (context) => MyCurrentLocation(flag: true)),
                  (route) => false);
          print("sucesss");
        }
      }
    }
  }

  void getLocation() {

    context.read<LocationServiceProvider>().getLocationAccess();

  }

  void getCityList() {
    context
        .read<LoginProvider>()
        .getCityList();
  }
}