import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class NavigationService {
  static NavigationService instance = NavigationService();
  GlobalKey<NavigatorState> navigatorKey;

  NavigationService() {
    navigatorKey = GlobalKey<NavigatorState>();
  }

  Future<dynamic> navigateToReplacement(String _routeName) {
    return navigatorKey.currentState.pushReplacementNamed(_routeName);
  }

  Future<dynamic> navigateTo(String _routeName) {
    return navigatorKey.currentState.pushNamed(_routeName);
  }

  Future<dynamic> navigatToRoute(MaterialPageRoute materialPageRoute) {
    return navigatorKey.currentState.push(materialPageRoute);
  }

   goBack() {
     navigatorKey.currentState.pop();
    
  }
}
