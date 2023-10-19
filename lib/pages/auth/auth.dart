// ignore_for_file: library_private_types_in_public_api

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:peakit_frontend/pages/auth/register.dart';
import 'package:peakit_frontend/pages/home/home.dart';

class AuthPage extends StatelessWidget {
  const AuthPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
      child: Column(
        children: [
          Image.asset('assets/Image.png'),
          const Padding(
            padding: EdgeInsets.only(top: 40),
            child: Column(
              children: [
                Padding(
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
                InputEmail(),
                InputPassword(),
                ForgotPassword(),
                LoginButton(),
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
  const InputEmail({super.key});

  @override
  _InputEmail createState() => _InputEmail();
}

class InputPassword extends StatefulWidget {
  const InputPassword({super.key});

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
  const LoginButton({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.only(top: 24.0),
        child: ElevatedButton(
          onPressed: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const HomePage()),
            );
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
