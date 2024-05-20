import 'package:read_it/src/selected_letters.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class LetterBox extends StatelessWidget {
  final String letter;
  final bool isEnabled;

  LetterBox({required this.letter, required this.isEnabled});

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: isEnabled
          ? () {
              context.read<SelectedLetters>().setLetter(letter);
            }
          : null,
      child: Text(
        letter,
        style: TextStyle(
            fontSize: Theme.of(context).textTheme.displaySmall?.fontSize),
      ),
    );
  }
}
