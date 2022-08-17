import 'dart:convert';
import 'dart:io';
import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:shopping_app_ui/colors/Colors.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:shopping_app_ui/constant/Constants.dart';
import 'package:shopping_app_ui/screens/authentication/LoginScreen.dart';
import 'package:shopping_app_ui/screens/authentication/VerifyAccountScreen.dart';
import 'package:shopping_app_ui/screens/products/VerifyCustomerScreen.dart';
import 'package:shopping_app_ui/util/size_config.dart';
import 'package:shopping_app_ui/widgets/Styles.dart';
import 'package:shopping_app_ui/util/Util.dart';
import 'package:month_picker_dialog/month_picker_dialog.dart';
import 'package:path/path.dart'; //due to importing path, a lot of our context have to be change to this.context ,, this is due to the problem of importing path package itself. please note this.


class MySubmitFormScreen extends StatefulWidget {
  MySubmitFormScreen(this.supporticket);

    final supporticket; 
  
  //item is for ticket details, we can also use riverpod family instead if we wish for later (for better state management rather)
  // for simplicity we purposely use statful widget and passing from screen to screen instead of using riverpod family (or anything that can store data like a repository like BLOC repository)

  @override
  _MySubmitFormScreenState createState() => _MySubmitFormScreenState();
}

class _MySubmitFormScreenState extends State<MySubmitFormScreen> {
  TextEditingController followUp = new TextEditingController();
  TextEditingController validUntil = new TextEditingController();
  TextEditingController cvv = new TextEditingController();
  TextEditingController resolution = new TextEditingController();
  //TextEditingController resolutionTimer = new TextEditingController();
  TextEditingController problem = new TextEditingController();

  FocusNode focusNodeFollowUp = new FocusNode();
  FocusNode focusNodeValidUntil = new FocusNode();
  FocusNode focusNodeCvv = new FocusNode();
  FocusNode focusNodeResolution = new FocusNode();
  //FocusNode focusNodeResolutionTimer = new FocusNode();
  FocusNode focusNodeErrorNotification = new FocusNode();
  FocusNode focusNodeProblem = new FocusNode();

  File imageFile;
  

  DateTime selectedCardExpiryDate;
  bool isSaveCardSelected = false,
  displaySuccessDialog = false,
  isDisplayErrorNotification = false;
  String errorMessage = '';
  var imagePicker = ImagePicker();

