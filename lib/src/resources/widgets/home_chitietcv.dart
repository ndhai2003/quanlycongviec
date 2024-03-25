
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/material.dart';
import '../../blocs/auth_bloc.dart';
import '../../fire_base/fire_user.dart';
import 'home_caidatthoigian.dart';



class HomeChitiet extends StatefulWidget {
  String Contact_Key;
  String Contact_KeyDanhMuc;
  String Contact_name;
  HomeChitiet({required this.Contact_Key,required this.Contact_name,required this.Contact_KeyDanhMuc});

  @override
  State<HomeChitiet> createState() => _HomeChitietState();
}


class _HomeChitietState extends State<HomeChitiet> {

  String buttonText = 'Thêm vào Ngày của Tôi';
  String buttonText1= 'Thêm vào Ngày đến hạn';

  TextEditingController _infoController = TextEditingController();
  TextEditingController _infoControllerGhichu = TextEditingController();
  AuthBloc authBloc = new AuthBloc();

  DatabaseReference db_Ref = FirebaseDatabase.instance.ref().child('chitietcv');
  DatabaseReference db_Ref1= FirebaseDatabase.instance.ref().child('ngaycuatoi');
  DatabaseReference db_Ref2 = FirebaseDatabase.instance.ref().child('ngaydenhan');
  DatabaseReference db_Ref3 = FirebaseDatabase.instance.ref().child('ghichu');


