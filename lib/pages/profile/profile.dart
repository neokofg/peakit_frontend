import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:deti_azii/pages/auth/auth.dart';
import 'package:deti_azii/pages/profile/editprofile.dart';
import 'package:deti_azii/pages/maps/maps.dart';
import 'package:deti_azii/pages/tickets/tickets.dart';
import 'package:deti_azii/pages/home/home.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  Widget? _ticketWidget;
  @override
  void initState() {
    super.initState();
    loadTicketWidget();
  }

  Future<void> loadTicketWidget() async {
    final result = await sendPostRequest();
    setState(() {
      _ticketWidget = result;
    });
  }

  Future<void> logout(BuildContext context) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove('auth_token');
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => AuthPage()),
    );
  }

  Future<Widget> sendPostRequest() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? authToken = prefs.getString('auth_token');
    final url = Uri.https('deti-azii.ru', 'api/user/get');
    final response = await http.get(
      url,
      headers: {
        'Accept': 'application/json',
        'Authorization':
            'Bearer ${authToken}' // Установите заголовок Accept на application/json
      },
    );
    var jsonResponse = json.decode(response.body);
    String id = jsonResponse['user'][0]['id'];
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 10.0),
          child: Image.asset(
            "assets/avatar.png",
            width: 80,
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 16.0),
          child: GestureDetector(
            child: const Text(
              "Добавить фото",
              style: TextStyle(
                color: Colors.blue,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),
        Padding(
          padding: EdgeInsets.only(top: 16.0),
          child: Text(
            jsonResponse['user'][0]['name'],
            style: TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.w900,
              fontSize: 18,
            ),
          ),
        ),
        Container(
          height: 30,
          margin: const EdgeInsets.only(top: 4, left: 24, right: 24),
          decoration: BoxDecoration(
            borderRadius:
                BorderRadius.circular(12), // Здесь задается радиус закругления
            color: const Color.fromARGB(255, 234, 242, 255), // Цвет фона
            border: Border.all(
              color: const Color.fromARGB(255, 234, 242, 255), // Цвет границы
              width: 2, // Толщина границы
            ),
          ),
          child: Center(
              child: Text(
            "ID: $id",
            style: TextStyle(
              color: Color.fromARGB(255, 0, 111, 253),
            ),
          )),
        ),
        Container(
          margin: const EdgeInsets.only(top: 24),
          width: MediaQuery.of(context).size.width - 48,
          height: 70,
          child: ElevatedButton(
            onPressed: () {},
            style: ElevatedButton.styleFrom(
              alignment: Alignment.centerLeft,
              backgroundColor: const Color.fromARGB(255, 234, 242, 255),
              foregroundColor: const Color.fromARGB(255, 31, 32, 36),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Электронная почта",
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Text(
                      jsonResponse['user'][0]['email'],
                      style: TextStyle(
                        color: Colors.grey,
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 45,
                  child: ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color.fromARGB(255, 234, 242, 255),
                      foregroundColor: Colors.blue,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                        side: const BorderSide(
                          color: Colors.blue,
                          width: 1.0,
                        ),
                      ),
                    ),
                    child: const Text(
                      "изменить",
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        toolbarHeight: 67,
        leadingWidth: 0,
        automaticallyImplyLeading: false,
        title: const Text(
          "Профиль",
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.w800,
            fontSize: 16,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      bottomNavigationBar: BottomNavigationBar(
        onTap: (int index) {
          if (index == 0) {
            Navigator.of(context).push(
                MaterialPageRoute(builder: (context) => const HomePage()));
          } else if (index == 1) {
            Navigator.of(context).push(
                MaterialPageRoute(builder: (context) => const MapsPage()));
          } else if (index == 2) {
            Navigator.of(context)
                .push(MaterialPageRoute(builder: (context) => TicketsPage()));
          } else if (index == 3) {}
        },
        currentIndex: 3,
        unselectedItemColor: const Color.fromARGB(255, 113, 114, 122),
        selectedItemColor: Colors.black,
        showUnselectedLabels: true,
        showSelectedLabels: true,
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(
              Icons.home,
              color: Color.fromARGB(255, 212, 214, 221),
            ),
            label: 'Главная',
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.location_on,
              color: Color.fromARGB(255, 212, 214, 221),
            ),
            label: 'Карты',
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.confirmation_number,
              color: Color.fromARGB(255, 212, 214, 221),
            ),
            label: 'Билеты',
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.person,
              color: Color.fromARGB(255, 0, 111, 253),
            ),
            label: 'Профиль',
          ),
        ],
      ),
      body: SafeArea(
        child: Center(
          child: Column(
            children: [
              SizedBox(
                height: 400,
                child: _ticketWidget ??
                    Center(
                      child: CircularProgressIndicator(),
                    ),
              ),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => EditProfilePage()));
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue,
                        foregroundColor: Colors.white,
                        minimumSize:
                            Size(MediaQuery.of(context).size.width - 48, 50),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                          side: const BorderSide(
                            color: Colors.blue,
                            width: 1.0,
                          ),
                        ),
                      ),
                      child: const Text("Редактировать"),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 24, top: 14),
                      child: ElevatedButton(
                        onPressed: () {
                          logout(context);
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          foregroundColor: Colors.blue,
                          minimumSize:
                              Size(MediaQuery.of(context).size.width - 48, 50),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                            side: const BorderSide(
                              color: Colors.blue,
                              width: 1.0,
                            ),
                          ),
                        ),
                        child: const Text("Выйти"),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
