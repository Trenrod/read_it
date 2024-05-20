import 'package:read_it/src/letter_box.dart';
import 'package:read_it/src/selected_letters.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Keypad extends StatefulWidget {
  @override
  State<Keypad> createState() => _KeypadState();
}

class _KeypadState extends State<Keypad> {
  var isUpper = true;
  var isEnabled = true;

  Row createRow(List<String> letters) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: letters
          .map((e) => LetterBox(
              letter: isUpper ? e.toUpperCase() : e.toLowerCase(),
              isEnabled: isEnabled))
          .toList(),
    );
  }

  @override
  Widget build(BuildContext context) {
    SelectedLetters selectedLetters = context.watch<SelectedLetters>();
    setState(() {
      isUpper = selectedLetters.firstLetter;
      isEnabled = selectedLetters.letter == null && !selectedLetters.read;
    });
    var rows = [
      ["A", "B", "C", "D", "E", "F"],
      ["G", "H", "I", "J", "K", "L"],
      ["M", "N", "O", "P", "Q", "R"],
      ["S", "T", "U", "V", "W", "X"],
      ["Y", "Z", " ", "Ä", "Ö", "Ü"],
    ].map((letters) => createRow(letters)).toList();

    rows.add(Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Expanded(
          child: GestureDetector(
            onTap: isEnabled
                ? () {
                    context.read<SelectedLetters>().deleteStart();
                  }
                : null,
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              decoration: BoxDecoration(
                  color:
                      isEnabled ? Colors.red.shade300 : Colors.grey.shade300),
              child: Icon(
                Icons.delete,
                size: 48,
              ),
            ),
          ),
        ),
        Expanded(
          child: GestureDetector(
            onTap: isEnabled
                ? () {
                    context.read<SelectedLetters>().readStart();
                  }
                : null,
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              decoration: BoxDecoration(
                  color:
                      isEnabled ? Colors.green.shade300 : Colors.grey.shade300),
              child: Icon(
                Icons.campaign,
                size: 48,
              ),
            ),
          ),
        ),
      ],
    ));

    return Column(children: rows);
  }
}
