import 'package:flutter/material.dart';
import 'package:peakit_frontend/pages/maps/maps.dart';
import 'package:peakit_frontend/pages/profile/profile.dart';
import 'package:peakit_frontend/pages/home/home.dart';
import 'package:peakit_frontend/pages/tickets/qrcode.dart';

class TicketsPage extends StatelessWidget {
  const TicketsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          toolbarHeight: 67,
          leadingWidth: 12,
          elevation: 0,
          title: const Text(
            "Билеты",
            style: TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.w900,
              fontSize: 18,
            ),
          ),
          backgroundColor: Colors.white,
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
              Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => const TicketsPage()));
            } else if (index == 3) {
              Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => const ProfilePage()));
            }
          },
          currentIndex: 2,
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
                Icons.search,
                color: Color.fromARGB(255, 212, 214, 221),
              ),
              label: 'Карты',
            ),
            BottomNavigationBarItem(
              icon: Icon(
                Icons.person,
                color: Color.fromARGB(255, 0, 111, 253),
              ),
              label: 'Билеты',
            ),
            BottomNavigationBarItem(
              icon: Icon(
                Icons.person,
                color: Color.fromARGB(255, 212, 214, 221),
              ),
              label: 'Профиль',
            ),
          ],
        ),
        body: SafeArea(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 40.0, left: 24, right: 24),
                child: Image.asset("assets/ticket.png"),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 12.0),
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => const QRcodePage()));
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
                  child: const Text("Предъявить билет"),
                ),
              ),
            ],
          ),
        ));
  }
}
