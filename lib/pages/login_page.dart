import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'package:simple_messenger/components/login_textfield.dart';
import 'package:simple_messenger/components/login_button.dart';
import 'package:simple_messenger/components/alert.dart';
import 'package:simple_messenger/services/auth_service.dart';

class LoginPage extends StatefulWidget {
  final Function()? onRegister;
  const LoginPage({super.key, required this.onRegister});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  bool isLoading = false;

  void googleSignIn() async {
    setState(() {
      isLoading = true;
    });

    try {
      await AuthService().signInWithGoogle();
    } catch (e) {
      setState(() {
        isLoading = false;
      });
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

  void signIn() async {
    setState(() {
      isLoading = true;
    });

    try {
      await AuthService().signInWithEmail(emailController.text, passwordController.text);
    } on FirebaseAuthException catch (e) {      
      setState(() {
        isLoading = false;
      });

      if(e.code == 'INVALID_LOGIN_CREDENTIALS') {
        // ignore: use_build_context_synchronously
        alertErrorMesage('Invalid credentials', context);
      } else {
        // ignore: use_build_context_synchronously
        alertErrorMesage('Error has occurred', context);
      }
    } catch (e) {
      setState(() {
        isLoading = false;
      });
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
    return Scaffold(
      backgroundColor: Colors.grey[300],
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              children: [
                const SizedBox(height: 50),
          
                Card(
                  color: Colors.grey.shade100,
                  child: const Padding(
                    padding: EdgeInsets.all(15.0),
                    child: Text('Simple Messenger', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 30)),
                  ),
                ),
          
                const SizedBox(height: 100),
          
                LoginTextField(
                  controller: emailController,
                  hintText: 'Email',
                  obscureText: false,
                ),
          
                const SizedBox(height: 10),
          
                LoginTextField(
                  controller: passwordController,
                  hintText: 'Password',
                  obscureText: true,
                ),
          
                const SizedBox(height: 50),
          
                LoginButton(
                  onTap: signIn,
                  text: 'Sign In',
                  isLoading: isLoading,
                ),
          
                const SizedBox(height: 50),
          
                Row(
                  children: [
                    Expanded(
                      child: Divider(
                        thickness: 0.5,
                        color: Colors.grey.shade400,
                      )
                    ),
                    Text(
                      'Or continue with',
                      style: TextStyle(color: Colors.grey.shade700)
                    ),
                    Expanded(
                      child: Divider(
                        thickness: 0.5,
                        color: Colors.grey.shade400,
                      )
                    ),
                  ],
                ),
          
                const SizedBox(height: 50),
          
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      padding: EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.white),
                        color: Colors.grey.shade200,
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: GestureDetector(
                        onTap: googleSignIn,
                        child: Image.asset(
                          'lib/assets/google.png',
                          height: 54,
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 25),

                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Don\'t have an account?',
                      style: TextStyle(color: Colors.grey.shade700),
                    ),
                    const SizedBox(width: 4),
                    GestureDetector(
                      onTap: widget.onRegister,
                      child: const Text(
                        'Register now',
                        style: TextStyle(
                          color: Colors.blue,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    )
                  ],
                ),
          
              ],
            ),
          ),
        ),
      )
      
    );
  }
}