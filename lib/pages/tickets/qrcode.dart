import 'package:flutter/material.dart';

class QRcodePage extends StatelessWidget {
  const QRcodePage({super.key});

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
                child: Image.asset("assets/qrcode.png"),
              )
            ],
          ),
        ));
  }
}
