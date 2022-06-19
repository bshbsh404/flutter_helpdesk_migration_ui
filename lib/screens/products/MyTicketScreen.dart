import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';
import 'package:odoo_rpc/odoo_rpc.dart';
import 'package:shopping_app_ui/Data/ProductData.dart';
import 'package:shopping_app_ui/OdooApiCall_DataMapping/ResPartner.dart';
import 'package:shopping_app_ui/OdooApiCall_DataMapping/SupportTicketandResPartner.dart';
import 'package:shopping_app_ui/colors/Colors.dart';
import 'package:shopping_app_ui/constant/Constants.dart';
import 'package:shopping_app_ui/model/Product.dart';
import 'package:shopping_app_ui/model/ProductInCart.dart';
import 'package:shopping_app_ui/screens/launch/HomeScreen.dart';
import 'package:shopping_app_ui/screens/products/MyAttendanceScreen.dart';
import 'package:shopping_app_ui/screens/products/TicketDetailScreen.dart';
import 'package:shopping_app_ui/util/RemoveGlowEffect.dart';
import 'package:shopping_app_ui/util/size_config.dart';
import 'package:shopping_app_ui/widgets/Styles.dart';
import 'package:shopping_app_ui/util/Util.dart';



























import '../../OdooApiCall/AllTicketsApi.dart';
import '../../OdooApiCall_DataMapping/SupportTicket.dart';
import '../LoadingAnimation.dart';
import '../authentication/LoginScreen.dart';


class MyTicketScreen extends StatefulWidget {
  @override
  _MyTicketScreenState createState() => _MyTicketScreenState();
}

class _MyTicketScreenState extends State<MyTicketScreen> {
  final scrollcontroller = ScrollController();
  List<ResPartner> partnerlist ;

  @override
  void initState(){
    super.initState();
    print ('find out whether sessionId exist!?' + globalClient.sessionId.id.toString());
    print('find out what the fuck is in globalsession '+ globalSession.toString());
   
  
  }

  @override
  void dispose() {
  
    scrollcontroller.dispose();  
    super.dispose();
  }

