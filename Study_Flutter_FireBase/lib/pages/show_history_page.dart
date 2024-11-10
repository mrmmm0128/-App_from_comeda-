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
    // データが正しく初期化されているか確認
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
    return Scaffold(
      appBar: AppBar(
        title: const Text("支払い履歴"),
        backgroundColor: Colors.blue.shade300,
        elevation: 0,
      ),
      body: amounts.isEmpty
          ? const Center(child: Text("支払い履歴がありません"))
          : SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: amounts.entries.map((entry) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    entry.key,
                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
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
                        title: Text('¥${payment['amount']}', style: const TextStyle(fontSize: 16)),
                        subtitle: Text(memoText, style: TextStyle(color: Colors.grey[600])),
                        trailing: IconButton(
                          icon: const Icon(Icons.delete, color: Colors.red),
                          onPressed: () {
                            // 元の deletePayment の呼び出しを維持
                            deletePayment(entry.key, entry.value.indexOf(payment));
                          },
                        ),
                      ),
                    );
                  }).toList(),
                  const SizedBox(height: 10),
                ],
              );
            }).toList(),
          ),
        ),
      ),
      backgroundColor: Colors.blue.shade50,
    );
  }

}