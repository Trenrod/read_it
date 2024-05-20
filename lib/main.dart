import 'package:read_it/src/display_selected_letters.dart';
import 'package:read_it/src/selected_letters.dart';
import 'package:read_it/src/tts_mananger.dart';
import 'package:flex_color_scheme/flex_color_scheme.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:window_manager/window_manager.dart';
import 'dart:io' show Platform;

import 'src/keypad.dart';

class MyApp extends StatefulWidget {
  @override
  State<MyApp> createState() => _MyApp();
}

class _MyApp extends State<MyApp> {
  TTSManager tssManager = TTSManager();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        DisplaySelectedLetters(),
        Keypad(),
      ],
    );
  }
}

class MyPhysicalKeyExample extends StatefulWidget {
  const MyPhysicalKeyExample({super.key});

  @override
  State<MyPhysicalKeyExample> createState() => _MyPhysicalKeyExampleState();
}

class _MyPhysicalKeyExampleState extends State<MyPhysicalKeyExample> {
// The node used to request the keyboard focus.
  final FocusNode _focusNode = FocusNode();
// The message to display.
  String? _message;

// Focus nodes need to be disposed.
  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

// Handles the key events from the RawKeyboardListener and update the
// _message.
  KeyEventResult _handleKeyEvent(FocusNode node, KeyEvent event) {
    setState(() {
      if (event.physicalKey == PhysicalKeyboardKey.keyA) {
        _message = 'Pressed the key next to CAPS LOCK!';
      } else {
        if (kReleaseMode) {
          _message =
              'Not the key next to CAPS LOCK: Pressed 0x${event.physicalKey.usbHidUsage.toRadixString(16)}';
        } else {
          // As the name implies, the debugName will only print useful
          // information in debug mode.
          _message =
              'Not the key next to CAPS LOCK: Pressed ${event.physicalKey.debugName}';
        }
      }
    });
    return event.physicalKey == PhysicalKeyboardKey.keyA
        ? KeyEventResult.handled
        : KeyEventResult.ignored;
  }

  @override
  Widget build(BuildContext context) {
    final TextTheme textTheme = Theme.of(context).textTheme;
    return Container(
      color: Colors.white,
      alignment: Alignment.center,
      child: DefaultTextStyle(
        style: textTheme.headlineMedium!,
        child: Focus(
          focusNode: _focusNode,
          onKeyEvent: _handleKeyEvent,
          child: ListenableBuilder(
            listenable: _focusNode,
            builder: (BuildContext context, Widget? child) {
              if (!_focusNode.hasFocus) {
                return GestureDetector(
                  onTap: () {
                    FocusScope.of(context).requestFocus(_focusNode);
                  },
                  child: const Text('Click to focus'),
                );
              }
              return Text(_message ?? 'Press a key');
            },
          ),
        ),
      ),
    );
  }
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  if (Platform.isWindows) {
    // Must add this line.
    await windowManager.ensureInitialized();

    WindowOptions windowOptions = WindowOptions(
      size: Size(600, 800),
      center: true,
      backgroundColor: Colors.transparent,
      skipTaskbar: false,
      titleBarStyle: TitleBarStyle.normal,
    );
    windowManager.waitUntilReadyToShow(windowOptions, () async {
      await windowManager.show();
      await windowManager.focus();
    });
  } else {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
  }

  runApp(MaterialApp(
    theme: FlexThemeData.light(scheme: FlexScheme.deepPurple),
    darkTheme: FlexThemeData.dark(scheme: FlexScheme.deepPurple),
    themeMode: ThemeMode.light,
    home: Scaffold(
      body: SafeArea(
        child: MultiProvider(
          providers: [
            ChangeNotifierProvider(create: (context) => SelectedLetters()),
            Provider(create: (context) => TTSManager()),
          ],
          child: MyApp(),
        ),
      ),
    ),
  ));
}
