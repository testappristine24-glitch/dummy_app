// ignore_for_file: unused_local_variable, invalid_return_type_for_catch_error

import 'package:delivoo/Locale/locales.dart';
import 'package:delivoo/Providers.dart/Address_provider.dart';
import 'package:delivoo/Providers.dart/OrderProvider.dart';
import 'package:delivoo/Providers.dart/Payment_provider.dart';
import 'package:delivoo/Providers.dart/banner_provider.dart';
import 'package:delivoo/Providers.dart/ProductProvider.dart';
import 'package:delivoo/Providers.dart/category_provider.dart';
import 'package:delivoo/Providers.dart/login_provider.dart';
import 'package:delivoo/Providers.dart/offer_provider.dart';
import 'package:delivoo/Providers.dart/store_provider.dart';
import 'package:delivoo/Routes/routes.dart';
import 'package:delivoo/Splashscreen.dart';
import 'package:delivoo/Themes/style.dart';
import 'package:delivoo/geo/LocationProvider.dart';
import 'package:delivoo/geo/MapMyIndiaLocationServiceProvider.dart';
import 'package:delivoo/language_cubit.dart';
import 'package:delivoo/theme_cubit.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:mappls_gl/mappls_gl.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'geo/GoogleLocationProvider.dart';

final navigatorKey = GlobalKey<NavigatorState>();
late AndroidNotificationChannel channel;
//bool? isload = true;

/// Initialize the [FlutterLocalNotificationsPlugin] package.
late FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {}

Future<void> main() async {
  // Initialize EasyLoading
  configLoading();
  WidgetsFlutterBinding.ensureInitialized();

  // MapplsAccountManager.setMapSDKKey('0e596bf4a4684468bd10e4b0dff6b8a1');
  // MapplsAccountManager.setRestAPIKey('0e596bf4a4684468bd10e4b0dff6b8a1');
  // MapplsAccountManager.setAtlasClientId('96dHZVzsAuvRBuz0xekrLLC1oY7UgcrCfBRgCjlKWgTQHdKuizSLxMQRs10-wCoHGVQsWbhF6t9uaWZ0RmzP8vh7eI9bwSe5');
  // MapplsAccountManager.setAtlasClientSecret('lrFxI-iSEg86fg3DkXp0ATpAy5zMy4HO0riPZq2NpRMZ1QpzWAj0LrOP_nATxl_j9BnSbSxSN-1Lq2pLVjDRpiXYDr9MUWMllbJeDz8pJV4=');

  MapplsAccountManager.setMapSDKKey('018314cfb13edaf5f2aa1c0e9e931a3b');
  MapplsAccountManager.setRestAPIKey('018314cfb13edaf5f2aa1c0e9e931a3b');
  MapplsAccountManager.setAtlasClientId('96dHZVzsAuttDLuUC7KHugzcXnxSUTxWQiuba_QyxOI4kFMs_bSygRJ1kKh_Wag2ahY6YZVd3ozlKfceMBbE3eP1tzRKRkkN');
  MapplsAccountManager.setAtlasClientSecret('lrFxI-iSEg9jHNLOiFyMrIMVerqVbh0HEjDWD5XbWQqx7mh8nTlZ1l-3jmPsjHs5F615nd-NUBI009QMp0IegV2yXXjHc5_nNuOMUjua-iM=');

  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  await Firebase.initializeApp();
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  if (!kIsWeb) {
    channel = const AndroidNotificationChannel(
      'high_importance_channel', // id
      'High Importance Notifications', // title
      description: 'This channel is used for important notifications.',
      //'This channel is used for important notifications.', // description
      // importance: Importance.high,
      playSound: true,
    );

    flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
    await flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(channel);
    FirebaseMessaging messaging = FirebaseMessaging.instance;

    NotificationSettings settings = await messaging.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: true,
      provisional: false,
      sound: true,
    );

    // if (settings.authorizationStatus == AuthorizationStatus.authorized) {
    //   print('User granted permission');
    // } else if (settings.authorizationStatus ==
    //     AuthorizationStatus.provisional) {
    //   print('User granted provisional permission');
    // } else {
    //   print('User declined or has not accepted permission');
    // }
  }
  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
    statusBarColor: Colors.transparent,
    statusBarIconBrightness: Brightness.dark,
  ));

  // runApp(Phoenix(child: Delivoo()));
  SharedPreferences.getInstance().then((prefs) {
    var darkModeOn = prefs.getBool('Dark Mode') ?? false;

    runApp(
      ChangeNotifierProvider<ThemeNotifier>(
          create: (_) => ThemeNotifier(darkModeOn ? darkTheme : appTheme),
          child: Delivoo()),
    );
  });
}

