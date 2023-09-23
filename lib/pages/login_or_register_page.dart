import 'package:flutter/material.dart';
import 'package:simple_messenger/pages/login_page.dart';
import 'package:simple_messenger/pages/register_page.dart';

class LoginOrRegisterPage extends StatefulWidget {
  const LoginOrRegisterPage({super.key});

  @override
  State<LoginOrRegisterPage> createState() => _LoginOrRegisterPageState();
}

class _LoginOrRegisterPageState extends State<LoginOrRegisterPage> {
  // Initially show login page
  bool showLoginPage = true;

  // Toggle between login and register page
  void togglePage() {
    setState(() {
      showLoginPage = !showLoginPage;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (showLoginPage) {
      return LoginPage(
        onRegister: togglePage,
      );
    } else {
      return RegisterPage(
        onSignIn: togglePage,
      );
    }
  }
}