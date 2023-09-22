import 'package:flutter/material.dart';
import '../components/friend.dart';

class MessagePage extends StatelessWidget {
  // In the constructor, require a Friend
  const MessagePage({super.key, required this.friend});

  // Declare a field that holds the Friend
  final Friend friend;

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: Text(friend.name),
        shadowColor: Theme.of(context).colorScheme.shadow,
        leading: Builder(
          builder: (BuildContext context) {
            return IconButton(
              icon: const Icon(Icons.arrow_back_ios),
              onPressed: () { 
                // Navigate back to Friends page
                Navigator.pop(context);
              },
            );
          }
        )
      ),
    );
  }
}