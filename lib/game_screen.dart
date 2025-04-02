import 'package:flutter/material.dart';
import 'package:flame/game.dart';
import 'package:video_player/video_player.dart';
import 'minigame.dart';

class GameScreen extends StatefulWidget {
  @override
  _GameScreenState createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  late VideoPlayerController _controller;
  int _counter = 0;
  final int _goal = 100;
  bool _gameOver = false;
  bool _miniGameActive = false;

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.network(
      'https://assets.mixkit.co/videos/5399/5399-720.mp4',
    )..initialize().then((_) {
      setState(() {});
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _incrementCounter() {
    setState(() {
      _counter++;
      if (_counter == 70) {
        _miniGameActive = true;
      }
      if (_counter >= _goal) {
        _gameOver = true;
        _controller.play(); // Запускаем видео при победе
      }
    });
  }

  void _resetGame() {
    setState(() {
      _counter = 0;
      _gameOver = false;
      _miniGameActive = false;
      _controller.pause();
      _controller.seekTo(Duration.zero);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.blue, Colors.green],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                if (_miniGameActive)
                  SizedBox(
                    height: 300,
                    child: GameWidget(game: MiniGame()),
                  ),
                if (_gameOver)
                  Column(
                    children: [
                      const Text(
                        'Поздравляю! Ты победил! 🎉',
                        style: TextStyle(fontSize: 24, color: Colors.white, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 20),
                      _controller.value.isInitialized
                          ? AspectRatio(
                        aspectRatio: _controller.value.aspectRatio,
                        child: VideoPlayer(_controller),
                      )
                          : const CircularProgressIndicator(),
                      const SizedBox(height: 20),
                      ElevatedButton(
                        onPressed: _resetGame,
                        child: const Text('Играть снова'),
                      ),
                    ],
                  )
                else ...[
                  const Text(
                    'Набери 100 очков чтобы выиграть!',
                    style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    '$_counter',
                    style: Theme.of(context).textTheme.displayLarge?.copyWith(
                      color: Colors.white,
                      shadows: [
                        const Shadow(
                          blurRadius: 4.0,
                          color: Colors.black,
                          offset: Offset(2.0, 2.0),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                  FloatingActionButton(
                    onPressed: _incrementCounter,
                    backgroundColor: Colors.blue,
                    child: const Icon(Icons.add, size: 36, color: Colors.white),
                  ),
                ]
              ],
            ),
          ),
        ),
      ),
    );
  }
}
