import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:simple_messenger/utils/https_helper.dart';
import 'package:simple_messenger/models/friend.dart';
import 'package:http/http.dart' as http;

class UserService {
  // Get user by email or ID
  // If isID is true, then search by ID
  // If isID is false, then search by email
  Future<bool> getUserFromDatabase(String id, bool isID) async {
    Map<String, String> queryParams;
    bool userExists = true;

    if (isID) {
      queryParams = {
        'type': 'id',
      };
    }
    else {
      queryParams = {
        'type': 'email',
      };
    }

    final response = await http.get(
      Uri.parse('${dotenv.env['API_URL']}/users/$id?${encodeQueryParameters(queryParams)}'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer ${dotenv.env['INTERNAL_TOKEN']}'
      },
    ).timeout(const Duration(seconds: 5));

    final body = jsonDecode(response.body);
    final status = body['status'];

    switch (status) {
      case 'SUCCESS':
        break;
      case 'BAD REQUEST':
        throw 'Invalid request';
      case 'NOT FOUND':
        userExists = false;
        break;
      default:
        throw 'Internal server error';
    }

    return userExists;
  }

  // Add the user to the database
  Future<void> addUserToDatabase(String email, String password, bool isFlutter) async {
    // Make a POST request to create a new user
    final response = await http.post(
      Uri.parse('${dotenv.env['API_URL']}/users'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer ${dotenv.env['INTERNAL_TOKEN']}'
      },
      body: jsonEncode(<String, String>{
        'email': email,
        'provider': isFlutter ? 'Flutter' : 'Google',
        'password': password
      }),
    ).timeout(const Duration(seconds: 5));

    final body = jsonDecode(response.body);
    final status = body['status'];

    switch (status) {
      case 'CREATED':
        break;
      case 'BAD REQUEST':
        throw 'Invalid request';
      case 'CONFLICT':
        throw 'User already exists';
      default:
        throw 'Internal server error';
    }
  }

  // Add friend
  Future<void> addFriend(String friendEmail, String token) async {
    // Make a POST request to add a friend
    final response = await http.post(
      Uri.parse('${dotenv.env['API_URL']}/users/friends'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer $token'
      },
      body: jsonEncode(<String, String>{
        'email': friendEmail,
      }),
    ).timeout(const Duration(seconds: 5));

    final body = jsonDecode(response.body);
    final status = body['status'];

    switch (status) {
      case "SUCCESS":
        break;
      case "BAD REQUEST":
        if(body['statusmessage'] == "Invalid request body") {
          throw "Internal server error";
        } else {
          throw "Invalid email";
        }
      case "UNAUTHORIZED":
        throw "Invalid access token";
      case "NOT FOUND":
        throw "User not found";
      case "CONFLICT":
        throw "Invalid friend";
      default:
        throw "Internal server error";
    }
  }

  // Retrieve a user's friends list
  Future<List<Friend>> getFriendsList(String token) async {
    // Make a GET request to retrieve friends list
    final response = await http.get(
      Uri.parse('${dotenv.env['API_URL']}/users/friends'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer $token'
      }
    ).timeout(const Duration(seconds: 5));

    final body = jsonDecode(response.body);
    final status = body['status'];

    switch (status) {
      case "SUCCESS":
        final list = body['friends'];

        List<Friend> friendsList = [];
        for (var friend in list) {
          Friend tempFriend = Friend(friend['email']);
          friendsList.add(tempFriend);
        }

        return friendsList;
      case "UNAUTHORIZED":
        throw "Invalid access token";
      default:
        throw "Internal server error";
    }
  }
}