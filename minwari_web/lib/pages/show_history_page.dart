import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:study_flutter_firebase/pages/privacypolicy.dart';
import 'package:study_flutter_firebase/pages/servicerule.dart';
import 'package:study_flutter_firebase/pages/our_information.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

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
  List<String> currencies = [
    //
    'USD', 'AED', 'AFN', 'ALL', 'AMD', 'ANG', 'AOA', 'ARS', 'AUD', 'AWG', 'AZN',
    'BAM', 'BBD', 'BDT', 'BGN', 'BHD', 'BIF', 'BMD', 'BND', 'BOB', 'BRL', 'BSD',
    'BTN', 'BWP', 'BYN', 'BZD', 'CAD', 'CDF', 'CHF', 'CLP', 'CNY', 'COP', 'CRC',
    'CUP', 'CVE', 'CZK', 'DJF', 'DKK', 'DOP', 'DZD', 'EGP', 'ERN', 'ETB', 'EUR',
    'FJD', 'FKP', 'FOK', 'GBP', 'GEL', 'GGP', 'GHS', 'GIP', 'GMD', 'GNF', 'GTQ',
    'GYD', 'HKD', 'HNL', 'HRK', 'HTG', 'HUF', 'IDR', 'ILS', 'IMP', 'INR', 'IQD',
    'IRR', 'ISK', 'JEP', 'JMD', 'JOD', 'JPY', 'KES', 'KGS', 'KHR', 'KID', 'KMF',
    'KRW', 'KWD', 'KYD', 'KZT', 'LAK', 'LBP', 'LKR', 'LRD', 'LSL', 'LYD', 'MAD',
    'MDL', 'MGA', 'MKD', 'MMK', 'MNT', 'MOP', 'MRU', 'MUR', 'MVR', 'MWK', 'MXN',
    'MYR', 'MZN', 'NAD', 'NGN', 'NIO', 'NOK', 'NPR', 'NZD', 'OMR', 'PAB', 'PEN',
    'PGK', 'PHP', 'PKR', 'PLN', 'PYG', 'QAR', 'RON', 'RSD', 'RUB', 'RWF', 'SAR',
    'SBD', 'SCR', 'SDG', 'SEK', 'SGD', 'SHP', 'SLE', 'SLL', 'SOS', 'SRD', 'SSP',
    'STN', 'SYP', 'SZL', 'THB', 'TJS', 'TMT', 'TND', 'TOP', 'TRY', 'TTD', 'TVD',
    'TWD', 'TZS', 'UAH', 'UGX', 'UYU', 'UZS', 'VES', 'VND', 'VUV', 'WST', 'XAF',
    'XCD', 'XDR', 'XOF', 'XPF', 'YER', 'ZAR', 'ZMW', 'ZWL'
  ];

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

  void _navigateToPrivacyPolicy(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const PrivacyPolicyPage()),
    );
  }

  Future<double> _convertToJPY(double amount, String? currency) async {
    if (currency == 'JPY') {
      return amount;
    }

    final url =
        'https://v6.exchangerate-api.com/v6/645a1985815f1f802148fe2f/latest/$currency';
    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final rates = json.decode(response.body)['conversion_rates'];
      if (rates.containsKey('JPY')) {
        double rate = rates['JPY'];
        return amount * rate;
      }
    }
    throw Exception("通貨レートの取得に失敗しました");
  }

  Future<void> editPayment(String participant, int index) async {
    var payment = amounts[participant]?[index];
    if (payment == null) return;

    final TextEditingController amountController = TextEditingController(
      text: (payment['originalAmount'] != null)
          ? payment['originalAmount'].toString()
          : payment['amount'].toString(),
    );
    final TextEditingController memoController = TextEditingController(
      text: payment['memo'] ?? '',
    );
    String selectedCurrency = payment['originalCurrency'] ?? 'JPY'; // デフォルトの通貨

    final result = await showDialog<Map<String, dynamic>>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("支払いを編集"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              DropdownButton<String>(
                value: selectedCurrency,
                onChanged: (String? newValue) {
                  setState(() {
                    selectedCurrency = newValue!;
                  });
                },
                items: currencies.map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
                hint: const Text('通貨を選択'),
              ),
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
                  'originalAmount': double.tryParse(amountController.text),
                  'memo': memoController.text,
                  'originalCurrency': selectedCurrency
                });
              },
              child: const Text("保存"),
            ),
          ],
        );
      },
    );

    if (result != null && result['originalAmount'] != null) {
      try {
        // 通貨変換を待機
        double convertedAmount = await _convertToJPY(
          result['originalAmount'],
          result["originalCurrency"],
        );

        Timestamp now = Timestamp.now();

        var updatedPayment = {
          'originalAmount': result['originalAmount'],
          'memo': result['memo'],
          'originalCurrency': result['originalCurrency'],
          'amount': convertedAmount,
          'date': now
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
    final screenWidth = MediaQuery.of(context).size.width;

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
                        "一人当たりの合計金額: ¥$perPersonPayment",
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
                                contentPadding: screenWidth < 600
                                    ? const EdgeInsets.all(8.0)
                                    : const EdgeInsets.symmetric(
                                        horizontal: 16.0),
                                title: Text(
                                    (payment['originalCurrency'] != null &&
                                            payment['originalAmount'] != null &&
                                            payment['originalCurrency']
                                                is! List)
                                        ? '${payment['originalCurrency']} ${payment['originalAmount']}'
                                        : 'JPY ${payment['amount']}',
                                    style: TextStyle(
                                      fontSize: screenWidth < 600 ? 14 : 16,
                                      fontFamily: "Roboto",
                                    )),
                                subtitle: Text(memoText,
                                    style: TextStyle(
                                      color: Colors.grey[600],
                                      fontFamily: "Roboto",
                                      fontSize: screenWidth < 600 ? 12 : 14,
                                    )),
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
                    const SizedBox(height: 40),
                    const Divider(),
                    const SizedBox(height: 20),
                    Wrap(
                      spacing: 8.0,
                      runSpacing: 8.0,
                      alignment: WrapAlignment.start,
                      children: [
                        TextButton(
                          onPressed: () => _navigateToPrivacyPolicy(context),
                          child: const Text(
                            'プライバシーポリシー',
                            style:
                                TextStyle(fontSize: 16, color: Colors.blueGrey),
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
                            style:
                                TextStyle(fontSize: 16, color: Colors.blueGrey),
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
                            style:
                                TextStyle(fontSize: 16, color: Colors.blueGrey),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 40),
                  ],
                ),
              ),
            ),
      backgroundColor: const Color(0xFFE0ECF8),
    );
  }
}
