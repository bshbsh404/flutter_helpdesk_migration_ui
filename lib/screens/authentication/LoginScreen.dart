import 'package:email_validator/email_validator.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:odoo_rpc/odoo_rpc.dart';
import 'package:shopping_app_ui/colors/Colors.dart';
import 'package:shopping_app_ui/constant/Constants.dart';
import 'package:shopping_app_ui/screens/launch/HomeScreen.dart';
import 'package:shopping_app_ui/util/size_config.dart';
import 'package:shopping_app_ui/widgets/Styles.dart';
import 'package:shopping_app_ui/screens/authentication/ForgotPasswordScreen.dart';
import 'package:shopping_app_ui/util/Util.dart';

//create a global variable because, sometimes we need a global variable.
//using client and session will not cause security issues on global by the way, it is only used for calling data from API.
//alternative would be to passvalue using stateful widget when passing in navigation.

var URL = 'http://192.168.0.123:8069';//'http://127.0.0.1:8069';//'http://localhost:8069';//'http://10.0.0.226:8069'; //192.168.0.123
var globalClient = OdooClient(URL);
var globalSession;



class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  TextEditingController email = new TextEditingController();
  TextEditingController password = new TextEditingController();

  bool isDisplayErrorNotification = false,
      isDisplayEmailErrorNotification = false,
      isUnAuthFlag = false,
      showLoadingIndicator = false;

  FocusNode focusNodeEmail = new FocusNode();
  FocusNode focusNodePassword = new FocusNode();
  FocusNode focusNodeErrorNotification = new FocusNode();

  String errorMessage = '';

  void showErrorNotification(String message) {
    setState(() {
      errorMessage = message;
      FocusScope.of(context).requestFocus(focusNodeErrorNotification);
    });
  }

  void hideErrorNotification() {
    setState(() {
      isDisplayErrorNotification = false;
      isDisplayEmailErrorNotification = false;
      errorMessage = "";
    });
  }

  void setUnAuthFlagTrue() {
    setState(() {
      isUnAuthFlag = true;
    });
  }

  Future<void> checkOdooSession () async {
    try {
      await globalClient.checkSession();
    } on OdooSessionExpiredException {
      print('Session expired');
    }
  }

  void setUnAuthFlagFalse() {
    setState(() {
      isUnAuthFlag = false;
    });
  }

  @override
  void initState() {
    super.initState();
    focusNodeEmail.addListener(onFocusChanged);
    focusNodePassword.addListener(onFocusChanged);
    

    // INFO: dummy username and password
    email.text = demoEmail;
    password.text = demoPassword;
    checkOdooSession();
  }

  @override
  void dispose() {
    focusNodeEmail.dispose();
    focusNodePassword.dispose();
    focusNodeErrorNotification.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: isDarkMode(context) ? darkBackgroundColor : Theme.of(context).backgroundColor,
      body: SafeArea(
        child: ListView(
          shrinkWrap: false,
          children: [
            Container(
              child: Padding(
                padding: EdgeInsets.symmetric(
                    horizontal: getProportionateScreenWidth(14)),
                child: Column(
                  children: [
                    SizedBox(
                      height: SizeConfig.screenHeight * 0.06,
                    ),
                    Container(
                      child: buildHeaderLayout(),
                    ),
                    SizedBox(
                      height: SizeConfig.screenHeight * 0.02,
                    ),
                    Container(
                      child: buildLoginInputField(email, password),
                    ),
                    SizedBox(
                      height: SizeConfig.screenHeight * 0.03,
                    ),
                    Container(
                      child: buildSignInButtons(),
                    ),
                    SizedBox(
                      height: SizeConfig.screenHeight * 0.02,
                    ),
                    Visibility(
                        visible: showLoadingIndicator,
                        child: displayLoadingIndicator())
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: buildSignUp(),
    );
  }

  Widget buildHeaderLayout() {
    return Container(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Visibility(
            visible: isDisplayErrorNotification,
            child: buildErrorNotificationWithOption(
              context,
              errorMessage,
              forgetPasswordLabel,
              isDarkMode(context) ? Colors.red[900] : pinkishColor,
              true,
              focusNode: focusNodeErrorNotification,
              onOptionTap: () {
                navigateToScreen(
                  context,
                  ForgotPasswordScreen(),
                );
              },
            ),
          ),
          Visibility(
              visible: isDisplayEmailErrorNotification,
              child: buildErrorNotification(
                errorMessage,
                isDarkMode(context) ? Colors.red[900] : pinkishColor,
              )),
          SizedBox(
            height: SizeConfig.screenHeight * 0.010,
          ),
          Text(
            signInLabel,
            style: Theme.of(context).textTheme.headline6,
          ),
          SizedBox(
            height: SizeConfig.screenHeight * 0.010,
          ),
          Text(
            toAccountLabel,
            style: Theme.of(context).textTheme.headline6,
          ),
          SizedBox(
            height: SizeConfig.screenHeight * 0.010,
          ),
          Text(signInWithLabel, style: Theme.of(context).textTheme.bodyText2),
        ],
      ),
    );
  }

  Widget buildLoginInputField(
      TextEditingController email, TextEditingController password) {
    return Column(
      children: [
        //INFO: email field
        Container(
          child: Padding(
            padding: EdgeInsets.only(top: getProportionateScreenWidth(18)),
            child: Container(
              height: getProportionateScreenHeight(50),
              child: buildTextField(
                context,
                email,
                TextCapitalization.none,
                TextInputType.emailAddress,
                TextInputAction.next,
                false,
                lightGreyColor.withOpacity(0.5),
                8.0,
                lightGreyColor.withOpacity(0.2),
                primaryColor,
                secondaryColor.withOpacity(0.2),
                focusNodeEmail.hasFocus
                    ? isDarkMode(context)
                        ? primaryColor.withOpacity(0.3)
                        : primaryColor.withOpacity(0.15)
                    : isDarkMode(context)
                        ? primaryColor.withOpacity(0.15)
                        : Colors.white,
                TextField.noMaxLength,
                emailLabel,
                true,
                focusNode: focusNodeEmail,
                onChange: (value) {},
                onSubmit: () {
                  FocusScope.of(context).requestFocus(focusNodePassword);
                },
              ),
            ),
          ),
        ),
        //INFO: Password field
        Container(
          child: Padding(
            padding: EdgeInsets.only(top: getProportionateScreenWidth(18)),
            child: Container(
              height: getProportionateScreenHeight(50),
              child: buildTextField(
                context,
                password,
                TextCapitalization.none,
                TextInputType.text,
                TextInputAction.done,
                true,
                lightGreyColor.withOpacity(0.5),
                8.0,
                lightGreyColor.withOpacity(0.2),
                primaryColor,
                primaryColor,
                focusNodePassword.hasFocus
                    ? isDarkMode(context)
                    ? primaryColor.withOpacity(0.3)
                    : primaryColor.withOpacity(0.15)
                    : isDarkMode(context)
                    ? primaryColor.withOpacity(0.15)
                    : Colors.white,
                TextField.noMaxLength,
                passwordLabel,
                true,
                focusNode: focusNodePassword,
                onChange: (value) {},
                onSubmit: () {},
              ),
            ),
          ),
        ),
        SizedBox(
          height: SizeConfig.screenHeight * 0.010,
        )
      ],
    );
  }

  Widget buildSignInButtons() {
    return Stack(
      children: [
        Container(
          child: Column(
            children: [
              //INFO: Sign in button
              buildButton(
                signInLabel,
                true,
                isDarkMode(context) ? primaryColorDark :primaryColor,
                isDarkMode(context) ? Colors.white.withOpacity(0.8) :Colors.white,
                2,
                2,
                8,
                onPressed: () {
                  checkValidations();
                },
              ),
              SizedBox(
                height: SizeConfig.screenHeight * 0.015,
              ),
              //INFO: Sign in with FB
              buildButtonWithIcon(
                context,
                '$baseImagePath/fb.png',
                signUpWithFB,
                true,
                isDarkMode(context) ? Colors.white24 : Colors.black.withOpacity(0.7),
                Colors.white,
                2,
                2,
                8,
                onPressed: () {
                  setState(
                    () {
                      showLoadingIndicator = true;
                    },
                  );
                  Future.delayed(
                    Duration(milliseconds: 500),
                    () {
                      navigateAndClearHistory(context, HomeScreen.routeName);
                    },
                  );
                },
              ),
              SizedBox(
                height: SizeConfig.screenHeight * 0.018,
              ),
            ],
          ),
        )
      ],
    );
  }

  Container buildSignUp() {
    return Container(
      padding: EdgeInsets.symmetric(vertical: getProportionateScreenWidth(16)),
      child: RichText(
        textAlign: TextAlign.center,
        text: TextSpan(
          children: [
            TextSpan(text: doNotHaveAccountLabel, style:  Theme.of(context).textTheme.bodyText2),
            TextSpan(
              text: signUpLabel,
              style: authScreensClickableLabelStyle,
              recognizer: TapGestureRecognizer()
                ..onTap = () {
                  navigateAndClearHistory(context, '/SignUpScreen');
                },
            )
          ],
        ),
      ),
    );
  }

  Future<void> checkValidations() async {
    if (email.text.isEmpty) {
      isDisplayEmailErrorNotification = true;
      isDisplayErrorNotification = false;

      showErrorNotification(pleaseEnterEmail);
    } else if (!EmailValidator.validate(email.text.trim())) {
      isDisplayEmailErrorNotification = true;
      isDisplayErrorNotification = false;

      showErrorNotification(pleaseEnterValidEmail);
    } else if (password.text.isEmpty) {
      isDisplayErrorNotification = true;
      isDisplayEmailErrorNotification = false;

      showErrorNotification(pleaseEnterPassword);
    } else {
      if (isDisplayErrorNotification == true ||
          isDisplayEmailErrorNotification == true) {
        hideErrorNotification();
        setUnAuthFlagFalse();
      }
      hideKeyboard(context);
      
      setState(() {
        showLoadingIndicator = true;
      });

      try {
        globalSession = await globalClient.authenticate(
            'sigmarectrix.com', email.text, password.text);
        setState(() {
          showLoadingIndicator = false;
        });
        ScaffoldMessenger.of(context).clearMaterialBanners();  
          // for a little bit of animation we remove the original line which is  //navigateAndClearHistory(context, HomeScreen.routeName)
          Navigator.pushAndRemoveUntil(
            context, 
            BouncyPageRoute(
              widget: HomeScreen()
            ), 
          ModalRoute.withName(HomeScreen.routeName)
          );
      } on OdooException catch (e) {
        setState(() {
          showLoadingIndicator = false;
        });
        print(e);
        ScaffoldMessenger.of(context).showMaterialBanner(MaterialBanner(
          backgroundColor: Colors.yellow,
          content: const Text(
            "Invalid Email or Password",
            style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.bold,
                ),

          ),
          actions: [
            TextButton(
                onPressed: () {
                  ScaffoldMessenger.of(context).clearMaterialBanners();
                },
                child: const Text("Dismiss",
                style: TextStyle(
                  fontStyle: FontStyle.normal,
                  fontWeight: FontWeight.bold,
                ),
                )

                )
          ],
       
        ));
        globalClient.close();

      } 
    }
  }

  void onFocusChanged() {
    setState(() {});
  }
}
