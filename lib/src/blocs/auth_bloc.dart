import 'dart:async';
import '../fire_base/fire_base_auth.dart';

class AuthBloc {
  var _firAuth = FirAuth();

  StreamController _nameController = new StreamController();
  StreamController _emailController = new StreamController();
  StreamController _passController = new StreamController();
  StreamController _phoneController = new StreamController();
  StreamController _newpassController = new StreamController();
  StreamController _newpassController1 = new StreamController();

  Stream get nameStream => _nameController.stream;
  Stream get emailStream => _emailController.stream;
  Stream get passStream => _passController.stream;
  Stream get newpassStream => _newpassController.stream;
  Stream get newpassStream1 => _newpassController1.stream;
  Stream get phoneStream => _phoneController.stream;




  bool isValid(String name, String email, String pass, String phone) {
    if (name == null || name.length == 0) {
      _nameController.sink.addError("Nhập Họ và Tên");
      return false;
    }
    _nameController.sink.add("");

    if (phone == null || phone.length == 0) {
      _phoneController.sink.addError("Nhập số điện thoại");
      return false;
    }
    _phoneController.sink.add("");

    if (email == null || email.length == 0) {
      _emailController.sink.addError("Nhập Email");
      return false;
    }
    _emailController.sink.add("");

    if (pass == null || pass.length < 6) {
      _passController.sink.addError("Mật khẩu phải trên 5 ký tự");
      return false;
    }
    _passController.sink.add("");

    return true;
  }

  bool isValid_dangnhap(String email, String pass) {

    if (email == null || email.length == 0) {
      _emailController.sink.addError("Nhập Email");
      return false;
    }
    _emailController.sink.add("");

    if (pass == null || pass.length < 6) {
      _passController.sink.addError("Mật khẩu phải trên 5 ký tự");
      return false;
    }
    _passController.sink.add("");

    return true;
  }

  bool isValid_doithongtin(String pass){
    if (pass == null || pass =="") {
      _passController.sink.addError("Mật khẩu cũ không được bỏ trống");
      return false;
    }
    _passController.sink.add("");
    if (pass.length < 6) {
      _passController.sink.addError("Mật khẩu cũ phải trên 5 ký tự");
      return false;
    }
    _passController.sink.add("");
    return true;
  }
  bool isValid_khoiphucPW(String email){
    if (email == null || email.length == 0) {
      _emailController.sink.addError("Nhập Email");
      return false;
    }
    _emailController.sink.add("");
    return true;
  }

  bool isValid_checkpass(String newpass,newpass1){
    if(newpass ==null &&newpass1 ==null)
      return true;
    if(newpass !=null || newpass1 !=null){
      if(newpass==newpass1){
        return true;
      }
      else{
        _newpassController.sink.addError("Mật khẩu xác thực không đúng");
        _newpassController1.sink.addError("Mật khẩu xác thực không đúng");
        return false;
      }
    }
    return true;
  }

  void signUp(String email, String pass, String phone, String name,
      Function onSuccess, Function(String) onError) {
    _firAuth.signUp(email, pass, name, phone, onSuccess, onError);
  }

  void resetPassword(String email,Function onSuccess, Function(String) onError){
    _firAuth.resetPassword(email, onSuccess,onError);
  }

  void changPass(String name, String phone, String oldPassword,String newPassword,String newPassword1,
      Function onSuccess, Function(String) onRegisterError){
      _firAuth.changPass(name, phone, oldPassword, newPassword, newPassword1, onSuccess, onRegisterError);
  }


  void signIn(String email, String pass, Function onSuccess,
      Function(String) onSignInError) {
    _firAuth.signIn(email, pass, onSuccess, onSignInError);
  }

  void createDanhMuc(String userId,String nameDanhmuc ){
    _firAuth.createDanhMuc(userId, nameDanhmuc);
  }

  void createCV(String userId,String nameDanhmuc,String nameCV){
    _firAuth.createCV(userId, nameDanhmuc, nameCV);
  }

