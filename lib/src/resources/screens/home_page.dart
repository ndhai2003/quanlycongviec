
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/material.dart';

import '../../../main.dart';
import '../../blocs/auth_bloc.dart';
import '../widgets/home_changeInfo.dart';
import '../widgets/home_danhmuc.dart';
import '../widgets/home_hoanthanh.dart';
import '../widgets/home_ngaycuatoi.dart';
import '../widgets/home_ngaydenhan.dart';
import '../widgets/home_quantrong.dart';
import 'login_page.dart';


class HomePage extends StatefulWidget {

  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}


class _HomePageState extends State<HomePage> {
  TextEditingController _infoController = TextEditingController();
  AuthBloc authBloc = new AuthBloc();
  DatabaseReference? db_Ref1;
  String? hovaten="";

@override
  void initState() {
    // TODO: implement initState
    super.initState();
    db_Ref1 = FirebaseDatabase.instance.ref().child('users');
    Contactt_data();
  }
  void Contactt_data() async {

    DataSnapshot snapshot = await db_Ref1!.child(user.uid).get();
    Map Contact = snapshot.value as Map;
    setState(() {
      hovaten = Contact['name'];
      print("Xin Chao: " +Contact['name']);

    });
  }

  DatabaseReference db_Ref =
  FirebaseDatabase.instance.ref().child('danhmuc');
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
               authBloc.createDanhMuc(user.uid, _infoController.text);
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

  void  _suaDanhmuc(String key,String txtString) {
    _infoController.text = txtString;
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Sửa thông tin Danh Mục'),
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
                  authBloc.updateDanhmuc(key, _infoController.text);
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
      body:
      SafeArea(

          child: Container(
            height: double.infinity,
              color: Colors.black,
              padding: const  EdgeInsets.only(top: 30,left: 10,right: 10),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    InkWell(
                        onTap: () {
                        // Xử lý khi nhấn vào ListTile
                        Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => HomeChangPass(), // Thay thế YourNewPage() bằng trang mới bạn muốn mở
                              ),
                            );
                        },
                      child: ListTile(
                        title: Column(
                          children: [
                            Text(
                              "Xin Chào",
                              style: TextStyle(fontSize: 25, color: Colors.cyan),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Icons.perm_identity_rounded, color: Colors.redAccent),
                                SizedBox(width: 8),
                                Text(
                                  hovaten ?? "",
                                  style: TextStyle(fontSize: 25, color: Colors.cyan),
                                ),
                                SizedBox(width: 8),
                                Icon(Icons.settings, color: Colors.yellow), // Thêm biểu tượng ở cuối dòng
                              ],
                            ),
                          ],
                        ),
                      ),

                    ),

                  Row(
                      children: [
                        Expanded(
                          child: ElevatedButton.icon(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => NgayCuaToi(),
                                ),
                              );
                            },
                            style: ElevatedButton.styleFrom(
                              padding: EdgeInsets.all(16.0),
                              primary: Colors.black, // Màu nền của nút
                            ),
                            icon: Icon(
                              Icons.sunny, // Chọn biểu tượng mong muốn
                              size: 24.0,color: Colors.yellow[300],
                            ),
                            label:  const  Align(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                'Ngày của Tôi',
                                style: TextStyle(fontSize: 18.0,color: Colors.white),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: [

                        Expanded(
                          child: ElevatedButton.icon(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => HomeQuantrong(),
                                ),
                              );
                            },
                            style: ElevatedButton.styleFrom(
                              padding: EdgeInsets.all(16.0),
                              primary: Colors.black, // Màu nền của nút
                            ),
                            icon: Icon(
                              Icons.star_border, // Chọn biểu tượng mong muốn
                              size: 24.0,color: Colors.pink[400],
                            ),
                            label: const  Align(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                'Quan Trọng',
                                style: TextStyle(fontSize: 18.0,color: Colors.white),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: [

                        Expanded(
                          child: ElevatedButton.icon(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => HomeNgaydenhan(),
                                ),
                              );
                            },
                            style: ElevatedButton.styleFrom(
                              padding: EdgeInsets.all(16.0),
                              primary: Colors.black, // Màu nền của nút
                            ),
                            icon: Icon(
                              Icons.calendar_today_outlined, // Chọn biểu tượng mong muốn
                              size: 24.0,color: Colors.green[300],
                            ),
                            label: const  Align(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                'Đã lập kế hoạch',
                                style: TextStyle(fontSize: 18.0,color: Colors.white),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: ElevatedButton.icon(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => const HomeHoanThanh(),
                                ),
                              );

                            },
                            style: ElevatedButton.styleFrom(
                              padding: EdgeInsets.all(16.0),
                              primary: Colors.black, // Màu nền của nút
                            ),
                            icon: Icon(
                              Icons.check_box_outlined, // Chọn biểu tượng mong muốn
                              size: 24.0,color: Colors.blue[200],
                            ),

                            label: const  Align(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                'Công Việc Đã Hoàn Thành',
                                style: TextStyle(fontSize: 18.0,color: Colors.white),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: [

                        Expanded(
                          child: ElevatedButton.icon(
                            onPressed: () {
                              authBloc.LogOut();
                              Navigator.pushAndRemoveUntil(
                                context,
                                MaterialPageRoute(builder: (context) => LoginPage()),
                                    (Route<dynamic> route) => false,
                              );
                            },
                            style: ElevatedButton.styleFrom(
                              padding: EdgeInsets.all(16.0),
                              primary: Colors.black, // Màu nền của nút
                            ),
                            icon: Icon(
                              Icons.logout, // Chọn biểu tượng mong muốn
                              size: 24.0,color: Colors.blue[200],
                            ),

                            label: const  Align(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                'Đăng Xuất',
                                style: TextStyle(fontSize: 18.0,color: Colors.white),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const Divider(
                      thickness: 0.5,
                      color: Colors.white,
                      height: 9,
                    ),
                    FirebaseAnimatedList(
                        query: db_Ref.orderByChild('user_key').equalTo(user.uid),
                        shrinkWrap: true,
                        itemBuilder: (context,snapshot,animation, index){
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
                                            builder: (_) => HomeDanhMuc(
                                              Contact_Key: Contact['key'],Contact_name: Contact['name'],
                                            ),
                                          ),
                                      );
                                    },
                                    style: ElevatedButton.styleFrom(
                                      padding: EdgeInsets.all(5),
                                     // primary: Colors.black,
                                      primary: Colors.blueGrey, // Màu nền của nút// Màu nền của nút
                                    ),
                                    icon: Container(
                                      padding: EdgeInsets.all(10.0),
                                      child: Icon(
                                        Icons.menu_open, // Chọn biểu tượng mong muốn
                                        size: 24.0,color: Colors.red[300],
                                      ),
                                    ),
                                    label: Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Expanded(
                                          child: Align(
                                            alignment: Alignment.centerLeft,
                                            child: Text(
                                              Contact['name'].toString(),
                                              style: TextStyle(fontSize: 18.0, color: Colors.white),
                                              softWrap: true, // Allow text to wrap onto multiple lines
                                            ),
                                          ),
                                        ),
                                        Row(
                                          children: [
                                            IconButton(
                                              onPressed: () {
                                                _suaDanhmuc(Contact['key'], Contact['name']);
                                              },
                                              icon: Icon(Icons.edit),
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
                    }
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
                        'Thêm Danh Mục',
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
