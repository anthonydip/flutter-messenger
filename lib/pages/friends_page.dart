import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter/cupertino.dart';

import '../main.dart';
import 'message_page.dart';


class FriendsPage extends StatefulWidget {
  const FriendsPage({super.key});

  @override
  State<FriendsPage> createState() => _FriendsPageState();
}

class _FriendsPageState extends State<FriendsPage> {
  // Create a text controller and use it to retrieve the current value
  // of the TextField
  final controller = TextEditingController();

  // Get the current user
  final user = FirebaseAuth.instance.currentUser!;

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed
    controller.dispose();
    super.dispose();
  }

  void signOut() async {
    await FirebaseAuth.instance.signOut();
  }

  @override
  Widget build(BuildContext context) {
    var appState = context.watch<MainAppState>();
    var friends = appState.friends;

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.logout),
          onPressed: signOut,
        ),
        title: const Text('Friends List'),
        shadowColor: Theme.of(context).colorScheme.shadow,
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.add, size: 30),
            onPressed: () => showDialog<String>(
              context: context,
              builder: (BuildContext context) => AlertDialog(
                title: const Text('Add Friend'),
                content: TextField(
                  controller: controller,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Name',
                  ),
                ),
                actions: <Widget>[
                  TextButton(
                    onPressed: () => Navigator.pop(context, 'Cancel'),
                    child: const Text('Cancel'),
                  ),
                  TextButton(
                    onPressed: () {
                      // Add friend to the friends list
                      appState.addFriend(controller.text);

                      Navigator.pop(context, 'Add');
                    },
                    child: const Text('Add'),
                  ),
                ],
              ),
            ),
          ),
        ],
        automaticallyImplyLeading: false,
      ),
      body: Padding(
        padding: const EdgeInsets.only(left: 20, top: 10, right: 20, bottom: 10),
        child: ListView.builder(
          itemCount: friends.length,
          itemBuilder: (BuildContext context, int index) {
            return ListTile(
              title: Text(friends[index].name),
              trailing: const Icon(Icons.message),
              onTap: () {
                // Navigate to the Message page, passing in the selected friend
                Navigator.push(
                  context,
                  CupertinoPageRoute(
                    builder: (context) => MessagePage(friend: friends[index]),
                  ),
                );
              },
            );
          },
        ),
      )
    );
  }
}