  bool convertToBool(dynamic value) {
    if (value is bool) {
      return value;
    } else if (value is String) {
      // Kiểm tra nếu là chuỗi "true" (không phân biệt hoa thường)
      return value.toLowerCase() == 'true';
    } else if (value is int) {
      // Kiểm tra nếu là số nguyên khác 0
      return value != 0;
    }
    // Trường hợp còn lại, trả về giá trị mặc định
    return false;
  }

  void capnhapTrangthaiCV(String keyDanhmuc ,String trangthai ){
    _firAuth.capnhapTrangthaiCV( keyDanhmuc, trangthai);
  }

  void createchitietCV(String userId,String keyCV,String chitietCV){
    _firAuth.createchitietCV(userId, keyCV, chitietCV );
  }

  void createGhichu(String userId,String keyCV,String chitietGhichu){
    _firAuth.createGhichu(userId, keyCV, chitietGhichu);
  }

  void updateGhichu(String ghichuKey, String newGhichu) {
    _firAuth.updateGhichu(ghichuKey, newGhichu);
  }

  void updateChitietCV(String chitietCVKey, String newChitiet) {
    _firAuth.updateChitietCV(chitietCVKey, newChitiet);
  }

  void updateDanhmuc(String danhmucKey, String newString ){
    _firAuth.updateDanhmuc(danhmucKey, newString);
  }

  void updateCV(String congviecKey, String newString ){
    _firAuth.updateCV(congviecKey, newString);
  }

  void XoaDuLieu(String userId , String Key,String Key1){
    _firAuth.XoaDuLieuCongviec(userId, Key, Key1);
  }

  void XoaDLDanhMuc(String userId , String Key, String Key1){
    _firAuth.XoaDulieuDanhmuc(userId, Key,Key1);
  }

  void createNgayCuaToi(String userId,String key_danhmuc,String key_congviec,String nameCV,){
    _firAuth.createNgayCuaToi(userId, key_danhmuc, key_congviec, nameCV);
  }

  void createQuantrong(String userId,String key_danhmuc,String key_congviec,String nameCV){
    _firAuth.createQuantrong(userId, key_danhmuc, key_congviec, nameCV);
  }
  void createNgaydenhan(String userId,String key_danhmuc,String key_congviec,String nameCV,String ngay){
    _firAuth.createNgaydenhan(userId, key_danhmuc, key_congviec, nameCV, ngay);
  }

  void createThoigianThongBao(String userId,String key_danhmuc,String key_congviec,String ngayvagio,String laplaisau){
    _firAuth.createThoigianThongBao(userId, key_danhmuc, key_congviec,  ngayvagio, laplaisau);
  }


  void CapnhaptrangthaiNgayCuaToi(String keyDanhmuc ,String trangthai ){
    _firAuth.CapnhaptrangthaiNgayCuaToi( keyDanhmuc, trangthai);

  }

 void  Capnhaptrangthai(String KeyCV ,String trangthai )
  {
    _firAuth.capnhaptrangthai(KeyCV, trangthai);
  }

  Future<String?> checkStatus(String key) async{
    return _firAuth.checkStatus(key);
  }

  Future<String?> checkNgayvagio(String tenKey) async {
    return _firAuth.checkNgayvagio(tenKey);
  }

  Future<bool> kiemTraTonTai_Key_Quangtrong(String thongTinCanKiemTra) async{
    return _firAuth.kiemTraTonTai_Key_Quangtrong(thongTinCanKiemTra);
  }

  Future<bool> kiemTraTonTai_Key_NgayCuaToi(String thongTinCanKiemTra) async{
    return _firAuth.kiemTraTonTai_Key_NgayCuaToi(thongTinCanKiemTra);
  }

  Future<bool> kiemTraTonTai_Key_Ngaydenhan(String thongTinCanKiemTra) async{
    return _firAuth.kiemTraTonTai_Key_Ngaydenhan(thongTinCanKiemTra);
  }


  void LogOut(){
    _firAuth.signOut();
  }

  void dispose() {
    _nameController.close();
    _emailController.close();
    _passController.close();
    _newpassController.close();
    _newpassController1.close();
    _phoneController.close();

  }


}