  Future showImagePickerDialog(BuildContext context) async {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text(imageDialogTitle),
        content: Text(imageDialogDesc),
        actions: [
          TextButton(
            onPressed: () async {
              Navigator.of(context).pop();
              await pickImageFromCamera(context);
            },
            child: Text(
              camera,
              style: TextStyle(
                fontSize: 14,
                fontFamily: poppinsFont,
              ),
            ),
          ),
          ElevatedButton(
            onPressed: () async {
              Navigator.of(context).pop();
              await pickImageFromGallery(context);
            },
            child: Text(
              gallery,
              style: TextStyle(
                fontSize: 14,
                fontFamily: poppinsFont,
              ),
            ),
          )
        ],
      ),
    );
  }

  Future pickImageFromCamera(BuildContext context) async {
    try {
      final pickedFile = await imagePicker.getImage(
        source: ImageSource.camera,
        maxHeight: 800,
        maxWidth: 800,
        imageQuality: 50,
      );

      if(pickedFile!= null)
        cropImage(context, pickedFile?.path ?? "");

    } catch (e) {
      PlatformException exemption = e;

      showErrorToast(context, 'Error ${exemption.message}');
    }
  }

  Future pickImageFromGallery(BuildContext context) async {
    try {
      final pickedFile = await imagePicker.getImage(
        source: ImageSource.gallery,
        maxWidth: 800,
        maxHeight: 800,
        imageQuality: 50,
      );

      if(pickedFile!= null)
        cropImage(context, pickedFile?.path     ?? "");

    } catch (e) {
      PlatformException exemption = e;

      showErrorToast(context, 'Error ${exemption.message}');
    }
  }

  Future cropImage(BuildContext context, String filePath) async {

    CroppedFile croppedFile = await ImageCropper().cropImage(
        sourcePath: filePath,
        aspectRatioPresets: setAspectRatios(),
        uiSettings: [        
          AndroidUiSettings(
          toolbarTitle: 'Crop your image',
          toolbarColor: primaryColor,
          toolbarWidgetColor: Colors.white,
          initAspectRatio: CropAspectRatioPreset.original,


          lockAspectRatio: false,
        ),
        IOSUiSettings(
          title: 'Crop your image',
          minimumAspectRatio: 1.0,
        )],
      );
    if (croppedFile != null) {
      setState(() {
        imageFile = File(croppedFile.path ?? "");
      });
    }
  }

  void showErrorNotification(String message) {
    setState(() {
      isDisplayErrorNotification = true;
      errorMessage = message;
      FocusScope.of(this.context).requestFocus(focusNodeErrorNotification);
    });
  }

  void hideErrorNotification() {
    setState(() {
      isDisplayErrorNotification = false;
      errorMessage = "";
    });
  }

  @override
  void initState() {
    super.initState();
    focusNodeFollowUp.addListener(() => setState(() {}));
    focusNodeValidUntil.addListener(() => setState(() {}));
    focusNodeCvv.addListener(() => setState(() {}));
    focusNodeResolution.addListener(() => setState(() {}));
    //focusNodeResolutionTimer.addListener(() => setState(() {}));
    focusNodeProblem.addListener(() => setState(() {}));

  }

  @override
  void dispose() {
    focusNodeFollowUp.dispose();
    focusNodeValidUntil.dispose();
    focusNodeCvv.dispose();
    focusNodeResolution.dispose();
    focusNodeErrorNotification.dispose();
    //focusNodeResolutionTimer.dispose();
    focusNodeProblem.addListener(() => setState(() {}));
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final _format = DateFormat("yyyy-MM-dd HH:mm:ss");
    


    return Scaffold(
      backgroundColor: isDarkMode(context)
          ? darkBackgroundColor
          : Theme.of(context).backgroundColor,
      appBar: buildAppBar(context, "Job Details", onBackPress: () {
        Navigator.pop(context);
      }),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Stack(
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 16.0, right: 16.0, top: 8),
                child: Card(
                  elevation: 6,
                  color: isDarkMode(context) ? Colors.white10 : Colors.white,
                  shadowColor: Colors.grey.withOpacity(0.15),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10)),
                  child: Padding(
                    padding: const EdgeInsets.only(
                        left: 22.0, right: 22.0, top: 8, bottom: 10),
                    child: Column(
                      children: [
                        Column(
                          children: [
                            Visibility(
                              visible: isDisplayErrorNotification,
                              child: buildErrorNotificationWithOption(
                                context,
                                errorMessage,
                                hideLabel,
                                isDarkMode(context)
                                    ? Colors.red[900]
                                    : pinkishColor,
                                true,
                                focusNode: focusNodeErrorNotification,
                                onOptionTap: () {
                                  setState(
                                    () {
                                      isDisplayErrorNotification = false;
                                    },
                                  );
                                },
                              ),
                            ),
                            SizedBox(
                              height: 30,
                            ),
                          ],
                        ),
                        Align(
                          alignment: Alignment.topCenter,
                          child: SvgPicture.asset(
                            isDarkMode(context)
                                ? '$darkIconPath/task-list.svg'
                                : '$lightIconPath/task-list.svg',
                            width: MediaQuery.of(context).size.width,
                            height: MediaQuery.of(context).size.height / 5.5,
                          ),
                        ),

                        Container(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            "Problem",
                            style: Theme.of(context).textTheme.subtitle2,
                          ),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        buildProblem(),
                        SizedBox(
                          height: 10,
                        ),

                  
                        Container(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            "Resolution",
                            style: Theme.of(context).textTheme.subtitle2,
                          ),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        buildResolutionName(),                       
                        SizedBox(
                          height: 10,
                        ),
                        

                        Container(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            "Follow-up",
                            style: Theme.of(context).textTheme.subtitle2,
                          ),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        buildAddFollowUp(),
                        SizedBox(
                          height: 10,
                        ),
                        
                        SizedBox(
                          height: 10,
                        ),
                        /*
                        Row(
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    validUntilLabel,
                                    style:
                                        Theme.of(context).textTheme.subtitle2,
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  InkWell(
                                    child: buildValidUntil(),
                                    onTap: () {
                                      buildDatePicker(context);
                                    },
                                  )
                                ],
                              ),
                            ),
                            SizedBox(
                              width: 30,
                            ),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    cvvLabel,
                                    style:
                                        Theme.of(context).textTheme.subtitle2,
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  buildCvvNumber()
                                ],
                              ),
                            ),
                          ],
                        ),
                        */
                        /*
                        SizedBox(
                          height: 20,
                        ),
                        */
                        /*
                        buildCheckBox(),
                        SizedBox(
                          height: 20,
                        ),
                        */
                        // ignore: missing_return

                        /*
                        SizedBox(
                          height: 10,
                        ),
                        Container(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            "Date of completion",
                            style: Theme.of(context).textTheme.subtitle2,
                          ),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        */

                        

                        /*
                        DateTimeField(controller: resolutionTimer,format: _format, 
                        textCapitalization: TextCapitalization.words,
                        textInputAction: TextInputAction.done,
                        obscureText: false,
                        cursorColor: primaryColor,
                        focusNode: focusNodeResolutionTimer,
                        decoration: InputDecoration( 
                          enabledBorder: OutlineInputBorder(
                            borderRadius: const BorderRadius.all(Radius.circular(10.0)),
                            borderSide: BorderSide(color: primaryColor, width:1.0),      
                          ),

                          focusedBorder: OutlineInputBorder(
                            borderRadius: const BorderRadius.all(Radius.circular(10.0)),
                            borderSide: BorderSide(color: primaryColor, width:1.0),      
                            ),
                          fillColor: focusNodeResolutionTimer.hasFocus
                            ? primaryColor.withOpacity(0.15)
                            : Colors.transparent,
                          hintText: "Choose resolution date & time",
                          
                          prefixIcon: Icon(
                            Icons.calendar_month,
                            color: Colors.black,
                          )
                        ),
                        onShowPicker: (context, currentValue) async {   
                          final date = await showDatePicker (context:context, 
                          initialDate: currentValue ?? DateTime.now(), 
                          firstDate:DateTime(1900), 
                          lastDate:DateTime(2100));
                          
                          if(date != null) {
                            final time = await showTimePicker(context: context, initialTime: TimeOfDay.fromDateTime(currentValue ?? DateTime.now()));
                            return DateTimeField.combine(date, time);
                          }
                          else
                          {
                            return currentValue;
                          }
                        }),

                        */
                        SizedBox(height: 10),
                        Container(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            "Upload proof of work (optional)",
                            style: Theme.of(context).textTheme.subtitle2,
                          ),
                        ),
                        SizedBox(height: 10),

                        
                      InkWell(
                        onTap: () => showImagePickerDialog(context),
                        child: Container(
                          child:                         
                          imageFile != null ? 
                            Image.file(
                              imageFile,
                              width: 400,
                              height: 400,
                            )
                          :
                          Image.asset(
                            '$baseImagePath/profile.png',
                            height: 200,
                            width: 200,
                            //fit: BoxFit.cover,
                          )
                        ),  
                      )
                        //FlutterLogo(size: 160)               
                      ],

                    ),
                  ),
                ),
              ),
              Visibility(
                  visible: displaySuccessDialog,
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      Container(
                        height: MediaQuery.of(context).size.height,
                        color: Colors.black26,
                      ),
                      buildSuccessDialog(),
                    ],
                  )),
            ],
          ),
        ),
      ),
      bottomNavigationBar: Visibility(
        visible: !displaySuccessDialog,
        child: Padding(
          padding: const EdgeInsets.only(
              top: 16.0, left: 22, right: 22, bottom: 8.0),
          child: new Container(
            height: 56.0,
            alignment: Alignment.center,
            child: buildSBottomButtons(),
          ),
        ),
      ),
    );
  }

  Widget buildAddFollowUp() {
    return buildTextFieldExtraHeight(
        this.context,
        followUp,
        TextCapitalization.words,
        TextInputType.name,
        TextInputAction.done,
        false,
        primaryColor,
        10.0,
        primaryColor,
        primaryColor,
        primaryColor,
        focusNodeFollowUp.hasFocus
            ? primaryColor.withOpacity(0.15)
            : Colors.transparent,
        500,
        3,
        '',
        true,
        focusNode: focusNodeFollowUp,
        onChange: (value) {},
        onSubmit: () {},
  
        
        );

  }



    Widget buildProblem() {
    return buildTextFieldExtraHeight(
        this.context,
        problem,
        TextCapitalization.words,
        TextInputType.name,
        TextInputAction.done,
        false,
        primaryColor,
        10.0,
        primaryColor,
        primaryColor,
        primaryColor,
        focusNodeProblem.hasFocus
            ? primaryColor.withOpacity(0.15)
            : Colors.transparent,
        500,
        3,
        '',
        true,
        focusNode: focusNodeProblem,
        onChange: (value) {},
        onSubmit: () {});
  }



  Widget buildValidUntil() {
    return buildTextField(
        this.context,
        validUntil,
        TextCapitalization.none,
        TextInputType.number,
        TextInputAction.next,
        false,
        primaryColor,
        10.0,
        primaryColor,
        primaryColor,
        primaryColor,
        focusNodeValidUntil.hasFocus
            ? primaryColor.withOpacity(0.15)
            : Colors.transparent,
        16,
        selectedCardExpiryDate != null
            ? '${selectedCardExpiryDate?.year}\/${selectedCardExpiryDate?.month}'
            : '',
        false,
        focusNode: focusNodeValidUntil,
        onChange: (value) {},
        onSubmit: () {});
  }

  Widget buildCvvNumber() {
    return buildTextField(
        this.context,
        cvv,
        TextCapitalization.none,
        TextInputType.number,
        TextInputAction.next,
        true,
        primaryColor,
        10.0,
        primaryColor,
        primaryColor,
        primaryColor,
        focusNodeCvv.hasFocus
            ? primaryColor.withOpacity(0.15)
            : Colors.transparent,
        3,
        '',
        true,
        focusNode: focusNodeCvv,
        onChange: (value) {},
        onSubmit: () {});
  }

  Widget buildResolutionName() {
    return buildTextFieldExtraHeight(
        this.context,
        resolution,
        TextCapitalization.words,
        TextInputType.name,
        TextInputAction.done,
        false,
        primaryColor,
        10.0,
        primaryColor,
        primaryColor,
        primaryColor,
        focusNodeResolution.hasFocus
            ? primaryColor.withOpacity(0.15)
            : Colors.transparent,
        500,
        3,
        '',
        true,
        focusNode: focusNodeResolution,
        onChange: (value) {},
        onSubmit: () {});
  }

  buildDatePicker(BuildContext context) async {

    final DateTime picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2040),
    );
    

    if (picked != null && picked != selectedCardExpiryDate)
      setState(
        () {
          selectedCardExpiryDate = picked;
        },
      );
  }

  Widget buildCheckBox() {
    return Row(
      children: [
        Checkbox(
          value: isSaveCardSelected,
          activeColor: primaryColor,
          onChanged: (b) {
            setState(() {
              isSaveCardSelected = b;
            });
          },
        ),
        Expanded(
          child: Text(
            saveCardLabel,
            style: Theme.of(this.context).textTheme.bodyText2,
          ),
        ),
      ],
    );
  }

  Widget buildSuccessDialog() {
    return buildDialog(
      this.context,
      cardAddedSuccessLabel,
      goBackLabel,
      isDarkMode(this.context)
          ? '$darkIconPath/card.svg'
          : '$baseImagePath/card.svg',
      onTap: () {
        SchedulerBinding.instance.addPostFrameCallback(
          (_) {
            Navigator.pop(this.context);
          },
        );
      },
    );
  }

  Widget buildSBottomButtons() {
    return Row(
      children: [
        Expanded(
          child: Container(
            child: buildButton(
              cancelLabel,
              true,
              secondaryColor,
              Colors.white,
              2,
              2,
              8,
              onPressed: () {
                Navigator.pop(this.context);
              },
            ),
          ),
        ),
        SizedBox(
          width: 20,
        ),
        Expanded(
          child: Container(
            child: buildButtonWithSuffixIcon(
              continueLabel,
              Icons.arrow_forward_rounded,
              true,
              isDarkMode(this.context) ? primaryColorDark : primaryColor,
              isDarkMode(this.context)
                  ? Colors.white.withOpacity(0.8)
                  : Colors.white,
              2,
              2,
              8,
              onPressed: () {
                checkValidations(); //should make if no error, then navigate push later for real scene
                saveToDatabase(problem,resolution,followUp, imageFile, widget.supporticket.ticket_id); //save to backend
                Navigator.push(
                              this.context,
                              OpenUpwardsPageRoute(child: VerifyCustomerScreen(), 
                                direction: AxisDirection.up));
              },
            ),
          ),
        )
      ],
    );
  }

  

  void checkValidations() {
    if (followUp.text.isEmpty) {
      showErrorNotification('Please enter card number');
    } else if (followUp.text.length != 16) {
      showErrorNotification('Please enter 16 digit in card number');
    //} else if (selectedCardExpiryDate == null) {
    //  showErrorNotification('Please select card expiry date');
    //} else if (cvv.text.isEmpty) {
    //  showErrorNotification('Please select country');
    } else if (resolution.text.isEmpty) {
      showErrorNotification('Please enter resolution');
    } else {
      if (isDisplayErrorNotification == true) {
        hideErrorNotification();
      }
      hideKeyboard(this.context);
      setState(() {
        displaySuccessDialog = true;
      });
    }
  }
}

