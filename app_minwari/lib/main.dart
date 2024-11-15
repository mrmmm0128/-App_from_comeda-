import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:study_flutter_firebase/firebase_options.dart';
import 'package:study_flutter_firebase/pages/Introduction.dart';
import 'package:study_flutter_firebase/pages/memo_detail_page.dart';

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
      title: "みんなで割り勘",
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      initialRoute: '/',
      onGenerateRoute: (settings) {
        final Uri? uri = Uri.tryParse(settings.name ?? '/');

        if (uri != null &&
            uri.pathSegments.length == 3 &&
            uri.pathSegments[0] == 'travel') {
          final String collectionName_url = uri.pathSegments[1];
          final String memoId_url = uri.pathSegments[2];
          return MaterialPageRoute(
            builder: (context) => MemoDetailPage(
              collectionName: collectionName_url,
              memoId: memoId_url,
            ),
          );
        }

        return MaterialPageRoute(
            builder: (context) => const IntroductionPage());
      },
    );
  }
}
