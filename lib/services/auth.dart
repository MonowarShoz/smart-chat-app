import 'package:chat_smart_app/services/navigation_service.dart';
import 'package:chat_smart_app/services/snackbar_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

enum AuthStatus {
  NotAuthenticated,
  Authenticating,
  Authenticated,
  UserNotFound,
  Error,
}

class AuthProvider extends ChangeNotifier {
  FirebaseAuth _auth;
  User user;
  AuthStatus authStatus;
  UserCredential credential;
  static AuthProvider instance = AuthProvider();

  AuthProvider() {
    _auth = FirebaseAuth.instance;
    _checkCurrentUser();
  }

  void _autoLogin() {
    if (user != null) {
      NavigationService.instance.navigateToReplacement("home");
    }
  }

  void _checkCurrentUser() {
    user = _auth.currentUser;
    if (user != null) {
      notifyListeners();
      _autoLogin();
    }
  }

  void loginUserWithEmailAndPassword(String _email, String _password) async {
    authStatus = AuthStatus.Authenticating;
    notifyListeners();
    try {
      credential = await _auth.signInWithEmailAndPassword(
          email: _email, password: _password);
      user = credential.user;
      authStatus = AuthStatus.Authenticated;
      SnackBarService.instance.showSuccessSnackbar("Welcome ${user.email}");
      NavigationService.instance.navigateToReplacement("home");
    } catch (e) {
      authStatus = AuthStatus.Error;
      user = null;
      SnackBarService.instance.showErrorSnackbar("Error");
    }
    notifyListeners();
  }

  void signupUserWithLoginAndPassword(String _email, String _password,
      Future<void> onSuccess(String _uid)) async {
    authStatus = AuthStatus.Authenticating;
    notifyListeners();
    try {
      credential = await _auth.createUserWithEmailAndPassword(
          email: _email, password: _password);
      user = credential.user;
      authStatus = AuthStatus.Authenticated;
      await onSuccess(user.uid);
      SnackBarService.instance.showSuccessSnackbar("Welcome ${user.email}");
      NavigationService.instance.goBack();
      NavigationService.instance.navigateToReplacement("home");
    } catch (e) {
      authStatus = AuthStatus.Error;
      user = null;
      SnackBarService.instance.showErrorSnackbar("Error Registering USer");
    }
    notifyListeners();
  }

  void logOutUser(Future<void> onSuccess()) async {
    try {
      await _auth.signOut();
      user = null;
      authStatus = AuthStatus.NotAuthenticated;
      await onSuccess();

      await NavigationService.instance.navigateToReplacement("login");
      SnackBarService.instance.showSuccessSnackbar("Logged Out Successfully");
    } catch (e) {
      SnackBarService.instance.showErrorSnackbar("Error logging out");
    }
    notifyListeners();
  }
}
