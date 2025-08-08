// ignore_for_file: deprecated_member_use

import 'package:delivoo/Themes/colors.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
//app theme

final ThemeData darkTheme = ThemeData.dark().copyWith(
  //fontFamily: 'OpenSans',
  pageTransitionsTheme: PageTransitionsTheme(
    builders: {
      TargetPlatform.android: CupertinoPageTransitionsBuilder(),
      TargetPlatform.iOS: CupertinoPageTransitionsBuilder(),
    },
  ),
  scaffoldBackgroundColor: kMainTextColor,
  secondaryHeaderColor: kWhiteColor,
  primaryColor: kMainColor,
  bottomAppBarTheme: BottomAppBarTheme(color: kMainColor),
  dividerColor: Color(0x1f000000),
  disabledColor: kDisabledColor,
  cardColor: Color(0xff212321),
  hintColor: kLightTextColor,
  indicatorColor: kMainColor,
  buttonTheme: ButtonThemeData(
    textTheme: ButtonTextTheme.normal,
    height: 33,
    padding: EdgeInsets.only(top: 0, bottom: 0, left: 16, right: 16),
    shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(30.0)),
        side: BorderSide(color: kMainColor)),
    alignedDropdown: false,
    buttonColor: kMainColor,
    disabledColor: kDisabledColor,
  ),
  appBarTheme: AppBarTheme(
    color: kMainColor,
    elevation: 0.0,
  ),
  //text theme which contains all text styles
  textTheme: GoogleFonts.openSansTextTheme().copyWith(
    //text style of 'Delivering almost everything' at phone_number page
    bodyLarge: TextStyle(
      fontWeight: FontWeight.bold,
      fontSize: 12,
    ),

    //text style of 'Everything.' at phone_number page
    bodyMedium: TextStyle(
      fontSize: 10,
      letterSpacing: 1.0,
      color: kDisabledColor,
    ),

    //text style of button at phone_number page
    labelLarge: TextStyle(
      fontSize: 8,
      color: kWhiteColor,
    ),

    //text style of 'Got Delivered' at home page
    headlineMedium: TextStyle(
      color: Colors.white,
      fontWeight: FontWeight.bold,
      fontSize: 12,
    ),

    //text style of we'll send verification code at register page
    headlineSmall: TextStyle(
      color: kLightTextColor,
      fontSize: 10,
    ),

    //text style of 'everything you need' at home page
    // headlineMedium: TextStyle(
    //   color: kDisabledColor,
    //   fontSize: 20.0,
    //   letterSpacing: 0.5,
    // ),

    //text entry text style
    // bodyMedium: TextStyle(
    //   color: Colors.white,
    //   fontSize: 13.3,
    // ),

    labelSmall: TextStyle(color: kLightTextColor, letterSpacing: 0.2),

    //text style of titles of card at home page
    headlineLarge: TextStyle(
      color: Colors.white,
      fontSize: 12.0,
      fontWeight: FontWeight.bold,
      letterSpacing: 0.5,
    ),
    bodySmall: TextStyle(
      color: kLightTextColor,
      fontSize: 12.0,
    ),
  ), colorScheme: ColorScheme.fromSwatch().copyWith(secondary: kMainColor),
);
final pageTransitionsTheme = const PageTransitionsTheme(
  builders: <TargetPlatform, PageTransitionsBuilder>{
    TargetPlatform.android: FadeUpwardsPageTransitionsBuilder(),
    TargetPlatform.iOS: CupertinoPageTransitionsBuilder(),
    // TargetPlatform.linux: NoAnimationPageTransitionsBuilder(),
    // TargetPlatform.macOS: NoAnimationPageTransitionsBuilder(),
    // TargetPlatform.windows: NoAnimationPageTransitionsBuilder(),
  },
);

final ThemeData appTheme = ThemeData(
  pageTransitionsTheme: pageTransitionsTheme,
  scaffoldBackgroundColor: Colors.white,
  secondaryHeaderColor: kMainTextColor,
  primaryColor: kMainColor,
  dividerColor: Color(0x1f000000),
  disabledColor: kDisabledColor, // kMainColor,
  cardColor: kCardBackgroundColor,
  hintColor: kLightTextColor,
  indicatorColor: kMainColor,
  bottomAppBarTheme: BottomAppBarTheme(color: kMainColor),
  buttonTheme: ButtonThemeData(
    textTheme: ButtonTextTheme.normal,
    height: 33,
    padding: EdgeInsets.only(top: 0, bottom: 0, left: 16, right: 16),
    shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(30.0)),
        side: BorderSide(color: kMainColor)),
    alignedDropdown: false,
    buttonColor: buttonColor, //Color(0xfff79b5c), // kMainColor,
    disabledColor: kDisabledColor,
  ),
  appBarTheme: AppBarTheme(
    color: kMainColor,
    elevation: 0.0,
  ),
  //text theme which contains all text styles
  textTheme: GoogleFonts.openSansTextTheme().copyWith(
    //text style of 'Delivering almost everything' at phone_number page
    bodyLarge: TextStyle(
      fontWeight: FontWeight.bold,
      fontSize: 12,
    ),

    //text style of 'Everything.' at phone_number page
    bodyMedium: TextStyle(
      fontSize: 12,
      letterSpacing: 1.0,
      color: kDisabledColor,
    ),

    //text style of button at phone_number page
    // button: TextStyle(
    //   fontSize: 13.3,
    //   color: kWhiteColor,
    // ),

    //text style of 'Got Delivered' at home page
    headlineMedium: TextStyle(
      color: Colors.black,
      fontWeight: FontWeight.bold,
      fontSize: 12,
    ),

    //text style of we'll send verification code at register page
    headlineSmall: TextStyle(
      color: kLightTextColor,
      fontSize: 10,
    ),

    //text style of 'everything you need' at home page
    // headlineMedium: TextStyle(
    //   color: kDisabledColor,
    //   fontSize: 20.0,
    //   letterSpacing: 0.5,
    // ),
    //
    // //text entry text style
    // bodyMedium: TextStyle(
    //   color: kMainTextColor,
    //   fontSize: 13.3,
    // ),

    labelSmall: TextStyle(color: kLightTextColor, letterSpacing: 0.2),

    //text style of titles of card at home page
    headlineLarge: TextStyle(
      color: kMainTextColor,
      fontSize: 12.0,
      fontWeight: FontWeight.bold,
      letterSpacing: 0.5,
    ),
    bodySmall: TextStyle(
      color: kLightTextColor,
      fontSize: 12.0,
    ),
  ), colorScheme: ColorScheme.fromSwatch().copyWith(secondary: kMainColor),
);

//text style of continue bottom bar
final TextStyle bottomBarTextStyle = GoogleFonts.openSans().copyWith(
  fontSize: 15.0,
  color: kWhiteColor,
  fontWeight: FontWeight.w400,
);

//text style of text input and account page list
final TextStyle inputTextStyle = GoogleFonts.openSans().copyWith(
  fontSize: 20.0,
  color: Colors.black,
);

final TextStyle listTitleTextStyle = GoogleFonts.openSans().copyWith(
  fontSize: 16.7,
  fontWeight: FontWeight.bold,
  color: kMainColor,
);

final TextStyle orderMapAppBarTextStyle = GoogleFonts.openSans().copyWith(
  fontSize: 13.3,
  fontWeight: FontWeight.bold,
  color: Colors.black,
);
