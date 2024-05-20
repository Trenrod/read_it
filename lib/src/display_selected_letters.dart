import 'package:read_it/src/display_letter.dart';
import 'package:read_it/src/selected_letters.dart';
import 'package:read_it/src/tts_mananger.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class DisplaySelectedLetters extends StatefulWidget {
  @override
  State<DisplaySelectedLetters> createState() => _DisplaySelectedLettersState();
}

class _DisplaySelectedLettersState extends State<DisplaySelectedLetters> {
  List<String> _letters = [];
  bool merge = false;
  int animationTimeMS = 1000;

  @override
  Widget build(BuildContext context) {
    SelectedLetters selectedLetters = context.watch<SelectedLetters>();

    if (selectedLetters.delete) {
      _letters = [];
      Future.microtask(() => context.read<SelectedLetters>().deleteDone());
    }

    // Process new letter
    String? letter = selectedLetters.letter;
    if (letter != null) {
      _letters.add(letter);
      context
          .read<TTSManager>()
          .asyncSpeak(letter)
          .then((value) => selectedLetters.letterProcessed());
    }

    // Read letter
    if (selectedLetters.read && merge == false) {
      setState(() {
        merge = true;
      });
      Future.delayed(Duration(milliseconds: animationTimeMS), () {
        context.read<TTSManager>().asyncSpeak(_letters.join()).then((value) {
          selectedLetters.readDone();
          setState(() {
            merge = false;
          });
        });
      });
    }

    return Expanded(
      child: Container(
        padding: EdgeInsets.all(20),
        decoration: BoxDecoration(),
        alignment: Alignment.topLeft,
        child: Wrap(
          children: _letters
              .asMap()
              .map((idx, letterInLetters) => MapEntry(
                  idx,
                  DisplayLetter(
                    letter: letterInLetters,
                    merge: merge,
                    key: Key("$idx-$letterInLetters"),
                  )))
              .values
              .toList(),
        ),
      ),
    );
  }
}
