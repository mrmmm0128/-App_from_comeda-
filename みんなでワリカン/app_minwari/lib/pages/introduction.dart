import 'package:flutter/material.dart';
import 'package:study_flutter_firebase/pages/input_collection.dart';
import 'package:study_flutter_firebase/pages/explain.dart';
import 'package:study_flutter_firebase/pages/privacypolicy.dart';
import 'package:study_flutter_firebase/pages/servicerule.dart';
import 'package:study_flutter_firebase/pages/our_information.dart';
import 'package:study_flutter_firebase/model/cliper.dart';
import 'package:url_launcher/url_launcher.dart';
import 'dart:io';
import 'package:device_info_plus/device_info_plus.dart';

class IntroductionPage extends StatelessWidget {
  const IntroductionPage({super.key});

  void _navigateToCollectionInput(BuildContext context) async {
    String deviceId = await getDeviceUUID();
    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => CollectionInputPage(
                deviceId: deviceId,
              )),
    );
  }

  void _navigateToExplain(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const Explain()),
    );
  }

  void _navigateToPrivacyPolicy(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const PrivacyPolicyPage()),
    );
  }

  // GoogleフォームのURLを開く関数
  void _launchContactForm() async {
    final Uri url = Uri.parse(
        'https://docs.google.com/forms/d/e/1FAIpQLSfHpmSHm5SBAARgemK39rfeWldmxmLPmfFU0BM1uuUXWYX3Hw/viewform?usp=sf_link');

    if (!await launchUrl(url, mode: LaunchMode.externalApplication)) {
      throw 'Could not launch $url';
    }
  }


Future<String> getDeviceUUID() async {
  final deviceInfo = DeviceInfoPlugin();
  String deviceId = "";

  if (Platform.isAndroid) {
    // Androidデバイスの場合
    """
    final androidInfo = await deviceInfo.androidInfo;
    deviceId = androidInfo.androidId ?? ""
    """; // Android固有のID
  } else if (Platform.isIOS) {
    // iOSデバイスの場合
    final iosInfo = await deviceInfo.iosInfo;
    deviceId = iosInfo.identifierForVendor ?? ""; // iOS固有のID
  } else {
    deviceId = "unsupported-platform"; // サポートされていないプラットフォーム
  }

  return deviceId;
}

  @override