class Delivoo extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<LanguageCubit>(create: (_) => LanguageCubit()),
        ChangeNotifierProvider<Paymentprovider>(
            create: (_) => Paymentprovider()),
        ChangeNotifierProvider<CategoryProvider>(
            create: (_) => CategoryProvider()),
        ChangeNotifierProvider<LoginProvider>(
          create: (context) => LoginProvider(),
        ),
        ChangeNotifierProvider<LocationServiceProvider>(
          create: (context) => LocationServiceProvider(),
        ),
        ChangeNotifierProvider<GoogleServiceProvider>(
          create: (context) => GoogleServiceProvider(),
        ),
        ChangeNotifierProvider<MapMyIndiaLocationServiceProvider>(
          create: (context) => MapMyIndiaLocationServiceProvider(),
        ),
        ChangeNotifierProvider<Addressprovider>(
          create: (context) => Addressprovider(),
        ),
        ChangeNotifierProvider<StoreProvider>(
          create: (context) => StoreProvider(),
        ),
        ChangeNotifierProvider<Bannerprovider>(
          create: (context) => Bannerprovider(),
        ),
        ChangeNotifierProvider<Offerprovider>(
          create: (context) => Offerprovider(),
        ),
        ChangeNotifierProvider<CategoryProvider>(
          create: (context) => CategoryProvider(),
        ),
        ChangeNotifierProvider(create: (context) => GoogleServiceProvider()),
        ChangeNotifierProvider(create: (context) => MapMyIndiaLocationServiceProvider()),
        ChangeNotifierProvider<ProductProvider>(
            create: (_) => ProductProvider()),
        ChangeNotifierProvider<Orderprovider>(create: (_) => Orderprovider()),
      ],
      child: Consumer2<LanguageCubit, ThemeNotifier>(
          builder: (context, model, modela, child) {
        final themeNotifier = Provider.of<ThemeNotifier>(context);
        return MaterialApp(
          // builder: (context, child) {
          //   return MediaQuery(
          //     child: child!,
          //     data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
          //   );
          // },
          builder: EasyLoading.init(),
          navigatorKey: navigatorKey,
          debugShowCheckedModeBanner: false,
          localizationsDelegates: [
            const AppLocalizationsDelegate(),
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
          ],
          supportedLocales: [
            const Locale('en'),
            const Locale('ar'),
            const Locale('fr'),
            const Locale('id'),
            const Locale('pt'),
            const Locale('es'),
            const Locale('es'),
            const Locale('tr'),
            const Locale('it'),
            const Locale('sw'),
          ],
          theme: themeNotifier.getTheme(),
          home: Splashscreen(),
          routes: PageRoutes().routes(),
        );
      }),
    );
  }
}

Future<void> configLoading() async {
  EasyLoading.instance
    ..displayDuration = const Duration(milliseconds: 500)
    ..indicatorType = EasyLoadingIndicatorType.circle
    ..loadingStyle = EasyLoadingStyle.custom
    ..indicatorSize = 38.0
    ..radius = 1.0
    ..progressWidth = 0.2
    ..progressColor = Colors.green
    ..backgroundColor = Colors.green
    ..boxShadow = <BoxShadow>[]
    ..maskType = EasyLoadingMaskType.clear
    ..indicatorColor = Colors.white
    ..radius = 5
    ..textColor = Colors.white
    ..maskColor = Colors.grey[100]
    ..userInteractions = true
    ..dismissOnTap = false;
}
