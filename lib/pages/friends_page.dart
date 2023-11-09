import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:simple_messenger/components/alert.dart';
import 'package:simple_messenger/services/user_service.dart';
import 'package:simple_messenger/singleton/user_data.dart';
import 'package:simple_messenger/services/auth_service.dart';
import 'package:simple_messenger/models/friend.dart';
import 'package:simple_messenger/components/alertSnackbar.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

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

  void addFriend(String email, BuildContext context) async {
    final userData = context.read<UserData>();
    final scaffoldMessenger = ScaffoldMessenger.of(context);

    try {
      String friendId = await UserService().getUserFromDatabase(email, false);
      Friend friend = Friend(friendId, email);

      if (userData.friends.contains(friend)) {
        // Friend already exists
        alertSnackbarMessage("User already added", scaffoldMessenger);
      } else {
        await UserService().addFriend(email, userData.token);

        // Get the FriendsModel and add the friend
        userData.addFriend(Friend(friendId, email));

        alertSnackbarMessage("User was added as friend", scaffoldMessenger);
      }
    } catch (e) {
      String message = "";
        if (e.toString().contains("Timeout")) {
          message = "Unable to connect to server";
        }
        else {
          message = e.toString();
        }
        
        alertSnackbarMessage(message, scaffoldMessenger);
    }
  }

  void signOut() async {
    try {
      await AuthService().signOut(userData.token);
      await FirebaseAuth.instance.signOut();
    } catch (e) {
      String message = "";
      if (e.toString().contains("Timeout")) {
        message = "Unable to connect to server";
      }
      else {
        message = e.toString();
      }

      // ignore: use_build_context_synchronously
      alertErrorMesage(message, context);
    }
  }

  @override
  Widget build(BuildContext context) {
    var appState = context.watch<MainAppState>();
    var userData = context.watch<UserData>();

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
                    labelText: 'Email',
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
                      addFriend(controller.text, context);
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
      // body: Text("Logged in as: ${user.email}, token: ${userData.token}"),
      body: Padding(
        padding: const EdgeInsets.only(left: 20, top: 10, right: 20, bottom: 10),
        child: ListView.builder(
          itemCount: userData.friends.length,
          itemBuilder: (BuildContext context, int index) {
            return ListTile(
              title: Text(userData.friends[index].email),
              trailing: const Icon(Icons.message),
              onTap: () {
                // Navigate to the Message page, passing in the selected friend
                Navigator.push(
                  context,
                  CupertinoPageRoute(
                    builder: (context) => MessagePage(friend: userData.friends[index]),
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