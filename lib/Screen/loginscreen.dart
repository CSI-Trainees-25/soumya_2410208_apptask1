import 'package:flutter/material.dart';
import 'package:up_todo/main.dart';

class login_screen extends StatefulWidget {
  const login_screen({super.key});

  @override
  State<login_screen> createState() => _login_screenState();
}

class _login_screenState extends State<login_screen> {
  final _formkey = GlobalKey<FormState>;
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black26,
      appBar: AppBar(
        title: Text(
          'LOGIN',
          style: TextStyle(
            color: const Color.fromARGB(255, 227, 218, 218),
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
      body: Center(
        child: Form(
          child: Column(
            children: [
              TextFormField(
                controller: _emailController,
                keyboardType: TextInputType.emailAddress,
                decoration: InputDecoration(
                  labelText: "Email",
                  hintText: "student1.@gmail.com",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(2 as Radius),
                  ),
                ),
              ),

              SizedBox(height: 20),
              TextFormField(
                controller: _passwordController,
                obscureText: true,
                keyboardType: TextInputType.visiblePassword,
                decoration: InputDecoration(
                  labelText: "Password",
                  hintText: "student123",
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 20),
              ElevatedButton(onPressed: () {}, child: Text('Login')),
            ],
          ),
        ),
      ),
    );
  }
}
