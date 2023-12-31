// ignore_for_file: library_private_types_in_public_api

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:fluttertoast/fluttertoast.dart';
import 'package:deti_azii/pages/auth/confirm_email.dart';
import 'dart:convert';

class RegisterPage extends StatelessWidget {
  RegisterPage({super.key});
  final TextEditingController emailController = TextEditingController();

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
                    "Регистрация",
                    textAlign: TextAlign.left,
                    style: TextStyle(fontWeight: FontWeight.w800, fontSize: 30),
                  ),
                ),
              ),
              const Padding(
                padding: EdgeInsets.only(left: 24, top: 24),
                child: Text(
                  "Введите электронную почту, чтобы получить код подтверждения",
                  style: TextStyle(color: Color.fromARGB(255, 113, 114, 122)),
                ),
              ),
              InputEmail(emailController: emailController),
              Expanded(
                child: SendButton(emailController: emailController),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class InputEmail extends StatefulWidget {
  final TextEditingController emailController;
  const InputEmail({super.key, required this.emailController});
  @override
  _InputEmail createState() => _InputEmail();
}

class _InputEmail extends State<InputEmail> {
  late TextEditingController _textEditingController;

  @override
  void initState() {
    super.initState();
    // Initialize _textEditingController using widget.emailController.text
    _textEditingController =
        TextEditingController(text: widget.emailController.text);
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
              controller: _textEditingController,
              onChanged: (value) {
                widget.emailController.text = value;
              },
              decoration: const InputDecoration(
                labelText: 'Email адрес',
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
  final TextEditingController emailController;

  const SendButton({super.key, required this.emailController});
  Future<void> sendPostRequest(BuildContext context) async {
    final url = Uri.https('deti-azii.ru', 'api/auth/register');
    final response = await http.post(
      url,
      headers: {
        'Accept':
            'application/json', // Установите заголовок Accept на application/json
      },
      body: {'email': emailController.text},
    );
    print(emailController);
    if (response.statusCode == 200) {
      // Request was successful, handle the response here.
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => ConfirmEmailPage()),
      );
    } else {
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
          child: const Text('Получить код'),
        ),
      ),
    );
  }
}
