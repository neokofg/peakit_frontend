// ignore_for_file: library_private_types_in_public_api

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:peakit_frontend/pages/home/home.dart';
import 'package:shared_preferences/shared_preferences.dart';

class RegisterFinishPage extends StatelessWidget {
  RegisterFinishPage({super.key});
  final TextEditingController nameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

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
                    "Добро пожаловать",
                    textAlign: TextAlign.left,
                    style: TextStyle(
                        fontWeight: FontWeight.w900,
                        fontSize: 30,
                        fontFamily: "Inter"),
                  ),
                ),
              ),
              Column(
                children: [
                  const Align(
                    alignment: Alignment.centerLeft,
                    child: Padding(
                      padding: EdgeInsets.only(top: 24, bottom: 8, left: 24),
                      child: Text("Имя профиля",
                          style: TextStyle(
                              fontWeight: FontWeight.w600, fontSize: 15)),
                    ),
                  ),
                  InputName(nameController: nameController),
                ],
              ),
              Column(
                children: [
                  const Align(
                    alignment: Alignment.centerLeft,
                    child: Padding(
                      padding: EdgeInsets.only(top: 24, bottom: 8, left: 24),
                      child: Text("Придумайте пароль",
                          style: TextStyle(
                              fontWeight: FontWeight.w600, fontSize: 15)),
                    ),
                  ),
                  InputPassword(passwordController: passwordController),
                ],
              ),
              Expanded(
                child: SendButton(
                    nameController: nameController,
                    passwordController: passwordController),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class InputName extends StatefulWidget {
  final TextEditingController nameController;
  const InputName({super.key, required this.nameController});
  @override
  _InputName createState() => _InputName();
}

class _InputName extends State<InputName> {
  late TextEditingController _textEditingController;

  @override
  void initState() {
    super.initState();
    // Initialize _textEditingController using widget.emailController.text
    _textEditingController =
        TextEditingController(text: widget.nameController.text);
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.only(left: 24, right: 24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: _textEditingController,
              onChanged: (value) {
                widget.nameController.text = value;
              },
              decoration: const InputDecoration(
                labelText: 'Никнейм',
                border: OutlineInputBorder(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class InputPassword extends StatefulWidget {
  final TextEditingController passwordController;
  const InputPassword({super.key, required this.passwordController});
  @override
  _InputPassword createState() => _InputPassword();
}

class _InputPassword extends State<InputPassword> {
  late TextEditingController _textEditingController;
  bool _passwordVisible = false;

  @override
  void initState() {
    super.initState();
    // Initialize _textEditingController using widget.emailController.text
    _textEditingController =
        TextEditingController(text: widget.passwordController.text);
    _passwordVisible = false;
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.only(left: 24, right: 24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              obscureText: !_passwordVisible,
              enableSuggestions: false,
              autocorrect: false,
              controller: _textEditingController,
              onChanged: (value) {
                widget.passwordController.text = value;
              },
              decoration: InputDecoration(
                labelText: 'Новый пароль',
                border: const OutlineInputBorder(),
                suffixIcon: IconButton(
                  icon: Icon(
                    _passwordVisible ? Icons.visibility : Icons.visibility_off,
                    color: const Color.fromARGB(255, 143, 144, 152),
                  ),
                  onPressed: () {
                    setState(() {
                      _passwordVisible = !_passwordVisible;
                    });
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class SendButton extends StatelessWidget {
  final TextEditingController nameController;
  final TextEditingController passwordController;

  const SendButton(
      {super.key,
      required this.nameController,
      required this.passwordController});
  Future<void> sendPostRequest(BuildContext context) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? authToken = prefs.getString('auth_token');
    final url = Uri.https('deti-azii.ru', 'api/auth/register/update');
    final response = await http.post(
      url,
      headers: {
        'Accept': 'application/json',
        'Authorization':
            'Bearer ${authToken}' // Установите заголовок Accept на application/json
      },
      body: {'name': nameController.text, 'password': passwordController.text},
    );

    if (response.statusCode == 200) {
      // Request was successful, handle the response here.
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const HomePage()),
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
          onPressed: () {
            sendPostRequest(context);
          },
          style: ButtonStyle(
              minimumSize: MaterialStateProperty.all(const Size(345, 50))),
          child: const Text('Подтвердить'),
        ),
      ),
    );
  }
}
