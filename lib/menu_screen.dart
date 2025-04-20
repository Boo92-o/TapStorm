import 'package:flutter/material.dart';
import 'game_screen.dart';
import 'main.dart';

import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';

import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';

class MenuScreen extends StatefulWidget {
  const MenuScreen({super.key});

  @override
  State<MenuScreen> createState() => _MenuScreenState();
}

class _MenuScreenState extends State<MenuScreen> {
  late AudioPlayer _audioPlayer;
  bool _isPlaying = false;
  double _volume = 0.5; // Начальная громкость 50%

  @override
  void initState() {
    super.initState();
    _audioPlayer = AudioPlayer();
    _playMusic();
  }

  Future<void> _playMusic() async {
    try {
      await _audioPlayer.setVolume(_volume); // Устанавливаем громкость
      await _audioPlayer.play(AssetSource('sound/pixel-playground.mp3'));
      setState(() {
        _isPlaying = true;
      });
      // Установка циклического воспроизведения
      _audioPlayer.onPlayerComplete.listen((_) {
        _audioPlayer.play(AssetSource('sound/pixel-playground.mp3'));
      });
    } catch (e) {
      debugPrint('Ошибка при воспроизведении музыки: $e');
    }
  }

  Future<void> _stopMusic() async {
    try {
      await _audioPlayer.stop();
      setState(() {
        _isPlaying = false;
      });
    } catch (e) {
      debugPrint('Ошибка при остановке музыки: $e');
    }
  }

  Future<void> _setVolume(double volume) async {
    try {
      await _audioPlayer.setVolume(volume);
      setState(() {
        _volume = volume;
      });
    } catch (e) {
      debugPrint('Ошибка при изменении громкости: $e');
    }
  }

  @override
  void dispose() {
    _audioPlayer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.blue, Colors.green],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    'Добро пожаловать в игру!',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => GameScreen()),
                      );
                    },
                    child: const Text('Начать игру'),
                  ),
                ],
              ),
            ),
          ),
          // Кнопка управления музыкой в левом верхнем углу
          Positioned(
            top: 40,
            left: 20,
            child: Row(
              children: [
                IconButton(
                  icon: Icon(
                    _isPlaying ? Icons.music_note : Icons.music_off,
                    color: Colors.white,
                    size: 30,
                  ),
                  onPressed: () {
                    if (_isPlaying) {
                      _stopMusic();
                    } else {
                      _playMusic();
                    }
                  },
                ),
                // Слайдер громкости
                SizedBox(
                  width: 100,
                  child: Slider(
                    value: _volume,
                    min: 0,
                    max: 1,
                    divisions: 10,
                    activeColor: Colors.white,
                    inactiveColor: Colors.white.withOpacity(0.5),
                    onChanged: (value) {
                      _setVolume(value);
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}