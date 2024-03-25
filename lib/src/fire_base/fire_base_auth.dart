import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';


class FirAuth {
  final FirebaseAuth _fireBaseAuth = FirebaseAuth.instance;
  User? get user =>_fireBaseAuth.currentUser;
  // final user = FirebaseAuth.instance.currentUser!;

  void signUp(String email, String pass, String name, String phone,
      Function onSuccess, Function(String) onRegisterError) {
    _fireBaseAuth
        .createUserWithEmailAndPassword(email: email, password: pass)
        .then((user) {
      _createUser(user.user!.uid, name, phone, email,pass,onSuccess, onRegisterError);
    }).catchError((err) {
      print("err: " + err.toString());
      _onXuly_loiErr(err.code, onRegisterError);
    });
  }

  _createUser(String userId, String name, String phone, String email,String pass ,Function onSuccess,
      Function(String) onRegisterError) {
    var user = Map<String, String>();
    user["name"] = name;
    user["phone"] = phone;
    user["email"] = email;
    user['pass'] = pass;

    var ref = FirebaseDatabase.instance.reference().child("users");
    ref.child(userId).set(user).then((vl) {
      print("on value: SUCCESSED");
      onSuccess();
    }).catchError((err) {
      print("err: " + err.toString());
      onRegisterError("SignUp fail, please try again");
    }).whenComplete(() {
      print("completed");
    });
  }

  void signIn(String email, String pass, Function onSuccess,
      Function(String) onSignInError) {
    _fireBaseAuth
        .signInWithEmailAndPassword(email: email, password: pass)
        .then((user) {
      updateLogin(user.user!.uid,pass);
      onSuccess();
    }).catchError((err) {
      print("err: " + err.toString());
      _onXuly_loiErr(err.code, onSignInError);
    });
  }

  updateLogin(String userId, String passs) {
    DatabaseReference dbRef = FirebaseDatabase.instance.reference().child('users').child(userId);
    Map<String, dynamic> updateData = {
      'pass': passs,
    };
    dbRef.update(updateData).then((_) {
      print("Cập nhật dữ liệu thành công!");
    }).catchError((error) {
      print("Lỗi khi cập nhật dữ liệu UpdateLogin: $error");
    });
  }
  void resetPassword(String email, Function onSuccess,
      Function(String) onRsInError){
    _fireBaseAuth.sendPasswordResetEmail(email: email).then((user){
      onSuccess();
    }).catchError((err){
      print("err: " + err.toString());
      _onXuly_loiErr(err.code, onRsInError);
    });
  }


  Future<void> changPass(String name, String phone, String oldPassword, String newPassword, String newPassword1,
      Function onSuccess, Function(String) onChangeError) async {
    bool isOldPasswordCorrect = await verifyOldPassword(oldPassword, onSuccess, onChangeError);

    if (isOldPasswordCorrect) {
      if (newPassword != "" && newPassword1 != "") {
        if (newPassword == newPassword1) {
          try {
            await user?.updatePassword(newPassword);
            updateUserData(user!.uid, name, newPassword, phone);
            onSuccess();
            print("Đổi mật khẩu thành công!");
          } catch (error) {
            _onXuly_loiErr("Lỗi khi đổi mật khẩu", onChangeError);
            print("Lỗi khi đổi mật khẩu: $error");
          }
        } else {
          // Thông báo lỗi khi newPassword và newPassword1 không giống nhau
          onChangeError("Mật khẩu mới không khớp");
        }
      }
    }
  }

