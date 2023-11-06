import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:simple_messenger/pages/auth_page.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:simple_messenger/services/user_service.dart';
import 'package:simple_messenger/singleton/user_data.dart';
import 'firebase_options.dart';

import 'models/friend.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await dotenv.load(fileName: ".env");
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => UserData()),
      ],
      child: const MainApp(),
    ),
  );
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScaffoldMessenger(
      child: ChangeNotifierProvider(
        create: (context) => MainAppState(),
        child: MaterialApp(
          title: 'Simple Messenger',
          theme: ThemeData(
            useMaterial3: true,
            colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
          ),
          home: const AuthPage(),
        ),
      ),
    );
  }
}

class MainAppState extends ChangeNotifier {
  var friends = <Friend>[];

  // void addFriend(email) async {
  //   if (friends.contains(email)) {
  //     // Friend already exists
  //     // code..
  //   } else {
  //     await UserService().addFriend(email, userData.token);

  //     // friends.add(Friend(email));
  //   }

  //   notifyListeners();
  // }
}

class FriendsModel extends ChangeNotifier {
  List<Friend> _friends = [];

  List<Friend> get friends => _friends;

  void addFriend(Friend friend) {
    _friends.add(friend);
    notifyListeners();
  }

  void clearFriends() {
    _friends.clear();
    notifyListeners();
  }
}