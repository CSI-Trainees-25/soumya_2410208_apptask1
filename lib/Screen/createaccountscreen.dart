import 'package:flutter/material.dart';
import 'homescreen.dart';
import 'package:up_todo/main.dart';

class CreateAccScreen extends StatefulWidget {
  const CreateAccScreen({super.key});

  @override
  State<CreateAccScreen> createState() => _CreateAccScreenState();
}

class _CreateAccScreenState extends State<CreateAccScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _usernameController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black26,
      appBar: AppBar(
        title: Text(
          'CREATE ACCOUNT',
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
                controller: _usernameController,
                keyboardType: TextInputType.name,
                decoration: InputDecoration(
                  labelText: "Username",
                  hintText: "student1",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(2 as Radius),
                  ),
                ),
              ),
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
              ElevatedButton(
                onPressed: () {
                  Navigator.pushReplacementNamed(context, '/home');
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color.fromARGB(255, 109, 73, 172),
                  foregroundColor: const Color.fromARGB(26, 234, 227, 227),
                ),
                child: Text('Create Account'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
