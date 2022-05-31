import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:shopping_app_ui/Data/ProductData.dart';
import 'package:shopping_app_ui/colors/Colors.dart';
import 'package:shopping_app_ui/constant/Constants.dart';
import 'package:shopping_app_ui/model/Product.dart';
import 'package:shopping_app_ui/model/ProductInCart.dart';
import 'package:shopping_app_ui/screens/launch/HomeScreen.dart';
import 'package:shopping_app_ui/util/RemoveGlowEffect.dart';
import 'package:shopping_app_ui/util/size_config.dart';
import 'package:shopping_app_ui/widgets/Styles.dart';
import 'package:shopping_app_ui/util/Util.dart';

class MyTicketScreen extends StatefulWidget {
  @override
  _MyTicketScreenState createState() => _MyTicketScreenState();
}

class _MyTicketScreenState extends State<MyTicketScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: isDarkMode(context)
          ? darkBackgroundColor
          : Theme.of(context).backgroundColor,
      appBar: buildAppBar(
        context,
        myTicketLabel,
        onBackPress: () {
          final CurvedNavigationBarState navState = getNavState();
          navState.setPage(0);
        },
      ),
      body: SafeArea(
        child: ScrollConfiguration(
          behavior: RemoveScrollingGlowEffect(),
          child: SingleChildScrollView(
            child: Column(
              children: [
                SizedBox(
                  height: getProportionateScreenWidth(10.0),
                ),
                myTicketProducts.length > 0
                    ? ListView.builder(
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        itemCount: myTicketProducts.length,
                        itemBuilder: (context, index) {
                          return buildTicketProduct(
                            myTicketProducts[index],
                          );
                        },
                      )
                    : Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: SvgPicture.asset(
                              isDarkMode(context)
                                  ? '$darkIconPath/empty_wishlist.svg'
                                  : '$lightIconPath/empty_wishlist.svg',
                              height: SizeConfig.screenHeight * 0.5,
                              width: double.infinity,
                            ),
                          ),
                          Text(
                            'No tickets found!',
                            style: Theme.of(context).textTheme.headline6,
                          )
                        ],
                      ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget buildTicketProduct(Product product) {
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: getProportionateScreenWidth(16),
        vertical: getProportionateScreenWidth(4),
      ),
      child: Card(
        elevation: 6,
        color: isDarkMode(context) ? darkGreyColor : Colors.white,
        shadowColor: Colors.grey.withOpacity(0.15),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        child: Padding(
          padding: EdgeInsets.all(getProportionateScreenWidth(8)),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Image.asset(
                        '$productImagesPath/${product.productImage}',
                        height: getProportionateScreenWidth(80),
                        width: getProportionateScreenWidth(80),
                      ),
                      SizedBox(width: getProportionateScreenWidth(10)),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Container(
                                width: SizeConfig.screenWidth / 2,
                                child: Text(
                                  product.productName,
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 1,
                                  style: Theme.of(context).textTheme.subtitle2,
                                ),
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Text(
                                    '\$' +
                                        (product.originalPrice -
                                                (product.originalPrice *
                                                    product.discountPercent /
                                                    100))
                                            .toStringAsFixed(2),
                                    style: Theme.of(context).textTheme.subtitle1.copyWith(
                                        fontWeight: Theme.of(context).textTheme.subtitle2.fontWeight),
                                  ),
                                  SizedBox(
                                    width: 10,
                                  ),
                                  Text(
                                    '\$' +
                                        product.originalPrice
                                            .toStringAsFixed(2),
                                    style: Theme.of(context)
                                        .textTheme
                                        .caption
                                        .copyWith(
                                          decoration:
                                              TextDecoration.lineThrough,
                                        ),
                                  ),
                                  SizedBox(
                                    width: 10,
                                  ),
                                  Text(
                                    '${product.discountPercent.round()}% off',
                                    style: homeScreensClickableLabelStyle,
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ],
                      )
                    ],
                  ),
                  InkWell(
                    child: Container(
                      padding: EdgeInsets.all(6),
                      decoration: BoxDecoration(
                        color: primaryColor.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Icon(
                        Icons.delete,
                        size: 22,
                        color: primaryColor,
                      ),
                    ),
                    onTap: () {
                      setState(
                        () {
                          myTicketProducts.remove(product);
                        },
                      );
                    },
                  ),
                ],
              ),
              Divider(),
              Align(
                alignment: Alignment.centerRight,
                child: Padding(
                  padding: EdgeInsets.symmetric(
                    vertical: getProportionateScreenWidth(4),
                  ),
                  child: RichText(
                    text: TextSpan(
                      children: [
                        TextSpan(
                          text: product.isAddedInCart
                              ? 'Added in cart'
                              : addToCartLabel,
                          style: product.isAddedInCart
                              ? Theme.of(context).textTheme.caption
                              : homeScreensClickableLabelStyle,
                          recognizer: TapGestureRecognizer()
                            ..onTap = () {
                              setState(
                                () {
                                  if (!product.isAddedInCart) {
                                    addProductToCart(product, true);
                                  }
                                },
                              );
                            },
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void addProductToCart(Product product, bool isAddedInCart) {
    product.isAddedInCart = isAddedInCart;
    setState(
      () {
        if (isAddedInCart) {
          myCartData.add(
            ProductInCart(
              product,
              1,
            ),
          );
        } else {
          myCartData.removeWhere((element) => element.product == product);
        }
        HomeScreen.cartItemCount = myCartData.length;
      },
    );
  }
}
