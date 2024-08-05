import 'package:flutter/material.dart';
import 'package:wx_box/wx_box.dart';
import 'package:wx_text/wx_text.dart';
import 'package:wx_anchor/wx_anchor.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'WxBox Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: false,
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatelessWidget {
  const MyHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              const SizedBox(height: 40),
              const WxText.displayMedium('WxBox'),
              const SizedBox(height: 40),
              const Wrapper(
                title: 'Rectangle Shape',
                child: Wrap(
                  crossAxisAlignment: WrapCrossAlignment.center,
                  spacing: 20,
                  children: [
                    WxAnimatedBox(
                      alignment: Alignment.center,
                      constraints: BoxConstraints(
                        minHeight: 45,
                        maxWidth: 100,
                      ),
                      color: Colors.amber,
                      padding: EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 5,
                      ),
                      borderStyle: BorderStyle.solid,
                      borderColor: Colors.red,
                      borderWidth: 1,
                      borderOffset: 7,
                      borderRadius: BorderRadius.all(Radius.circular(5)),
                      child: Text(
                        'Text',
                        style: TextStyle(
                          height: 1.15,
                        ),
                      ),
                    ),
                    WxBox.square(
                      size: 45,
                      borderRadius: BorderRadius.all(Radius.circular(4)),
                      alignment: Alignment.center,
                      color: Colors.amber,
                      child: Text(
                        'Text',
                        style: TextStyle(
                          height: 1.15,
                        ),
                      ),
                    ),
                    WxBox.square(
                      borderWidth: 1,
                      borderStyle: BorderStyle.solid,
                      borderColor: Colors.black87,
                      borderOffset: BorderSide.strokeAlignOutside,
                      borderRadius: BorderRadius.all(Radius.circular(4)),
                      padding: EdgeInsets.all(5),
                      child: Text(
                        'Text',
                        style: TextStyle(
                          height: 1.15,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              const Wrapper(
                title: 'Circle Shape',
                child: Wrap(
                  crossAxisAlignment: WrapCrossAlignment.center,
                  spacing: 20,
                  children: [
                    WxBox.circle(
                      elevation: 2,
                      color: Colors.amber,
                      padding: EdgeInsets.all(10),
                      child: Text(
                        '9',
                        style: TextStyle(
                          height: 1.2,
                        ),
                      ),
                    ),
                    WxAnimatedBox.circle(
                      radius: 25,
                      alignment: Alignment.center,
                      shadows: [
                        BoxShadow(
                          color: Colors.grey,
                          spreadRadius: 3,
                          blurRadius: 3,
                          offset: Offset(0, 0), // changes position of shadow
                        ),
                      ],
                      gradient: LinearGradient(
                        colors: [
                          Colors.teal,
                          Colors.indigo,
                        ],
                      ),
                      child: Text(
                        'Text',
                        style: TextStyle(
                          color: Colors.white,
                          height: 1.15,
                        ),
                      ),
                    ),
                    ElevatedBox(),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              Wrapper(
                title: 'Stadium Shape',
                child: Wrap(
                  crossAxisAlignment: WrapCrossAlignment.center,
                  spacing: 20,
                  children: [
                    const WxBox.stadium(
                      color: Colors.amber,
                      padding: EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 5,
                      ),
                      child: Text(
                        'Text',
                        style: TextStyle(
                          height: 1.15,
                        ),
                      ),
                    ),
                    WxAnimatedBox.stadium(
                      // color: Colors.amber,
                      width: 150,
                      height: 50,
                      borderWidth: 1,
                      borderStyle: BorderStyle.solid,
                      borderColor: Theme.of(context).colorScheme.onSurface,
                      borderOffset: BorderSide.strokeAlignOutside,
                      clipBehavior: Clip.antiAlias,
                      child: Material(
                        type: MaterialType.transparency,
                        child: InkWell(
                          onTap: () {},
                          child: Center(
                            child: Text(
                              'Text',
                              style: Theme.of(context)
                                  .textTheme
                                  .titleLarge
                                  ?.copyWith(height: 1.15),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }
}

class ElevatedBox extends StatefulWidget {
  const ElevatedBox({super.key});

  @override
  State<ElevatedBox> createState() => _ElevatedBoxState();
}

class _ElevatedBoxState extends State<ElevatedBox> {
  bool _isHover = false;
  bool _isPressed = false;

  _setIsHover(bool val) {
    setState(() => _isHover = val);
  }

  _setIsPressed(bool val) {
    setState(() => _isPressed = val);
  }

  double get _elevation => _isPressed
      ? 0
      : _isHover
          ? 3
          : 0;

  @override
  Widget build(BuildContext context) {
    return WxAnchor.circle(
      radius: 25,
      onHover: (hover) => _setIsHover(hover),
      onTapUp: (_) => _setIsPressed(false),
      onTapDown: (_) => _setIsPressed(true),
      onTapCancel: () => _setIsPressed(false),
      child: WxAnimatedBox.circle(
        elevation: _elevation,
        radius: 25,
        color: Colors.amber,
        alignment: Alignment.center,
        child: const Text(
          'Text',
          style: TextStyle(
            color: Colors.white,
            height: 1.15,
          ),
        ),
      ),
    );
  }
}

class Wrapper extends StatelessWidget {
  const Wrapper({
    super.key,
    required this.title,
    required this.child,
  });

  final String title;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(10, 0, 0, 0),
          child: WxText.labelLarge(title),
        ),
        SizedBox(
          width: 300,
          height: 100,
          child: Card.outlined(
            child: Padding(
              padding: const EdgeInsets.all(15.0),
              child: Center(child: child),
            ),
          ),
        ),
      ],
    );
  }
}
