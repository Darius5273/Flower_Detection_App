import 'package:demo/MyModel.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'CommonPageLayout.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  MyModel classifier = MyModel();
  await classifier.initialize();

  runApp(
      MultiProvider(
          providers: [
            ChangeNotifierProvider(
              create: (context) => classifier,
            ),
          ],
          child: const MyApp(),
          ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flower D\'techtion',
      debugShowCheckedModeBanner: false,
      color: Colors.greenAccent,
      home: HomePage(),
    );
  }
}


class HomePage extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return  CommonPageLayout(text: 'Upload an image with a flower for identification', image: 'Images/Detective.png',showDecoration: true, additionalChild: null,);
  }

}
