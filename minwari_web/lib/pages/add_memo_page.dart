import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:study_flutter_firebase/pages/top_page.dart';
import 'package:study_flutter_firebase/pages/privacypolicy.dart';
import 'package:study_flutter_firebase/pages/servicerule.dart';
import 'package:study_flutter_firebase/pages/our_information.dart';
import 'dart:html' as html;

class AddMemoPage extends StatefulWidget {
  const AddMemoPage({super.key, required this.collectionName});
  final String collectionName;

  @override
  State<AddMemoPage> createState() => _AddMemoPageState();
}

class _AddMemoPageState extends State<AddMemoPage> {
  TextEditingController titleController = TextEditingController();
  List<TextEditingController> participantControllers = [
    TextEditingController()
  ];
  @override
  void initState() {
    super.initState();
    _fetchLatestParticipants();
  }

  Future<void> createMemo() async {
    final memoCollection =
        FirebaseFirestore.instance.collection(widget.collectionName);
    List<String> participants = participantControllers
        .map((c) => c.text)
        .where((text) => text.isNotEmpty)
        .toList();

    // 各参加者に空の履歴リストを用意
    Map<String, List<double>> amounts = {
      for (var participant in participants) participant: []
    };

    await memoCollection.add({
      "title": titleController.text,
      "participants": participants,
      "amounts": amounts, // 参加者ごとの履歴リストを初期化
      "date": Timestamp.now(),
    });
  }

  void _navigateToPrivacyPolicy(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const PrivacyPolicyPage()),
    );
  }

  // GoogleフォームのURLを開く関数
  void _launchContactForm() {
    html.window.open(
      'https://docs.google.com/forms/d/e/1FAIpQLSfHpmSHm5SBAARgemK39rfeWldmxmLPmfFU0BM1uuUXWYX3Hw/viewform?usp=sf_link',
      '_blank',
    );
  }

  void _addParticipantField() {
    setState(() {
      participantControllers.add(TextEditingController());
    });
  }

  Future<void> _fetchLatestParticipants() async {
    try {
      final snapshot = await FirebaseFirestore.instance
          .collection(widget.collectionName)
          .orderBy('date', descending: true)
          .limit(1)
          .get();

      if (snapshot.docs.isNotEmpty) {
        final latestDoc = snapshot.docs.first;
        final participants = latestDoc.data()['participants'];

        if (participants != null && participants is List) {
          setState(() {
            participantControllers = participants
                .map((participant) => TextEditingController(text: participant))
                .toList();
          });
        }
      }
    } catch (e) {
      // エラー処理（必要ならログを追加）
      print('Error fetching participants: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "メモ追加",
          style: TextStyle(
            fontFamily: 'Roboto',
          ),
        ),
        backgroundColor: const Color(0xFF75A9D6), //Appbarの色
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 40),
              const Padding(
                padding: EdgeInsets.only(left: 20),
                child: Text(
                  "タイトル",
                  style: TextStyle(fontSize: 18, color: Colors.blueGrey),
                ),
              ),
              const SizedBox(height: 20),
              Container(
                margin: EdgeInsets.symmetric(horizontal: 20),
                padding: EdgeInsets.symmetric(horizontal: 10),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.blue.shade100,
                      blurRadius: 6,
                      offset: Offset(0, 3),
                    ),
                  ],
                ),
                child: TextField(
                  controller: titleController,
                  decoration: const InputDecoration(
                    hintText: "メモのタイトルを入力",
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.symmetric(vertical: 10),
                  ),
                ),
              ),
              const SizedBox(height: 40),
              const Padding(
                padding: EdgeInsets.only(left: 20),
                child: Text(
                  "参加者",
                  style: TextStyle(fontSize: 18, color: Colors.blueGrey),
                ),
              ),
              const SizedBox(height: 10),
              ...participantControllers.asMap().entries.map((entry) {
                int index = entry.key;
                TextEditingController controller = entry.value;
                return Padding(
                  padding:
                      const EdgeInsets.only(bottom: 10, left: 20, right: 20),
                  child: Row(
                    children: [
                      Expanded(
                        child: Container(
                          padding: EdgeInsets.symmetric(horizontal: 10),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(12),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.blue.shade100,
                                blurRadius: 6,
                                offset: Offset(0, 3),
                              ),
                            ],
                          ),
                          child: TextField(
                            controller: controller,
                            decoration: const InputDecoration(
                              hintText: "参加者の名前を入力",
                              border: InputBorder.none,
                              contentPadding:
                                  EdgeInsets.symmetric(vertical: 10),
                            ),
                          ),
                        ),
                      ),
                      IconButton(
                        icon: Icon(Icons.remove_circle, color: Colors.red),
                        onPressed: () {
                          setState(() {
                            participantControllers.removeAt(index);
                          });
                        },
                      ),
                    ],
                  ),
                );
              }).toList(),
              const SizedBox(height: 10),
              Center(
                child: ElevatedButton(
                  onPressed: _addParticipantField,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF75A9D6),
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                  child: const Text("参加者を追加",
                      style: TextStyle(fontFamily: "Roboto")),
                ),
              ),
              const SizedBox(height: 40),
              Container(
                width: MediaQuery.of(context).size.width * 0.8,
                alignment: Alignment.center,
                child: ElevatedButton(
                  onPressed: () async {
                    if (titleController.text.isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                            content: Text('タイトルを入力してください',
                                style: TextStyle(fontFamily: "Roboto"))),
                      );
                      return;
                    }
                    if (participantControllers
                        .every((controller) => controller.text.isEmpty)) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                            content: Text('少なくとも1人の参加者を入力してください',
                                style: TextStyle(fontFamily: "Roboto"))),
                      );
                      return;
                    }
                    await createMemo();
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            MyHomePage(collectionName: widget.collectionName),
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF75A9D6),
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    padding: EdgeInsets.symmetric(vertical: 12, horizontal: 30),
                  ),
                  child:
                      const Text("確定", style: TextStyle(fontFamily: "Roboto")),
                ),
              ),
              const SizedBox(height: 40),
              const Divider(),
              const SizedBox(height: 20),
              TextButton(
                onPressed: () => _navigateToPrivacyPolicy(context),
                child: const Text(
                  'プライバシーポリシー',
                  style: TextStyle(fontSize: 16, color: Colors.blueGrey),
                ),
              ),
              TextButton(
                onPressed: _launchContactForm,
                child: const Text(
                  'お問い合わせ',
                  style: TextStyle(fontSize: 16, color: Colors.blueGrey),
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
                child: const Text(
                  '利用規約',
                  style: TextStyle(fontSize: 16, color: Colors.blueGrey),
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
                child: const Text(
                  '運営元情報',
                  style: TextStyle(fontSize: 16, color: Colors.blueGrey),
                ),
              ),
              const Spacer(),
              const SizedBox(height: 200),
            ],
          ),
        ),
      ),
      backgroundColor: const Color(0xFFE0ECF8), // 背景色 // 背景色//Appbarの色
    );
  }
}
