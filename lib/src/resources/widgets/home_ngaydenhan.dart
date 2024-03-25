import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/material.dart';

import '../../../main.dart';
import '../../blocs/auth_bloc.dart';
import 'home_chitietcv.dart';

class HomeNgaydenhan extends StatefulWidget {
  const HomeNgaydenhan({Key? key}) : super(key: key);

  @override
  State<HomeNgaydenhan> createState() => _HomeNgaydenhanState();
}

class _HomeNgaydenhanState extends State<HomeNgaydenhan> {
  TextEditingController _infoController = TextEditingController();
  AuthBloc authBloc = AuthBloc();
  DatabaseReference dbRef = FirebaseDatabase.instance.ref().child('ngaydenhan');


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
                      "Danh mục: Ngày Đến Hạn",
                      style: TextStyle(
                        fontSize: 25,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    )
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
                _buildTaskList(true, 'Công việc đã hết hạn'),
                _buildTaskList(false, 'Công việc chưa hết hạn'),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTaskList(bool isExpired, String title) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 10),
          child: Text(
            title,
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),
          ),
        ),
        FirebaseAnimatedList(
          query: dbRef.orderByChild('user_key').equalTo(user.uid),
          shrinkWrap: true,
          itemBuilder: (context, snapshot, animation, index) {
            if (snapshot.value == null) {
              return Container(); // Return an empty container if there's no data
            }
            Map Contact = snapshot.value as Map;
            Contact['key'] = snapshot.key;

            bool isTaskExpired = DateTime.now().isAfter(
              DateTime.parse(Contact['ngay'] + ' 23:59:59'), // Append the time to make it end of day
            );

            if (isExpired && isTaskExpired) {
              return _buildTaskItem(Contact, isExpired);
            } else if (!isExpired && !isTaskExpired) {
              return _buildTaskItem(Contact, isExpired);
            } else {
              return Container(); // Return an empty container if the task doesn't match the criteria
            }
          },
        ),
      ],
    );
  }

  Widget _buildTaskItem(dynamic taskData, bool isExpired) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: ElevatedButton.icon(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => HomeChitiet(
                Contact_Key: taskData['key'],
                Contact_name: taskData['name_congviec'],
                Contact_KeyDanhMuc: taskData['key_danhmuc'],
              ),
            ),
          );
        },
        style: ElevatedButton.styleFrom(
          padding: EdgeInsets.all(5.0),
          primary: Colors.blueGrey,
        ),
        icon: IconButton(
          onPressed: () async {
            String? trangThai = await authBloc.checkStatus(taskData['key']);
            String newStatus = (trangThai == "true") ? "false" : "true";
            authBloc.Capnhaptrangthai(taskData['key'], newStatus);
            await Future.delayed(const Duration(milliseconds: 400));
            setState(() {
              trangThai = (trangThai == "true") ? "false" : "true";
            });
          },
          icon: FutureBuilder<String?>(
            future: authBloc.checkStatus(taskData['key']),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                String? trangThai = snapshot.data;
                return trangThai == 'true'
                    ? Icon(
                  Icons.check_circle,
                  color: Colors.blue,
                )
                    : Icon(
                  Icons.circle,
                  color: Colors.white,
                );
              } else {
                return const CircularProgressIndicator();
              }
            },
          ),
        ),
        label: FutureBuilder<String?>(
          future: authBloc.checkNgayvagio(taskData['key'].toString()),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return CircularProgressIndicator();
            } else if (snapshot.hasError) {
              return Text('Đã xảy ra lỗi: ${snapshot.error}');
            } else {
              String? ngayvagio = snapshot.data;

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
                            taskData['name_congviec'].toString(),
                            style: TextStyle(fontSize: 18.0, color: Colors.white),
                            softWrap: true,
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 3), // Khoảng cách giữa các dòng
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
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
                          Row(
                            children: [
                              Text(
                                isExpired ? 'Đã hết hạn ' : 'Đến Hạn: ',
                                style: TextStyle(fontSize: 13.0, color: isExpired ? Colors.red : Colors.white),
                              ),
                              SizedBox(height: 3), // Khoảng cách giữa các dòng
                              Text(
                                isExpired ? '' : '${taskData['ngay']}',
                                style: TextStyle(fontSize: 13.0, color: Colors.white),
                              ),
                            ],
                          ),
                        ],
                      ),
                      SizedBox(width: 3), // Khoảng cách giữa các cột

                      Column(
                        children: [
                          IconButton(
                            onPressed: () {
                              dbRef?.child(taskData['key']).remove();
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
      ),
    );
  }
}
