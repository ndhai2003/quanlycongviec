
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import '../../../main.dart';
import '../../blocs/auth_bloc.dart';
import '../dialog/loading_dialog.dart';
import '../dialog/msg_dilog.dart';
import '../screens/home_page.dart';


class HomeChangPass extends StatefulWidget {
  @override
  _HomeChangPass createState() => _HomeChangPass();
}

class _HomeChangPass extends State<HomeChangPass> {

  final TextEditingController _newpassController = TextEditingController();
  final TextEditingController _newpassController1 = TextEditingController();
  final TextEditingController _passController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  AuthBloc authBloc = new AuthBloc();
  DatabaseReference? db_Ref;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    db_Ref = FirebaseDatabase.instance.ref().child('users');
    Contactt_data();
  }
  void Contactt_data() async {
    DataSnapshot snapshot = await db_Ref!.child(user.uid).get();
    Map Contact = snapshot.value as Map;
    setState(() {
      _nameController.text = Contact['name'];
      _phoneController.text =Contact['phone'];
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: EdgeInsets.fromLTRB(30, 0, 30, 0),
        constraints: BoxConstraints.expand(),
        color: Colors.white,
        child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              SizedBox(
                height: 30,
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(0, 20, 0, 6),
                child: Text(
                  "Đổi thông tin thành viên",
                  style: TextStyle(fontSize: 22, color: Color(0xff333333)),
                ),
              ),

              Padding(
                padding: const EdgeInsets.fromLTRB(0, 50, 0, 20),
                child: TextFormField(
                  controller: _nameController,
                  style: TextStyle(fontSize: 18, color: Colors.black, ),
                  decoration: InputDecoration(
                    labelText: "Họ và Tên",
                    prefixIcon: const Icon(Icons.person),
                    border: OutlineInputBorder(
                      borderSide:
                      BorderSide(color: Color(0xffCED0D2), width: 1),
                      borderRadius: BorderRadius.all(Radius.circular(30)),
                    ),
                  ),
                ),
              ),

              Padding(
                padding: const EdgeInsets.fromLTRB(0, 0, 0, 20),
                child: TextFormField(
                  controller: _phoneController,
                  style: TextStyle(fontSize: 18, color: Colors.black),
                  decoration: InputDecoration(
                      labelText: "Phone",
                      prefixIcon: const Icon(Icons.phone),
                      border: OutlineInputBorder(
                          borderSide:
                          BorderSide(color: Color(0xffCED0D2), width: 1),
                          borderRadius: BorderRadius.all(Radius.circular(30)))),
                ),
              ),
              StreamBuilder(
                  stream: authBloc.passStream,
                  builder: (context, snapshot) => TextField(
                    controller: _passController,
                    obscureText: true,
                    style: TextStyle(fontSize: 18, color: Colors.black),
                    decoration: InputDecoration(
                        errorText:
                        snapshot.hasError ? snapshot.error.toString() : null,
                        labelText: "Mật Khẩu Cũ",
                        prefixIcon: const Icon(Icons.lock_outlined),
                        border: OutlineInputBorder(
                            borderSide:
                            BorderSide(color: Color(0xffCED0D2), width: 1),
                            borderRadius: BorderRadius.all(Radius.circular(30)))),
                  )),
              Padding(
                padding: const EdgeInsets.fromLTRB(0, 20, 0, 20),
                child:  StreamBuilder(
                    stream: authBloc.newpassStream,
                    builder: (context, snapshot) => TextField(
                      controller: _newpassController,
                      obscureText: true,
                      style: TextStyle(fontSize: 18, color: Colors.black),
                      decoration: InputDecoration(
                          errorText:
                          snapshot.hasError ? snapshot.error.toString() : null,
                          labelText: "Mật Khẩu Mới",
                          prefixIcon: const Icon(Icons.lock),
                          border: OutlineInputBorder(
                              borderSide:
                              BorderSide(color: Color(0xffCED0D2), width: 1),
                              borderRadius: BorderRadius.all(Radius.circular(30)))),
                    )),
              ),
              StreamBuilder(
                  stream: authBloc.newpassStream1,
                  builder: (context, snapshot) => TextField(
                    controller: _newpassController1,
                    obscureText: true,
                    style: TextStyle(fontSize: 18, color: Colors.black),
                    decoration: InputDecoration(
                        errorText:
                        snapshot.hasError ? snapshot.error.toString() : null,
                        labelText: "Xác Thực Mật Khẩu Mới",
                        prefixIcon: const Icon(Icons.lock),
                        border: OutlineInputBorder(
                            borderSide:
                            BorderSide(color: Color(0xffCED0D2), width: 1),
                            borderRadius: BorderRadius.all(Radius.circular(30)))),
                  )),

              Padding(
                padding: const EdgeInsets.symmetric(vertical: 30),
                child: SizedBox(
                  width: double.infinity,
                  height: 52,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () {
                            _onChangInFoClick();
                          },
                          style: ElevatedButton.styleFrom(
                            primary: Colors.blue,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(26),
                            ),
                          ),
                          child: Text(
                            "Lưu",
                            style: TextStyle(color: Colors.white, fontSize: 18),
                          ),
                        ),
                      ),
                      SizedBox(width: 16), // Khoảng cách giữa các nút
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () {

                            Navigator.of(context).pop();

                          },
                          style: ElevatedButton.styleFrom(
                            primary: Colors.black38,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(26),
                            ),
                          ),
                          child: Text(
                            "Quay lại",
                            style: TextStyle(color: Colors.white, fontSize: 18),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

            ],
          ),
        ),
      ),
    );
  }

  void _onChangInFoClick() {
    String ten = _nameController.text;
    String phone = _phoneController.text;
    String newpass = _newpassController.text;
    String newpass1 = _newpassController1.text;
    String pass = _passController.text;
    var isValid = authBloc.isValid_doithongtin(pass );
    if (isValid) {
      var checkpass = authBloc.isValid_checkpass(newpass, newpass1);
      if(checkpass){
        LoadingDialog.showLoadingDialog(context, "Loading...");
        authBloc.changPass(ten,phone,pass, newpass,newpass1, ()  {
          LoadingDialog.hideLoadingDialog(context);
          MsgDialog.showCustomDialogChangInfo(context,"Đổi Thông Tin","Đổi Thông Tin Thành Công");
        }, (msg) {
          LoadingDialog.hideLoadingDialog(context);
          MsgDialog.showMsgDialog(context, "Đổi Thông Tin", msg);
        });
      }

    }

  }

}
