import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class PaymentHistoryPage extends StatefulWidget {
  final Map<String, List<Map<String, dynamic>>> amounts;
  final String travelId;
  final String collectionName;

  const PaymentHistoryPage({
    Key? key,
    required this.amounts,
    required this.travelId,
    required this.collectionName,
  }) : super(key: key);

  @override
  _PaymentHistoryPageState createState() => _PaymentHistoryPageState();
}

class _PaymentHistoryPageState extends State<PaymentHistoryPage> {
  late Map<String, List<Map<String, dynamic>>> amounts;

  @override
  void initState() {
    super.initState();
    amounts = Map.from(widget.amounts);
  }

  /// 一人当たりの支払いを計算するメソッド
  double calculatePerPersonPayment() {
    double totalAmount = 0;
    int participantCount = amounts.keys.length;

    amounts.forEach((_, payments) {
      for (var payment in payments) {
        totalAmount += payment['amount'] ?? 0.0;
      }
    });

    return participantCount > 0 ? totalAmount / participantCount : 0.0;
  }

  Future<void> editPayment(String participant, int index) async {
    var payment = amounts[participant]?[index];
    if (payment == null) return;

    final TextEditingController amountController = TextEditingController(
      text: payment['amount'].toString(),
    );
    final TextEditingController memoController = TextEditingController(
      text: payment['memo'] ?? '',
    );

    final result = await showDialog<Map<String, dynamic>>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("支払いを編集"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: amountController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(labelText: "金額"),
              ),
              TextField(
                controller: memoController,
                decoration: const InputDecoration(labelText: "メモ"),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(null),
              child: const Text("キャンセル"),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop({
                  'amount': double.tryParse(amountController.text),
                  'memo': memoController.text,
                });
              },
              child: const Text("保存"),
            ),
          ],
        );
      },
    );

    if (result != null && result['amount'] != null) {
      try {
        var updatedPayment = {
          'amount': result['amount'],
          'memo': result['memo'],
        };

        await FirebaseFirestore.instance
            .collection(widget.collectionName)
            .doc(widget.travelId)
            .update({
          'amounts.$participant': FieldValue.arrayRemove([payment]),
        });
        await FirebaseFirestore.instance
            .collection(widget.collectionName)
            .doc(widget.travelId)
            .update({
          'amounts.$participant': FieldValue.arrayUnion([updatedPayment]),
        });

        setState(() {
          amounts[participant]?[index] = updatedPayment;
        });
      } catch (e) {
        print('編集に失敗しました: $e');
      }
    }
  }

  Future<void> deletePayment(String participant, int index) async {
    var payment = amounts[participant]?[index];
    if (payment != null) {
      try {
        await FirebaseFirestore.instance
            .collection(widget.collectionName)
            .doc(widget.travelId)
            .update({
          'amounts.$participant': FieldValue.arrayRemove([payment]),
        });

        setState(() {
          amounts[participant]?.removeAt(index);
          if (amounts[participant]?.isEmpty ?? false) {
            amounts.remove(participant);
          }
        });
      } catch (e) {
        print('削除に失敗しました: $e');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    double perPersonPayment = calculatePerPersonPayment();

    return Scaffold(
      appBar: AppBar(
        title: const Text("支払い履歴", style: TextStyle(fontFamily: "Roboto")),
        backgroundColor: const Color(0xFF75A9D6),
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: amounts.isEmpty
          ? const Center(
              child:
                  Text("支払い履歴がありません", style: TextStyle(fontFamily: "Roboto")),
            )
          : SingleChildScrollView(
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // 一人当たりの金額表示
                    Container(
                      margin: const EdgeInsets.only(bottom: 16.0),
                      padding: const EdgeInsets.all(16.0),
                      decoration: BoxDecoration(
                        color: const Color(0xFFDAE8FC),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        "一人当たりのお支払い: ¥$perPersonPayment",
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          fontFamily: "Roboto",
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    ...amounts.entries.map((entry) {
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            entry.key,
                            style: const TextStyle(
                                fontSize: 18, fontFamily: "Roboto"),
                          ),
                          ...entry.value.map((payment) {
                            String memoText = payment['memo'] ?? 'メモなし';
                            return Card(
                              elevation: 4,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              margin: const EdgeInsets.symmetric(vertical: 4.0),
                              child: ListTile(
                                title: Text('¥${payment['amount']}',
                                    style: const TextStyle(
                                        fontSize: 16, fontFamily: "Roboto")),
                                subtitle: Text(memoText,
                                    style: TextStyle(
                                        color: Colors.grey[600],
                                        fontFamily: "Roboto")),
                                trailing: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    IconButton(
                                      icon: const Icon(Icons.edit,
                                          color: Colors.blue),
                                      onPressed: () {
                                        editPayment(entry.key,
                                            entry.value.indexOf(payment));
                                      },
                                    ),
                                    IconButton(
                                      icon: const Icon(Icons.delete,
                                          color: Colors.red),
                                      onPressed: () {
                                        deletePayment(entry.key,
                                            entry.value.indexOf(payment));
                                      },
                                    ),
                                  ],
                                ),
                              ),
                            );
                          }).toList(),
                          const SizedBox(height: 10),
                        ],
                      );
                    }).toList(),
                  ],
                ),
              ),
            ),
      backgroundColor: const Color(0xFFE0ECF8),
    );
  }
}
