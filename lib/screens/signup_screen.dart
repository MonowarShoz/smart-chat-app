import 'dart:io';

import 'package:chat_smart_app/services/auth.dart';
import 'package:chat_smart_app/services/database_service.dart';
import 'package:chat_smart_app/services/db_storage.dart';


import 'package:chat_smart_app/services/navigation_service.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
//import 'package:firebase_storage/firebase_storage.dart';

import 'package:provider/provider.dart';

class SignupScreen extends StatefulWidget {
  @override
  _SignupScreenState createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  double deviceHeight;
  double deviceWidth;
  GlobalKey<FormState> _formKey;
  AuthProvider _auth;
  String _name;
  String _email;
  String _password;
  File _image;
 

  final _picker = ImagePicker();

  _SignupScreenState() {
    _formKey = GlobalKey<FormState>();
  }
  @override
  Widget build(BuildContext context) {
    deviceHeight = MediaQuery.of(context).size.height;
    deviceWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      body: Container(
        alignment: Alignment.center,
        child: ChangeNotifierProvider<AuthProvider>.value(
          value: AuthProvider.instance,
          child: signUpUi(),
        ),
      ),
    );
  }

  Widget signUpUi() {
    return Builder(builder: (BuildContext context) {
      _auth = Provider.of<AuthProvider>(context);
      return Container(
        height: deviceHeight * 0.75,
        padding: EdgeInsets.symmetric(horizontal: deviceWidth * 0.10),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            _headerWidget(),
            _inputForm(),
            _regButton(),
            _backButton(),
          ],
        ),
      );
    });
  }

  Widget _headerWidget() {
    return Container(
      height: deviceHeight * 0.12,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            "Lets Register",
            style: TextStyle(
              fontSize: 35,
              fontWeight: FontWeight.w700,
            ),
          ),
          Text(
            "Please Enter your details",
            style: TextStyle(
              fontWeight: FontWeight.w200,
              fontSize: 25,
            ),
          ),
        ],
      ),
    );
  }

  Widget _inputForm() {
    return Container(
      height: deviceHeight * 0.35,
      child: Form(
        key: _formKey,
        onChanged: () {
          _formKey.currentState.save();
        },
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            _imagePickerWidget(),
            _userNameTextField(),
            _userEmailTextField(),
            _passwordTextField(),
          ],
        ),
      ),
    );
  }

  Future getImageFromSource() async {
    final pickedImage = await _picker.getImage(source: ImageSource.gallery);
    setState(() {
      if (pickedImage != null) {
        _image = File(pickedImage.path);
      }
    });
  }

  Widget _imagePickerWidget() {
    return Align(
      alignment: Alignment.center,
      child: GestureDetector(
        onTap: getImageFromSource,
        child: Container(
          height: deviceHeight * 0.10,
          width: deviceWidth * 0.10,
          decoration: BoxDecoration(
            color: Colors.transparent,
            borderRadius: BorderRadius.circular(500),
            image: DecorationImage(
              fit: BoxFit.cover,
              image: _image != null
                  ? FileImage(_image)
                  : NetworkImage(
                      "https://cdn0.iconfinder.com/data/icons/occupation-002/64/programmer-programming-occupation-avatar-512.png"),
            ),
          ),
        ),
      ),
    );
  }

  Widget _userNameTextField() {
    return TextFormField(
      autocorrect: false,
      style: TextStyle(
        color: Colors.white,
      ),
      validator: (input) {
        return input.length != 0 ? null : "Please enter a valid User Name";
      },
      onSaved: (input) {
        setState(() {
          _name = input;
        });
      },
      cursorColor: Colors.white,
      decoration: InputDecoration(
        hintText: "Insert User Name",
        focusedBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: Colors.white),
        ),
      ),
    );
  }

  Widget _userEmailTextField() {
    return TextFormField(
      autocorrect: false,
      style: TextStyle(
        color: Colors.white,
      ),
      validator: (input) {
        return input.length != 0 && input.contains("@")
            ? null
            : "Please enter a valid Email";
      },
      onSaved: (input) {
        setState(() {
          _email = input;
        });
      },
      cursorColor: Colors.white,
      decoration: InputDecoration(
        hintText: "Email Address",
        focusedBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: Colors.white),
        ),
      ),
    );
  }

  Widget _passwordTextField() {
    return Expanded(
      child: TextFormField(
        autocorrect: false,
        obscureText: true,
        style: TextStyle(
          color: Colors.white,
        ),
        validator: (input) {
          return input.length != 0 ? null : "Please enter a valid password";
        },
        onSaved: (input) {
          setState(() {
            _password = input;
          });
        },
        cursorColor: Colors.white,
        decoration: InputDecoration(
          hintText: "Password",
          focusedBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: Colors.white),
          ),
        ),
      ),
    );
  }

  Widget _regButton() {
    return _auth.authStatus != AuthStatus.Authenticating
        ? Container(
            height: deviceHeight * 0.06,
            width: deviceWidth,
            child: MaterialButton(
              onPressed: () {
                if (_formKey.currentState.validate() && _image != null) {
                  _auth.signupUserWithLoginAndPassword(_email, _password,
                      (String _uid) async {
                    var _result = await 
                        DbStorageService.instance.uploadUserImage(_uid, _image);
                     
                    var imgUrl =  await _result.ref.getDownloadURL();
                       await  DbService.instance.createUserInDb(_uid, _name, _email, imgUrl);
                  });
                }
              },
              color: Colors.blue,
              child: Text(
                "Register",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          )
        : Align(
            alignment: Alignment.center,
            child: CircularProgressIndicator(),
          );
  }

  Widget _backButton() {
    return GestureDetector(
      onTap: () {
        NavigationService.instance.goBack();
      },
      child: Container(
        height: deviceHeight * 0.06,
        width: deviceWidth,
        child: Icon(
          Icons.arrow_back,
          size: 40,
        ),
      ),
    );
  }
}
