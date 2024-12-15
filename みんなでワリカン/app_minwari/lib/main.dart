import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:study_flutter_firebase/firebase_options.dart';
import 'package:study_flutter_firebase/pages/introduction.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "みんなでワリカン",
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      debugShowCheckedModeBanner: false, //<-この行を追加
      initialRoute: '/',
      onGenerateRoute: (settings) {
        final Uri? uri = Uri.tryParse(settings.name ?? '/');

        return MaterialPageRoute(
            builder: (context) => const IntroductionPage());
      },
    );
  }
}
