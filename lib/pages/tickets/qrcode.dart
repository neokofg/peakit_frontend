import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:peakit_frontend/pages/tickets/tickets.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class QRcodePage extends StatefulWidget {
  const QRcodePage({super.key});

  @override
  State<QRcodePage> createState() => QRcodePageState();
}

class QRcodePageState extends State<QRcodePage> {
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

  Future<Image> sendPostRequest() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? authToken = prefs.getString('auth_token');
    final url = Uri.https('deti-azii.ru', 'api/user/ticket/qr');
    final response = await http.get(
      url,
      headers: {
        'Accept': 'application/json',
        'Authorization':
            'Bearer ${authToken}' // Установите заголовок Accept на application/json
      },
    );

    if (response.statusCode == 200) {
      var jsonResponse = json.decode(response.body);
      Uint8List uint8List =
          Uint8List.fromList(base64.decode(jsonResponse['qr']));
      Image image = Image.memory(uint8List);
      return image;
    } else {
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => TicketsPage(),
        ),
      );
      return Image.asset("assets/qrcode.png");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          toolbarHeight: 67,
          leadingWidth: 50,
          elevation: 0,
          leading: Container(
            padding: const EdgeInsets.only(left: 12),
            child: IconButton(
              icon: const Icon(Icons.arrow_back,
                  color: Colors.blue), // Установите иконку "назад" здесь
              onPressed: () {
                Navigator.of(context)
                    .pop(); // Это закроет текущий экран и вернется назад
              },
            ),
          ),
          title: const Text(
            "Билет",
            style: TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.w900,
              fontSize: 18,
            ),
          ),
          backgroundColor: Colors.white,
        ),
        body: SafeArea(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 40.0, left: 24, right: 24),
                child:
                    _ticketWidget ?? Center(child: CircularProgressIndicator()),
              )
            ],
          ),
        ));
  }
}
