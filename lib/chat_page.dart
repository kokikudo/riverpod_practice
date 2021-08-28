import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:riverpod_practice/provider.dart';
import 'login.dart';
import 'add_post_page.dart';

// チャット画面用Widget
class ChatPage extends ConsumerWidget {
  @override
  Widget build(BuildContext context, ScopedReader watch) {
    // Userデータとsnapshotを受け取る
    final User user = watch(userProvider).state!;
    // snapshotの中身
    final AsyncValue<QuerySnapshot> asyncPostsQuery = watch(postsQueryProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text('チャット'),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.close),
            onPressed: () async {
              // signOut
              await FirebaseAuth.instance.signOut();
              // ログイン画面に遷移＋チャット画面を破棄
              await Navigator.of(context).pushReplacement(
                MaterialPageRoute(builder: (context) {
                  return LoginPage();
                }),
              );
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Container(
            padding: EdgeInsets.all(8),
            child: Text('ログイン情報:${user.email}'),
          ),
          // snapshotからデータを取得
          Expanded(
            // AsyncValue型のデータにある便利なメソッドwhen()
            // データ取得成功時、ロード時、エラー時のそれぞれの処理を書くことができる
            child: asyncPostsQuery.when(
              data: (QuerySnapshot query) {
                return ListView(
                    children: query.docs.map((doc) {
                  return Card(
                    child: ListTile(
                      title: Text(doc['text']),
                      subtitle: Text(doc['email']),
                      trailing: doc['email'] == user.email
                          ? IconButton(
                              onPressed: () async {
                                FirebaseFirestore.instance
                                    .collection('posts')
                                    .doc(doc.id)
                                    .delete();
                              },
                              icon: Icon(Icons.delete),
                            )
                          : null,
                    ),
                  );
                }).toList());
              },
              loading: () {
                return Center(
                  child: Text('読み込み中...'),
                );
              },
              error: (e, stackTrace) {
                return Center(
                  child: Text(e.toString()),
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () async {
          // 投稿画面に遷移
          await Navigator.of(context).push(
            MaterialPageRoute(builder: (context) {
              return AddPostPage();
            }),
          );
        },
      ),
    );
  }
}
