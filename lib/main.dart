import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:t80/splash_screen.dart';
import 'package:t80/profile_manager.dart';
import 'package:t80/post_manager.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  final profileManager = ProfileManager();
  runApp(MyApp(profileManager: profileManager));
}

class MyApp extends StatelessWidget {
  final ProfileManager profileManager;

    MyApp({super.key, ProfileManager? profileManager})
      : profileManager = profileManager ?? ProfileManager();

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<ProfileManager>.value(value: profileManager),
        ChangeNotifierProvider<PostManager>(create: (_) => PostManager()),
      ],
      child: MaterialApp(
        title: 'T80 - ${profileManager.userProfile.fullName}',
        debugShowCheckedModeBanner: false,
        home: const SplashScreen(),
      ),
    );
  }
}