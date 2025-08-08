//import 'dart:html';
import 'package:app_settings/app_settings.dart';
import 'package:delivoo/Components/list_tile.dart';
import 'package:delivoo/Locale/locales.dart';
import 'package:delivoo/Pages/PrivacyPolicy.dart';

import 'package:delivoo/Providers.dart/Address_provider.dart';
import 'package:delivoo/Providers.dart/Payment_provider.dart';
import 'package:delivoo/Providers.dart/ProductProvider.dart';
import 'package:delivoo/Providers.dart/login_provider.dart';
import 'package:delivoo/Providers.dart/store_provider.dart';
import 'package:delivoo/Routes/routes.dart';
import 'package:delivoo/Themes/colors.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../Components/common_home_nav_bar.dart';

class AccountPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        context.read<StoreProvider>().onTapped(0);
        return Future.value(false);
      },
      child: Scaffold(
        appBar: CommonHomeNavBar(
          titleWidget: Text(AppLocalizations.of(context)!.account!,
              style: Theme.of(context)
                  .textTheme
                  .bodyLarge!
                  .copyWith(color: Colors.white)),
        ),
        body: Account(),
      ),
    );
  }
}

class Account extends StatefulWidget {
  @override
  _AccountState createState() => _AccountState();
}

class _AccountState extends State<Account> {
  String? number;

  @override
  void initState() {
    context.read<Addressprovider>().setLocationDialog(false); //this is to show new location pop up if value is true it shows the pop up
    context.read<LoginProvider>().getprofile();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: <Widget>[
        UserDetails(),
        Divider(
          color: Theme.of(context).cardColor,
          thickness: 8.0,
        ),
        AddressTile(),
        BuildListTile(
            image: 'images/account/ic_menu_wallet.png',
            text: AppLocalizations.of(context)!.wallet,
            onTap: () async {
              var x = await context.read<Paymentprovider>().getwalletdetails();
              if (x != null) {
                Navigator.pushNamed(context, PageRoutes.wallet);
              }
            }),
        BuildListTile(
            image: 'images/account/coupon.png',
            text: "Coupons",
            onTap: () async {
              var res = await context
                  .read<ProductProvider>()
                  .loadCoupons(action: "3");
              res == "sucess"
                  ? Navigator.pushNamed(context, PageRoutes.couponTab)
                  : null;
            }),
        BuildListTile(
            image: 'images/account/ic_menu_tncact.png',
            text: 'Privacy Policy',
            onTap: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => PrivacyPolicy()));
            }),
        BuildListTile(
            image: 'images/account/ic_menu_supportact.png',
            text: AppLocalizations.of(context)!.support,
            onTap: () => Navigator.pushNamed(context, PageRoutes.supportPage,
                arguments: number)),
        BuildListTile(
          image: 'images/account/ic_menu_setting.png',
          text: AppLocalizations.of(context)!.settings,
          onTap: () => Navigator.pushNamed(context, PageRoutes.settings),
        ),
        BuildListTile(
            image: 'images/account/navigation.png',
            text: "Location Permission",
            onTap: () async {
              AppSettings.openAppSettings(type: AppSettingsType.location);
            }),
        BuildListTile(
          widget: Icon(Icons.delete_forever, color: Colors.red),
          text: 'Delete account',
          onTap: () {
            showDialog(
                context: context,
                barrierDismissible: true,
                builder: (BuildContext context) {
                  return AlertDialog(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20)),
                    title: Column(
                      children: [
                        Text(
                            "Are you sure that you want to delete your kisanserv express account?"),
                        Text(
                          "Please note that there is no option to restore the account or its data once it's deleted.",
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        Text(
                            "If you still want to delete kisanserv account then hit Delete Account Button")
                      ],
                    ),
                    content: Text(AppLocalizations.of(context)!.areYouSure!,
                        style: Theme.of(context).textTheme.bodyMedium!),
                    actions: <Widget>[
                      TextButton(
                        child: Text('Cancel',
                            style: Theme.of(context)
                                .textTheme
                                .bodyMedium!
                                .copyWith(color: Colors.white)),
                        onPressed: () => Navigator.pop(context),
                        style: TextButton.styleFrom(
                          backgroundColor: Colors.green,
                          shape: RoundedRectangleBorder(
                              side: BorderSide(color: kTransparentColor)),
                        ),
                      ),
                      TextButton(
                          child: Text('Delete account',
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyMedium!
                                  .copyWith(color: Colors.white)),
                          style: TextButton.styleFrom(
                            backgroundColor: Colors.red,
                            shape: RoundedRectangleBorder(
                                side: BorderSide(color: kTransparentColor)),
                          ),
                          onPressed: () async {
                            // Phoenix.rebirth(context);
                            // context.read<StoreProvider>().currentindex = 0;
                            await context
                                .read<LoginProvider>()
                                .getdevicedetails("2");
                            context.read<ProductProvider>().removeallProducts();
                            context.read<LoginProvider>().deleteprofile();
                            context.read<LoginProvider>().logoutUser(context);
                          })
                    ],
                  );
                });
          },
        ),
        LogoutTile(),
      ],
    );
  }
}

