import 'package:flutter/material.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:todo/screens/auth/register_screen.dart';
import 'package:todo/screens/home_screen.dart';
import 'package:todo/screens/tickets/phoneAssigned.dart';
import 'package:todo/screens/tickets/phoneaccepted.dart';
import 'package:todo/screens/tickets/phonearrived.dart';
import 'package:todo/screens/tickets/phonedeparture.dart';
import 'package:todo/screens/tickets/phoneloading.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SharedPreferences prefs = await SharedPreferences.getInstance();
  String? token = prefs.getString('token');
  String? email = prefs.getString('email');

  runApp(MyApp(token: token, email: email));
}

class MyApp extends StatelessWidget {
  final String? token;
  final String? email;

  const MyApp({Key? key, required this.token, required this.email})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    bool isTokenExpired = token == null || JwtDecoder.isExpired(token!);
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Tunisys',

      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
            seedColor: const Color.fromARGB(255, 185, 6, 6)),
        useMaterial3: true,
        textTheme: GoogleFonts
            .poppinsTextTheme(), 
      ),
      routes: {
        '/assignedphone': (context) => PhoneAssignedScreen(token: token!),
        '/acceptedphone': (context) => PhoneAcceptedScreen(token: token!),
        '/departurephone': (context) => PhoneDepartureScreen(token: token!),
        '/arrivedphone': (context) => PhoneArrivedScreen(token: token!),
        '/loadingphone': (context) => PhoneLoadingScreen(token: token!),
      },

      home: isTokenExpired
          ? const RegisterScreen()
          : HomeScreen(
              token: token!,
              email: email!,
            ), 
    );
  }
}
