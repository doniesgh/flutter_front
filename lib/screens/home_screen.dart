import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:todo/components/text_field.dart';
import 'package:todo/models/todo_model.dart';
import 'package:todo/screens/auth/register_screen.dart';
import 'package:todo/screens/pages/alerte.dart';
import 'package:todo/screens/pages/equipement.dart';
import 'package:todo/screens/pages/main_home.dart';
import 'package:todo/screens/pages/profile.dart';
import 'package:todo/utils/toast.dart';
import 'package:http/http.dart' as http;

class HomeScreen extends StatefulWidget {
  final String token;
  const HomeScreen({super.key, required this.token});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late final email;
  late final userId;
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    Map<String, dynamic> jwtToken = JwtDecoder.decode(widget.token);
    userId = jwtToken["_id"];
    email = jwtToken["email"];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home',
            style: TextStyle(color: Colors.white, fontSize: 24)),
        backgroundColor: Color.fromRGBO(209, 77, 90, 1),
        toolbarHeight: 60,
      ),
      drawer: Drawer(
          child: ListView(
        children: [
          ListTile(
            title: const Text('Phone Tickets'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => FieldTicket()),
              );
            },
          ),
          ListTile(
              title: const Text('Field Tickets'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => FieldTicket()),
                );
              }),
          ListTile(
            title: const Text('Logout'),
            onTap: () async {
              SharedPreferences prefs = await SharedPreferences.getInstance();
              await prefs
                  .remove('token'); // Clear the token from SharedPreferences
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => RegisterScreen()),
              );
            },
          )
        ],
      )),
      body: Column(
        children: [
          const SizedBox(height: 100), // space between AppBar and first row
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                onPressed: () {
                  // Action for button
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor:
                      Color.fromARGB(255, 255, 118, 118), // background color
                  minimumSize: Size(140, 120), // width and height
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20), // border radius
                  ),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.phone,
                        color: Colors.white, size: 40), // Icon added here
                    SizedBox(
                        height:
                            15), // Adjust the spacing between the icon and the label
                    Text(
                      'Phone Tickets',
                      style: TextStyle(color: Colors.white), // text color
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 20), // space between buttons
              ElevatedButton(
                onPressed: () {
                  // Action for button
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor:
                      Color.fromARGB(255, 255, 118, 118), // background color
                  minimumSize: Size(140, 120), // width and height
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20), // border radius
                  ),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.map,
                        color: Colors.white, size: 40), // Icon added here
                    SizedBox(
                        height:
                            15), // Adjust the spacing between the icon and the label
                    Text(
                      'Fields Tickets',
                      style: TextStyle(color: Colors.white), // text color
                    ),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => EquipementScreen(),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor:
                      Color.fromARGB(255, 255, 118, 118), // background color
                  minimumSize: Size(140, 120), // width and height
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20), // border radius
                  ),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.list,
                        color: Colors.white, size: 40), // Icon added here
                    SizedBox(
                        height:
                            15), // Adjust the spacing between the icon and the label
                    Text(
                      'Equipements',
                      style: TextStyle(color: Colors.white), // text color
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 20), // space between buttons
              ElevatedButton(
                onPressed: () {
                  // Action for button
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor:
                      Color.fromARGB(255, 255, 118, 118), // background color
                  minimumSize: Size(140, 120), // width and height
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20), // border radius
                  ),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.history,
                        color: Colors.white, size: 40), // Icon added here
                    SizedBox(
                        height:
                            15), // Adjust the spacing between the icon and the label
                    Text(
                      'History',
                      style: TextStyle(color: Colors.white), // text color
                    ),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => AlerteScreen(token: widget.token),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor:
                      Color.fromARGB(255, 255, 118, 118), // background color
                  minimumSize: Size(140, 120), // width and height
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20), // border radius
                  ),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.warning,
                        color: Colors.white, size: 40), // Icon added here
                    SizedBox(
                        height:
                            15), // Adjust the spacing between the icon and the label
                    Text(
                      'Warnings',
                      style: TextStyle(color: Colors.white), // text color
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 20), // space between buttons
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ProfileScreen(
                          token: widget.token,
                          email: email,
                        ),
                      ));
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor:
                      Color.fromARGB(255, 255, 118, 118), // background color
                  minimumSize: Size(140, 120), // width and height
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20), // border radius
                  ),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.person, color: Colors.white, size: 40),
                    SizedBox(height: 15),
                    Text(
                      'Profile',
                      style: TextStyle(color: Colors.white), // text color
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