class AddressTile extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BuildListTile(
        image: 'images/account/ic_menu_addressact.png',
        text: AppLocalizations.of(context)!.saved,
        onTap: () {
          context.read<Addressprovider>().getaddresses(isload: true);
          Navigator.pushNamed(context, PageRoutes.savedAddressesPage);
        });
  }
}

class LogoutTile extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BuildListTile(
      image: 'images/account/ic_menu_logoutact.png',
      text: AppLocalizations.of(context)!.logout,
      onTap: () {
        showDialog(
            context: context,
            barrierDismissible: false,
            builder: (BuildContext context) {
              return AlertDialog(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20)),
                title: Text(AppLocalizations.of(context)!.loggingOut!,
                    style: Theme.of(context)
                        .textTheme
                        .bodyMedium!
                        .copyWith(fontSize: 15, fontWeight: FontWeight.w500)),
                content: Text(AppLocalizations.of(context)!.areYouSure!,
                    style: Theme.of(context).textTheme.bodyMedium!),
                actions: <Widget>[
                  TextButton(
                    child: Text(AppLocalizations.of(context)!.no!,
                        style: Theme.of(context)
                            .textTheme
                            .bodyMedium!
                            .copyWith(color: Colors.white)),
                    onPressed: () => Navigator.pop(context),
                    style: TextButton.styleFrom(
                      backgroundColor: buttonColor,
                      shape: RoundedRectangleBorder(
                          side: BorderSide(color: kTransparentColor)),
                    ),
                  ),
                  TextButton(
                      child: Text(AppLocalizations.of(context)!.yes!,
                          style: Theme.of(context)
                              .textTheme
                              .bodyMedium!
                              .copyWith(color: Colors.white)),
                      style: TextButton.styleFrom(
                        backgroundColor: buttonColor, // Color(0xfff79b5c),
                        shape: RoundedRectangleBorder(
                            side: BorderSide(color: kTransparentColor)),
                      ),
                      onPressed: () async {
                        // Phoenix.rebirth(context);
                        // context.read<StoreProvider>().currentindex = 0;
                        await context
                            .read<LoginProvider>()
                            .getdevicedetails("2");
                        context.read<ProductProvider>().loginRemoveallProducts();
                        // context.read<StoreProvider>().onTapped(0);
                        context.read<LoginProvider>().logoutUser(context);
                      })
                ],
              );
            });
      },
    );
  }
}

class UserDetails extends StatefulWidget {
  @override
  State<UserDetails> createState() => _UserDetailsState();
}