  /*getPartnerImage(supportticketID) async {
    Future<List<ResPartner>> respartnerlist = AllTicketsApi.getPartnerImage(supportticketID); //fetch partner image data based on support ticket ID.
    //we have awaited , it should give us instance of [] anymore....
    partnerlist = await respartnerlist;
    print ('getPartnerImage function respartnerlist yofuture?: '+partnerlist.toString());
  }
  */

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
              FutureBuilder(
                //future: AllTicketsApi.getAllSupportTickets(),
                future: AllTicketsApi.getAllSupportTickets(),//Future.wait( [AllTicketsApi.combinedData(), AllTicketsApi.getAllSupportTickets()]),
                builder: (context, snapshot) {
                  //final partners = snapshot.data[0];
                  final tickets = snapshot.data;
                     
                  switch (snapshot.connectionState) {
                    case ConnectionState.waiting:
                      return AnimatedContainers(context);

                    case ConnectionState.none:
                      break;
                                  

                    case ConnectionState.active: //this is for stream so, futurebuilder does not need to use this.
                      // TODO: Handle this case.
                    break;

                    case ConnectionState.done:
                      if(snapshot.hasData){
                        return buildSupportTickets(//partners,
                        tickets);
                      }
                      else if (snapshot.hasError){
                        bool loadText;
                        return Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Lottie.asset(
                              'assets/json/lottieJson/no-internet.json',
                              repeat: true,
                            ),
                            
                            
                            const SizedBox(height:(10)),
                            Text('Unable to fetch data, please refresh and try again.', style: Theme.of(context).textTheme.subtitle1.copyWith(
                              fontWeight: Theme.of(context).textTheme.subtitle2.fontWeight),textAlign: TextAlign.center,)
                          ],
                        );
                        //return Text('Some error has occured on snapshot');
                      }
                      else if (snapshot.hasData == false){
                        return Column(
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
                      );
                      }
                      else
                        return Center(child: Text('ConnectionDone but some error occured!'));
                                    
                    /*default:
                      if (snapshot.hasError && snapshot.connectionState == ConnectionState.waiting) {
                        return Center(child: Text('Some error occurred!'));
                      } else if(tickets.length == 0) {
                        return Column(
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
                      );

                      }else if (snapshot.hasData && snapshot.connectionState == ConnectionState.done){                      
                        return buildSupportTickets(//partners,
                        tickets);
                      }

                      else {
                        return Text('State: ${snapshot.connectionState}');
                      }

                   */   
                  }
                  return Text('Connection is broken,Some error ocurred! ${snapshot.connectionState}');
                },
              ),                    
                /*myTicketProducts.length > 0
                    ? ListView.builder(
                        shrinkWrap: true,
                        physics: BouncingScrollPhysics(),
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
                */
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget buildSupportTickets(//List<dynamic>respartners,
  List<SupportTicketResPartner> supporttickets) =>

    ListView.builder(
      shrinkWrap: true,
      physics: BouncingScrollPhysics(),
      itemCount: supporttickets.length,
      controller: scrollcontroller,
      itemBuilder: (context, index){

        var supportticket = supporttickets[index];
        //var respartner = respartners[index];
        String unique = 'empty' ;
        print('is the problem here before getpartnerimage?');
        print('can we get the supportticket_id here?' +supportticket.partner_id.toString());
        print ('unique' + unique);
        var avatarUrl;

        if(supportticket.partner_id != null)
          avatarUrl= '${globalClient.baseURL}/web/image?model=res.partner&id=${supportticket.partner_id}&field=image_medium'; //&unique=$unique';
        else
          avatarUrl = null;
          DateFormat inputFormat = DateFormat('yyyy-MM-dd HH:mm:ss');
          DateTime input = inputFormat.parse (supportticket.created_date);
          DateTime MYtimezone = input.add(Duration(hours:8));                    
          String create_date = DateFormat("dd/MM/yyyy hh:mm:ss a").format(MYtimezone); //use this variable, because malaysia timezone is +8 hours from UTC. database gives u UTC time
          String respartner_id = supportticket.partner_id != null ? supportticket.partner_id : ''; //we need this to pass non null partner_id data to the attendance screen, to get the partner_latitude and longitude
          //field respartner_id is very important.
          

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
          //create Inkwell to head the items
          child: InkWell(
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
                          avatarUrl != null ? CircleAvatar(
                            backgroundImage: NetworkImage(avatarUrl, headers: {"X-Openerp-Session-Id":globalClient.sessionId.id}), 
                            onBackgroundImageError: null,
                            backgroundColor: Color.fromARGB(255, 150, 190, 223),     
                            radius:getProportionateScreenWidth(35) )
                            :                  
                            CircleAvatar(
                            backgroundColor: Color.fromARGB(255, 150, 190, 223),     
                            radius:getProportionateScreenWidth(35) ),              
                          /*Image.asset(
                            '$productImagesPath/${product.productImage}',
                            height: getProportionateScreenWidth(80),
                            width: getProportionateScreenWidth(80),
                          ),*/
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
                                    width: SizeConfig.screenWidth / 1.8,
                                    child: Text(
                                      '#${supportticket.ticket_number} ${supportticket.subject}',
                                      overflow: TextOverflow.ellipsis,
                                      maxLines: 2,
                                      style: Theme.of(context).textTheme.subtitle1.copyWith(
                                            fontWeight: Theme.of(context).textTheme.subtitle2.fontWeight),
                                      
                                    ),
                                  
                                  ),
                                  SizedBox(height: getProportionateScreenHeight(5)),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      /*Text(
                                        '\$' +
                                            (product.originalPrice -
                                                    (product.originalPrice *
                                                        product.discountPercent /
                                                        100))
                                                .toStringAsFixed(2),
                                        
                                        '#${supportticket.ticket_id}',
                                        style: Theme.of(context).textTheme.subtitle1.copyWith(
                                            fontWeight: Theme.of(context).textTheme.subtitle2.fontWeight),
                                      ),
                                      SizedBox(
                                        width: 10,
                                      ),*/
                                      Container(
                                        width: SizeConfig.screenWidth / 1.8,
                                        child: RichText(
                                          overflow: TextOverflow.ellipsis,
                                          maxLines: 2,
                                          text: TextSpan(
                                            children: [
                                              WidgetSpan(
                                                child: Icon(Icons.person,size: 20),
                                              ),
                                              TextSpan(
                                                text: ' '+supportticket.equipment_user,
                                                style: ticketScreensClickableLabelStyle,
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                      /*Text(
                                        
                                        'User: '+supportticket.equipment_user,
                                        style: homeScreensClickableLabelStyle,
                                        overflow: TextOverflow.ellipsis,
                                        maxLines: 2,
                                      ),*/
                                      /*SizedBox(
                                        width: 10,
                                      ),
          
          
                                      Text(
                                        '',
                                        style: homeScreensClickableLabelStyle,
                                      ),*/
                                    ],
                                  ),
          
                                  
          
                                    supportticket.partner_name != ''? 
                                      Container(
                                        width: SizeConfig.screenWidth / 1.8,
                                        child: RichText(
                                          overflow: TextOverflow.ellipsis,
                                          maxLines: 1,
                                          text: TextSpan(
                                            children: [
                                              WidgetSpan(
                                                child: Icon(Icons.business,size: 20),
                                              ),
                                              TextSpan(
                                                text: ' '+supportticket.partner_name.toString(),
                                                style:Theme.of(context)
                                                .textTheme
                                                .bodyText2
                                                .copyWith(
                                                  //decoration:
                                                  //    TextDecoration.lineThrough,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      )                               
                                    :const SizedBox(),
          
          
                                    Container(
                                      width: SizeConfig.screenWidth / 1.8,
                                        child: RichText(
                                          overflow: TextOverflow.ellipsis,
                                          maxLines: 1,
                                          text: TextSpan(
                                            children: [
                                              WidgetSpan(
                                                child: Icon(Icons.date_range,size: 20),
                                              ),
                                              TextSpan(
                                                text: ' '+create_date,
                                                style:Theme.of(context)
                                                .textTheme
                                                .bodyText2
                                                .copyWith(
                                                  //decoration:
                                                  //    TextDecoration.lineThrough,
                                                  color: Theme.of(context).textTheme.caption.color,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                    ),
          
                                    SizedBox(height : getProportionateScreenHeight(10)),
                                    Container(
                                      width: SizeConfig.screenWidth / 2,
                                        child: RichText(
                                          overflow: TextOverflow.ellipsis,
                                          maxLines: 2,
                                          text: TextSpan(
                                            children: [ 
                                              supportticket.category_name != '' && supportticket.subcategory_name == ''
                                              ?                            
                                              TextSpan(                 
                                                text: '• '+supportticket.category_name,
                                                style:Theme.of(context)
                                                .textTheme
                                                .bodyText2
                                                .copyWith(
                                                  decoration: TextDecoration.underline,
                                                  color: orangeredColor                                  
                                                ),
                                              ) :
          
                                              supportticket.category_name !='' && supportticket.subcategory_name != ''
                                              ?                                           
                                              TextSpan( 
                                                children: [            
                                                  TextSpan (                                            
                                                    text: '• '+supportticket.category_name,
                                                    style:Theme.of(context)
                                                    .textTheme
                                                    .bodyText2
                                                    .copyWith(
                                                      decoration: TextDecoration.underline,
                                                      color: orangeredColor                                  
                                                    )
                                                  ),
                                                  TextSpan(                                              
                                                    text: ' '+'• '+supportticket.subcategory_name,
                                                    style:Theme.of(context)
                                                    .textTheme
                                                    .caption
                                                    .copyWith(                                                   
                                                    ),
                                                  )
                                                ]
                                              ) 
                                              : 
                                              TextSpan(),                                 
                                            ],
                                          ),
                                        ),
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
                          /*
                          setState(
                            () {
                              myTicketProducts.remove(product);
                            },
                          );
                          */
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
                      child:      
                      /*supportticket.check_in != '' && supportticket.check_out != '' 
                                    ? 'Done checked out'
                                    : null,
                                style: supportticket.check_in != '' && supportticket.check_out != '' 
                                    ? Theme.of(context).textTheme.caption.copyWith(
                                      fontFamily: poppinsFont,
                                      color:Colors.white
                                    )
                      */
                      supportticket.check_in != '' && supportticket.check_out != '' 
                      ? 
                      Text('Done checked out',
                        style: Theme.of(context).textTheme.caption.copyWith(
                          fontFamily: poppinsFont,
                        )
                      )                     
                      :
                      ElevatedButton(     
                        onPressed:(){
                          
                          Navigator.push(
                            context,
                            OpenUpwardsPageRoute(child: MyAttendanceScreen(
                              supportticket, respartner_id), 
                              direction: AxisDirection.up)).then((value){
                                setState((){
                                  
                                });
                              });                     
                        } ,
                        autofocus: true,
                        style: ButtonStyle(
                          elevation: MaterialStateProperty.resolveWith<double>(
                          (Set<MaterialState> states) {
                            if (states.contains(MaterialState.pressed))
                              return 16;
                            return null;
                          }),
                          //shape: RectangularRangeSliderTrackShap
                          backgroundColor: MaterialStateProperty.all<Color>(primaryColor),
                          
                          ),
             
                        child: RichText(
                          text: TextSpan(
                            children: [                    
                              TextSpan(
                                text: supportticket.check_in == '' && supportticket.check_out == '' 
                                    ? 'CHECK IN'
                                    : supportticket.check_in  != '' && supportticket.check_out == ''
                                    ? 'CHECK OUT'
                                    : null,
                                    style: Theme.of(context).textTheme.button.copyWith(
                                        fontFamily: poppinsFont,
                                        color: Colors.white,
                                        fontWeight: FontWeight.w600,
                                        decoration: TextDecoration.none,         
                                    ),
                                /*
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
                                */
                              ),
                              /*
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
                              */
                              
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            onTap: () {                         
              Navigator.push(
                context,
                OpenUpwardsPageRoute(child: TicketDetailScreen(
                  supportticket, respartner_id), 
                  direction: AxisDirection.right)).then((value){
                    setState((){
                      
                    });
                  }); 
            }
          ),
          
        ),
      //),
      );
      } 


    );
  

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
