import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:simple_messenger/models/friend.dart';
import 'package:simple_messenger/singleton/user_data.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:simple_messenger/services/user_service.dart';

class AuthService {
  // Get access token for the user
  Future<String> getUserAccessToken(String email) async {
    final response = await http.post(
      Uri.parse('${dotenv.env['API_URL']}/auth/tokens/access'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer ${dotenv.env['INTERNAL_TOKEN']}'
      },
      body: jsonEncode(<String, String>{
        'email': email,
      }),
    ).timeout(const Duration(seconds: 5));

    final body = jsonDecode(response.body);
    final status = body['status'];

    switch (status) {
      case 'CREATED':
        break;
      case 'BAD REQUEST':
        throw 'Invalid request';
      default:
        throw 'Internal server error';
    }

    userData.token = body['token'];

    return body['token'];
  }

  // Sign out
  signOut(String token) async {
    await http.delete(
      Uri.parse('${dotenv.env['API_URL']}/auth/tokens/access/$token'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer ${dotenv.env['INTERNAL_TOKEN']}'
      },
    ).timeout(const Duration(seconds: 5));

    userData.clear();
  }

  // Email and Password Sign In
  signInWithEmail(String email, String password) async {
    final response = await http.post(
      Uri.parse('${dotenv.env['API_URL']}/auth/signin'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer ${dotenv.env['INTERNAL_TOKEN']}'
      },
      body: jsonEncode(<String, String>{
        'email': email,
        'provider': 'Flutter',
        'password': password
      }),
    ).timeout(const Duration(seconds: 5));

    final body = jsonDecode(response.body);
    final status = body['status'];

    switch (status) {
      case 'SUCCESS':
        break;
      case 'BAD REQUEST':
        throw 'Invalid request';
      case 'UNAUTHORIZED':
        throw 'Incorrect password';
      case 'NOT FOUND':
        throw 'User does not exist';
      default:
        throw 'Internal server error';
    }

    userData.token = body['token'];

    // Retrieve friends list
    List<Friend> friends = await UserService().getFriendsList(userData.token);
    userData.friends = friends;

    await FirebaseAuth.instance.signInWithEmailAndPassword(
      email: email, 
      password: password
    );
  }

  // Google Sign In
  signInWithGoogle() async {
    // Begin interactive sign in process
    final GoogleSignInAccount? gUser = await GoogleSignIn().signIn();

    // Obtain auth details from request
    final GoogleSignInAuthentication gAuth = await gUser!.authentication;

    // Create a new credential for the user
    final credential = GoogleAuthProvider.credential(
      accessToken: gAuth.accessToken,
      idToken: gAuth.idToken,
    );

    // Check if the user already exists in the database
    try {
      await UserService().getUserFromDatabase(gUser.email, false);

      // Add the user to the database if they do not already exist
      await UserService().addUserToDatabase(gUser.email, "", false);

      // Get user access token
      await getUserAccessToken(gUser.email);

      // Retrieve friends list
      List<Friend> friends = await UserService().getFriendsList(userData.token);
      userData.friends = friends;

      // Sign in
      final UserCredential userCred = await FirebaseAuth.instance.signInWithCredential(credential);

      return userCred;
    } catch (e) {
      // Expected error if user's Google account already exists
      if (e == "User already exists") {
        // Get user access token
        await getUserAccessToken(gUser.email);

        // Retrieve friends list
        List<Friend> friends = await UserService().getFriendsList(userData.token);
        userData.friends = friends;

        // Sign in
        final UserCredential userCred = await FirebaseAuth.instance.signInWithCredential(credential);

        return userCred;
      } else {
        rethrow;
      }
    }
    
  }
}