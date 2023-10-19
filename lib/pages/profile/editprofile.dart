// ignore_for_file: library_private_types_in_public_api

import 'dart:convert';

import 'package:deti_azii/pages/profile/profile.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class EditProfilePage extends StatelessWidget {
  EditProfilePage({super.key});
  final TextEditingController nameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
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
          "Редактировать профиль",
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
              child: UpdateButton(
                  nameController: nameController,
                  passwordController: passwordController),
            ),
          ],
        ),
      ),
    );
  }
}

class UpdateButton extends StatelessWidget {
  final TextEditingController nameController;
  final TextEditingController passwordController;

  const UpdateButton(
      {super.key,
      required this.nameController,
      required this.passwordController});

  Future<void> sendPostRequest(BuildContext context) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? authToken = prefs.getString('auth_token');
    final url = Uri.https('deti-azii.ru', 'api/user/update');

    Map<String, String> requestBody = {
      if (nameController.text.isNotEmpty) 'name': nameController.text,
      if (passwordController.text.isNotEmpty)
        'password': passwordController.text,
    };

    final response = await http.post(
      url,
      headers: {
        'Accept': 'application/json',
        'Authorization':
            'Bearer ${authToken}' // Установите заголовок Accept на application/json
      },
      body: requestBody,
    );

    if (response.statusCode == 200) {
      var jsonResponse = json.decode(response.body);
      Fluttertoast.showToast(
        msg: "${jsonResponse['message']}",
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.TOP,
        backgroundColor: Colors.green,
        textColor: Colors.white,
      );
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const ProfilePage()),
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
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.blue,
            foregroundColor: Colors.white,
            minimumSize: Size(MediaQuery.of(context).size.width - 48, 50),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
              side: const BorderSide(
                color: Colors.blue,
                width: 1.0,
              ),
            ),
          ),
          child: const Text("Готово"),
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
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(12))),
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
