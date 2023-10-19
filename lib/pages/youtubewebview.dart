import 'package:flutter/material.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class YoutubePage extends StatefulWidget {
  const YoutubePage({super.key});

  @override
  State<YoutubePage> createState() => _YoutubePageState();
}

class _YoutubePageState extends State<YoutubePage> {
  YoutubePlayerController _controller =
      YoutubePlayerController(initialVideoId: 'E3oMinGUUh8');
  bool isFullScreen = false;
  @override
  void initState() {
    super.initState();
    _controller = YoutubePlayerController(
      initialVideoId: 'E3oMinGUUh8',
      flags: YoutubePlayerFlags(
        autoPlay: true,
        mute: false,
        isLive: false,
      ),
    )..addListener(() {
        if (_controller.value.isFullScreen) {
          // В полноэкранном режиме скрываем AppBar
          setState(() {
            isFullScreen = true;
          });
        } else {
          // Вернулись из полноэкранного режима, показываем AppBar
          setState(() {
            isFullScreen = false;
          });
        }
      });
  }

  @override
  void dispose() {
    _controller.dispose(); // Переносим dispose сюда
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: isFullScreen
          ? null
          : AppBar(
              title: Text(
                "Трансляция",
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
        child: YoutubePlayerBuilder(
            player: YoutubePlayer(
              controller: _controller,
            ),
            builder: (context, player) {
              return Column(
                children: [
                  // some widgets
                  player,
                  const Padding(
                    padding: EdgeInsets.only(top: 24, left: 24, right: 24),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        "Children of Asia. Sambo 2023",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ),
                  ),
                  const Padding(
                    padding: EdgeInsets.only(top: 24, left: 24, right: 24),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        "VII Международные спортивные игры 'Дети Азии'. Самбо. Отборочные соревнования, плей-офф, медальные матчи, церемония награждения.",
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: Colors.grey,
                        ),
                      ),
                    ),
                  ),
                ],
              );
            }),
      ),
    );
  }
}
