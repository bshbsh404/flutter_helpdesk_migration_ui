import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shopping_app_ui/OdooApiCall_DataMapping/ResPartner.dart';
import 'package:shopping_app_ui/OdooApiCall_DataMapping/SupportTicketandResPartner.dart';
import 'package:shopping_app_ui/colors/Colors.dart';
import 'package:shopping_app_ui/constant/Constants.dart';
import 'package:shopping_app_ui/screens/authentication/LoginScreen.dart';
import 'package:shopping_app_ui/widgets/Styles.dart';
import 'package:shopping_app_ui/widgets/MyCustomStepper.dart'
    as MyCustomStepper;
import 'package:shopping_app_ui/util/Util.dart';
import 'package:slide_to_act/slide_to_act.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';
import '../../OdooApiCall/AllTicketsApi.dart';
import '../../util/size_config.dart';
import '../../widgets/MapsWidget.dart';

class MyAttendanceScreen extends StatefulWidget {
  MyAttendanceScreen(this.supporticket, this.respartner_id);
  final SupportTicketResPartner supporticket;
  final respartner_id;
  @override
  _MyAttendanceScreenState createState() => _MyAttendanceScreenState();
}

class _MyAttendanceScreenState extends State<MyAttendanceScreen> {

  TextStyle orderStatusInfoTextStyle = TextStyle(
    fontSize: 11,
    fontFamily: poppinsFont,
    color: Colors.black.withOpacity(0.6),
  );
  double currentLat;
  double currentLong;
  final panelController = PanelController();
  

  Future<void> getResPartnerData() async {
    var listResPartner = await AllTicketsApi.getResPartner(widget.respartner_id);
    print(widget.respartner_id);

    setState(() {
      for(int i=0;i<listResPartner.length;i++){
      currentLat= listResPartner[i].partner_latitude;
      currentLong= listResPartner[i].partner_longitude;
    }
    });    
    print('tiba masanya kamu faham anak muda: '+listResPartner.toString());
  }

  @override
  void initState(){
    super.initState();
    getResPartnerData();
  }

