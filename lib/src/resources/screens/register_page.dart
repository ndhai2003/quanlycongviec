import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import '../../CheckUID.dart';
import '../../blocs/auth_bloc.dart';
import '../dialog/loading_dialog.dart';
import '../dialog/msg_dilog.dart';
import 'login_page.dart';

class RegisterPage extends StatefulWidget {
  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  AuthBloc authBloc = new AuthBloc();

  TextEditingController _nameController = new TextEditingController();
  TextEditingController _emailController = new TextEditingController();
  TextEditingController _passController = new TextEditingController();
  TextEditingController _phoneController = new TextEditingController();

  @override
  void dispose() {
    authBloc.dispose();
    super.dispose();
    KiemTra();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: const EdgeInsets.fromLTRB(30, 0, 30, 0),
        constraints: const BoxConstraints.expand(),
        color: Colors.white,
        child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              const SizedBox(
                height: 30,
              ),
              Image.asset('assets/images/anhnen.png'),
              const  Padding(
                padding: const EdgeInsets.fromLTRB(0, 20, 0, 6),
                child: Text(
                  "WELCOME !",
                  style: TextStyle(fontSize: 22, color: Color(0xff333333)),
                ),
              ),
              const Text(
                "Đăng Ký Thành Viên APP QLCVTB",
                style: TextStyle(fontSize: 16, color: Color(0xff606470)),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(0, 30, 0, 20),
                child: StreamBuilder(
                    stream: authBloc.nameStream,
                    builder: (context, snapshot) => TextField(
                          controller: _nameController,
                          style: TextStyle(fontSize: 18, color: Colors.black),
                          decoration: InputDecoration(
                              errorText:
                                  snapshot.hasError ? snapshot.error.toString() : null,
                              labelText: "Họ và Tên",
                              prefixIcon: const Icon(Icons.person),
                              border: const OutlineInputBorder(
                                  borderSide: BorderSide(
                                      color: Color(0xffCED0D2), width: 1),
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(30)))),
                        )),
              ),
              StreamBuilder(
                  stream: authBloc.phoneStream,
                  builder: (context, snapshot) => TextField(
                        controller: _phoneController,
                        style: TextStyle(fontSize: 18, color: Colors.black),
                        decoration: InputDecoration(
                            labelText: "Phone",
                            errorText:
                                snapshot.hasError ? snapshot.error.toString() : null,
                            prefixIcon: const Icon(Icons.phone),
                            border:const OutlineInputBorder(
                                borderSide: BorderSide(
                                    color: Color(0xffCED0D2), width: 1),
                                borderRadius:
                                    BorderRadius.all(Radius.circular(30)))),
                      )),
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
              StreamBuilder(
                  stream: authBloc.passStream,
                  builder: (context, snapshot) => TextField(
                        controller: _passController,
                        obscureText: true,
                        style: TextStyle(fontSize: 18, color: Colors.black),
                        decoration: InputDecoration(
                            errorText:
                                snapshot.hasError ? snapshot.error.toString() : null,
                            labelText: "Password",
                            prefixIcon: const Icon(Icons.lock_outlined),
                            border: const OutlineInputBorder(
                                borderSide: BorderSide(
                                    color: Color(0xffCED0D2), width: 1),
                                borderRadius:
                                    BorderRadius.all(Radius.circular(30)))),
                      )),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 30),
                child: SizedBox(
                  width: double.infinity,
                  height: 52,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 80),
                    child: ElevatedButton(
                      onPressed: _onSignUpClicked,
                      style: ElevatedButton.styleFrom(
                        primary: Colors.blue, // Set your desired button color
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(26), // Adjust the border radius as needed
                        ),
                      ),
                      child: Text(
                        "Đăng Ký",
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
                      text: "Đã có tài khoản? ",
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
                            text: "Đăng Nhập Ngay",
                            style: TextStyle(
                                color: Colors.redAccent, fontSize: 16))
                      ]),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  _onSignUpClicked() {
    String email = _emailController.text;
    String name = _nameController.text;
    String phone = _phoneController.text;
    String pass = _passController.text;
    var isValid = authBloc.isValid(name, email,
        pass, phone);
    if (isValid) {
      // create user
      // loading dialog
      LoadingDialog.showLoadingDialog(context, 'Loading...');
      authBloc.signUp(email, pass,
          phone, name, () {
        LoadingDialog.hideLoadingDialog(context);
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => KiemTra()));
      }, (msg) {
        LoadingDialog.hideLoadingDialog(context);
        MsgDialog.showMsgDialog(context, "Thông Báo Đăng Ký", msg);
        // show msg dialog
      });
    }
  }

}
