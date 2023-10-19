// ignore_for_file: library_private_types_in_public_api

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:deti_azii/pages/auth/register_finish.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ConfirmEmailPage extends StatelessWidget {
  ConfirmEmailPage({super.key});
  final TextEditingController codeController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.only(top: 150),
          child: Column(
            children: [
              const Padding(
                padding: EdgeInsets.only(left: 24),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    "Подтвердите электронную почту",
                    textAlign: TextAlign.left,
                    style: TextStyle(
                        fontWeight: FontWeight.w900,
                        fontSize: 30,
                        fontFamily: "Inter"),
                  ),
                ),
              ),
              const Padding(
                padding: EdgeInsets.only(left: 24, top: 24),
                child: Text(
                  "Ha вашу почту отправлено письмо с кодом. Введите его здесь:",
                  style: TextStyle(color: Color.fromARGB(255, 113, 114, 122)),
                ),
              ),
              InputCode(codeController: codeController),
              Expanded(
                child: SendButton(codeController: codeController),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class InputCode extends StatefulWidget {
  final TextEditingController codeController;
  const InputCode({super.key, required this.codeController});
  @override
  _InputCode createState() => _InputCode();
}

class _InputCode extends State<InputCode> {
  late TextEditingController _textEditingController;

  @override
  void initState() {
    super.initState();
    // Initialize _textEditingController using widget.emailController.text
    _textEditingController =
        TextEditingController(text: widget.codeController.text);
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.only(top: 24, left: 24, right: 24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              keyboardType: TextInputType.number,
              maxLength: 4,
              controller: _textEditingController,
              onChanged: (value) {
                widget.codeController.text = value;
              },
              decoration: const InputDecoration(
                labelText: 'Код подтверждения',
                border: OutlineInputBorder(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class SendButton extends StatelessWidget {
  final TextEditingController codeController;

  const SendButton({super.key, required this.codeController});
  Future<void> sendPostRequest(BuildContext context) async {
    final url = Uri.https('deti-azii.ru', 'api/auth/register/approve');
    final response = await http.post(
      url,
      headers: {
        'Accept':
            'application/json', // Установите заголовок Accept на application/json
      },
      body: {'code': codeController.text},
    );

    if (response.statusCode == 200) {
      var jsonResponse = json.decode(response.body);
      // Request was successful, handle the response here.
      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setString('auth_token', "${jsonResponse['token']}");
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => RegisterFinishPage()),
      );
    } else {
      // Request failed, handle errors here.
      var jsonResponse = json.decode(response.body);
      Fluttertoast.showToast(
        msg: "${jsonResponse['message']}",
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.TOP,
        backgroundColor: Colors.red,
        textColor: Colors.white,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.bottomCenter,
      child: Padding(
        padding: const EdgeInsets.only(bottom: 24.0),
        child: ElevatedButton(
          onPressed: () async {
            await sendPostRequest(context);
          },
          style: ButtonStyle(
              minimumSize: MaterialStateProperty.all(const Size(345, 50))),
          child: const Text('Подтвердить'),
        ),
      ),
    );
  }
}
