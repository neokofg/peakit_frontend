// ignore_for_file: library_private_types_in_public_api

import 'dart:convert';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:peakit_frontend/pages/auth/register.dart';
import 'package:peakit_frontend/pages/home/home.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class AuthPage extends StatelessWidget {
  AuthPage({super.key});
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  Future<void> sendPostRequest(BuildContext context) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? authToken = prefs.getString('auth_token');
    if (authToken != null) {
      final url = Uri.https('deti-azii.ru', 'api/user/get');
      final response = await http.get(
        url,
        headers: {
          'Accept': 'application/json',
          'Authorization':
              'Bearer ${authToken}' // Установите заголовок Accept на application/json
        },
      );

      if (response.statusCode == 200) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const HomePage()),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    sendPostRequest(context);
    return Scaffold(
        body: SafeArea(
      child: ListView(
        children: [
          Image.asset('assets/Image.png'),
          Padding(
            padding: EdgeInsets.only(top: 40),
            child: Column(
              children: [
                const Padding(
                  padding: EdgeInsets.only(left: 24, bottom: 8),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      "Добро пожаловать",
                      textAlign: TextAlign.left,
                      style:
                          TextStyle(fontWeight: FontWeight.w800, fontSize: 24),
                    ),
                  ),
                ),
                InputEmail(emailController: emailController),
                InputPassword(passwordController: passwordController),
                ForgotPassword(),
                LoginButton(
                    emailController: emailController,
                    passwordController: passwordController),
                RegisterLink()
              ],
            ),
          )
        ],
      ),
    ));
  }
}

class InputEmail extends StatefulWidget {
  final TextEditingController emailController;
  const InputEmail({super.key, required this.emailController});
  @override
  _InputEmail createState() => _InputEmail();
}

class InputPassword extends StatefulWidget {
  final TextEditingController passwordController;
  const InputPassword({super.key, required this.passwordController});

  @override
  _InputPassword createState() => _InputPassword();
}

class _InputEmail extends State<InputEmail> {
  final TextEditingController _textEditingController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.only(top: 16, left: 24, right: 24),
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

class _InputPassword extends State<InputPassword> {
  final TextEditingController _textEditingController = TextEditingController();
  bool _passwordVisible = false;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.only(top: 16, left: 24, right: 24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              obscureText: !_passwordVisible,
              enableSuggestions: false,
              autocorrect: false,
              onChanged: (value) {
                widget.passwordController.text = value;
              },
              controller: _textEditingController,
              decoration: InputDecoration(
                labelText: 'Пароль',
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

class ForgotPassword extends StatelessWidget {
  const ForgotPassword({super.key});

  @override
  Widget build(BuildContext context) {
    return const Padding(
        padding: EdgeInsets.only(top: 16, left: 24),
        child: Align(
          alignment: Alignment.centerLeft,
          child: Text(
            'Забыли пароль?',
            style: TextStyle(
              color: Colors.blue,
              decoration: TextDecoration.underline,
            ),
          ),
        ));
  }
}

class LoginButton extends StatelessWidget {
  const LoginButton(
      {super.key,
      required this.emailController,
      required this.passwordController});
  final TextEditingController emailController;
  final TextEditingController passwordController;
  Future<void> sendPostRequest(BuildContext context) async {
    final url = Uri.https('deti-azii.ru', 'api/auth/login');
    final response = await http.post(
      url,
      headers: {
        'Accept':
            'application/json', // Установите заголовок Accept на application/json
      },
      body: {
        'email': emailController.text,
        'password': passwordController.text
      },
    );

    if (response.statusCode == 200) {
      var jsonResponse = json.decode(response.body);
      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setString('auth_token', "${jsonResponse['token']}");
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
    return Center(
      child: Padding(
        padding: const EdgeInsets.only(top: 24.0),
        child: ElevatedButton(
          onPressed: () {
            sendPostRequest(context);
          },
          style: ButtonStyle(
              minimumSize: MaterialStateProperty.all(const Size(345, 50))),
          child: const Text('Войти'),
        ),
      ),
    );
  }
}

class RegisterLink extends StatelessWidget {
  const RegisterLink({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Другие элементы интерфейса, такие как текстовые поля для ввода логина и пароля.

            RichText(
              text: TextSpan(
                text: 'Еще нет аккаунта? ',
                style: DefaultTextStyle.of(context).style,
                children: <TextSpan>[
                  TextSpan(
                    text: 'Регистрация',
                    style: const TextStyle(
                      color: Colors.blue,
                      decoration: TextDecoration.underline,
                    ),
                    recognizer: TapGestureRecognizer()
                      ..onTap = () {
                        // Действия, выполняемые при нажатии на "Регистрация".
                        // Например, переход на страницу регистрации.
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => RegisterPage()),
                        );
                      },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
