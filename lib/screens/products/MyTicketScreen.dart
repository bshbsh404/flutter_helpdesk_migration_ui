import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';
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
import 'package:shopping_app_ui/util/RemoveGlowEffect.dart';
import 'package:shopping_app_ui/util/custom_pageroutebuilder.dart';
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
    checkOdooSession();
    print ('find out whether sessionId exist!?' + globalClient.sessionId.id.toString());
    print('find out what the fuck is in globalsession '+ globalSession.toString());
   
  
  }

  Future<void> checkOdooSession () async {
    try {
      await globalClient.checkSession();
      print ('session is still alive in myticketscreen');
    } on OdooSessionExpiredException {
      print('Session expired in myticketscreen');
    }
  }


  @override
  void dispose() {
    super.dispose();
    scrollcontroller.dispose();  
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
                future: AllTicketsApi.getAllSupportTicketsResPartner(),//Future.wait( [AllTicketsApi.combinedData(), AllTicketsApi.getAllSupportTickets()]),
                builder: (context, snapshot) {
                  //final partners = snapshot.data[0];
                  final tickets = snapshot.data;
                  
          
                  switch (snapshot.connectionState) {
                    case ConnectionState.waiting:
                      return AnimatedContainers(context);
                    default:
                      if (snapshot.hasError) {
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

                      }else {                      
                        return buildSupportTickets(//partners,
                        tickets);
                      }
                  }
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
        print('can we get the supportticket_id here?' +supportticket.partner_id);

        //var respartnerlist = AllTicketsApi.getPartnerImage(supportticket.partner_id); //fetch partner image data based on support ticket ID.
        
        //getPartnerImage(supportticket.partner_id); //call the class for fetching partner image data
        /*
        FutureBuilder <List<ResPartner>>(
          future: AllTicketsApi.getPartnerImage(supportticket.partner_id),
          // ignore: missing_return
          builder: (context, snapshot)   
          {
          if (snapshot.hasData){
            print("This is the output in hasData ${snapshot.data[index].last_update}");

            setState(() {
            unique = snapshot.data[index].last_update;
            unique = unique.replaceAll(RegExp(r'[^0-9]'), '');              
            });
            //unique = snapshot.data[index].last_update;
            //unique = unique.replaceAll(RegExp(r'[^0-9]'), '');
          }
          else if(snapshot.hasError){
            print("This is the output in snapshothaserror ${snapshot.data[index].last_update}");
          }
          else 
            print("some error occured");
          });
          */

        print ('unique' + unique);


        //var newPartnerList = partnerlist; //create  a temporary variable to store partnerlist value, because we doont want to turn partnerlist into String directly.
        //print ('now we print partnerlist value: '+newPartnerList.toString());
        unique = supportticket.last_update;   //assign unique here
        unique = unique.replaceAll(RegExp(r'[^0-9]'), '');
        var avatarUrl;

        if(supportticket.partner_id != 'false' && unique != '')
          avatarUrl= '${globalClient.baseURL}/web/image?model=res.partner&id=${supportticket.partner_id}&field=image_medium'; //&unique=$unique';
        else
          avatarUrl = null;

          DateFormat inputFormat = DateFormat('yyyy-MM-dd HH:mm:ss');
          DateTime input = inputFormat.parse (supportticket.created_date);
          DateTime MYtimezone = input.add(Duration(hours:8));                    
          String create_date = DateFormat("dd/MM/yyyy hh:mm:ss a").format(MYtimezone); //use this variable, because malaysia timezone is +8 hours from UTC. database gives u UTC time

        //'${globalClient.baseURL}/web/image?model=res.partner&field=image_small&id=${supportticket.partner_id}&unique=$unique';
        //${globalClient.baseURL/web/image?model=res.partner&id=${supportticket.partner_id}&field=image_medium&unique=${unique}}

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
                                    '#${supportticket.ticket_id} ${supportticket.subject}',
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

                                

                                  supportticket.partner_name != 'false'? 
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
                                              text: ' '+supportticket.partner_name,
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
                                            null                                       
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
                            supportticket), 
                            direction: AxisDirection.up),                         
                          //MaterialPageRoute(
                          //  builder: (context) => MyAttendanceScreen(supportticket) //here we passed the data of supportticket listview card. So there will be no need of calling twice. save performance.
                          //)
                        ); 
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