  updateUserData(String userId, String newName, String newPass,String newPhone) {
    DatabaseReference dbRef = FirebaseDatabase.instance.reference().child('users').child(userId);
    Map<String, dynamic> updateData = {
      'name': newName,
      'pass': newPass,
      'phone':newPhone,
      // Thêm các trường dữ liệu cần cập nhật khác vào đây
    };

    dbRef.update(updateData).then((_) {
      print("Cập nhật dữ liệu thành công!");
    }).catchError((error) {
      print("Lỗi khi cập nhật dữ liệu: $error");
    });
  }
  Future<bool> verifyOldPassword(String oldPassword,
      Function onSuccess, Function(String) onVerifyOldError) async {
    try {
      UserCredential userCredential = await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: FirebaseAuth.instance.currentUser!.email!,
        password: oldPassword,
      );
      return userCredential.user != null;
    } on FirebaseAuthException catch (e) {
      _onXuly_loiErr("Mật khẩu cũ không chính xác.", onVerifyOldError);
      print("Lỗi xác thực mật khẩu cũ: $e");
      return false;
    }
  }



  void createDanhMuc(String userId,String nameDanhmuc ){
    var user = Map<String, String>();
    user["name"] = nameDanhmuc;
    user["user_key"]=userId;
    var ref = FirebaseDatabase.instance.reference().child("danhmuc");
    ref.push().set(user).then((vl) {
      print("on value: SUCCESSED");
      
    }).catchError((err) {
      print("err: " + err.toString());
    
    }).whenComplete(() {
      print("completed");
    });
  }
  void createCV(String userId, String keyDanhmuc, String nameCV) {
    var user = Map<String, String>();
    user["name_congviec"] = nameCV;
    user['user_key'] = userId;
    user['key_danhmuc'] = keyDanhmuc;


    var congviecRef = FirebaseDatabase.instance.reference().child("congviec");
    var newCongviecRef = congviecRef.push(); // Tạo một tham chiếu mới và lấy key
    newCongviecRef.set(user).then((vl) {
      print("on value: SUCCESSED");

      // Sử dụng key mới tạo trong bảng "trangthai"
      var trangthaiRef = FirebaseDatabase.instance.reference().child("trangthai");
      var trangthaiData = {
        'trangthai': 'false',
        'key_congviec': newCongviecRef.key, // Sử dụng key mới tạo từ bảng "congviec"
      };

      trangthaiRef.push().set(trangthaiData).then((trangthaiValue) {
        print("Trạng thái created successfully");
      }).catchError((trangthaiError) {
        print("Trạng thái creation error: " + trangthaiError.toString());
      });
    }).catchError((err) {
      print("err: " + err.toString());
    }).whenComplete(() {
      print("completed");
    });
  }



  void createchitietCV(String userId,String keyCV,String chitietCV){
    var user = Map<String, String>();
    user["congviec"] = chitietCV;
    user['key_cv']=keyCV;
    user['user_key']=userId;

    var ref = FirebaseDatabase.instance.reference().child("chitietcv");
    ref.push().set(user).then((vl) {
      print("on value: SUCCESSED");

    }).catchError((err) {
      print("err: " + err.toString());

    }).whenComplete(() {
      print("completed");
    });
  }

  void createGhichu(String userId,String keyCV,String chitietGhichu){
    var user = Map<String, String>();
    user["ghichu"] = chitietGhichu;
    user['key_cv']=keyCV;
    user['user_key']=userId;

    var ref = FirebaseDatabase.instance.reference().child("ghichu");
    ref.push().set(user).then((vl) {
      print("on value: SUCCESSED");

    }).catchError((err) {
      print("err: " + err.toString());

    }).whenComplete(() {
      print("completed");
    });
  }

  void updateGhichu(String ghichuKey, String newGhichu) {
    var updatedGhichu = {
      'ghichu': newGhichu,
    };

    var ref = FirebaseDatabase.instance.reference().child("ghichu").child(ghichuKey);

    ref.update(updatedGhichu).then((_) {
      print("Ghichu updated successfully");
    }).catchError((err) {
      print("Error updating ghichu: $err");
    }).whenComplete(() {
      print("Update operation completed");
    });
  }

  void updateChitietCV(String chitietCVKey, String newChitiet) {
    var updatedGhichu = {
      'congviec': newChitiet,
    };

    var ref = FirebaseDatabase.instance.reference().child("chitietcv").child(chitietCVKey);

    ref.update(updatedGhichu).then((_) {
      print("Ghichu updated successfully");
    }).catchError((err) {
      print("Error updating ghichu: $err");
    }).whenComplete(() {
      print("Update operation completed");
    });
  }

  void updateDanhmuc(String danhmucKey, String newString ){
    var updatedGhichu = {
      'name': newString,
    };

    var ref = FirebaseDatabase.instance.reference().child("danhmuc").child(danhmucKey);

    ref.update(updatedGhichu).then((_) {
      print("Ghichu updated successfully");
    }).catchError((err) {
      print("Error updating ghichu: $err");
    }).whenComplete(() {
      print("Update operation completed");
    });
  }
  void updateCV(String congviecKey, String newString ){
    var updatedGhichu = {
      'name_congviec': newString,
    };

    var ref = FirebaseDatabase.instance.reference().child("congviec").child(congviecKey);

    ref.update(updatedGhichu).then((_) {
      print("Ghichu updated successfully");
    }).catchError((err) {
      print("Error updating ghichu: $err");
    }).whenComplete(() {
      print("Update operation completed");
    });
  }


  void XoaDuLieuCongviec(String userId, String Key, String Key1) {
   var ref = FirebaseDatabase.instance.reference().child('chitietcv');
    ref.child(userId).child(Key).child(Key1).remove().then((_) {
      print("Xoá dữ liệu thành công");
    }).catchError((error) {
      print("Lỗi khi xoá dữ liệu: $error");
    });
  }
  void XoaDulieuDanhmuc(String userId,String Key,String Key1){
    var ref = FirebaseDatabase.instance.reference().child('congviec');
    ref.child(userId).child(Key).child(Key1).remove().then((_) {
      print("Xoá dữ liệu thành công");
    }).catchError((error) {
      print("Lỗi khi xoá dữ liệu: $error");
    });
  }

  void createNgayCuaToi(String userId,String key_danhmuc,String key_congviec,String nameCV){
    var user = Map<String, String>();
    user["key_danhmuc"] = key_danhmuc;
    user["name_congviec"] = nameCV;
    user['user_key']=userId;

    var ref = FirebaseDatabase.instance.reference().child("ngaycuatoi");
    ref.child(key_congviec).set(user).then((vl) {
      print("on value: SUCCESSED");

    }).catchError((err) {
      print("err: " + err.toString());

    }).whenComplete(() {
      print("completed");
    });
  }


  void createQuantrong(String userId,String key_danhmuc,String key_congviec,String nameCV){
    var user = Map<String, String>();
    user["key_danhmuc"] = key_danhmuc;
    user["name_congviec"] = nameCV;
    user['user_key']=userId;

    var ref = FirebaseDatabase.instance.reference().child("quantrong");
    ref.child(key_congviec).set(user).then((vl) {
      print("on value: SUCCESSED");

    }).catchError((err) {
      print("err: " + err.toString());

    }).whenComplete(() {
      print("completed");
    });
  }

  void createNgaydenhan(String userId,String key_danhmuc,String key_congviec,String nameCV,String ngay){
    var user = Map<String, String>();
    user["key_danhmuc"] = key_danhmuc;
    user["name_congviec"] = nameCV;
    user['user_key']=userId;
    user['ngay']=ngay;

    var ref = FirebaseDatabase.instance.reference().child("ngaydenhan");
    ref.child(key_congviec).set(user).then((vl) {
      print("on value: SUCCESSED");

    }).catchError((err) {
      print("err: " + err.toString());

    }).whenComplete(() {
      print("completed");
    });
  }

  void capnhapTrangthaiCV(String keyDanhmuc,String trangthai ){
    var ref = FirebaseDatabase.instance.reference().child("congviec");
    ref.child(keyDanhmuc).update({
      "trangthai":trangthai,
    });
  }

  void CapnhaptrangthaiNgayCuaToi(String keyDanhmuc ,String trangthai ){
    var ref = FirebaseDatabase.instance.reference().child("ngaycuatoi");
    ref.child(keyDanhmuc).update({
      "trangthai":trangthai,
    });
  }


  Future<void> capnhaptrangthai(String KeyCV, String trangthai) async {
    var ref = FirebaseDatabase.instance.reference().child("trangthai");

    DatabaseEvent event = await ref.orderByChild('key_congviec').equalTo(KeyCV).once();

    if (event.snapshot?.value != null) {
      Map<dynamic, dynamic> trangthaiData = event.snapshot!.value as Map;

      for (var entry in trangthaiData.entries) {
        String childKey = entry.key as String;
        Map<dynamic, dynamic> childData = entry.value as Map;

        if (childData['key_congviec'] == KeyCV) {
          await ref.child(childKey).update({"trangthai": trangthai});
          break;
        }
      }
    }
  }
  void createThoigianThongBao(String userId,String key_danhmuc,String key_congviec,String ngayvagio,String laplaisau){
    var user = Map<String, String>();
    user["key_danhmuc"] = key_danhmuc;
    user['user_key']=userId;
    user['ngayvagio']=ngayvagio;
    user['laplaisau']=laplaisau;


    var ref = FirebaseDatabase.instance.reference().child("thoigianthongbao");
    ref.child(key_congviec).set(user).then((vl) {
      print("on value: SUCCESSED");

    }).catchError((err) {
      print("err: " + err.toString());

    }).whenComplete(() {
      print("completed");
    });
  }


  Future<bool> kiemTraTonTai_Key_Quangtrong(String keyCanKiemTra) async {
    DatabaseReference databaseReference = FirebaseDatabase.instance.reference();

    DataSnapshot dataSnapshot = await databaseReference.child('quantrong').get();

    if (dataSnapshot.value != null) {
      Map<dynamic, dynamic> quanTrongData = dataSnapshot.value as Map;

      // Kiểm tra xem keyCanKiemTra có tồn tại trong bảng không
      return quanTrongData.containsKey(keyCanKiemTra);
    }

    // Trường hợp không tìm thấy hoặc có lỗi
    return false;
  }

  Future<bool> kiemTraTonTai_Key_NgayCuaToi(String keyCanKiemTra) async {
    DatabaseReference databaseReference = FirebaseDatabase.instance.reference();

    DataSnapshot dataSnapshot = await databaseReference.child('ngaycuatoi').get();

    if (dataSnapshot.value != null) {
      Map<dynamic, dynamic> quanTrongData = dataSnapshot.value as Map;

      // Kiểm tra xem keyCanKiemTra có tồn tại trong bảng không
      return quanTrongData.containsKey(keyCanKiemTra);
    }

    // Trường hợp không tìm thấy hoặc có lỗi
    return false;
  }

  Future<bool> kiemTraTonTai_Key_Ngaydenhan(String keyCanKiemTra) async {
    DatabaseReference databaseReference = FirebaseDatabase.instance.reference();

    DataSnapshot dataSnapshot = await databaseReference.child('ngaydenhan').get();

    if (dataSnapshot.value != null) {
      Map<dynamic, dynamic> quanTrongData = dataSnapshot.value as Map;

      // Kiểm tra xem keyCanKiemTra có tồn tại trong bảng không
      return quanTrongData.containsKey(keyCanKiemTra);
    }

    // Trường hợp không tìm thấy hoặc có lỗi
    return false;
  }


  Future<String?> checkStatus(String tenKey) async {
    var db_Ref = FirebaseDatabase.instance.reference().child('trangthai');
    DatabaseEvent event = await db_Ref.orderByChild('key_congviec').equalTo(tenKey).once();

    if (event.snapshot?.value != null) {
      Map<dynamic, dynamic> trangthaiData = event.snapshot!.value as Map;

      // Iterate through each child node
      for (var entry in trangthaiData.entries) {
        Map<dynamic, dynamic> childData = entry.value as Map;
        if (childData['key_congviec'] == tenKey) {
          return childData['trangthai'];
        }
      }
    }

    // Return null if data is not found
    return null;
  }
  Future<String?> checkNgayvagio(String tenKey) async {
    var db_Ref = FirebaseDatabase.instance.reference().child('thoigianthongbao');
    DatabaseEvent event = await db_Ref.orderByKey().equalTo(tenKey).once();

    if (event.snapshot?.value != null) {
      Map<dynamic, dynamic> trangthaiData = event.snapshot!.value as Map;

      // Lấy giá trị ngày và giờ từ child có key là tenKey
      return trangthaiData[tenKey]['ngayvagio'];
    }

    // Return null if data is not found
    return null;
  }






  ///

  void _onXuly_loiErr(String code, Function(String) onLoi_Error) {
    print(code);
    switch (code) {
      case "INVALID_LOGIN_CREDENTIALS":
        onLoi_Error("Mật Khẩu Không Đúng");
      case "invalid-email":
        onLoi_Error("Email Không Hợp Lệ");
        break;
      case "email-already-in-use":
        onLoi_Error("Email Đã Tồn Tại");
        break;
      case "Mật khẩu cũ không chính xác.":
        onLoi_Error("Mật khẩu cũ không chính xác.");
        break;
      default:
        onLoi_Error("Đăng Ký Thật Bại,Vui Lòng Thử Lại");
        break;

    }

  }



  Future<bool> isKeyExist( String keyToCheck) async {
    var ref = FirebaseDatabase.instance.reference();

    // Thực hiện truy vấn để kiểm tra xem keyToCheck có tồn tại trong Firebase không
    DataSnapshot snapshot =  ref.child('ngaycuatoi').child(keyToCheck).once() as DataSnapshot;

    // Kiểm tra nếu keyToCheck tồn tại
    return snapshot.exists;
  }

  Future<void> signOut() async {
    print("signOut");
    return _fireBaseAuth.signOut();
  }


}