void saveToDatabase(problem,resolution,followup,imageFile, ticket_id){

    //DateTime resolutionTimerDate = new DateFormat("yyyy-MM-dd hh:mm:ss").parse(resolutionTimer.text);
    //resolutionTimerDate.subtract(Duration(hours: 8)); // we subtract 8 hours to convert MYT to GMT
    //String resolutionTimerUTC = resolutionTimerDate.toString();

    //here we combined problem,resolution and followup and save to database comment
    String comment = "Problem: "+problem.text+"\nResolution: "+resolution.text+"\nFollow-up: "+followup.text;
    //var attachment // for attachmenment we will upload the proof of work picture
        
    globalClient.callKw({
    'model': 'website.supportzayd.ticket',
    'method': 'write',
    'args': [ 
      [int.parse(ticket_id)], //update check_in data using ticket id                    
        {
          //'case_done': resolutionTimerUTC,
          'close_comment' : comment,
          //'check_out_long' : ,
          //'check_out_address' : address,         
        },
    ],
    'kwargs': {},
    });


    //this is because imagile is an optional field.

    
    print("if imagefile is null print this");

    if(imageFile != null){

      print("before globalclient call imagefile ");

      List<int> imageBytes = imageFile.readAsBytesSync();
      String imageBase64 = base64Encode(imageBytes);
      //String fileName = imageFile.path.split(Platform.pathSeparator).last;
      // ignore: unnecessary_statements 
      //print("file name after convert? : "+imageFile.toString());
      final _filename = basename(imageFile.path);
      final _extension = extension(imageFile.path);


      DateTime now = new DateTime.now();
      DateTime date = new DateTime(now.year, now.month, now.day, now.hour, now.minute);
      

      //imageFile.rename ("TicketImage"+DateTime.now().toString() +_extension.toString());

      globalClient.callKw({
        'model': 'ir.attachment',
        'method': 'create',
        'args': [
          {
            'res_model': 'website.supportzayd.ticket',
            'name': 'proofImage_'+now.toString(),
            'res_id':ticket_id,
            'type': 'binary',
            'mime_type' : 'image/$_extension',
            //'store_fname': _filename,
            'datas_fname':'proofImage_'+date.toString(),
            'datas':imageBase64,
            //'datas':'base64.b64encode($imageBase64)'
          },
        ],
        'kwargs': {
        },
      });
      print("after globalclient call imagefile ");     
    }
}
