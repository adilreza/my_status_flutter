import 'package:flutter/material.dart';
import 'package:my_status_final/component/BlueButton.dart';
import 'package:my_status_final/component/Normal_TextField.dart';
import 'package:http/http.dart' as http;
import 'package:toast/toast.dart';
import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class dashboard extends StatefulWidget {
  @override
  _dashboardState createState() => _dashboardState();
}

class _dashboardState extends State<dashboard> {
  final storage = new FlutterSecureStorage();

  var status_context = "";
  var find_phone = "";
  String _last_updated=" ", _pstatus=" ";
  TextEditingController controller=new TextEditingController();
  TextEditingController controller2 = new TextEditingController();
  var url = "https://www.adilreza.info/my_status_api/user_status_set.php";
  var url2 = "https://www.adilreza.info/my_status_api/user_status_get.php";


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    get_my_status();

  }

  void get_my_status()async
  {
    String st_phone = await storage.read(key: 'phone');
    var response = await http.post(
        url2, body: {'phone': st_phone});
    if(response.statusCode==200)
      {
        var decodedData = jsonDecode(response.body);
        String pstatus = decodedData['status'];

        setState(() {
          controller.text=pstatus;
        });

      }
  }


  void update_my_status()async
  {
    String st_phone = await storage.read(key: 'phone');


    var response;
    try {
       response = await http.post(
          url, body: {'phone': st_phone, 'status': status_context});
    }
    catch(er)
    {
      print(er);
    }
    if (response.statusCode == 200) {
      try {

        var decodedData = jsonDecode(response.body);
        String status = decodedData['status'];
        print(status);

        setState(() {
          controller.text=status;
        });
        Toast.show(
            "Successfully updated", context, duration: Toast.LENGTH_LONG,
            gravity: Toast.CENTER, backgroundColor: Colors.green);
      }
      catch (error) {
        print(error);
      }
    }
  }
  void find_one_status()async
  {
    var response;
    try {
      response = await http.post(
          url2, body: {'phone': find_phone});
    }
    catch(er)
    {
      print(er);
    }

    if (response.statusCode == 200) {
      try {

        var decodedData = jsonDecode(response.body);
        String pstatus = decodedData['status'];
        String last_updated =decodedData['last_update'];
        print(pstatus);
        setState(() {
          _pstatus=pstatus;
          _last_updated=last_updated;
        });


        Toast.show(
            "Successfully found", context, duration: Toast.LENGTH_LONG,
            gravity: Toast.CENTER, backgroundColor: Colors.green);
      }
      catch (error) {
        print(error);
      }
    }

  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomPadding: false,
        appBar: AppBar(
          title: Text("Welcome to My Status"),
        ),
        body: SafeArea(
          child: Container(
            //color: Colors.lightBlueAccent,
            child: Padding(
              padding: EdgeInsets.only(left: 10.0, right: 10.0),
              child: Column(
                children: <Widget>[
                  SizedBox(height: 15.0,),
                  NormalTextField(
                    inputType: TextInputType.text ,
                    onChange: (v){status_context=v;},
                    hint: "Enter your status",
                    controller: controller,
                  ),
                  SizedBox(height: 10.0,),
                  BlueButton(
                    text: "Update Now",
                    onPress: update_my_status,
                  ),

                  SizedBox(height: 45.0,),
                  NormalTextField(
                    inputType: TextInputType.text ,
                    onChange: (v2){find_phone=v2;},
                    hint: "Find One",
                    controller: controller2,
                  ),
                  SizedBox(height: 10.0,),
                  BlueButton(
                    text: "Find Now",
                    onPress: find_one_status,
                  ),

                  SizedBox(height: 15.0),

                  Expanded(
                    child: Container(
                      child: Column(
                        children: <Widget>[
                          Text("$_pstatus"),
                          SizedBox(height: 5.0,),
                          Text("$_last_updated"),
                        ],
                      ),
                    ),
                  )

                ],
              ),
            ),
          ),
        ));
  }
}
