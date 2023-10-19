import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:deti_azii/pages/home/home.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:http/http.dart' as http;

class QiwiWebview extends StatefulWidget {
  const QiwiWebview({super.key});

  @override
  State<QiwiWebview> createState() => _QiwiWebviewState();
}

class _QiwiWebviewState extends State<QiwiWebview> {
  Widget? _ticketWidget;
  @override
  void initState() {
    super.initState();
    loadTicketWidget();
  }

  Future<void> loadTicketWidget() async {
    final result = await sendPostRequest();
    if (mounted) {
      setState(() {
        _ticketWidget = result;
      });
    }
  }

  String uri = " ";

  Future<WebViewWidget> sendPostRequest() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? authToken = prefs.getString('auth_token');
    final url = Uri.https('deti-azii.ru', 'api/user/buy/ticket');
    final response = await http.post(
      url,
      headers: {
        'Accept': 'application/json',
        'Authorization':
            'Bearer ${authToken}' // Установите заголовок Accept на application/json
      },
    );
    print(json.decode(response.body));
    if (response.statusCode == 200) {
      var jsonResponse = json.decode(response.body);
      uri = jsonResponse["url"];
      controller.loadRequest(Uri.parse(uri));
      return WebViewWidget(
        controller: controller,
      );
    } else {
      Fluttertoast.showToast(
        msg: "Что-то пошло не так!",
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.TOP,
        backgroundColor: Colors.red,
        textColor: Colors.white,
      );
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => const HomePage(),
        ),
      );
      return WebViewWidget(
        controller: controller,
      );
    }
  }

  @override
  void dispose() {
    // Очистите любые ресурсы, если это необходимо
    super.dispose();
  }

  var controller = WebViewController()
    ..setJavaScriptMode(JavaScriptMode.unrestricted);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Оплата",
          style: TextStyle(
            fontSize: 18,
            color: Colors.black,
            fontWeight: FontWeight.w900,
          ),
        ),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.white,
      ),
      body: SafeArea(
        child: _ticketWidget ?? Center(child: CircularProgressIndicator()),
      ),
    );
  }
}
