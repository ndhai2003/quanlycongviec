
import 'package:QLCVTB/src/resources/screens/login_page.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

import '../../CheckUID.dart';

import '../../blocs/auth_bloc.dart';
import '../dialog/loading_dialog.dart';
import '../dialog/msg_dilog.dart';

import 'register_page.dart';


class ResetPwPage extends StatefulWidget {
  @override
  _ResetPwPageState createState() => _ResetPwPageState();
}

class _ResetPwPageState extends State<ResetPwPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passController = TextEditingController();
  AuthBloc authBloc = new AuthBloc();

  @override
  void dispose() {
    authBloc.dispose();
    super.dispose();
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
              Image.asset('assets/images/anhnen.png'),
              Padding(
                padding: const EdgeInsets.fromLTRB(0, 20, 0, 6),
                child: Text(
                  "WELCOME !",
                  style: TextStyle(fontSize: 22, color: Color(0xff333333)),
                ),
              ),
              Text(
                "Khôi Phục Mật Khẩu APP QLCVTB",
                style: TextStyle(fontSize: 16, color: Color(0xff606470)),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(0, 20, 0, 20),
                child: StreamBuilder(
                    stream: authBloc.emailStream,
                    builder: (context, snapshot) => TextField(
                      controller: _emailController,
                      style: TextStyle(fontSize: 18, color: Colors.black),
                      decoration: InputDecoration(
                          labelText: "Email",
                          errorText:
                          snapshot.hasError ? snapshot.error.toString() : null,
                          prefixIcon: const Icon(Icons.email_outlined),
                          border: const OutlineInputBorder(
                              borderSide: BorderSide(
                                  color: Color(0xffCED0D2), width: 1),
                              borderRadius:
                              BorderRadius.all(Radius.circular(30)))),
                    )),
              ),

              Padding(
                padding: const EdgeInsets.symmetric(vertical: 20),
                child: SizedBox(
                  width: double.infinity,
                  height: 52,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 50),
                    child: ElevatedButton(
                      onPressed: _onRsClick,
                      style: ElevatedButton.styleFrom(
                        primary: Colors.blue, // Set your desired button color
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(26), // Adjust the border radius as needed
                        ),
                      ),
                      child: Text(
                        "Khôi Phục Mật Khẩu",
                        style: TextStyle(color: Colors.white, fontSize: 18),
                      ),
                    ),
                  ),
                ),
              ),

              Padding(
                padding: const EdgeInsets.fromLTRB(0, 0, 0, 40),
                child: RichText(
                  text: TextSpan(
                      text: "Quay lại? ",
                      style: TextStyle(color: Color(0xff606470), fontSize: 16),
                      children: <TextSpan>[
                        TextSpan(
                            recognizer: TapGestureRecognizer()
                              ..onTap = () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => LoginPage()));
                              },
                            text: "Đăng Nhập",
                            style: TextStyle(
                                color: Color(0xff3277D8), fontSize: 16))
                      ]),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  void _onRsClick() {
    String email = _emailController.text;
    var isValid = authBloc.isValid_khoiphucPW(email);
    if (isValid) {
      LoadingDialog.showLoadingDialog(context, "Loading...");
      authBloc.resetPassword(email, () {
        LoadingDialog.hideLoadingDialog(context);
        MsgDialog.showCustomDialog(context, 'Thông Báo', 'Vui Lòng Kiểm Tra Email.');
      }, (msg) {
        LoadingDialog.hideLoadingDialog(context);
        MsgDialog.showMsgDialog(context, "Thông Báo Khôi Phục Mật Khẩu", msg);
      });
    }
  }




}
