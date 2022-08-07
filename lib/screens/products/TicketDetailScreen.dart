import 'package:flutter/material.dart';
import 'package:shopping_app_ui/Data/ProductData.dart';
import 'package:shopping_app_ui/OdooApiCall_DataMapping/SupportTicketandResPartner.dart';
import 'package:shopping_app_ui/colors/Colors.dart';
import 'package:shopping_app_ui/constant/Constants.dart';
import 'package:shopping_app_ui/util/size_config.dart';
import 'package:shopping_app_ui/widgets/Styles.dart';
import 'package:shopping_app_ui/widgets/MyCustomStepperHafiz.dart'
    as MyCustomStepper;
import 'package:shopping_app_ui/util/Util.dart';

class TicketDetailScreen extends StatefulWidget {

  TicketDetailScreen(this.supportticket, this.respartner_id);

  //final SupportTicketResPartner supportticket;
  final supportticket;
  final respartner_id;

  @override
  _TicketDetailScreenState createState() => _TicketDetailScreenState();
}

class _TicketDetailScreenState extends State<TicketDetailScreen> {
  TextStyle orderStatusInfoTextStyle = TextStyle(
    fontSize: 11,
    fontFamily: poppinsFont,
    color: Colors.black.withOpacity(0.6),
  );
  
