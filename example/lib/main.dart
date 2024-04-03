import 'package:flutter/material.dart';
import 'package:wx_box/wx_box.dart';

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
        useMaterial3: true,
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
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const ColoredBox(
              color: Colors.amber,
              child: WxBox(
                width: 50,
                height: 50,
              ),
            ),
            const WxBox(height: 20),
            WxBox.circle(
              color: Theme.of(context).colorScheme.surface,
              radius: 25,
              elevation: 2,
            ),
            const WxBox(height: 20),
            WxAnimatedBox(
              color: Colors.amber,
              width: 150,
              height: 50,
              borderWidth: 1,
              borderStyle: BorderStyle.solid,
              borderColor: Theme.of(context).colorScheme.onSurface,
              borderAlign: BorderSide.strokeAlignOutside,
              shape: WxBoxShape.stadium,
              alignment: Alignment.center,
              child: Text(
                'Text',
                style: Theme.of(context).textTheme.titleLarge,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
