import 'package:flutter_tts/flutter_tts.dart';

class TTSManager {
  FlutterTts flutterTts = FlutterTts();
  bool isInit = false;

  Future<void> init() async {
    if (!isInit) {
      await flutterTts.setVolume(1.0);
      await flutterTts.setSpeechRate(.6);
      await flutterTts.setPitch(1.0);
      await flutterTts.setLanguage("de-DE");
    }
    isInit = true;
  }

  Future<void> asyncSpeak(String text) async {
    try {
      await init();
      await flutterTts.awaitSpeakCompletion(true);
      await flutterTts.speak(text);
    } catch (e) {
      print(e);
    }
  }

  speak(String text) {
    asyncSpeak(text).catchError((e) {});
  }
}
