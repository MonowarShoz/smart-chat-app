import 'package:chat_smart_app/models/contact.dart';
import 'package:chat_smart_app/services/auth.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:chat_smart_app/services/database_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

AuthProvider _auth;

class ProfileScreen extends StatelessWidget {
  final double _height;
  final double _width;

  ProfileScreen(this._height, this._width);
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Theme.of(context).backgroundColor,
      height: _height,
      width: _width,
      child: ChangeNotifierProvider<AuthProvider>.value(
        value: AuthProvider.instance,
        child: _profileUi(context),
      ),
    );
  }

  Widget _profileUi(BuildContext context) {
    _auth = Provider.of<AuthProvider>(context);
    return StreamBuilder<Contact>(
      stream: DbService.instance.getUserData(_auth.user.uid),
      builder: (_context, snapshot) {
        var _userData = snapshot.data;
        return snapshot.hasData
            ? Align(
                child: SizedBox(
                  height: _height * 0.50,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisSize: MainAxisSize.max,
                    children: <Widget>[
                      _userImageWidget(_userData.image),
                      _userNameWidget(_userData.name),
                      _userEmailWidget(_userData.email),
                      _logoutButton(),
                    ],
                  ),
                ),
              )
            : SpinKitWanderingCubes(
                color: Colors.blue,
                size: 50.0,
              );
      },
    );
  }

  Widget _userImageWidget(String _image) {
    double _imgRadius = _height * 0.20;
    return Container(
      height: _imgRadius,
      width: _imgRadius,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(_imgRadius),
        image: DecorationImage(
          fit: BoxFit.cover,
          image: NetworkImage(_image),
        ),
      ),
    );
  }

  Widget _userNameWidget(String _userName) {
    return Container(
      height: _height * 0.05,
      width: _width,
      child: Text(
        _userName,
        textAlign: TextAlign.center,
        style: TextStyle(
          color: Colors.white24,
          fontSize: 15,
        ),
      ),
    );
  }

  Widget _userEmailWidget(String _email) {
    return Container(
      height: _height * 0.03,
      width: _width,
      child: Text(
        _email,
        textAlign: TextAlign.center,
        style: TextStyle(
          color: Colors.white24,
          fontSize: 15,
        ),
      ),
    );
  }

  Widget _logoutButton() {
    return Container(
      height: _height * 0.06,
      width: _width * 0.80,
      child: MaterialButton(
        onPressed: () {
          // ignore: missing_return
          _auth.logOutUser(() {});
        },
        color: Colors.red,
        child: Text(
          "Logout",
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
    );
  }
}
