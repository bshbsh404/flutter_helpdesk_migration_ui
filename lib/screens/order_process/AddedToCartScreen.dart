import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:shopping_app_ui/colors/Colors.dart';
import 'package:shopping_app_ui/constant/Constants.dart';
import 'package:shopping_app_ui/widgets/Styles.dart';
import 'package:shopping_app_ui/util/Util.dart';

class AddedToCartScreen extends StatefulWidget {
  @override
  _AddedToCartScreenState createState() => _AddedToCartScreenState();
}

class _AddedToCartScreenState extends State<AddedToCartScreen> {
  void navigateBackToShopping() {
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: isDarkMode(context) ? darkBackgroundColor : Theme.of(context).backgroundColor,
      body: SafeArea(
        child: Center(
          child: Container(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(24, 0, 24, 0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SvgPicture.asset(
                    isDarkMode(context)
                        ? '$darkIconPath/added_to_cart.svg'
                        :'$lightIconPath/added_to_cart.svg',
                    height: 150,
                    width: double.infinity,
                  ),
                  Container(
                    padding: EdgeInsets.only(top: 30),
                    child: buildMiddlePart(),
                  ),
                  Container(
                    padding: EdgeInsets.fromLTRB(30, 30, 30, 0),
                    child: buildBottomButtons(),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget buildMiddlePart() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 26.0),
      child: Container(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              productAddedToCartLabel,
              style: Theme.of(context).textTheme.subtitle1,
            ),
            SizedBox(
              height: 10,
            ),
            Text(canBuyAnytimeLabel,
                style: Theme.of(context).textTheme.bodyText2,
                textAlign: TextAlign.center),
          ],
        ),
      ),
    );
  }

  Widget buildBottomButtons() {
    return Stack(
      children: [
        Container(
          child: Column(
            children: [
              buildButton(
                checkCartLabel,
                true,
                isDarkMode(context) ? primaryColorDark : primaryColor,
                isDarkMode(context)
                    ? Colors.white.withOpacity(0.8)
                    : Colors.white,
                2,
                2,
                8,
                onPressed: () {
                  navigateAndReplaceScreen(context, '/MyCartScreen');
                },
              ),
              SizedBox(
                height: 15,
              ),
              Container(
                child: buildButtonOutline(
                    continueShoppingLabel, primaryColor, primaryColor,
                    onPressed: () {
                  navigateHomeScreen(context);
                }),
              )
            ],
          ),
        )
      ],
    );
  }
}