class _UserDetailsState extends State<UserDetails> {
  String? mno;
  @override
  void initState() {
    Future.delayed(Duration(milliseconds: 100), () async {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      context.read<LoginProvider>().mno = prefs.getString('mob_no');
      context.read<LoginProvider>().refresh();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final profile = context.watch<LoginProvider>().profile?.d;
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.0),
      child: Row(
        children: [
          Container(
            width: MediaQuery.of(context).size.width * 0.7,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text('\n' + '${profile?[0].memberName ?? ''}',
                    style: Theme.of(context).textTheme.bodyLarge),
                Text('\n' + '${context.watch<LoginProvider>().mno}',
                    style: Theme.of(context)
                        .textTheme
                        .bodySmall!
                        .copyWith(color: Color(0xff9a9a9a))),
                SizedBox(
                  height: 5.0,
                ),
                Text('Email : ${profile?[0].emailId ?? ''}',
                    style: Theme.of(context)
                        .textTheme
                        .bodySmall!
                        .copyWith(color: Color(0xff9a9a9a))),
                Text('Wallet : \u{20B9} ${profile?[0].walletamt ?? ''}',
                    style: Theme.of(context)
                        .textTheme
                        .bodySmall!
                        .copyWith(color: Color(0xff9a9a9a))),
              ],
            ),
          ),
          Spacer(),
          IconButton(
              onPressed: () {
                showDialog(
                    context: context,
                    builder: (context) {
                      var _formkey = GlobalKey<FormState>();
                      TextEditingController nameController =
                          TextEditingController();
                      nameController.text = profile![0].memberName.toString();
                      TextEditingController emailController =
                          TextEditingController();
                      emailController.text = profile[0].emailId.toString();
                      return AlertDialog(
                        title: Text(
                          "Update Details",
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                        content: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Form(
                              key: _formkey,
                              child: Column(
                                children: [
                                  TextFormField(
                                    style: Theme.of(context).textTheme.bodyMedium,
                                    autovalidateMode:
                                        AutovalidateMode.onUserInteraction,
                                    validator: (value) => value!.length < 1
                                        ? 'Please enter name'
                                        : null,
                                    textAlign: TextAlign.center,
                                    controller: nameController,
                                    decoration: InputDecoration(
                                      hintText: 'Name',
                                      suffixIcon: Padding(
                                        padding:
                                            const EdgeInsets.only(right: 8),
                                        child: Icon(
                                          Icons.edit,
                                          size: 16,
                                        ),
                                      ),
                                      enabledBorder: OutlineInputBorder(
                                          borderSide: BorderSide(width: 1)),
                                      border: new OutlineInputBorder(
                                        borderSide:
                                            const BorderSide(width: 2.0),
                                        borderRadius:
                                            BorderRadius.circular(5.0),
                                      ),
                                      contentPadding: EdgeInsets.only(),
                                    ),
                                    onChanged: (value) {},
                                  ),
                                  SizedBox(height: 20),
                                  TextFormField(
                                    style: Theme.of(context).textTheme.bodyMedium,
                                    autovalidateMode:
                                        AutovalidateMode.onUserInteraction,
                                    validator: (value) => value!.length < 1
                                        ? 'Please enter email'
                                        : null,
                                    textAlign: TextAlign.center,
                                    controller: emailController,
                                    decoration: InputDecoration(
                                      hintText: 'Email',
                                      suffixIcon: Padding(
                                        padding:
                                            const EdgeInsets.only(right: 8),
                                        child: Icon(
                                          Icons.edit,
                                          size: 16,
                                        ),
                                      ),
                                      enabledBorder: OutlineInputBorder(
                                          borderSide: BorderSide(width: 1)),
                                      border: new OutlineInputBorder(
                                        borderSide:
                                            const BorderSide(width: 2.0),
                                        borderRadius:
                                            BorderRadius.circular(5.0),
                                      ),
                                      contentPadding: EdgeInsets.only(),
                                    ),
                                    onChanged: (value) {},
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Container(
                              child: ElevatedButton.icon(
                                  style: ButtonStyle(
                                      backgroundColor:
                                          MaterialStateProperty.all<Color>(
                                              buttonColor)),
                                  onPressed: () async {
                                    if (_formkey.currentState!.validate()) {
                                      await context
                                          .read<LoginProvider>()
                                          .updateprofile(nameController.text,
                                              emailController.text);
                                      Navigator.pop(context);
                                    }
                                  },
                                  icon: Icon(Icons.done),
                                  label: Text("ok")),
                            ),
                          ],
                        ),
                      );
                    });
              },
              icon: Icon(Icons.edit)),
        ],
      ),
    );
  }
}
