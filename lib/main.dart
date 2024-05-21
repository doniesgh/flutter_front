import 'package:flutter/material.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:todo/screens/auth/register_screen.dart';
import 'package:todo/screens/home_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SharedPreferences prefs = await SharedPreferences.getInstance();
  String? token = prefs.getString('token');
  runApp(MyApp(token: token));
}

class MyApp extends StatelessWidget {
  final String? token;

  const MyApp({Key? key, required this.token}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    bool isTokenExpired = token == null || JwtDecoder.isExpired(token!);
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: isTokenExpired ? const RegisterScreen() : HomeScreen(token: token!),
    );
  }
}
