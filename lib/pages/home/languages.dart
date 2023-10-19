import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class LanguagesPage extends StatelessWidget {
  const LanguagesPage({super.key});

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
            "Выбор языка",
            style: TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.w900,
              fontSize: 18,
            ),
          ),
          backgroundColor: Colors.white,
        ),
        body: const SafeArea(
          child: Column(
            children: [
              Padding(
                padding: EdgeInsets.only(top: 24, left: 24, right: 24),
                child: Column(
                  children: [
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        "Языки",
                        style: TextStyle(
                            fontWeight: FontWeight.w900, fontSize: 26),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: 16.0),
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          "Выберите свой язык",
                          style: TextStyle(
                            fontWeight: FontWeight.w400,
                            fontSize: 16,
                            color: Colors.grey,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.only(top: 28, left: 24, right: 24),
                child: Column(
                  children: [
                    Language(
                      name: "Русский",
                      icon: "russia.svg",
                    ),
                    NotPickedLanguage(
                      name: "中文",
                      icon: "china.svg",
                    ),
                    NotPickedLanguage(
                      name: "English",
                      icon: "england.svg",
                    ),
                  ],
                ),
              )
            ],
          ),
        ));
  }
}

class NotPickedLanguage extends StatelessWidget {
  const NotPickedLanguage({
    super.key,
    required this.name,
    required this.icon,
  });
  final String name;
  final String icon;
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 8),
      width: MediaQuery.of(context).size.width,
      height: 60,
      child: ElevatedButton(
        onPressed: () {},
        style: ElevatedButton.styleFrom(
          alignment: Alignment.centerLeft,
          backgroundColor: Colors.white,
          foregroundColor: const Color.fromARGB(255, 31, 32, 36),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                SvgPicture.asset(
                  'assets/$icon',
                  width: 24,
                  height: 24,
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 16.0),
                  child: Text(name),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class Language extends StatelessWidget {
  const Language({
    super.key,
    required this.name,
    required this.icon,
  });
  final String name;
  final String icon;
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 8),
      width: MediaQuery.of(context).size.width,
      height: 60,
      child: ElevatedButton(
        onPressed: () {},
        style: ElevatedButton.styleFrom(
          alignment: Alignment.centerLeft,
          backgroundColor: const Color.fromARGB(255, 234, 242, 255),
          foregroundColor: const Color.fromARGB(255, 31, 32, 36),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                SvgPicture.asset(
                  'assets/$icon',
                  width: 24,
                  height: 24,
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 16.0),
                  child: Text(name),
                ),
              ],
            ),
            const Padding(
              padding: EdgeInsets.only(right: 16.0),
              child: Icon(
                Icons.check, // Иконка галочки
                color: Colors.blue, // Цвет галочки
              ),
            ),
          ],
        ),
      ),
    );
  }
}
