import 'package:flutter/material.dart';
import 'package:peakit_frontend/pages/home/languages.dart';
import 'package:peakit_frontend/pages/maps/maps.dart';
import 'package:peakit_frontend/pages/profile/profile.dart';
import 'package:peakit_frontend/pages/results/results.dart';
import 'package:peakit_frontend/pages/tickets/qrcode.dart';
import 'package:peakit_frontend/pages/tickets/tickets.dart';
import 'package:peakit_frontend/pages/webview.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
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
    double appBarHeight = 67.0;
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(appBarHeight),
        child: AppBar(
          leading: Container(
            margin: const EdgeInsets.only(left: 24), // Отступ слева
            child: Image.asset(
              'assets/logo.png',
              width: 132,
              height: 34,
            ),
          ),
          leadingWidth: 160,
          backgroundColor: Colors.white,
          automaticallyImplyLeading: false,
          toolbarHeight: appBarHeight, // Устанавливаем высоту Toolbar
          actions: [
            Container(
              width: 160,
              padding: const EdgeInsets.only(top: 10, bottom: 10, right: 24),
              child: ElevatedButton.icon(
                onPressed: () {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => const LanguagesPage()));
                },
                icon: const Icon(Icons.language),
                label: const Text('Language'),
                style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.blue,
                  backgroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                    side: const BorderSide(
                      color: Colors.blue,
                      width: 2.0,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        onTap: (int index) {
          if (index == 0) {
          } else if (index == 1) {
            Navigator.of(context).push(
                MaterialPageRoute(builder: (context) => const MapsPage()));
          } else if (index == 2) {
            Navigator.of(context)
                .push(MaterialPageRoute(builder: (context) => TicketsPage()));
          } else if (index == 3) {
            Navigator.of(context).push(
                MaterialPageRoute(builder: (context) => const ProfilePage()));
          }
        },
        unselectedItemColor: const Color.fromARGB(255, 113, 114, 122),
        selectedItemColor: Colors.black,
        showUnselectedLabels: true,
        showSelectedLabels: true,
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(
              Icons.home,
              color: Color.fromARGB(255, 0, 111, 253),
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
        child: ListView(
          children: [
            _ticketWidget ??
                SizedBox(
                  height: 221,
                  child: Center(child: CircularProgressIndicator()),
                ),
            Padding(
              padding: const EdgeInsets.only(top: 24, left: 24, right: 24),
              child: Column(
                children: [
                  Row(
                    children: [
                      SizedBox(
                        width: 164,
                        height: 164,
                        child: GestureDetector(
                          onTap: () {
                            // Действие при нажатии на изображение
                          },
                          child: Image.asset('assets/cameratranslation.png'),
                        ),
                      ),
                      Container(
                        width: 164,
                        height: 164,
                        margin: const EdgeInsets.only(left: 15),
                        child: GestureDetector(
                          onTap: () {
                            Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) => const ResultsPage()));
                          },
                          child: Image.asset('assets/documentresults.png'),
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Container(
                        width: 164,
                        height: 164,
                        margin: const EdgeInsets.only(top: 15),
                        child: GestureDetector(
                          onTap: () {
                            Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) => const QiwiWebview()));
                          },
                          child: Image.asset('assets/ticketsbuy.png'),
                        ),
                      ),
                      Container(
                        width: 164,
                        height: 164,
                        margin: const EdgeInsets.only(left: 15, top: 15),
                        child: GestureDetector(
                          onTap: () {
                            Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) => const MapsPage()));
                          },
                          child: Image.asset('assets/openmap.png'),
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 24, left: 24, right: 24),
              child: Column(
                children: [
                  Container(
                    alignment: Alignment.centerLeft,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const Text(
                          "Смотреть трансляцию",
                          style: TextStyle(
                            fontWeight: FontWeight.w900,
                            fontSize: 18,
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            // Действие при нажатии на изображение
                          },
                          child: const Text(
                            'Перейти',
                            style: TextStyle(
                                color: Colors.blue,
                                fontWeight: FontWeight.w600,
                                fontSize: 14),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.only(top: 24),
                    child: GestureDetector(
                      onTap: () {
                        // Действие при нажатии на изображение
                      },
                      child: Image.asset("assets/preview.png"),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 24, left: 24, right: 24),
              child: Column(
                children: [
                  const Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      "Партнеры",
                      style: TextStyle(
                        fontWeight: FontWeight.w900,
                        fontSize: 18,
                      ),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.only(top: 24),
                    child: Image.asset(
                      "assets/partners.png",
                    ),
                  ),
                  const SizedBox(
                    height: 40,
                  )
                ],
              ),
            )
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
