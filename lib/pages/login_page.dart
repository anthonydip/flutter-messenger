import 'package:flutter/material.dart';

import 'package:simple_messenger/components/login_textfield.dart';
import 'package:simple_messenger/components/login_button.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  void signIn() {}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[300],
      body: SafeArea(
        child: Center(
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
                    child: Image.asset(
                      'lib/assets/google.png',
                      height: 54,
                    )
                  )
                  
                ]
              )

            ],
          ),
        ),
      )
      
    );
  }
}