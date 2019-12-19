import 'dart:convert';

import 'package:flutter/material.dart';
import '../component/BlueButton.dart';
import '../component/Normal_TextField.dart';
import '../component/password_input_textField.dart';
import 'package:toast/toast.dart';
import '../helpers/ensure_visible.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../my_status_screens/dashboard.dart';


class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final storage = new FlutterSecureStorage();

  final FocusNode _EmailFocus = FocusNode();
  final FocusNode _PasswordFocus = FocusNode();

  static final TextEditingController _firstNameController =
      new TextEditingController();
  static final TextEditingController _lastNameController =
      new TextEditingController();

  final EmailKey = GlobalKey<FormState>();
  final PasswordKey = GlobalKey<FormState>();
  String _email, _password;

  void _submit()async {
    if (EmailKey.currentState.validate()) {
      EmailKey.currentState.save();
      var url ="https://www.adilreza.info/my_status_api/user_login.php";

      var response = await http.post(url, body: {'email': _email,'password':_password});
      if(response.statusCode==200)
      {
        try{
          var decodedData = jsonDecode(response.body);
          String status = decodedData['status'];
          String phone = decodedData['phone'];
          print(phone);
          await storage.write(key: 'phone', value: phone);

          print(status);
          if(status=="login")
          {
            Toast.show("Successfully Login", context, duration: Toast.LENGTH_LONG, gravity:  Toast.CENTER, backgroundColor:Colors.green,textColor: Colors.white);

            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => dashboard()),
            );
          }
          else
          {
            Toast.show("Something went Wrong, try again", context, duration: Toast.LENGTH_LONG, gravity:  Toast.CENTER, backgroundColor: Colors.red, textColor: Colors.white);

          }
        }
        catch(error){
          print(error);
        }

      }

    }
  }

  Future<Null> _focusNodeListener() async {
    if (_PasswordFocus.hasFocus) {
      print('TextField got the focus');
    } else {
      print('TextField lost the focus');
    }

    if (_EmailFocus.hasFocus) {
      print('Email got the focus');
    } else {
      print('Email lost the focus');
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    _PasswordFocus.addListener(_focusNodeListener);
    _EmailFocus.addListener(_focusNodeListener);
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _PasswordFocus.removeListener(_focusNodeListener);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 0.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Form(
                key: EmailKey,
                child: Column(
                  children: <Widget>[
                    EnsureVisibleWhenFocused(
                      child: new NormalTextField(
                        focusNode: _EmailFocus,
                        onFieldSubmitted: (term) {
                          _EmailFocus.unfocus();
                          FocusScope.of(context).requestFocus(_PasswordFocus);
                        },
                        hint: 'E-mail',
                        inputType: TextInputType.emailAddress,
                        validator: (input) =>
                            !input.contains('@') ? 'Not a valid Email' : null,
                        OnSaved: (input) => _email = input,
                      ),
                      focusNode: _EmailFocus,
                    ),
                    SizedBox(
                      height: 15.0,
                    ),
                    EnsureVisibleWhenFocused(
                      child: new PasswordTextField(
                        focusNode: _PasswordFocus,
                        hint: 'Password',
                        validator: (input) => input.length < 4
                            ? 'You need at least 4 characters'
                            : null,
                        OnSaved: (input) => _password = input,
                      ),
                      focusNode: _PasswordFocus,
                    ),
                  ],
                )),
            SizedBox(
              height: 10.0,
            ),
            BlueButton(
              text: 'Log In',
              onPress: () {
                _submit();
                print('log in pressed');
              },
            ),
            SizedBox(
              height: 10.0,
            ),

          ],
        ),
      ),
    );
  }
}
