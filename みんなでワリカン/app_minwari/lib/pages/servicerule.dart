import 'package:flutter/material.dart';

class servicerule extends StatelessWidget {
  const servicerule({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFE0ECF8), // 背景色
      appBar: AppBar(
        backgroundColor: const Color(0xFF75A9D6),
        title: const Text(
          '利用規約',
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 32.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const [
                                    const Text(
                '''
この利用規約（以下、「本規約」といいます。）は、Webアプリ「みんなで割り勘」（以下、「本サービス」といいます。）をご利用いただく際の条件やルールを定めるものです。本サービスをご利用いただくユーザー（以下、「ユーザー」といいます。）には、本規約を十分にご確認いただき、内容をご理解いただいた上で、本サービスをご利用いただくことが求められます。本サービスの利用を開始することで、本規約に同意いただいたものとみなされますので、もし本規約のいずれかに同意いただけない場合には、本サービスの利用をお控えください。本サービスを利用することで、ユーザーは、本規約に定められた全ての条件に従うことを承諾したものとみなされます。
''',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 24),
                      Text(
                        '第1条 本規約の適用について',
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(height: 8),
                      Text(
                        '本規約は、ユーザーが本サービスを利用する際に生じる全ての関係に適用されるものとします。本規約は、本サービスを提供する運営者とユーザーとの間における基本的なルールを定めるものであり、ユーザーが本サービスにアクセスし利用を開始した時点で、本規約に同意したものとみなされます。また、本サービスを利用する過程で追加のルールやガイドラインが提示される場合、本規約の一部として扱われます。万が一、本規約と個別のガイドラインに矛盾が生じた場合には、特段の定めがない限り、当該ガイドラインが優先して適用されるものとします。',
                        style: TextStyle(fontSize: 16),
                      ),
                      SizedBox(height: 16),
                      Text(
                        '第2条 本サービスの目的および提供内容',
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(height: 8),
                      Text(
                        '本サービスは、複数人で行う割り勘計算を効率化し、金銭的なやり取りにおける煩雑さを軽減することを目的として設計されたWebアプリケーションです。本サービスは、ユーザーが支払額や人数などの情報を入力することで、簡単かつ迅速に割り勘の金額を計算し、結果を表示する機能を提供します。しかしながら、本サービスが提供する機能は、あくまでも計算結果を提示するものであり、実際の金銭のやり取りを代行したり、責任を持つものではありません。',
                        style: TextStyle(fontSize: 16),
                      ),
                      SizedBox(height: 16),
                      Text(
                        '第3条 サービスの利用条件',
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(height: 8),
                      Text(
                        '本サービスは、個々のユーザーに対して均等にサービスを提供することを目指しており、運営者はユーザー間の公平性を保つために、適切な技術的および運用上の対応を行っています。しかし、特定の環境や状況下において、本サービスの一部機能が利用できない場合があることをご了承ください。',
                        style: TextStyle(fontSize: 16),
                      ),
                      SizedBox(height: 16),
                      Text(
                        '第4条 禁止事項',
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(height: 8),
                      Text(
                        '''ユーザーが本サービスを利用するにあたり、以下に定める行為は禁止されています。これらの禁止事項に違反した場合、運営者は該当するユーザーに対して、本サービスの利用停止や登録抹消などの措置を講じることがあります。\n
・法令や公序良俗に反する行為を行うこと\n
・犯罪行為や犯罪行為を助長する恐れのある行為を行うこと\n
・本サービスのサーバーやネットワークに不正にアクセスし、またはその機能を妨害する行為を行うこと\n
・他のユーザーに対して不利益を与える行為や嫌がらせを行うこと\n
・他人になりすまして本サービスを利用する行為を行うこと\n
・本サービスの提供に関連して、反社会的勢力に対して利益を供与する行為を行うこと\n
・その他、運営者が不適切と判断する行為を行うこと\n
運営者は、これらの禁止事項を遵守しないユーザーに対して、事前通知なくサービス利用を停止または制限する権利を有します。また、必要に応じて、法的措置を講じる場合があります。
                        ''',
                        style: TextStyle(fontSize: 16),
                      ),
                      SizedBox(height: 16),
                      Text(
                        '第5条 サービスの中断・停止について',
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(height: 8),
                      Text(
                        '''運営者は、以下の理由により本サービスの全部または一部を事前通知なしに中断または停止する場合があります。\n
・システムの保守や点検、更新を行う必要がある場合\n
・地震、火災、停電などの自然災害や不可抗力によりサービス提供が困難となった場合\n
・コンピュータや通信回線の障害が発生した場合\n
・その他、運営者がサービスの提供を継続することが困難と判断した場合\n
本サービスの中断または停止により、ユーザーが被るいかなる不利益や損害についても、運営者は一切の責任を負わないものとします。\n
''',
                        style: TextStyle(fontSize: 16),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF75A9D6), // ボタンの背景色
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
                ),
                child: const Text(
                  '閉じる',
                  style: TextStyle(color: Colors.white, fontSize: 16),
                ),
              ),
              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }
}
