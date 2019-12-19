import 'dart:convert';
import 'package:flutter/material.dart';
import '../component/RedButton.dart';
import '../component/Normal_TextField.dart';
import '../component/password_input_textField.dart';
import 'package:http/http.dart' as http;
import 'package:toast/toast.dart';





class SignUpPage extends StatelessWidget {
  String name="";
  String email="";
  String phone = "";
  String password = "";
  var url = "https://www.adilreza.info/my_status_api/user_signup.php";
  void sigin_up_operation( context )async
  {
    var response = await http.post(url, body: {'full_name': name, 'email': email,'phone':phone, 'password':password});
    if(response.statusCode==200)
    {
      try{
        var decodedData = jsonDecode(response.body);
        String status = decodedData['status'];
        print(status);
        if(status=="inserted")
          {
            Toast.show("Successfully Registered", context, duration: Toast.LENGTH_LONG, gravity:  Toast.CENTER);
          }
        else
          {
            Toast.show("Something went Wrong, try again", context, duration: Toast.LENGTH_LONG, gravity:  Toast.CENTER);

          }
      }
      catch(error){
        print(error);
      }

    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: SingleChildScrollView(
        child: Wrap(
          crossAxisAlignment: WrapCrossAlignment.center,
          runSpacing: 15.0,
          children: <Widget>[
            new NormalTextField(
              inputType: TextInputType.text,
              hint: 'Name',
              onChange: (value){name=value;},
            ),
            new NormalTextField(
              inputType: TextInputType.emailAddress,
              hint: 'E-mail address',
              onChange: (value){email=value;},
            ),
            new NormalTextField(
              inputType: TextInputType.phone,
              hint: 'Mobile No',
              onChange: (v){phone=v;},
            ),
            new PasswordTextField(
              hint: 'Password',
              onChange: (vp){password=vp;},

            ),

            RedButton(text: 'Sign Up',onPress:()=>sigin_up_operation(context),),
            SizedBox(
              height: 50,
            ),
          ],
        ),
      ),
    );
  }
}
