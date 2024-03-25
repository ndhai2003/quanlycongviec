import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/material.dart';

import '../../../main.dart';
import '../../blocs/auth_bloc.dart';
import 'home_chitietcv.dart';

class HomeHoanThanh extends StatefulWidget {
  const HomeHoanThanh({Key? key});

  @override
  State<HomeHoanThanh> createState() => _HomeHoanThanhState();
}

class _HomeHoanThanhState extends State<HomeHoanThanh> {
  TextEditingController _infoController = TextEditingController();
  AuthBloc authBloc = AuthBloc();

  DatabaseReference dbRef = FirebaseDatabase.instance.ref().child('congviec');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          height: double.infinity,
          color: Colors.black,
          padding: const EdgeInsets.only(top: 30, left: 10, right: 10),
          child: SingleChildScrollView(
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Danh Mục: Hoàn Thành",
                      style: TextStyle(
                        fontSize: 25,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
                Row(
                  children: [
                    IconButton(
                      icon: Icon(Icons.arrow_back, color: Colors.white),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                    ),
                    Text(
                      'Quay lại',
                      style: TextStyle(
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
                FirebaseAnimatedList(
                  query: dbRef.orderByChild('user_key').equalTo(user.uid),
                  shrinkWrap: true,
                  itemBuilder: (context, snapshot, animation, index) {
                    if (snapshot.value == null) {
                      return Container();
                    }

                    Map Contact = snapshot.value as Map;
                    Contact['key'] = snapshot.key;

                    return Padding(
                      padding: const EdgeInsets.all(7.0),
                      child: Column(
                        children: [
                          Row(
                            children: [
                              Expanded(
                                child: FutureBuilder<String?>(
                                  future: authBloc.checkStatus(Contact['key']),
                                  builder: (context, statusSnapshot) {
                                    if (statusSnapshot.connectionState == ConnectionState.done) {
                                      bool trangThai = statusSnapshot.data == 'true';
                                      if (!trangThai) {
                                        return Container();
                                      }

                                      return ElevatedButton.icon(
                                        onPressed: () async {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (_) => HomeChitiet(
                                                Contact_Key: Contact['key'],
                                                Contact_name: Contact['name_congviec'],
                                                Contact_KeyDanhMuc: Contact['key_danhmuc'],
                                              ),
                                            ),
                                          );
                                        },
                                        style: ElevatedButton.styleFrom(
                                          primary: Colors.blueGrey,
                                          padding: EdgeInsets.all(5.0),
                                        ),
                                        icon: Container(
                                          padding: EdgeInsets.all(8.0),
                                          child: Icon(
                                            trangThai ? Icons.check_circle : Icons.circle,
                                            color: trangThai ? Colors.blue : Colors.white,
                                          ),
                                        ),
                                        label: FutureBuilder<String?>(
                                          future: authBloc.checkNgayvagio(Contact['key'].toString()),
                                          builder: (context, snapshot) {
                                            if (snapshot.connectionState == ConnectionState.waiting) {
                                              return CircularProgressIndicator();
                                            } else if (snapshot.hasError) {
                                              return Text('Đã xảy ra lỗi: ${snapshot.error}');
                                            } else {
                                              String? ngayvagio = snapshot.data;

                                              print(ngayvagio);

                                              return Column(
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: [
                                                  Row(
                                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                    children: [
                                                      Expanded(
                                                        child: Align(
                                                          alignment: Alignment.centerLeft,
                                                          child: Text("Công việc: "+
                                                              Contact['name_congviec'].toString(),
                                                            style: TextStyle(fontSize: 18.0, color: Colors.white),
                                                            softWrap: true,
                                                          ),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                  Row(
                                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                    children: [
                                                      Expanded(
                                                        child: Column(
                                                          children: [
                                                            Row(
                                                              children: [
                                                                Icon(
                                                                  Icons.notifications,
                                                                  color: Colors.white,
                                                                ),
                                                                SizedBox(width: 8),
                                                                Text(
                                                                  ngayvagio ?? 'Chưa cài thông báo',
                                                                  style: TextStyle(fontSize: 13.0, color: Colors.white),
                                                                ),
                                                              ],
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                      Row(
                                                        children: [
                                                          IconButton(
                                                            onPressed: () {
                                                              dbRef.child(Contact['key']).remove();
                                                            },
                                                            icon: Icon(Icons.delete_forever),
                                                          ),
                                                        ],
                                                      ),
                                                    ],
                                                  ),
                                                ],
                                              );
                                            }
                                          },
                                        ),
                                      );
                                    } else {
                                      return const CircularProgressIndicator();
                                    }
                                  },
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
