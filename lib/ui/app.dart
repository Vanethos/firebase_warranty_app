import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:warranty_app_example/ui/home/home_page.dart';
import 'package:warranty_app_example/ui/login/login_page.dart';
import 'package:warranty_app_example/ui/navigation.dart';

class WarrantyApp extends StatelessWidget {
  const WarrantyApp({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      initialRoute: routeLogin,
      routes: {
        routeLogin: (context) => const LoginPage(title: 'Warranty App'),
      },
      onGenerateRoute: (routeSettings) {
        if (routeSettings.name == routeHome) {
          var arguments = routeSettings.arguments as User;
          return MaterialPageRoute(
              settings: routeSettings,
              builder: (context) => HomePage(user: arguments));
        }

        return MaterialPageRoute(
            builder: (_) => const Scaffold(
                  body: Center(
                    child: Text("404"),
                  ),
                ));
      },
    );
  }
}
