import 'package:flutter/material.dart';
import 'package:latlong2/latlong.dart';
import 'package:deti_azii/pages/profile/profile.dart';
import 'package:deti_azii/pages/home/home.dart';
import 'package:deti_azii/pages/tickets/tickets.dart';
import 'package:flutter_map/flutter_map.dart';

class MapsPage extends StatelessWidget {
  const MapsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 67,
        leadingWidth: 0,
        automaticallyImplyLeading: false,
        title: const Text(
          "Карта",
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
          } else if (index == 2) {
            Navigator.of(context)
                .push(MaterialPageRoute(builder: (context) => TicketsPage()));
          } else if (index == 3) {
            Navigator.of(context).push(
                MaterialPageRoute(builder: (context) => const ProfilePage()));
          }
        },
        currentIndex: 1,
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
              color: Color.fromARGB(255, 0, 111, 253),
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
              color: Color.fromARGB(255, 212, 214, 221),
            ),
            label: 'Профиль',
          ),
        ],
      ),
      body: SafeArea(
          child: FlutterMap(
        options: const MapOptions(
          initialCenter: LatLng(62.034278, 129.713928),
          initialZoom: 16.5,
        ),
        children: [
          TileLayer(
            urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
            userAgentPackageName: 'com.example.app',
          ),
          const MarkerLayer(
            markers: [
              Marker(
                point: LatLng(62.034456, 129.715796),
                child: Column(
                  children: [
                    Icon(Icons.door_front_door),
                    Text(
                      "Entrance",
                      style: TextStyle(fontSize: 5.5),
                    )
                  ],
                ),
              ),
              Marker(
                point: LatLng(62.034954, 129.714150),
                child: Column(
                  children: [
                    Icon(Icons.wc),
                    Text(
                      "WC",
                      style: TextStyle(fontSize: 5.5),
                    )
                  ],
                ),
              ),
              Marker(
                point: LatLng(62.033688, 129.713608),
                child: Column(
                  children: [
                    Icon(Icons.fastfood),
                    Text(
                      "Foodcoart",
                      style: TextStyle(fontSize: 5.5),
                    )
                  ],
                ),
              ),
              Marker(
                point: LatLng(62.035574, 129.715667),
                child: Column(
                  children: [
                    Icon(Icons.fastfood),
                    Text(
                      "Foodcoart",
                      style: TextStyle(fontSize: 5.5),
                    )
                  ],
                ),
              ),
            ],
          )
        ],
      )),
    );
  }
}
