import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/material.dart';


import '../../../main.dart';
import '../../blocs/auth_bloc.dart';
import 'home_chitietcv.dart';


class HomeQuantrong extends StatefulWidget {
  const HomeQuantrong({super.key});

  @override
  State<HomeQuantrong> createState() => _HomeQuantrongState();
}


class _HomeQuantrongState extends State<HomeQuantrong> {

  AuthBloc authBloc = new AuthBloc();
  DatabaseReference db_Ref =
  FirebaseDatabase.instance.ref().child('quantrong');

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      body:
      SafeArea(

        child: Container(
          height: double.infinity,
          color: Colors.black,
          padding: const  EdgeInsets.only(top: 30,left: 10,right: 10),
          child: SingleChildScrollView(
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center, // Canh giữa theo chiều ngang

                  children: [
                    Text( "Danh mục: Quan Trọng",style: TextStyle(
                        fontSize: 25,
                        fontWeight: FontWeight.bold,
                        color: Colors.white
                    ),)
                  ],),
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
                  query: db_Ref.orderByChild('user_key').equalTo(user.uid),
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
                                          Contact_Key: Contact['key'],Contact_name: Contact['name_congviec'],Contact_KeyDanhMuc:  Contact['key_danhmuc'] ,
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
                                                        db_Ref?.child(Contact['key']).remove();
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