Widget build(BuildContext context) {
  final screenWidth = MediaQuery.of(context).size.width;
  final screenHeight = MediaQuery.of(context).size.height;

  return Scaffold(
    appBar: AppBar(
      title: Text(
        "みんなでワリカン",
        style: TextStyle(fontFamily: "Roboto"),
      ),
      backgroundColor: const Color(0xFF75A9D6),
      foregroundColor: Colors.white,
      centerTitle: true,
      elevation: 0,
    ),
    body: SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(height: screenHeight * 0.08),
            Center(
              child: ClipPath(
                clipper: RoundedCornersClipper(),
                child: Image.asset(
                  'images/icon.jpg',
                  width: screenWidth * 0.5,
                  height: screenWidth * 0.5,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            SizedBox(height: screenHeight * 0.05),
            Text(
              'お金のやり取りをシンプルに',
              style: TextStyle(
                fontSize: screenWidth * 0.065,
                fontWeight: FontWeight.bold,
                fontFamily: 'Roboto',
                color: Colors.black,
              ),
            ),
            SizedBox(height: screenHeight * 0.02),
            Text(
              'このアプリで、支払い管理がもっと簡単に！\nお金のことは忘れて旅行や飲み会を楽しみましょう！',
              style: TextStyle(
                fontSize: screenWidth * 0.04,
                fontFamily: 'Roboto',
                color: Colors.black87,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: screenHeight * 0.05),
            ElevatedButton(
              onPressed: () => _navigateToCollectionInput(context),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF75A9D6),
                foregroundColor: Colors.white,
                padding: EdgeInsets.symmetric(
                  vertical: screenHeight * 0.015,
                  horizontal: screenWidth * 0.1,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
              child: Text(
                '始める',
                style: TextStyle(fontSize: screenWidth * 0.045),
              ),
            ),
            SizedBox(height: screenHeight * 0.02),
            ElevatedButton(
              onPressed: () => _navigateToExplain(context),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF75A9D6),
                foregroundColor: Colors.white,
                padding: EdgeInsets.symmetric(
                  vertical: screenHeight * 0.015,
                  horizontal: screenWidth * 0.1,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
              child: Text(
                '使い方',
                style: TextStyle(fontSize: screenWidth * 0.045),
              ),
            ),
            SizedBox(height: screenHeight * 0.05),
            // Row with Image and Text
            Row(
              children: [
                Container(
                  width: screenWidth * 0.4,
                  height: screenWidth * 0.4,
                  child: const Image(
                    image: AssetImage('images/グループ説明.png'),
                  ),
                ),
                SizedBox(width: screenWidth * 0.05),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "固定メンバーで一括管理！",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: screenWidth * 0.04,
                          fontFamily: 'Montserrat',
                          color: Colors.black87,
                        ),
                      ),
                      SizedBox(height: screenHeight * 0.01),
                      Text(
                        "過去の飲み会や旅行を確認することが出来るため、「あのときいくらはらったっけ？」と悩むことはありません。",
                        style: TextStyle(
                          fontSize: screenWidth * 0.035,
                          fontFamily: 'Roboto',
                          color: Colors.black87,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(height: screenHeight * 0.03),
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "リンク共有で誰でも入力！",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: screenWidth * 0.04,
                          fontFamily: 'Montserrat',
                          color: Colors.black87,
                        ),
                      ),
                      SizedBox(height: screenHeight * 0.01),
                      Text(
                        "支払入力画面の共有リンクを使えば、誰でも支払入力できます。",
                        style: TextStyle(
                          fontSize: screenWidth * 0.035,
                          fontFamily: 'Roboto',
                          color: Colors.black87,
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(width: screenWidth * 0.05),
                Container(
                  width: screenWidth * 0.4,
                  height: screenWidth * 0.4,
                  child: const Image(
                    image: AssetImage('images/支払説明.png'),
                  ),
                ),
              ],
            ),
            SizedBox(height: screenHeight * 0.03),
            Row(
              children: [
                Container(
                  width: screenWidth * 0.4,
                  height: screenWidth * 0.4,
                  child: const Image(
                    image: AssetImage('images/支払提案説明.png'),
                  ),
                ),
                SizedBox(width: screenWidth * 0.05),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "効率の良い割り勘を！！",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: screenWidth * 0.04,
                          fontFamily: 'Montserrat',
                          color: Colors.black87,
                        ),
                      ),
                      SizedBox(height: screenHeight * 0.01),
                      Text(
                        "過去の支払情報から次のお会計の分配を行うことにより、個人の支払いのばらつきを小さくすることができます。",
                        style: TextStyle(
                          fontSize: screenWidth * 0.035,
                          fontFamily: 'Roboto',
                          color: Colors.black87,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(height: screenHeight * 0.05),
            const Divider(),
            SizedBox(height: screenHeight * 0.02),
            TextButton(
              onPressed: () => _navigateToPrivacyPolicy(context),
              child: Text(
                'プライバシーポリシー',
                style: TextStyle(
                  fontSize: screenWidth * 0.04,
                  color: Colors.blueGrey,
                ),
              ),
            ),
            TextButton(
              onPressed: _launchContactForm,
              child: Text(
                'お問い合わせ',
                style: TextStyle(
                  fontSize: screenWidth * 0.04,
                  color: Colors.blueGrey,
                ),
              ),
            ),
            TextButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => servicerule(),
                  ),
                );
              },
              child: Text(
                '利用規約',
                style: TextStyle(
                  fontSize: screenWidth * 0.04,
                  color: Colors.blueGrey,
                ),
              ),
            ),
            TextButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => AboutUsPage(),
                  ),
                );
              },
              child: Text(
                '運営元情報',
                style: TextStyle(
                  fontSize: screenWidth * 0.04,
                  color: Colors.blueGrey,
                ),
              ),
            ),
            SizedBox(height: screenHeight * 0.1),
          ],
        ),
      ),
    ),
    backgroundColor: const Color(0xFFE0ECF8),
  );
}
}