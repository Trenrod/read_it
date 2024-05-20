import 'package:flutter/material.dart';

class DisplayLetter extends StatefulWidget {
  final String letter;
  final bool merge;

  DisplayLetter({required this.letter, required this.merge, super.key});

  @override
  State<DisplayLetter> createState() => _DisplayLetterState();
}

class _DisplayLetterState extends State<DisplayLetter> {
  static const double marginInit = 10;
  static const double paddingInit = 20;
  static const double borderRadiusInit = 15;

  double _margin = marginInit;
  double _padding = paddingInit;
  double _borderRadius = borderRadiusInit;

  void merge() {
    setState(() {
      _borderRadius = 0;
      _margin = 0;
      _padding = 0;
    });
  }

  void unmerge() {
    setState(() {
      _borderRadius = borderRadiusInit;
      _margin = marginInit;
      _padding = 5;
    });
  }

  @override
  Widget build(BuildContext context) {
    Future.microtask(
      () => setState(() {
        _padding = 5;
      }),
    );

    if (widget.merge) {
      Future.microtask(() => merge());
    } else {
      Future.microtask(() => unmerge());
    }

    return AnimatedContainer(
      // height: _dimension,
      // width: _dimension,
      // alignment: Alignment.center,
      margin: EdgeInsets.all(_margin),
      padding: EdgeInsets.all(_padding),
      decoration: BoxDecoration(
          shape: BoxShape.rectangle,
          borderRadius: BorderRadius.circular(_borderRadius),
          color: Theme.of(context).colorScheme.primary),
      duration: Duration(milliseconds: 500),
      child: Text(
        widget.letter,
        style: TextStyle(
            color: Theme.of(context).colorScheme.onPrimary,
            fontSize: Theme.of(context).textTheme.displaySmall?.fontSize),
      ),
    );
  }
}