  DateTime selectedDate = DateTime.now();

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (picked != null && picked != selectedDate)
      setState(() {
        selectedDate = picked;
      });
  }

  Future<void> _selectTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.fromDateTime(selectedDate),
    );
    if (picked != null)
      setState(() {
        selectedDate = DateTime(
          selectedDate.year,
          selectedDate.month,
          selectedDate.day,
          picked.hour,
          picked.minute,
        );
      });
  }

  Future<void> _hienBangChonNgay(BuildContext context) async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
      initialDatePickerMode: DatePickerMode.year,
      builder: (BuildContext context, Widget? child) {
        return Theme(
          data: ThemeData.light().copyWith(
            primaryColor: Colors.blue,
            hintColor: Colors.blue,
            colorScheme: ColorScheme.light(primary: Colors.red),
            buttonTheme: ButtonThemeData(textTheme: ButtonTextTheme.primary),
          ),
          child: child!,
        );
      },
    );

    if (pickedDate != null && pickedDate != DateTime.now()) {
      // Chuyển đổi thời gian về múi giờ địa phương nếu cần
      pickedDate = pickedDate.toLocal();

      // Lấy ngày mà không bao gồm giờ, phút, giây và mili giây
      DateTime selectedDate = DateTime(pickedDate.year, pickedDate.month, pickedDate.day);
      String year = selectedDate.year.toString();
      String month = selectedDate.month < 10 ? '0${selectedDate.month}' : selectedDate.month.toString();
      String day = selectedDate.day < 10 ? '0${selectedDate.day}' : selectedDate.day.toString();
      String ngay = '$year-$month-$day';

      // Thực hiện các hành động với ngày được chọn
      print('Ngày được chọn: $ngay');
      authBloc.createNgaydenhan(user.uid, widget.Contact_KeyDanhMuc, widget.Contact_Key, widget.Contact_name, ngay);
    }
  }

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
              onPressed: () {
                if (_infoController.text.isNotEmpty) {
                  // Kiểm tra trường thông tin không trống
                  authBloc.createchitietCV(user.uid, widget.Contact_Key, _infoController.text);
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

  void _showInputGhiChu() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Nhập thông tin ghi chú'),
          content: TextField(
            controller: _infoControllerGhichu,
            decoration: InputDecoration(labelText: 'Ghi chú'),
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
                if (_infoControllerGhichu.text.isNotEmpty) {
                  // Kiểm tra trường thông tin không trống
                  authBloc.createGhichu(user.uid, widget.Contact_Key, _infoControllerGhichu.text);
                  _infoControllerGhichu.text = "";
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
  void  _suaGhiChu(String key,String txtghichu) {
    _infoControllerGhichu.text = txtghichu;
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Nhập thông tin ghi chú'),
          content: TextField(
            controller: _infoControllerGhichu,
            decoration: InputDecoration(labelText: txtghichu),
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
                if (_infoControllerGhichu.text.isNotEmpty) {
                  // Kiểm tra trường thông tin không trống
                  authBloc.updateGhichu(key, _infoControllerGhichu.text);

                  _infoControllerGhichu.text = "";
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

  void  _suaChitietCV(String key,String txtghichu) {
    _infoController.text = txtghichu;
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Nhập thông tin công việc'),
          content: TextField(
            controller: _infoController,
            decoration: InputDecoration(labelText: "Thông tin ban đầu: $txtghichu"),
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
                  authBloc.updateChitietCV(key, _infoController.text);

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
  Future<void> _checkButtonState() async {
    bool kiemtra = await authBloc.kiemTraTonTai_Key_NgayCuaToi(widget.Contact_Key);

    if (kiemtra == true) {
      print("Đã tồn tại key");
      setState(() {
        buttonText = 'Đã thêm vào Ngày của Tôi';
      });
    }
  }

  Future<void> _checkButtonState1() async {
    bool kiemtra = await authBloc.kiemTraTonTai_Key_Ngaydenhan(widget.Contact_Key);

    if (kiemtra == true) {
      setState(() {
        buttonText1 = 'Đã thêm vào Ngày đến hạn';
      });
    }
  }
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _checkButtonState();
    _checkButtonState1();

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
                          "Chi Tiết Công Việc:",
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
                    ),
                    ),
                  ],
                ),
                FirebaseAnimatedList(
                    query: db_Ref.orderByChild('key_cv').equalTo(widget.Contact_Key),
                    shrinkWrap: true,
                    itemBuilder: (context,snapshot,animation, index){
                      Map Contact = snapshot.value as Map;
                      Contact['key'] = snapshot.key;

                      return Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                  child:  ElevatedButton.icon(
                                    onPressed: () {
                                      _suaChitietCV(Contact['key'],Contact['congviec']);
                                    },
                                    style: ElevatedButton.styleFrom(
                                      padding: EdgeInsets.all(3.0),
                                      primary: Colors.blueGrey, // Màu nền của nút
                                    ),
                                    icon: Container(
                                      padding: EdgeInsets.all(6.0),
                                      child: Icon(
                                        Icons.border_color, // Chọn biểu tượng mong muốn
                                        size: 24.0,color: Colors.blue[200],
                                      ),
                                    ),
                                    label:Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Expanded(
                                          child: Align(
                                            alignment: Alignment.centerLeft,
                                            child: Text(
                                              Contact['congviec'].toString(),
                                              style: TextStyle(fontSize: 18.0, color: Colors.white),
                                              softWrap: true,
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

                                  ),
                                ),

                              ],
                            ),
                          ],
                        ),
                      );
                    }
                ),
                const Divider(
                  thickness: 0.5,
                  color: Colors.white,
                  height: 9,
                ),
                Row(
                  children: [

                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: () async {

                          bool kiemtra = await authBloc.kiemTraTonTai_Key_NgayCuaToi(widget.Contact_Key);
                          if(kiemtra==true){
                            print("Đã tồn tại key");
                           setState(() {
                             buttonText = 'Thêm vào Ngày của Tôi';
                           });
                            db_Ref1?.child(widget.Contact_Key).remove();
                          }
                        else{
                          setState(() {
                            buttonText = 'Đã Thêm vào Ngày của Tôi';
                          });
                            authBloc.createNgayCuaToi(user.uid,widget.Contact_KeyDanhMuc,widget.Contact_Key,widget.Contact_name);
                          }
                          // Xử lý khi nút được nhấn

                        },
                        style: ElevatedButton.styleFrom(
                          padding: EdgeInsets.all(16.0),
                          primary: Colors.black, // Màu nền của nút
                        ),
                        icon: Icon(
                          Icons.sunny, // Chọn biểu tượng mong muốn
                          size: 24.0,color: Colors.blue[200],
                        ),

                        label: Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            buttonText,
                            style: TextStyle(fontSize: 18.0, color: Colors.white),
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
                Row(
                  children: [

                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                              builder: (_) => HomeThoiGian(key_danhmuc: widget.Contact_KeyDanhMuc, key_congviec:widget.Contact_Key ,name_congviec: widget.Contact_name,),
                          ),
                          );
                          // Xử lý khi nút được nhấn

                        },
                        style: ElevatedButton.styleFrom(
                          padding: EdgeInsets.all(16.0),
                          primary: Colors.black, // Màu nền của nút
                        ),
                        icon: Icon(
                          Icons.notifications, // Chọn biểu tượng mong muốn
                          size: 24.0,color: Colors.blue[200],
                        ),

                        label: const  Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            'Cài Đặt Thông Báo',
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
                        onPressed: () async {
                          print(widget.Contact_Key);
                          bool kiemtra = await authBloc.kiemTraTonTai_Key_Ngaydenhan(widget.Contact_Key);
                          if(kiemtra==true){
                            print("Đã tồn tại key");
                            setState(() {
                              buttonText1 = 'Thêm vào Ngày đến hạn';
                            });
                            db_Ref2?.child(widget.Contact_Key).remove();
                          }
                          else{
                            _hienBangChonNgay(context);
                            setState(() {
                              buttonText1 = 'Đã Thêm vào Ngày đến hạn';
                            });

                          }

                        },
                        style: ElevatedButton.styleFrom(
                          padding: EdgeInsets.all(16.0),
                          primary: Colors.black, // Màu nền của nút
                        ),
                        icon: Icon(
                          Icons.date_range, // Chọn biểu tượng mong muốn
                          size: 24.0,color: Colors.blue[200],
                        ),

                        label: Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            buttonText1,
                            style: TextStyle(fontSize: 18.0, color: Colors.white),
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
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: () {
                          _showInputGhiChu();

                        },
                        style: ElevatedButton.styleFrom(
                          padding: EdgeInsets.all(16.0),
                          primary: Colors.black, // Màu nền của nút
                        ),
                        icon: Icon(
                          Icons.edit_calendar_rounded, // Chọn biểu tượng mong muốn
                          size: 24.0,color: Colors.blue[200],
                        ),
                        label: const  Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            'Thêm ghi chú',
                            style: TextStyle(fontSize: 18.0,color: Colors.white),
                          ),
                        ),
                      ),
                    ),

                  ],
                ),
                FirebaseAnimatedList(
                    query: db_Ref3.orderByChild('key_cv').equalTo(widget.Contact_Key),
                    shrinkWrap: true,
                    itemBuilder: (context,snapshot,animation, index){
                      Map Contact = snapshot.value as Map;
                      Contact['key'] = snapshot.key;

                      return Padding(
                        padding: const EdgeInsets.only(top: 10,right: 20,left: 20,bottom: 10),
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                  child:  ElevatedButton.icon(
                                      onPressed: () {
                                        _suaGhiChu(Contact['key'],Contact['ghichu']);
                                      },
                                      style: ElevatedButton.styleFrom(
                                        padding: EdgeInsets.all(3.0),
                                        primary: Colors.blueGrey, // Màu nền của nút
                                      ),
                                      icon: Icon(
                                        Icons.edit_note_outlined, // Chọn biểu tượng mong muốn
                                        size: 24.0,color: Colors.blue[200],
                                      ),
                                      label:Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          Align(
                                            alignment: Alignment.centerLeft,
                                            child: Text(Contact['ghichu'].toString(),
                                              style: TextStyle(fontSize: 18.0,color: Colors.white),
                                            ),
                                          ),

                                          IconButton(onPressed: (){
                                            db_Ref3?.child(Contact['key']).remove();

                                          },
                                              icon: Icon(Icons.delete_forever)),
                                        ],
                                      )
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
                        'Thêm Từng Công Việc',
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
