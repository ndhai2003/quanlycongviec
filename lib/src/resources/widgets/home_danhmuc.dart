import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/material.dart';


import '../../../main.dart';
import '../../blocs/auth_bloc.dart';
import 'home_chitietcv.dart';

class HomeDanhMuc extends StatefulWidget {
  String Contact_Key;
  String Contact_name;

  HomeDanhMuc({required this.Contact_Key,required this.Contact_name,});

  @override
  State<HomeDanhMuc> createState() => _HomeDanhMucState();
}


class _HomeDanhMucState extends State<HomeDanhMuc> {
  TextEditingController _infoController = TextEditingController();
  AuthBloc authBloc = new AuthBloc();

  DatabaseReference db_Ref1 =
  FirebaseDatabase.instance.ref().child('quantrong');

  DatabaseReference db_Ref =
  FirebaseDatabase.instance.ref().child('congviec');


  void _showInputDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Nhập thông tin'),
          content: TextField(
            controller: _infoController,
            decoration: InputDecoration(labelText: 'Thông tin'),
          ),
          actions: [
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context); // Đóng dialog
              },
              child: Text('Hủy'),
            ),
            ElevatedButton(
              onPressed: (){
                authBloc.createCV(user.uid,widget.Contact_Key ,_infoController.text);
                _infoController.text = "";
                Navigator.pop(context);
              },
              child: Text('Lưu'),
            ),
          ],
        );
      },
    );
  }

  void  _suaCV(String key,String txtString) {
    _infoController.text = txtString;
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Sửa thông tin Công Việc'),
          content: TextField(
            controller: _infoController,
            decoration: InputDecoration(labelText: "Thông tin ban đầu: $txtString"),
          ),
          actions: [
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context); // Đóng dialog
              },
              child: Text('Hủy'),
            ),
            ElevatedButton(
              onPressed: () {
                if (_infoController.text.isNotEmpty) {
                  // Kiểm tra trường thông tin không trống
                  authBloc.updateCV(key, _infoController.text);
                  print(key);
                  _infoController.text = "";
                  Navigator.pop(context);
                } else {
                  // Hiển thị thông báo nếu trường thông tin trống
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: Text('Lỗi'),
                        content: Text('Vui lòng nhập thông tin trước khi lưu.'),
                        actions: [
                          ElevatedButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            child: Text('OK'),
                          ),
                        ],
                      );
                    },
                  );
                }
              },
              child: Text('Lưu'),
            ),
          ],
        );
      },
    );

  }
  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      body: SafeArea(
        child: Container(
          height: double.infinity,
          color: Colors.black,
          padding: const  EdgeInsets.only(top: 30,left: 10,right: 10),
          child: SingleChildScrollView(
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Expanded(
                      child: Container(
                        alignment: Alignment.center,
                        child: Text(
                          " Danh mục:",
                          style: TextStyle(
                            fontSize: 25,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Expanded(
                      child: Container(
                        alignment: Alignment.center,
                        child: Text(
                          " ${widget.Contact_name}",
                          style: TextStyle(
                            fontSize: 25,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),

                Row(
                  children: [
                    IconButton(
                      icon: Icon(Icons.arrow_back,color: Colors.white,),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                    ),
                    Text('Quay lại', style: TextStyle(
                      color: Colors.white, // Màu sắc cho văn bản
                    ),),
                  ],
                ),



            FirebaseAnimatedList(
              query: db_Ref.orderByChild('key_danhmuc').equalTo(widget.Contact_Key),
              shrinkWrap: true,
              itemBuilder: (context, snapshot, animation, index) {
                if (snapshot.value == null) {
                  return Container(); // Return an empty container if there's no data
                }

                Map Contact = snapshot.value as Map;
                Contact['key'] = snapshot.key;

                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: ElevatedButton.icon(
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => HomeChitiet(
                                      Contact_Key: Contact['key'],Contact_name: Contact['name_congviec'],Contact_KeyDanhMuc: widget.Contact_Key ,
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
                                  // Call the function to update the status
                                  String? trangThai = await authBloc.checkStatus(Contact['key']);

                                  String newStatus = (trangThai == "true") ? "false" : "true";
                                  authBloc.Capnhaptrangthai(Contact['key'], newStatus);
                                  await Future.delayed(const Duration(milliseconds: 400));
                                  setState(()  {
                                    trangThai = (trangThai == "true") ? "false" : "true";


                                  });
                                },

                                icon: FutureBuilder<String?>(
                                  future: authBloc.checkStatus(Contact['key']),
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


                              label: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Expanded(
                                    child: Align(
                                      alignment: Alignment.centerLeft,
                                      child: Text(
                                        Contact['name_congviec'].toString(),
                                        style: TextStyle(fontSize: 18.0, color: Colors.white),
                                        softWrap: true,
                                      ),
                                    ),
                                  ),
                                  Row(
                                    children: [
                                      IconButton(
                                        onPressed: () {
                                          _suaCV(Contact['key'], Contact['name_congviec']);
                                        },
                                        icon: Icon(Icons.edit),
                                      ),
                                      Container(
                                        width: 40, // Adjust the width as needed
                                        child: IconButton(
                                          onPressed: () async {
                                            bool tonTai = await authBloc.kiemTraTonTai_Key_Quangtrong(Contact['key']);
                                            if (tonTai == false) {
                                              authBloc.createQuantrong(user.uid, widget.Contact_Key, Contact['key'], Contact['name_congviec']);
                                            } else {
                                              db_Ref1?.child(Contact['key']).remove();
                                            }
                                            setState(() {});
                                          },
                                          icon: FutureBuilder<bool>(
                                            future: authBloc.kiemTraTonTai_Key_Quangtrong(Contact['key']),
                                            builder: (context, snapshot) {
                                              if (snapshot.connectionState == ConnectionState.done) {
                                                bool? trangThai = snapshot.data;
                                                return trangThai == true
                                                    ? Icon(
                                                  Icons.star,
                                                  color: Colors.blue,
                                                )
                                                    : Icon(
                                                  Icons.star_border,
                                                  color: Colors.white,
                                                );
                                              } else {
                                                return const CircularProgressIndicator();
                                              }
                                            },
                                          ),
                                        ),
                                      ),
                                      IconButton(
                                        onPressed: () {
                                          db_Ref?.child(Contact['key']).remove();
                                        },
                                        icon: Icon(Icons.delete_forever),
                                      ),
                                    ],
                                  ),
                                ],
                              ),


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

      bottomNavigationBar: BottomAppBar(
        color: Colors.black,
        shape: const CircularNotchedRectangle(),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16), // Adjust the horizontal padding as needed
                child: ElevatedButton(
                  onPressed: () {
                    _showInputDialog();
                  },
                  style: ElevatedButton.styleFrom(
                    primary: Colors.indigo[400], // Set the background color
                  ),
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.add, // Replace with your desired icon
                        color: Colors.white,
                      ),
                      SizedBox(width: 8), // Adjust the spacing between icon and text
                      Text(
                        'Thêm Công Việc',
                        style: TextStyle(color: Colors.white),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            // Add more IconButton or ElevatedButton widgets as needed
          ],
        ),
      ),






    );
  }
}
