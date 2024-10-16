import 'package:flutter/material.dart';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'firebase_options.dart';

import 'package:cs4900/auth.dart';
import 'package:cs4900/views/home.dart';
import 'package:cs4900/views/signin.dart';
import 'package:cs4900/views/signup.dart';
import 'package:cs4900/views/feed.dart';
import 'package:cs4900/views/post.dart';
import 'package:cs4900/views/my_profile.dart';
import 'package:cs4900/views/profile_setup.dart';
import 'package:cs4900/views/profile.dart';

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
class RouteNames {
  static const String defaultScreenRoute = "";
  static const String homeScreenRoute = "/home";
  static const String signinScreenRoute = "/signin";
  static const String signupScreenRoute = "/signup";
  static const String profileScreenRoute = "/profile";
  static const String myProfileScreenRoute = "/my_profile";
  static const String feedScreenRoute = "/feed";
  static const String profileSetupScreenRoute = "/profile_setup";
}

class Router {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case RouteNames.defaultScreenRoute:
        return MaterialPageRoute(builder: (_) => HomeScreen());
      case RouteNames.homeScreenRoute:
        return MaterialPageRoute(builder: (_) => HomeScreen());
      case RouteNames.signinScreenRoute:
        return MaterialPageRoute(builder: (_) => SignInScreen());
      case RouteNames.signupScreenRoute:
        return MaterialPageRoute(builder: (_) => SignUpScreen());
      case RouteNames.profileScreenRoute:
        return MaterialPageRoute(builder: (_) => ProfileScreen());
      case RouteNames.myProfileScreenRoute:
        return MaterialPageRoute(builder: (_) => MyProfileScreen());
      case RouteNames.profileSetupScreenRoute:
        return MaterialPageRoute(builder: (_) => ProfileSetupScreen());
      case RouteNames.feedScreenRoute:
        return MaterialPageRoute(builder: (_) => FeedScreen());
      default:
        return MaterialPageRoute(builder: (_) => Scaffold(
          body: Center(child: Text("No route defined for ${settings.name}"))
        ));
    }
  }
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform,);
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    MaterialApp app = new MaterialApp(
      title: "Instagram Clone",
      initialRoute: "",
      theme: ThemeData(
        scaffoldBackgroundColor: const Color.fromARGB(255, 18, 25, 33),
      ),
      navigatorKey: navigatorKey,
      onGenerateRoute: Router.generateRoute,
    );

    return app;
  }
}
