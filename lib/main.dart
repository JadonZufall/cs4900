import 'dart:developer';

import 'package:cs4900/views/upload_type.dart';
import 'package:flutter/material.dart';
import 'package:camera/camera.dart';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'firebase_options.dart';

import 'package:cs4900/auth.dart';
import 'package:cs4900/views/home.dart';
import 'package:cs4900/views/signin.dart';
import 'package:cs4900/views/signup.dart';
import 'package:cs4900/views/feed.dart';
import 'package:cs4900/views/post.dart';
//import 'package:cs4900/views/my_profile.dart';
import 'package:cs4900/views/profile/my_profile.dart';
import 'package:cs4900/views/profile_setup.dart';
import 'package:cs4900/views/profile.dart';
import 'package:cs4900/views/camera/photo.dart';

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
  static const String uploadTypeScreenRoute = "/upload_type";
  static const String uploadScreenRoute = "/upload";
  static const String myProfileSettingsRoute = "/profile_setup";
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
        return MaterialPageRoute(builder: (_) {
          return MyProfileScreen();
        });
      case RouteNames.profileSetupScreenRoute:
        return MaterialPageRoute(builder: (_) => ProfileSetupScreen());
      case RouteNames.feedScreenRoute:
        return MaterialPageRoute(builder: (_) => FeedScreen());
      case RouteNames.uploadScreenRoute:
        return MaterialPageRoute(builder: (_) {
          if (primaryCamera != null) {
            return TakePictureScreen(camera: primaryCamera as CameraDescription);
          }
          log("Unable to find primary camera!");
          return HomeScreen();
        });
      case RouteNames.uploadTypeScreenRoute:
          return MaterialPageRoute(builder: (_) => UploadTypeScreen());
      default:
        return MaterialPageRoute(builder: (_) => Scaffold(
          body: Center(child: Text("No route defined for ${settings.name}"))
        ));
    }
  }
}

CameraDescription? primaryCamera;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final List<CameraDescription> cameras = await availableCameras();
  log("found ${cameras.length} cameras");
  primaryCamera = cameras.first;
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
