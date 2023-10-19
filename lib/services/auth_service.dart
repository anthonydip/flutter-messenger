import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:simple_messenger/models/user.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class AuthService {

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
    );

    print(jsonDecode(response.body));

    final body = jsonDecode(response.body);
    final status = body['status'];

    switch (status) {
      case 'BAD REQUEST':
        throw 'Invalid request';
      case 'CONFLICT':
        throw 'User already exists';
      case 'INTERNAL SERVER ERROR':
        throw 'Internal server error';
    }
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

    // Sign in
    return await FirebaseAuth.instance.signInWithCredential(credential);
  }
}