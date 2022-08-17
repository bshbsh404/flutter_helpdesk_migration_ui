import 'dart:ui';
import 'package:shopping_app_ui/Api/PdfApi.dart';
import 'package:open_file/open_file.dart';
import 'package:flutter/material.dart';
import 'package:shopping_app_ui/widgets/Styles.dart';
import 'package:syncfusion_flutter_signaturepad/signaturepad.dart';

class SignatureScreen extends StatefulWidget {
  final supportTicket;

  const SignatureScreen({Key key, this.supportTicket}) : super(key: key);

  @override
  State<SignatureScreen> createState() => _SignatureScreenState();
}

class _SignatureScreenState extends State<SignatureScreen> {
  final problem = TextEditingController();
  final keySignaturePad = GlobalKey<SfSignaturePadState>();

 @override
 Widget build(BuildContext context) {
  //setting up screensize mediaquery
  final screensize = MediaQuery.of(context).size;
  //setting up submit cmform button function
  return Scaffold(
          appBar: buildAppBar(context, "Get Signature", onBackPress: () {
          Navigator.pop(context);
        }),
                 
        body: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.only(left: 0.1* screensize.width, right:0.1* screensize.width, top: 0.05 *screensize.height, bottom: 0.05 *screensize.height),
            child: Column(
              children: [
                Form(
                  
                  child: TextFormField(              
                   decoration: InputDecoration(
                    labelText: 'Resolution',
                    fillColor: Colors.white,filled: true,
                    labelStyle: TextStyle(
                      color: Colors.black,
                      fontSize: 16,
                      fontFamily: 'Poppins',
                      fontWeight: FontWeight.w600,
                    ),
                    focusedBorder: UnderlineInputBorder(      
                      borderSide: BorderSide(color: Colors.purple),   
                    ),
                    enabledBorder: new UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.grey, 
                        width: 1.0)
                    ),),
                   
                    
                  )),
                  SizedBox(height: 5,),
                  Form(
                  
                  child: TextFormField(              
                   decoration: InputDecoration(
                    labelText: 'Follow-up',
                    fillColor: Colors.white,filled: true,
                    labelStyle: TextStyle(
                      color: Colors.black,
                      fontSize: 16,
                      fontFamily: 'Poppins',
                      fontWeight: FontWeight.w600,
                    ),
                    focusedBorder: UnderlineInputBorder(      
                      borderSide: BorderSide(color: Colors.purple),   
                    ),
                    enabledBorder: new UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.grey, 
                        width: 1.0)
                    ),),
                   
                    
                  )),

                  SizedBox(height: 5,),
                  Form(
                  
                  child: TextFormField(              
                   decoration: InputDecoration(
                    labelText: 'Customer IC number',
                    fillColor: Colors.white,filled: true,
                    labelStyle: TextStyle(
                      color: Colors.black,
                      fontSize: 16,
                      fontFamily: 'Poppins',
                      fontWeight: FontWeight.w600,
                    ),
                    focusedBorder: UnderlineInputBorder(      
                      borderSide: BorderSide(color: Colors.purple),   
                    ),
                    enabledBorder: new UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.grey, 
                        width: 1.0)
                    ),),
                   
                    
                  )),
                  SizedBox(height: 5,),
                  Form(
                  
                  child: TextFormField(              
                   decoration: InputDecoration(
                    labelText: 'Signature',
                    fillColor: Colors.white,filled: true,
                    labelStyle: TextStyle(
                      color: Colors.black,
                      fontSize: 16,
                      fontFamily: 'Poppins',
                      fontWeight: FontWeight.w600,
                    ),
                    focusedBorder: UnderlineInputBorder(      
                      borderSide: BorderSide(color: Colors.purple),   
                    ),
                    enabledBorder: new UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.grey, 
                        width: 1.0)
                    ),),                    
                  )

                  ),SizedBox(height: 10,),

                SfSignaturePad(
                  backgroundColor: Colors.grey.withOpacity((0.2)),
                  key: keySignaturePad,
                ),                  
                ElevatedButton(onPressed: onSubmit, child: Text('Submit CM Form')
                )

              ],),
          )), 
          
  );
  
  } Future onSubmit() async {
  showDialog(
    barrierDismissible: false,
    context: context, 
    builder: (context)=> Center(child: CircularProgressIndicator())
  ); 
  final image = await keySignaturePad.currentState?.toImage();
  final imageSignature = 
    await image.toByteData(format: ImageByteFormat.png);
  final file = await PdfApi.generatePDF(
  imageSignature: imageSignature, supportTicket: widget.supportTicket );
  Navigator.of(context).pop();
  await OpenFile.open(file.path);
  }
}