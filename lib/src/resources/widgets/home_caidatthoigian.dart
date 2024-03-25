import 'package:QLCVTB/main.dart';
import 'package:QLCVTB/src/resources/widgets/home_ngaydenhan.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import '../../blocs/auth_bloc.dart';
import '../../thongbao/local_notifications.dart';
import '../dialog/msg_dilog.dart';


class HomeThoiGian extends StatefulWidget {
  String key_danhmuc;
  String key_congviec;
  String name_congviec;
  HomeThoiGian({required this.key_danhmuc,required this.key_congviec,required this.name_congviec});

  @override
  State<HomeThoiGian> createState() => _HomeThoiGianState();
}


class _HomeThoiGianState extends State<HomeThoiGian> {

  DatabaseReference? db_Ref;
  AuthBloc authBloc = new AuthBloc();
  DateTime selectedDateTime = DateTime.now();
  int timeDifferenceInSeconds = 0;
  List<String> items = ['Không','1 phút','60 phút','1 ngày'];
  String selectedItem = 'Không';
  String ngaychon="";


  listenToNotifications() {
    print("Listening to notification");
    LocalNotifications.onClickNotification.stream.listen((event) {
      Navigator.push(context,
          MaterialPageRoute(builder: (context) => HomeNgaydenhan()));
    });
  }
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
     db_Ref = FirebaseDatabase.instance.ref().child('thoigianthongbao');
      Contactt_data();
      listenToNotifications();
      LocalNotifications.cancelAll();

  }
  void Contactt_data() async {
    DataSnapshot snapshot = await db_Ref!.child(widget.key_congviec).get();
    Map Contact = snapshot.value as Map;
    setState(() {
      ngaychon = Contact['ngayvagio'];
      selectedItem = Contact['laplaisau'];
    });
  }


  Future<void> _selectDateTime(BuildContext context) async {
    DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDateTime,
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );

    if (picked != null) {
      TimeOfDay? selectedTime = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.fromDateTime(selectedDateTime),
      );
      if (selectedTime != null) {
        setState(() {
          selectedDateTime = DateTime(
            picked.year,
            picked.month,
            picked.day,
            selectedTime.hour,
            selectedTime.minute,
          );
        });
      }
      setState(() {
        ngaychon = selectedDateTime.year.toString()+"-"+selectedDateTime.month.toString()+"-"+selectedDateTime.day.toString()+" "+selectedDateTime.hour.toString()+":"+selectedDateTime.minute.toString();
      });
    }
  }
  void _calculateDifference() {
    // Calculate the time difference in seconds
    timeDifferenceInSeconds = selectedDateTime.difference(DateTime.now()).inSeconds;
    print(ngaychon);

    print(selectedItem);
    print('Time Difference: $timeDifferenceInSeconds seconds');
    if(timeDifferenceInSeconds>0){
      LocalNotifications.thongbaosaukhichongio(
          title: "Thông báo công việc",
          body: 'Công việc: ${widget.name_congviec}',
          payload: "Nhấn vào để xem",
          time: timeDifferenceInSeconds
      );
    }
    else{
      LocalNotifications.thongbaoluon(
        title: 'Thông báo công việc',
        body: 'Công việc: ${widget.name_congviec}',
        payload: 'Nhấn vào để xem',

      );
    }
    if(selectedItem =="Không"){
      LocalNotifications.cancel(1);
    }else if(selectedItem=="1 phút"){
      LocalNotifications.Thongbaosau1phut(
        title: 'Thông báo công việc',
        body: 'Có công việc ($widget.name_congviec)',
        payload: 'Nhấn vào để xem',
      );
    } else if(selectedItem=="1 giờ" ){
      LocalNotifications.Thongbaosau1gio(
        title: 'Thông báo công việc',
        body: 'Công việc: ${widget.name_congviec}',
        payload: 'Nhấn vào để xem',
      );
    } else if(selectedItem=="1 ngày" ){
      LocalNotifications.Thongbaosau1ngay(
        title: 'Thông báo công việc',
        body: 'Công việc: ${widget.name_congviec}',
        payload: 'Nhấn vào để xem',
      );
    }
    authBloc.createThoigianThongBao(user.uid, widget.key_danhmuc, widget.key_congviec, ngaychon, selectedItem);
    MsgDialog.showCustomDialogChangInfo(context, 'Thông Báo', 'Lưu Thành Công');

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          height: double.infinity,
          color: Colors.black,
          padding: const EdgeInsets.only(top: 30, left: 10, right: 10),
          child: Column(

            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Danh mục: Nhắc Tôi",
                    style: TextStyle(
                      fontSize: 25,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
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
              SizedBox(height: 120), // Khoảng cách giữa "Danh mục: Quan Trọng" và phần còn lại
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      _selectDateTime(context);
                    },
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.calendar_today, // Thay đổi thành biểu tượng bạn muốn sử dụng
                          color: Colors.white,
                        ),
                        SizedBox(width: 8), // Khoảng cách giữa icon và văn bản
                        Text(
                          'Chọn Ngày và Giờ',
                          style: TextStyle(color: Colors.white),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 16),
                  Text(
                    'Ngày và giờ đã chọn: $ngaychon',
                    style: TextStyle(color: Colors.white),
                  ),
                  SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Báo Lại Sau:',
                        style: TextStyle(fontSize: 20, color: Colors.white),
                      ),
                      SizedBox(width: 10),
                      DropdownButton(
                        value: selectedItem,
                        items: items.map((String item) {
                          return DropdownMenuItem(
                            value: item,
                            child: Text(
                              item,
                              style: TextStyle(color: Colors.red),
                            ),
                          );
                        }).toList(),
                        onChanged: (value) {
                          setState(() {
                            selectedItem = value.toString();
                            print(selectedItem);
                          });
                        },
                      ),
                    ],
                  ),
                  ElevatedButton(
                    onPressed: () {
                      _calculateDifference();
                    },
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.save, // Thay đổi thành biểu tượng bạn muốn sử dụng
                          color: Colors.white,
                        ),
                        SizedBox(width: 8), // Khoảng cách giữa icon và văn bản
                        Text(
                          'Lưu',
                          style: TextStyle(color: Colors.white),
                        ),
                      ],
                    ),
                  ),

                ],
              ),
            ],
          ),
        ),
      ),
    );
  }





}
