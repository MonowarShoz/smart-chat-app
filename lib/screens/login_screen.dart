import 'dart:ui';

import 'package:chat_smart_app/services/auth.dart';
import 'package:chat_smart_app/services/navigation_service.dart';
import 'package:chat_smart_app/services/snackbar_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  double _deviceHeight;
  double _deviceWidth;

  GlobalKey<FormState> _formKey;
  AuthProvider _auth;
  String _email;
  String _password;

  _LoginScreenState() {
    _formKey = GlobalKey<FormState>();
  }

  @override
  Widget build(BuildContext context) {
    _deviceHeight = MediaQuery.of(context).size.height;
    _deviceWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      body: Align(
        alignment: Alignment.center,
        child: ChangeNotifierProvider<AuthProvider>.value(
          value: AuthProvider.instance,
          child: _loginUi(),
        ),
      ),
    );
  }

  Widget _loginUi() {
    return Builder(builder: (BuildContext context) {
      SnackBarService.instance.buildSnackbarContext = context;
      _auth = Provider.of<AuthProvider>(context);
      return Container(
        padding: EdgeInsets.symmetric(horizontal: _deviceWidth * 0.10),
        height: _deviceHeight * 0.50,
        alignment: Alignment.center,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            _headerWidget(),
            _inputFormField(),
            _loginButton(),
            _signupButton(),
          ],
        ),
      );
    });
  }

  Widget _headerWidget() {
    return Container(
      height: _deviceHeight * 0.12,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        mainAxisSize: MainAxisSize.max,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            "Welcome back",
            style: TextStyle(
              fontSize: 35,
              fontWeight: FontWeight.w700,
            ),
          ),
          Text(
            "Please login to your account",
            style: TextStyle(
              fontSize: 25,
              fontWeight: FontWeight.w200,
            ),
          ),
        ],
      ),
    );
  }

  Widget _inputFormField() {
    return Expanded(
      child: Container(
        height: _deviceHeight * 0.16,
        child: Form(
          key: _formKey,
          onChanged: () {
            _formKey.currentState.save();
          },
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.max,
            children: <Widget>[
              _emailTextFormField(),
              _passwordFormField(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _emailTextFormField() {
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

  Widget _passwordFormField() {
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
        onSaved: (_input) {
          setState(() {
            _password = _input;
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

  Widget _loginButton() {
    return _auth.authStatus == AuthStatus.Authenticating
        ? Align(
            alignment: Alignment.center,
            child: CircularProgressIndicator(),
          )
        : Container(
            height: _deviceHeight * 0.06,
            width: _deviceWidth,
            child: MaterialButton(
              onPressed: () {
                if (_formKey.currentState.validate()) {
                  //login user
                  _auth.loginUserWithEmailAndPassword(_email, _password);
                  
                }
              },
              color: Colors.blue,
              child: Text(
                "Login",
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
            
          );
  }

  Widget _signupButton() {
    return GestureDetector(
      onTap: () {
        NavigationService.instance.navigateTo("signup");
      },
      child: Container(
        margin: EdgeInsets.all(10),
        height: _deviceHeight * 0.06,
        width: _deviceWidth,
        child: Container(
          child: Text(
            "Sign up",
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w700,
              color: Colors.white60,
            ),
          ),
        ),
      ),
    );
  }
}
