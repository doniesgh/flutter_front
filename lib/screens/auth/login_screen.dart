import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:todo/components/text_field.dart';
import 'package:todo/screens/Manager/homeManager.dart';
import 'package:todo/screens/auth/register_screen.dart';
import 'package:http/http.dart' as http;
import 'package:todo/screens/coordinatrice/homeCordinatrice.dart';
import 'package:todo/screens/home_screen.dart';
import 'package:todo/utils/toast.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);
  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  late SharedPreferences prefs;
  String? errorMessage;
  @override
  void initState() {
    super.initState();
    _initPrefs();
  }

  void _initPrefs() async {
    prefs = await SharedPreferences.getInstance();
  }

  final url = dotenv.env['URL'];
  final port = dotenv.env['PORT'];
  Future<void> login() async {
    try {
      if (emailController.text.isNotEmpty &&
          passwordController.text.isNotEmpty) {
        var loginBody = {
          "email": emailController.text,
          "password": passwordController.text,
        };
        Utils.showToast("Logging in...");
        var response = await http.post(
          Uri.parse("$url:$port/api/user/login"),
          headers: {"Content-Type": "application/json"},
          body: jsonEncode(loginBody),
        );

        if (response.statusCode == 200) {
          var responseData = jsonDecode(response.body);
          var myToken = responseData["token"];
          var email = responseData["email"];
          var role = responseData["role"];
          Utils.showToast("Logged in successfully");
          Utils.showToast(email);
          Utils.showToast(role);
          prefs.setString("token", myToken);
          prefs.setString("email", email);
          prefs.setString("email", role);
          // Redirect based on role
          if (role == "COORDINATRICE") {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) =>
                    HomeCordinatrice(token: myToken, email: email),
              ),
            );
          } else if (role == "MANAGER") {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => HomeManager(token: myToken, email: email),
              ),
            );
          } else {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => HomeScreen(token: myToken, email: email),
              ),
            );
          }
        } else {
          var errorResponse = jsonDecode(response.body);
          Utils.showToast("Login failed: ${errorResponse['error']}");
          setState(() {
            errorMessage = errorResponse['error'];
          });
        }
      } else {
        Utils.showToast("Please fill all the fields");
      }
    } catch (e) {
      Utils.showToast("Error: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                margin: EdgeInsets.only(top: 100.0),
                child: Image.asset(
                  'assets/tu.png',
                  width: 220,
                  height: 150,
                ),
              ),
              const SizedBox(height: 100),
              TextInput(
                controller: emailController,
                label: "Email",
              ),
              TextInput(
                controller: passwordController,
                label: "Password",
                isPass: true,
              ),
              ElevatedButton(
                onPressed: login,
                child: const Text('Login'),
              ),
              if (errorMessage != null)
                Text(
                  errorMessage!,
                  style: TextStyle(color: Colors.red),
                ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text("Don't have an account?"),
                  GestureDetector(
                    onTap: () {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const RegisterScreen(),
                        ),
                      );
                    },
                    child: Text(
                      ' Register',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).primaryColor,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
