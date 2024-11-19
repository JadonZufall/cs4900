import 'dart:developer';

import 'package:cs4900/views/message/direct_messages.dart';
import 'package:cs4900/views/message/inbox.dart';
import 'package:cs4900/views/notifications/notificationScreen.dart';
import 'package:cs4900/views/profile/profile_following.dart';
import 'package:cs4900/views/profile/profile_followers.dart';
import 'package:cs4900/views/upload_type.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
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
import 'package:cs4900/views/profile/my_profile.dart';
import 'package:cs4900/views/profile/public_profile.dart';
import 'package:cs4900/views/profile_setup.dart';
import 'package:cs4900/views/camera/photo.dart';
import 'package:cs4900/views/profile/my_profile_settings.dart';
import 'package:cs4900/views/profile/profile_followers.dart';
import 'package:cs4900/views/search/search.dart';
import 'package:cs4900/views/camera/upload.dart';

@pragma('vm:entry-point')
Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
}

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
  static const String profilePictureScreenRoute = "/uploadProfilePicture";
  static const String myProfileSettingsRoute = "/my_profile_settings";
  static const String searchScreenRoute = "/search";
  static const String publicProfileRoute = '/publicProfile';
  static const String directMessageRoute = '/direct_message';
  static const String inboxScreenRoute = '/inbox';
  static const String followingRoute = 'following';
  static const String followersRoute = 'followers';
  static const String notificationsScreenRoute = '/notifications';
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
      case RouteNames.publicProfileRoute:
        final args = settings.arguments as Map<String, String>;
        return MaterialPageRoute(
          builder: (_) => PublicProfileScreen(userId: args['userId']!),
        );
      case RouteNames.followersRoute:
        final args = settings.arguments as Map<String, String>;
        return MaterialPageRoute(
          builder: (_) => FollowersPage(userId: args['userId']!),
        );
      case RouteNames.followingRoute:
        final args = settings.arguments as Map<String, String>;
        return MaterialPageRoute(
          builder: (_) => FollowingPage(userId: args['userId']!),
        );
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
            return TakePictureScreen(camera: primaryCamera as CameraDescription, uploadType: UploadType.imageUpload);
          }
          log("Unable to find primary camera!");
          return HomeScreen();
        });
      case RouteNames.uploadTypeScreenRoute:
          return MaterialPageRoute(builder: (_) => UploadTypeScreen(uploadType: UploadType.imageUpload));
      case RouteNames.myProfileSettingsRoute:
        return MaterialPageRoute(builder: (_) => MyProfileSettingsScreen());
      case RouteNames.searchScreenRoute:
        return MaterialPageRoute(builder: (_) => SearchPage());
      case RouteNames.inboxScreenRoute:
        return MaterialPageRoute(builder: (_) => InboxScreen());
      case RouteNames.directMessageRoute:
        final args = settings.arguments as Map<String, String>;
        return MaterialPageRoute(builder: (_) => DirectMessagesScreen(recieverUserId: args['userId']!));
      case RouteNames.profilePictureScreenRoute:
        return MaterialPageRoute(builder: (_) => UploadTypeScreen(uploadType: UploadType.profilePictureUpload));
      case RouteNames.notificationsScreenRoute:
        return MaterialPageRoute(builder: (_) => NotificationScreen());
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
  FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);
  runApp(MyApp());
}

final RouteObserver<PageRoute> routeObserver = RouteObserver<PageRoute>();

class MyApp extends StatelessWidget {
  MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    MaterialApp app = new MaterialApp(
      navigatorObservers: [routeObserver],
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
