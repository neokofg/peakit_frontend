import 'package:flutter/material.dart';
import 'package:deti_azii/pages/maps/maps.dart';
import 'package:deti_azii/pages/profile/profile.dart';
import 'package:deti_azii/pages/home/home.dart';
import 'package:deti_azii/pages/scanqrcode.dart';
import 'package:deti_azii/pages/tickets/qrcode.dart';
import 'package:deti_azii/pages/webview.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class TicketsPage extends StatefulWidget {
  TicketsPage({Key? key}) : super(key: key);

  @override
  _TicketsPageState createState() => _TicketsPageState();
}

class _TicketsPageState extends State<TicketsPage> {
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

  Future<Widget> sendPostRequest() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? authToken = prefs.getString('auth_token');
    final url = Uri.https('deti-azii.ru', 'api/user/ticket');
    final response = await http.get(
      url,
      headers: {
        'Accept': 'application/json',
        'Authorization':
            'Bearer ${authToken}' // Установите заголовок Accept на application/json
      },
    );
    if (response.statusCode == 200) {
      return HaveTicket();
    } else {
      return WithoutTicket();
    }
  }

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
              Icons.location_on,
              color: Color.fromARGB(255, 212, 214, 221),
            ),
            label: 'Карты',
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.confirmation_number,
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
            _ticketWidget ??
                SizedBox(
                  height: 300,
                  child: Center(
                    child: CircularProgressIndicator(),
                  ),
                ),
            Expanded(
              child: Align(
                alignment: Alignment.bottomCenter,
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 24.0),
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => const ScanQRPage()));
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
                    child: const Text("Сканировать"),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class WithoutTicket extends StatelessWidget {
  const WithoutTicket({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 24.0),
      child: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: Image.asset("assets/notickets.png"),
          ),
          Positioned(
            bottom: 50, // Расположение кнопки снизу
            left: 48, // Расположение кнопки слева
            child: ElevatedButton(
              onPressed: () {
                Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) => QiwiWebview()));
              },
              child:
                  const Text('Купить билеты', style: TextStyle(fontSize: 12)),
            ),
          ),
        ],
      ),
    );
  }
}

class HaveTicket extends StatelessWidget {
  const HaveTicket({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 40.0, left: 24, right: 24),
          child: Image.asset("assets/ticket.png"),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 12.0),
          child: ElevatedButton(
            onPressed: () {
              Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => const QRcodePage()));
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.white,
              foregroundColor: Colors.blue,
              minimumSize: Size(MediaQuery.of(context).size.width - 48, 50),
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
    );
  }
}
