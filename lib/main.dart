import 'package:bot_toast/bot_toast.dart';
import 'package:e_labors/profile/views/profile_screen.dart';
import 'package:e_labors/push_notification/controllers/notification_controller.dart';
import 'package:e_labors/routes/app_routes.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';
import 'home/views/home_screen.dart';
import 'chat_screen.dart';
import 'notification_screen.dart' as custom_notification;


Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  // Register the background message handler
  FirebaseMessaging.onBackgroundMessage(NotificationController.firebaseMessagingBackgroundHandler);

  // Ensure the NotificationController is initialized
  Get.put(NotificationController());

  // Check if the app was launched by a notification
  FirebaseMessaging.instance.getInitialMessage().then((RemoteMessage? message) {
    if (message != null) {
      Get.find<NotificationController>().onSelectNotification(message.data['payload']);
    }
  });

  runApp(const MyApp());

  // Optional: Set preferred status bar styles (Android only)
  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    statusBarColor: Colors.transparent, // Adjust as needed
  ));
}





class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Your App Name',
      builder: BotToastInit(),
      navigatorObservers: [BotToastNavigatorObserver()],
      theme: ThemeData(
        // Your app's theme customizations
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      initialRoute: AppRoutes.MAINSCREEN,
      getPages: AppRoutes.routes,
    );
  }
}
class MainScreen extends StatefulWidget {
  final int selectedIndex;

  const MainScreen({Key? key, this.selectedIndex = 0}) : super(key: key);

  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0;

  static final List<Widget> _screens = <Widget>[
    HomeScreen(),
    ChatScreen(),
    custom_notification.NotificationScreen(),
    ProfileScreen(),
  ];

  NotificationController notificationController = Get.put(NotificationController());
  @override
  void initState() {
    super.initState();
    _selectedIndex = widget.selectedIndex;  // Set the initial index based on the constructor
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  Future<bool> _onWillPop() async {
    // If the current screen is not HomeScreen (index 0), navigate to HomeScreen
    if (_selectedIndex != 0) {
      setState(() {
        _selectedIndex = 0; // Set to HomeScreen
      });
      return false; // Prevent the back action (stay in the app)
    } else {
      // If already on HomeScreen, allow the back button to exit the app
      return true;
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onWillPop,  // Handle back button press
      child: Scaffold(
        body: _screens[_selectedIndex],
        bottomNavigationBar: BottomNavigationBar(
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.chat),
              label: 'Chat',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.notifications),
              label: 'Notifications',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.account_circle),
              label: 'Profile',
            ),
          ],
          currentIndex: _selectedIndex,
          selectedItemColor: Color(0xfff67322),
          unselectedItemColor: Colors.grey.withOpacity(0.9),
          onTap: _onItemTapped,
        ),
      ),
    );
  }
}
