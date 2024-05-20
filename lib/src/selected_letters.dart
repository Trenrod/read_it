import 'package:flutter/material.dart';

class SelectedLetters extends ChangeNotifier {
  String? letter;
  bool firstLetter = true;
  bool read = false;
  bool delete = false;

  deleteStart() {
    delete = true;
    notifyListeners();
  }

  deleteDone() {
    delete = false;
    firstLetter = true;
    notifyListeners();
  }

  setLetter(String letter) {
    this.letter = letter;
    firstLetter = false;
    notifyListeners();
  }

  letterProcessed() {
    letter = null;
    notifyListeners();
  }

  readStart() {
    read = true;
    notifyListeners();
  }

  readDone() {
    read = false;
    notifyListeners();
  }

  clear() {
    firstLetter = true;
    notifyListeners();
  }
}
