import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

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
      "amounts": amounts,
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
    // スクリーンサイズ取得
    final screenSize = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "メモ追加",
          style: TextStyle(
            fontFamily: 'Roboto',
          ),
        ),
        backgroundColor: const Color(0xFF75A9D6), // AppBarの色
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          // 画面幅が600px以上の場合はタブレットレイアウトを適用
          final isWide = constraints.maxWidth > 600;
          final padding = isWide ? 40.0 : 20.0;

          return SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.all(padding),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 40),
                  const Text(
                    "タイトル",
                    style: TextStyle(fontSize: 18, color: Colors.blueGrey),
                  ),
                  const SizedBox(height: 20),
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.blue.shade100,
                          blurRadius: 6,
                          offset: const Offset(0, 3),
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
                  const Text(
                    "参加者",
                    style: TextStyle(fontSize: 18, color: Colors.blueGrey),
                  ),
                  const SizedBox(height: 10),
                  ...participantControllers.asMap().entries.map((entry) {
                    int index = entry.key;
                    TextEditingController controller = entry.value;

                    return Padding(
                      padding: const EdgeInsets.only(bottom: 10),
                      child: Row(
                        children: [
                          Expanded(
                            child: Container(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 10),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(12),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.blue.shade100,
                                    blurRadius: 6,
                                    offset: const Offset(0, 3),
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
                            icon: const Icon(Icons.remove_circle,
                                color: Colors.red),
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
                      child: const Text(
                        "参加者を追加",
                        style: TextStyle(fontFamily: "Roboto"),
                      ),
                    ),
                  ),
                  const SizedBox(height: 40),
                  Center(
                    child: SizedBox(
                      width: isWide ? 300 : screenSize.width * 0.8,
                      child: ElevatedButton(
                        onPressed: () async {
                          if (titleController.text.isEmpty) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('タイトルを入力してください')),
                            );
                            return;
                          }
                          if (participantControllers
                              .every((controller) => controller.text.isEmpty)) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                  content: Text('少なくとも1人の参加者を入力してください')),
                            );
                            return;
                          }
                          await createMemo();
                          Navigator.pop(context);
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF75A9D6),
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                          padding: const EdgeInsets.symmetric(
                              vertical: 12, horizontal: 30),
                        ),
                        child: const Text(
                          "確定",
                          style: TextStyle(fontFamily: "Roboto"),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 40),
                ],
              ),
            ),
          );
        },
      ),
      backgroundColor: const Color(0xFFE0ECF8), // 背景色
    );
  }
}
