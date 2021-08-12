import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:weighttrackerapp/pages/edit.dart';
import 'package:weighttrackerapp/pages/login.dart';

class ListPage extends StatefulWidget {
  ListPage({Key? key, this.id}) : super(key: key);
  final id;
  @override
  _ListPageState createState() => _ListPageState();
}

class _ListPageState extends State<ListPage> {
  final Stream<QuerySnapshot> listStream =
      FirebaseFirestore.instance.collection('weight').snapshots();

  // For Deleting User
  CollectionReference weight = FirebaseFirestore.instance.collection('weight');

  Future<void> deleteUser(id) {
    // print("User Deleted $id");
    return weight
        .doc(id)
        .delete()
        .then(
          (value) =>
              // print('User Deleted')

              ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              backgroundColor: Colors.redAccent,
              content: Text(
                "Weight Deleted",
                style: TextStyle(fontSize: 18.0),
              ),
            ),
          ),
        )
        .catchError((error) => //print('Failed to Delete user: $error')

            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                backgroundColor: Colors.redAccent,
                content: Text(
                  "user not delete",
                  style: TextStyle(fontSize: 18.0),
                ),
              ),
            ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("List Page"),
      ),
      body: StreamBuilder<QuerySnapshot>(
          stream: listStream,
          builder:
              (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (snapshot.hasError) {
              print('Something went wrong');
            }

            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(
                child: CircularProgressIndicator(),
              );
            }

            final List weight = [];
            FirebaseFirestore.instance
                .collection('weight')
                .orderBy('createdAt', descending: true && true)
                .get();
            snapshot.data!.docs.map((DocumentSnapshot document) {
              Map a = document.data() as Map<String, dynamic>;
              weight.add(a);
              a['id'] = document.id;
            }).toList();

            return Container(
              margin: EdgeInsets.symmetric(horizontal: 10.0, vertical: 10.0),
              child: SingleChildScrollView(
                scrollDirection: Axis.vertical,
                child: Column(
                  children: [
                    Table(
                      border: TableBorder.all(),
                      columnWidths: const <int, TableColumnWidth>{
                        1: FixedColumnWidth(110),
                      },
                      defaultVerticalAlignment:
                          TableCellVerticalAlignment.middle,
                      children: [
                        TableRow(
                          children: [
                            TableCell(
                              child: Container(
                                height: 40,
                                color: Colors.greenAccent,
                                child: Center(
                                  child: Text(
                                    'Weight',
                                    style: TextStyle(
                                      fontSize: 20.0,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            TableCell(
                              child: Container(
                                height: 40,
                                color: Colors.greenAccent,
                                child: Center(
                                  child: Text(
                                    'Time',
                                    style: TextStyle(
                                      fontSize: 20.0,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            TableCell(
                              child: Container(
                                height: 40,
                                color: Colors.greenAccent,
                                child: Center(
                                  child: Text(
                                    'Action',
                                    style: TextStyle(
                                      fontSize: 20.0,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        for (var i = 0; i < weight.length; i++) ...[
                          TableRow(
                            children: [
                              TableCell(
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Center(
                                      child: Text(weight[i]['weight'],
                                          style: TextStyle(fontSize: 12.0))),
                                ),
                              ),
                              TableCell(
                                child: Padding(
                                  padding: const EdgeInsets.all(4.0),
                                  child: Center(
                                      child: Text(weight[i]['time'].toString(),
                                          style: TextStyle(fontSize: 12.0))),
                                ),
                              ),
                              TableCell(
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    IconButton(
                                      onPressed: () => {
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) => UpdatePage(
                                                  id: weight[i]['id']),
                                            )),
                                      },
                                      icon: Icon(
                                        Icons.edit,
                                        color: Colors.orange,
                                      ),
                                    ),
                                    IconButton(
                                      onPressed: () {
                                        deleteUser(weight[i]['id']);
                                      },
                                      icon: Icon(
                                        Icons.delete,
                                        color: Colors.red,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ],
                      ],
                    ),
                    ElevatedButton(
                        onPressed: () async => {
                              await FirebaseAuth.instance.signOut(),
                              Navigator.pushAndRemoveUntil(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => Login(),
                                  ),
                                  (route) => false)
                            },
                        child: Text('SignOut'))
                  ],
                ),
              ),
            );
          }),
    );
  }
}
