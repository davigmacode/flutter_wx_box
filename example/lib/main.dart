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
            WxBox(
              color: Theme.of(context).colorScheme.surface,
              width: 50,
              height: 50,
              elevation: 2,
              shape: BoxShape.circle,
            ),
            const WxBox(height: 20),
            WxBox(
              color: Colors.amber,
              width: 50,
              height: 50,
              borderWidth: 5,
              borderStyle: BorderStyle.solid,
              borderColor: Theme.of(context).colorScheme.surface,
              borderAlign: BorderSide.strokeAlignOutside,
              shape: BoxShape.circle,
              alignment: Alignment.center,
              child: Text(
                '1',
                style: Theme.of(context).textTheme.titleLarge,
              ),
            ),
            const WxBox(height: 20),
            WxBox(
              color: Colors.amber,
              width: 150,
              height: 50,
              border: const StadiumBorder(
                side: BorderSide(
                  width: 5,
                  style: BorderStyle.solid,
                  color: Colors.black,
                  strokeAlign: BorderSide.strokeAlignOutside,
                ),
              ),
              alignment: Alignment.center,
              child: Text(
                'text',
                style: Theme.of(context).textTheme.titleLarge,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
