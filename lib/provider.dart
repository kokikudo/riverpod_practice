import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// user情報
final userProvider = StateProvider((ref) => FirebaseAuth.instance.currentUser);

// ログイン失敗時のテキスト。autoDisposeをつけて自動的に値をリセット
final infoTextProvider = StateProvider.autoDispose((ref) => '');

// メールアドレス、パスワード、メッセージの受け渡し
final emailProvider = StateProvider.autoDispose((ref) => '');
final passwordProvider = StateProvider.autoDispose((ref) => '');
final messageTextProvider = StateProvider.autoDispose((ref) => '');

// Stream式でsnapshotを取得するProvider
final postsQueryProvider = StreamProvider.autoDispose(
  (ref) {
    return FirebaseFirestore.instance
        .collection('posts')
        .orderBy('date')
        .snapshots();
  },
);
