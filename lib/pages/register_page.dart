import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'package:simple_messenger/components/login_textfield.dart';
import 'package:simple_messenger/components/login_button.dart';
import 'package:simple_messenger/services/auth_service.dart';

class RegisterPage extends StatefulWidget {
  final Function()? onSignIn;
  const RegisterPage({super.key, required this.onSignIn});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();
  bool isLoading = false;

  void signUp() async {
    setState(() {
      isLoading = true;
    });

    try {
      // Check if password is confirmed
      if (passwordController.text == confirmPasswordController.text) {
        await AuthService().addUserToDatabase(emailController.text, passwordController.text, true);

        await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: emailController.text, 
          password: passwordController.text
        );
      } else {
        setState(() {
          isLoading = false;
        });
        alertErrorMesage('Passwords do not match');
      }

    } on FirebaseAuthException catch (e) {
      setState(() {
        isLoading = false;
      });
      alertErrorMesage(e.code);
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      alertErrorMesage(e.toString());
    }
  }

  void alertErrorMesage(String message) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Error'),
          content: Text(message),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.pop(context, 'OK');
              },
              child: const Text('OK'),
            ),
          ]
        );
      },
    );
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
          
                const SizedBox(height: 50),
          
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
          
                const SizedBox(height: 10),

                LoginTextField(
                  controller: confirmPasswordController,
                  hintText: 'Confirm Password',
                  obscureText: true,
                ),
          
                const SizedBox(height: 50),

                LoginButton(
                  onTap: signUp,
                  text: 'Sign Up',
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
                        onTap: () => AuthService().signInWithGoogle(),
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
                      'Already have an account?',
                      style: TextStyle(color: Colors.grey.shade700),
                    ),
                    const SizedBox(width: 4),
                    GestureDetector(
                      onTap: widget.onSignIn,
                      child: const Text(
                        'Sign in',
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