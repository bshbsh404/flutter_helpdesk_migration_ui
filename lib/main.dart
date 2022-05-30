import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shopping_app_ui/screens/order_process/AddedToCartScreen.dart';
import 'package:shopping_app_ui/screens/order_process/DeliveryAddressScreen.dart';
import 'package:shopping_app_ui/screens/launch/HomeScreen.dart';
import 'package:shopping_app_ui/screens/authentication/LoginScreen.dart';
import 'package:shopping_app_ui/screens/order_process/MyCartScreen.dart';
import 'package:shopping_app_ui/screens/products/AllCategoriesScreen.dart';
import 'package:shopping_app_ui/screens/products/MyFavoriteScreen.dart';
import 'package:shopping_app_ui/screens/order_process/MyOrdersScreen.dart';
import 'package:shopping_app_ui/screens/authentication/SignUpScreen.dart';

import 'package:shopping_app_ui/screens/profile/UserProfileScreen.dart';

import 'colors/Colors.dart';
import 'notifier/dark_theme_provider.dart';
import 'screens/launch/SplashScreen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key key}) : super(key: key);

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  DarkThemeProvider themeChangeProvider = new DarkThemeProvider();

  @override
  void initState() {
    super.initState();
    getCurrentAppTheme();
  }

  void getCurrentAppTheme() async {
    themeChangeProvider.darkTheme =
        await themeChangeProvider.themePreferences.getTheme();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) {
        return themeChangeProvider;
      },
      child: Consumer<DarkThemeProvider>(
        builder: (BuildContext context, value, Widget child) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            theme: themeData(themeChangeProvider.darkTheme, context),
            initialRoute: '/',
            routes: <String, WidgetBuilder>{
              '/': (context) => SplashScreen(),
              '/LoginScreen': (BuildContext context) => LoginScreen(),
              '/SignUpScreen': (BuildContext context) => SignUpScreen(),
              HomeScreen.routeName: (BuildContext context) => HomeScreen(),
              '/MyFavoriteScreen': (BuildContext context) => MyFavoriteScreen(),
              '/AddedToCartScreen': (BuildContext context) =>
                  AddedToCartScreen(),
              '/MyCartScreen': (BuildContext context) => MyCartScreen(),
              UserProfileScreen.routeName: (BuildContext context) =>
                  UserProfileScreen(),
              AllCategoriesScreen.routeName: (BuildContext context) =>
                  AllCategoriesScreen(),
              '/DeliveryAddressScreen': (BuildContext context) =>
                  DeliveryAddressScreen(),
              '/MyOrdersScreen': (BuildContext context) => MyOrdersScreen(),
            },
          );
        },
      ),
    );
  }
}