  @override
  Widget build(BuildContext context) {
    final panelHeightClosed = SizeConfig.screenHeight*0.16;
    final panelHeightOpen = SizeConfig.screenHeight*0.55;

    return Scaffold(
      backgroundColor: isDarkMode(context) ? darkBackgroundColor : Theme.of(context).backgroundColor,
      appBar: buildAppBar(context, 'My Attendance', onBackPress: () {
        Navigator.pop(context,MapsWidget(widget.supporticket, currentLat, currentLong));       
      }),
      body: SlidingUpPanel (
        defaultPanelState: PanelState.CLOSED,
        color: Theme.of(context).primaryColor,
        controller: panelController,
        minHeight: panelHeightClosed,
        maxHeight: panelHeightOpen,
        parallaxEnabled: true,
        parallaxOffset: 1.0, //maybe 0.5 is better
        body: MapsWidget(widget.supporticket,currentLat,currentLong),
        panelBuilder: (controller) => PanelWidget(
          panelController : panelController,
          controller: controller,
        ),
        /* //notes by hafizalwi: ideally we can use onPanelSlide and create a better gui where floating button will float on top of slidinguppanel even when panel is open or close
        //but we will not used it as It brings a lot of lagginess to the apps.
        onPanelSlide: (position)=> setState((){
          //print(position);
          position;
        }),
        */    
      ),

      
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 22.0, vertical: 25.0),
        child: Container(
          height: 56.0,
          alignment: Alignment.center,
          child: forfun(),
        ),
      ),
    );
    }

  Widget buildDragHandle()  => InkWell(
    child:Center(
      child:Padding(
        //padding: const EdgeInsets.fromLTRB(8,0,8,8), 
        padding: const EdgeInsets.all(8.0),
        child: Container(
          width:30,
          height:8,
          decoration:BoxDecoration(
          color:Colors.grey[300],
          borderRadius:BorderRadius.circular(12),
          ),// BoxDecoration
        ),
      ),// Container
    ),// Center
  onTap:togglePanel,
  );// GestureDetector
  //currently there is a bug where isPanelOpen and isPanelClosed will always return false because panelposition does not reach 1 , but close to 0. eg : panelposition: 0.9999999
  //due to this bug we cannot close it
  void togglePanel() => panelController.isPanelOpen
    ? panelController.close().then((value) => print("panelControllerstate: "+ panelController.isPanelClosed.toString()))
    : panelController.open();

  Widget PanelWidget({ScrollController controller, PanelController panelController}){
    //final ScrollController controller; 
    //we will combine all the widgets needed inside here.
    return
      SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.max,
          children: [ 
            buildDragHandle(),
            Flexible(
              child: SingleChildScrollView(
                physics: BouncingScrollPhysics(),
                controller: controller,
                child: Column(
                  children: [
                    buildIntro(),
                    //buildStepper(),
                    buildAttendanceData(),
                    buildHomeAddress(),
                    //buildDeliveryExpectCard() //
                  ],
                ),
              ),
            ),
          ],
        ),
      );
  }

  Widget buildIntro () {
    return Padding(
      padding:
          const EdgeInsets.only(left: 16.0, right: 16.0, top: 16, bottom: 4.0),
      child: Card(
        elevation: 6,
        color: isDarkMode(context) ? darkGreyColor : Colors.white,
        shadowColor: Colors.grey.withOpacity(0.15),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
          child: Container(
            width: double.infinity,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Hello, ' + globalClient.sessionId.userName.toString(),
                
                //+ 'this is partner longitude: '+widget.supporticket.partner_long.toString()
                //+' \n this is partner latitude: '+ currentLat.toString()
                //+' \N this is last update '+ currentLong.toString(),
                  style: Theme.of(context).textTheme.subtitle1.copyWith(
                      fontWeight: Theme.of(context).textTheme.subtitle2.fontWeight),
                ),
                SizedBox(
                  height: 5,
                ),
                Text('Please Check in here!',
                    style: homeScreensClickableLabelStyle),
                  SizedBox(
                  height: 10,
                ),
                Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: (0),
                  vertical: (0),
                ),
                child: Row(
                  children: [
                    StreamBuilder<Object>(
                      stream: Stream.periodic (const Duration (seconds: 1), (count) => Duration(seconds:count)),
                      builder: (context, snapshot) {
                        return Container(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            DateFormat ('hh:mm:ss aa').format(DateTime.now()),
                            style: ticketScreensClickableLabelStyle.copyWith(color: isDarkMode(context)?Color.fromARGB(255, 232, 120, 251): Colors.purpleAccent )
                          ), 
                        );
                      }
                    ),
                    Spacer(),
                      //TODO if checked in and checked out, put icons.check, otherwise put icons.warning/icons..waiting
                      InkWell(
                      child: Container(
                        width: 20,
                        height: 20,
                        decoration: BoxDecoration(
                          color: primaryColor,
                          borderRadius: BorderRadius.all(
                            Radius.elliptical(10, 10),
                          ),
                        ),
                        child: Center(
                          child: Icon(
                            Icons.check,
                            color: Colors.white,
                            size: 14,
                          ),
                        ),
                      ),
                      onTap: () {}(),
                    ),
                  ],
                ),
              ),
              ],
            ),
          ),
        ),
      ),
    );    

  }


  Widget buildDeliveryExpectCard() {
    return Padding(
      padding:
          const EdgeInsets.only(left: 16.0, right: 16.0, top: 16, bottom: 4.0),
      child: Card(
        elevation: 6,
        color: isDarkMode(context) ? darkGreyColor : Colors.white,
        shadowColor: Colors.grey.withOpacity(0.15),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
          child: Container(
            width: double.infinity,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Delivery expected on Sat, 19',
                  style: Theme.of(context).textTheme.subtitle1.copyWith(
                      fontWeight: Theme.of(context).textTheme.subtitle2.fontWeight),
                ),
                SizedBox(
                  height: 5,
                ),
                Text('Order ID: OD110589307',
                    style: homeScreensClickableLabelStyle),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget buildAttendanceData() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 4.0),
      child: Card(
        elevation: 6,
        color: isDarkMode(context) ? darkGreyColor : Colors.white,
        shadowColor: Colors.grey.withOpacity(0.15),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        child: Padding(
          padding: EdgeInsets.only(
            top: getProportionateScreenWidth(8),
            bottom: getProportionateScreenWidth(8),
          ),
          child: Column(
            children: [
              buildListRow(
                Icon(Icons.location_pin, size:30),//size: SizeConfig.screenHeight*0.030),
                'Location',
                'Kota Kinabalu'
              ),
              Divider(),
              buildListRowWithTwoData(
                Icon(Icons.calendar_month, size:30),//size: SizeConfig.screenHeight*0.030), 
                'Check In',
                '12/12/2022', 
                'Check out', 
                '13/12/2022'),
              SizedBox(height: 10),             
            ],
            
          ),
        ),
      ),
    );
  }
  /*
  Widget buildStepper() {
    List<MyCustomStepper.Step> orderSteps = [
      MyCustomStepper.Step(
        title: Text(
          'Ordered',
          style: Theme.of(context).textTheme.subtitle2,
        ),
        isActive: true,
        state: MyCustomStepper.StepState.complete,
        subtitle: Text(
          'Sat, 19th Dec 2020',
          style: Theme.of(context).textTheme.caption,
        ),
        content: Container(),
      ),
      MyCustomStepper.Step(
        title: Text(
          'Shipped',
          style: Theme.of(context).textTheme.subtitle2,
        ),
        isActive: true,
        state: MyCustomStepper.StepState.complete,
        subtitle: Text(
          'Tue, 22nd Dec 2020',
          style: Theme.of(context).textTheme.caption,
        ),
        content: Text(
          'Package left warehouse facility, 10:00 pm\n' +
              'Package arrived at Grand Station, 12:00 am',
          style: Theme.of(context).textTheme.caption,
        ),
      ),
      MyCustomStepper.Step(
        title: Text(
          'Delivered',
          style: Theme.of(context).textTheme.subtitle2,
        ),
        isActive: true,
        state: MyCustomStepper.StepState.emptyCircle,
        subtitle: Container(),
        content: Container(),
      ),
    ];

    return Theme(
      data: ThemeData(
        primaryColor: primaryColor,
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
        child: Card(
          elevation: 2,
          color: isDarkMode(context) ? darkGreyColor : Colors.white,
          shadowColor: Colors.grey.withOpacity(0.15),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          child: MyCustomStepper.MyCustomStepper(
            steps: orderSteps,
            currentStep: 1,
            controlsBuilder: (BuildContext context,
                    ControlsDetails controls) =>
                Container(),
          ),
        ),
      ),
    );
  }
  */
  Widget buildHomeAddress() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 4.0),
      child: Card(
        elevation: 6,
        color: isDarkMode(context) ? darkGreyColor : Colors.white,
        shadowColor: Colors.grey.withOpacity(0.15),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
          child: Container(
            width: double.infinity,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Check in Check out',
                  style: Theme.of(context).textTheme.subtitle1.copyWith(
                      fontWeight: Theme.of(context).textTheme.subtitle2.fontWeight),
                ),
                SizedBox(
                  height: 5,
                ),
                Text(
                  '2249 Carling Ave #416',
                  style: Theme.of(context).textTheme.bodyText2,
                ),
                SizedBox(
                  height: 5,
                ),
                Text(
                  'Ottawa, ON K2B 7E9',
                  style: Theme.of(context).textTheme.bodyText2,
                ),
                SizedBox(
                  height: 5,
                ),
                Text(
                  'Canada',
                  style: Theme.of(context).textTheme.bodyText2,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget forfun() {
  return Container(
     
    child: Padding(
      padding: EdgeInsets.symmetric(vertical: SizeConfig.screenHeight * 0.018),
      child: Builder(
        builder: (context){
          final GlobalKey <SlideActionState> key = GlobalKey();
          return SlideAction(
            text: 'slide to check in',
            textStyle: TextStyle(
              color: isDarkMode(context) ? Colors.white.withOpacity(0.8) : Colors.white,
            ), // TextStyle
            outerColor: isDarkMode(context) ? Colors.grey : Colors.white,
            innerColor: isDarkMode(context) ? primaryColorDark : primaryColor,
            key: key,
            onSubmit: () async {
              //we will return lottie here hehehe?!
            }
          );
        }
      ),
    )
  );
  }            

  Widget buildBottomPart() {
    return Container(
      child: buildButton(
        'Slide to check in',
        true,
        isDarkMode(context) ? primaryColorDark : primaryColor,
        isDarkMode(context) ? Colors.white.withOpacity(0.8) : Colors.white,
        2,
        2,
        8,
        onPressed: () {
          navigateHomeScreen(context);
        },
      ),
    );
  }
  Widget buildListRow(Icon icon, String title, String subtitle) {
    return InkWell(
      child: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: getProportionateScreenWidth(16),
          vertical: getProportionateScreenWidth(8),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            icon,
            Padding(
              padding: const EdgeInsets.only(left: 20), //to make it kinda allign
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: Theme.of(context).textTheme.caption,
                  ),
                  Text(
                    subtitle,
                    style: Theme.of(context).textTheme.subtitle1.copyWith(
                      fontWeight: Theme.of(context).textTheme.subtitle2.fontWeight
                    ),
                  ),
                ],
              ),
            ),
            Spacer(),
            Icon(Icons.navigate_next)
          ],
        ),
      ),
    );
  }
  Widget buildListRowWithTwoData(Icon icon, String title, String subtitle, String title2, String subtitle2 ) {
    return InkWell(
      child: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: getProportionateScreenWidth(16),
          vertical: getProportionateScreenWidth(8),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            icon,
            Padding( //to make the padding kinda allign, i have to set this paddning to 0, while keeping location icon padding to 20 // TODO: find a way to align, perhaps using property such as spacebetween/spaceevenly properly
              padding: const EdgeInsets.symmetric(
                horizontal: 0,
                vertical: 0,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [        
                  Text(
                    title2,
                    style: Theme.of(context).textTheme.caption,
                  ),
                  Text(
                    subtitle,
                    overflow: TextOverflow.ellipsis,
                    maxLines: 3,
                    style: Theme.of(context).textTheme.subtitle1.copyWith(
                      fontWeight: Theme.of(context).textTheme.subtitle2.fontWeight
                    ),
                  ),
                ],              
              ),           
            ),     
            Container
            (
              height: SizeConfig.screenHeight/20, // i think this is the magic height, otherwise, please find way to stretch this container size to its parent size <row>. //TODO making this todo incase 
              child: VerticalDivider(
                thickness: 2,
                width: 20,
                color: isDarkMode(context) ? Colors.white54 : Colors.black,
              ),
            ),      
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: Theme.of(context).textTheme.caption,
                ),
                Text(
                  subtitle2,
                  overflow: TextOverflow.ellipsis,
                  maxLines: 3,
                  style: Theme.of(context).textTheme.subtitle1.copyWith(
                    fontWeight: Theme.of(context).textTheme.subtitle2.fontWeight
                  ),
                ),
              ]
            ),
            //Spacer(),
            Icon(Icons.navigate_next)
          ],
        ),
      ),
    );
    
  }

  @override
  void dispose(){
    super.dispose();
    print("Attendancescreen disposed");
    

  }
}
