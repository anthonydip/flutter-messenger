import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'home.dart';
import 'friend.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => MainAppState(),
      child: MaterialApp(
        title: 'Simple Messenger',
        theme: ThemeData(
          useMaterial3: true,
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        ),
        home: const HomePage(),
      ),
    );
  }
}

class MainAppState extends ChangeNotifier {
  var friends = <Friend>[];

  void addFriend(name) {
    if (friends.contains(name)) {
      // Friend already exists
      // code..
    } else {
      friends.add(Friend(name));
    }

    notifyListeners();
  }
}