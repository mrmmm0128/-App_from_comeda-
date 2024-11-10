import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:study_flutter_firebase/pages/top_page.dart';

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

  Future<void> createMemo() async {
    final memoCollection = FirebaseFirestore.instance.collection(widget.collectionName);
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

  void _addParticipantField() {
    setState(() {
      participantControllers.add(TextEditingController());
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("旅行追加"),
        backgroundColor: Colors.blue.shade300,
        foregroundColor: Colors.black,
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
                    hintText: "旅行のタイトルを入力",
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
              ...participantControllers.map((controller) {
                return Padding(
                  padding: const EdgeInsets.only(
                      bottom: 10, left: 20, right: 20),
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
                        contentPadding: EdgeInsets.symmetric(vertical: 10),
                      ),
                    ),
                  ),
                );
              }).toList(),
              const SizedBox(height: 10),
              Center(
                child: ElevatedButton(
                  onPressed: _addParticipantField,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue.shade300,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                  child: const Text("参加者を追加"),
                ),
              ),
              const SizedBox(height: 40),
              Container(
                width: MediaQuery
                    .of(context)
                    .size
                    .width * 0.8,
                alignment: Alignment.center,
                child: ElevatedButton(
                  onPressed: () async {
                    if (titleController.text.isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                            content: Text('タイトルを入力してください')),
                      );
                      return;
                    }
                    if (participantControllers.every((controller) =>
                    controller.text.isEmpty)) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text(
                            '少なくとも1人の参加者を入力してください')),
                      );
                      return;
                    }
                    await createMemo();
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => MyHomePage(collectionName: widget.collectionName),
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue.shade300,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    padding: EdgeInsets.symmetric(vertical: 12, horizontal: 30),
                  ),
                  child: const Text("追加"),
                ),
              ),
            ],
          ),
        ),
      ),
      backgroundColor: Colors.blue.shade50,
    );
  }
}