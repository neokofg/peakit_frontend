import 'package:flutter/material.dart';
import 'package:deti_azii/pages/youtubewebview.dart';

class TranslationsPage extends StatelessWidget {
  const TranslationsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 67,
        leadingWidth: 50,
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
          "Смотреть трансляцию",
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
              padding: const EdgeInsets.only(top: 24, left: 24, right: 24),
              child: GestureDetector(
                onTap: () {
                  Navigator.of(context).push(
                      MaterialPageRoute(builder: (context) => YoutubePage()));
                },
                child: Image.asset("assets/preview.png"),
              ),
            )
          ],
        ),
      ),
    );
  }
}
