import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart' as provider;
import 'package:shopping_app_ui/screens/order_process/AddedToCartScreen.dart';
import 'package:shopping_app_ui/screens/order_process/DeliveryAddressScreen.dart';
import 'package:shopping_app_ui/screens/launch/HomeScreen.dart';
import 'package:shopping_app_ui/screens/authentication/LoginScreen.dart';
import 'package:shopping_app_ui/screens/order_process/MyCartScreen.dart';
import 'package:shopping_app_ui/screens/products/AllCategoriesScreen.dart';
import 'package:shopping_app_ui/screens/products/MyAttendanceScreen.dart';
import 'package:shopping_app_ui/screens/products/MyTicketScreen.dart';
import 'package:shopping_app_ui/screens/order_process/MyOrdersScreen.dart';
import 'package:shopping_app_ui/screens/authentication/SignUpScreen.dart';
import 'package:shopping_app_ui/screens/profile/UserProfileScreen.dart';
import 'colors/Colors.dart';
import 'notifier/dark_theme_provider.dart';
import 'screens/launch/SplashScreen.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';


void main() async {
  //WidgetsFlutterBinding.ensureInitialized();
  //await Hive.initFlutter(); //hive needs to be initialized before calling for boxes so it is better to initialize it in main
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(ProviderScope(child: MyApp())); //initiating flutter riverpod (wajib iniialize providerscope on the most top of app architecture,,)
  
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
    return provider.ChangeNotifierProvider(
      create: (_) {
        return themeChangeProvider;
      },
      child: provider.Consumer<DarkThemeProvider>(
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
              '/MyTicketScreen': (BuildContext context) => MyTicketScreen(),
              //'/MyAttendanceScreen': (BuildContext context) => MyAttendanceScreen(),
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