  double rowLineHeight = 8.0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: isDarkMode(context) ? darkBackgroundColor : Theme.of(context).backgroundColor,
      appBar: buildAppBar(context, 'Details', onBackPress: () {
        Navigator.pop(context);
      }),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              //buildDeliveryExpectCard(),
              buildStepper(),
              buildDetailScreen(),
              //buildHomeAddress(),
            ],
          ),
        ),
      ),
      
      /*
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 22.0, vertical: 25.0),
        child: Container(
          height: 56.0,
          alignment: Alignment.center,
          child: buildBottomPart(),
        ),
      ),
      */
    );
  }

  /*
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
                Text('Home Address',
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
                SizedBox(
                  height: 10,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Default delivery address',
                        style: homeScreensClickableLabelStyle),
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
              ],
            ),
          ),
        ),
      ),
    );
  }
  */

  Widget buildStepper() {
    
    List<MyCustomStepper.Step> orderSteps = [
      if(widget.supportticket.open_case != '')
      MyCustomStepper.Step(
        title: Text(
          'Case Opened',
          style: Theme.of(context).textTheme.subtitle2,
        ),
        isActive: true,
        state: MyCustomStepper.StepState.filledCircle,
        subtitle: Text(
          widget.supportticket.open_case,
          style: Theme.of(context).textTheme.caption,
        ),
        content: Container(),
      ),

      if(widget.supportticket.created_date != '')
      MyCustomStepper.Step(
        title: Text(
          'Ticket Created',
          style: Theme.of(context).textTheme.subtitle2,
        ),
        isActive: true,
        state: MyCustomStepper.StepState.created,
        subtitle: Text(
          widget.supportticket.created_date,
          style: Theme.of(context).textTheme.caption,
        ),
        content: Container(),
      ),


      if(widget.supportticket.check_out != '')
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

      if(widget.supportticket.check_in != '')
        MyCustomStepper.Step(
        title: Text(
          'Technician Checked In',
          style: Theme.of(context).textTheme.subtitle2,
        ),
        isActive: true,
        state: MyCustomStepper.StepState.engineer_arrived,
        subtitle: Text(
          widget.supportticket.check_in,
          style: Theme.of(context).textTheme.caption,
        ),
        content: Container(),
      ),

      if(widget.supportticket.check_out != '')
        MyCustomStepper.Step(
        title: Text(
          'Technician Checked Out',
          style: Theme.of(context).textTheme.subtitle2,
        ),
        isActive: true,
        state: MyCustomStepper.StepState.complete,
        subtitle: Text(
          widget.supportticket.check_out,
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
          'Case Closed',
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
          child: MyCustomStepper.MyCustomStepperHafiz(
            physics: ClampingScrollPhysics(),
            steps: orderSteps,
            currentStep: 2,
            controlsBuilder: (BuildContext context,
                    ControlsDetails controls) =>
                Container(),
          ),
        ),
      ),
    );
  }
  

    Widget buildDetailScreen() {

      var _RowSerialNumber = Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 2,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                'Equipment Serial Number: ',
                style: Theme.of(context).textTheme.bodyText2,
                softWrap: true,
              ),
            ),
          ),
          Expanded(
            flex: 2,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child:
              widget.supportticket.itemname != null ?
              Text(
                widget.supportticket.itemname,
                style: Theme.of(context).textTheme.bodyText2,
                textAlign: TextAlign.right,
                softWrap: true,
              ) 
              : const SizedBox(height:0)  ,            
            ),
          ),
        ],
      );

      var _RowEquipmentLocation = Row (
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 2,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                'Equipment Location: ',
                style: Theme.of(context).textTheme.bodyText2,
                softWrap: true,
              ),
            ),
          ),
          Expanded(
            flex: 2,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: 
              widget.supportticket.equipment_location !='' ?
              Text(
                widget.supportticket.equipment_location,
                style: Theme.of(context).textTheme.bodyText2,
                textAlign: TextAlign.right,
                softWrap: true,
              ) 
              : const SizedBox(height:0)  ,            
            ),
          ),
        ],
      );

      var _RowEquipmentUser = Row (
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 2,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                'Equipment User: ',
                style: Theme.of(context).textTheme.bodyText2,
                softWrap: true,
              ),
            ),
          ),
          Expanded(
            flex: 2,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: 
              widget.supportticket.equipment_user != '' ?
              Text(
                widget.supportticket.equipment_user,
                style: Theme.of(context).textTheme.bodyText2,
                textAlign: TextAlign.right,
                softWrap: true,
              ) 
              : const SizedBox(height:0),            
            ),
          ),
        ],
      );

      var _RowReportedBy = Row (
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 2,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                'Reported By: ',
                style: Theme.of(context).textTheme.bodyText2,
                softWrap: true,
              ),
            ),
          ),
          Expanded(
            flex: 2,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: 
              widget.supportticket.reported_by != '' ?
              Text(
                widget.supportticket.reported_by,
                style: Theme.of(context).textTheme.bodyText2,
                textAlign: TextAlign.right,
                softWrap: true,
              ) 
              : const SizedBox(height:0),            
            ),
          ),
        ],
      );

      var _RowContactNumber = Row (
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 2,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                'Contact Number: ',
                style: Theme.of(context).textTheme.bodyText2,
                softWrap: true,
              ),
            ),
          ),
          Expanded(
            flex: 2,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: 
              widget.supportticket.contact_num != '' ?
              Text(
                widget.supportticket.contact_num,
                style: Theme.of(context).textTheme.bodyText2,
                textAlign: TextAlign.right,
                softWrap: true,
              ) 
              : const SizedBox(height:0),            
            ),
          ),
        ],
      );

      var _RowEmail = Row (
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 2,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                'Email: ',
                style: Theme.of(context).textTheme.bodyText2,
                softWrap: true,
              ),
            ),
          ),
          Expanded(
            flex: 2,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: 
              widget.supportticket.email != '' ?
              Text(
                widget.supportticket.email,
                style: Theme.of(context).textTheme.bodyText2,
                textAlign: TextAlign.right,
                softWrap: true,
              ) 
              : const SizedBox(height:0),            
            ),
          ),
        ],
      );

      var _RowDepartment = Row (
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 2,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                'Department: ',
                style: Theme.of(context).textTheme.bodyText2,
                softWrap: true,
              ),
            ),
          ),
          Expanded(
            flex: 2,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: 
              widget.supportticket.department != '' ?
              Text(
                widget.supportticket.department,
                style: Theme.of(context).textTheme.bodyText2,
                textAlign: TextAlign.right,
                softWrap: true,
              ) 
              : const SizedBox(height:0),            
            ),
          ),
        ],
      );

      var _RowAddress = Row (
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 2,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                'Address: ',
                style: Theme.of(context).textTheme.bodyText2,
                softWrap: true,
              ),
            ),
          ),
          Expanded(
            flex: 2,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: 
              widget.supportticket.address != '' ?
              Text(
                widget.supportticket.address,
                style: Theme.of(context).textTheme.bodyText2,
                textAlign: TextAlign.right,
                softWrap: true,
              ) 
              : const SizedBox(height:0),            
            ),
          ),
        ],
      );

      var _RowCategory = Row (
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 2,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                'Category: ',
                style: Theme.of(context).textTheme.bodyText2,
                softWrap: true,
              ),
            ),
          ),
          Expanded(
            flex: 2,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: 
              widget.supportticket.category_name != '' ?
              Text(
                widget.supportticket.category_name,
                style: Theme.of(context).textTheme.bodyText2,
                textAlign: TextAlign.right,
                softWrap: true,
              ) 
              : const SizedBox(height:0),            
            ),
          ),
        ],
      );

      var _RowSubCategory = Row (
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 2,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                'Subcategory: ',
                style: Theme.of(context).textTheme.bodyText2,
                softWrap: true,
              ),
            ),
          ),
          Expanded(
            flex: 2,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: 
              widget.supportticket.subcategory_name != '' ?
              Text(
                widget.supportticket.subcategory_name,
                style: Theme.of(context).textTheme.bodyText2,
                textAlign: TextAlign.right,
                softWrap: true,
              ) 
              : const SizedBox(height:0),            
            ),
          ),
        ],
      );

      var _RowProblem = Row (
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 2,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                'Problem: ',
                style: Theme.of(context).textTheme.bodyText2,
                softWrap: true,
              ),
            ),
          ),
          Expanded(
            flex: 2,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: 
              widget.supportticket.problem_name != '' ?
              Text(
                widget.supportticket.problem_name,
                style: Theme.of(context).textTheme.bodyText2,
                textAlign: TextAlign.right,
                softWrap: true,
              ) 
              : const SizedBox(height:0),            
            ),
          ),
        ],
      );

      var _RowPriority = Row (
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 2,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                'Priorty: ',
                style: Theme.of(context).textTheme.bodyText2,
                softWrap: true,
              ),
            ),
          ),
          Expanded(
            flex: 2,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: 
              widget.supportticket.problem_name != '' ?
              Text(
                widget.supportticket.problem_name,
                style: Theme.of(context).textTheme.bodyText2,
                textAlign: TextAlign.right,
                softWrap: true,
              ) 
              : const SizedBox(height:0),            
            ),
          ),
        ],
      );
      
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: getProportionateScreenWidth(14),
        vertical: getProportionateScreenWidth(8),
      ),
      child: Card(
        elevation: 6,
        color: isDarkMode(context) ? darkGreyColor : Colors.white,
        shadowColor: Colors.grey.withOpacity(0.15),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.only(
                  top: getProportionateScreenWidth(8),
                  left: getProportionateScreenWidth(12)),
              child: Text(
                detailsLabel,
                style: Theme.of(context).textTheme.subtitle1.copyWith(
                  fontWeight: FontWeight.bold
                ),
              ),
            ),
            Divider(),
            _RowSerialNumber,
            _RowEquipmentLocation,
            _RowEquipmentUser,
            _RowReportedBy,
            _RowContactNumber,
            _RowEmail,
            _RowDepartment,
            _RowAddress,
            _RowCategory,
            _RowSubCategory,
            _RowProblem,
            SizedBox(
              height: SizeConfig.screenHeight * 0.015,
            )
          ],
        ),
      ),
    );
  }

  Widget buildBottomPart() {
    return Container(
      child: buildButton(
        'Continue Shopping',
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


             
}
