import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'booking.dart'; // Import file booking.dart

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: HotelRoomPage(),
    );
  }
}

class RoomTypeButton extends StatelessWidget {
  final String title;
  final String kamar;
  final String imagePath;

  RoomTypeButton({
    required this.title,
    required this.kamar,
    required this.imagePath,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) =>
                  Booking(kamarName: title, selectedKamar: kamar),
            ),
          );
        },
        child: Container(
          padding: EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Colors.blue,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Column(
            children: [
              Image.asset(
                imagePath,
                height: 200,
                width: 320,
              ),
              SizedBox(height: 8),
              Text(
                title,
                style: TextStyle(
                  fontSize: 18,
                  color: Colors.white,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class HotelRoomPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('HOTEL KITA'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                'DAFTAR KAMAR',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 24,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            RoomTypeButton(
              title: 'Single Room',
              kamar: 'SingleRoom',
              imagePath: 'assets/singleroom.png',
            ),
            RoomTypeButton(
              title: 'Double Room',
              kamar: 'DoubleRoom',
              imagePath: 'assets/doubleroom.png',
            ),
            RoomTypeButton(
              title: 'Family Room',
              kamar: 'FamilyRoom',
              imagePath: 'assets/familyroom.png',
            ),
            RoomTypeButton(
              title: 'Suite Room',
              kamar: 'SuiteRoom',
              imagePath: 'assets/suiteroom.png',
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => BookingPageList(),
                  ),
                );
              },
              child: Text('Booking List'),
            ),
          ],
        ),
      ),
    );
  }
}

class Booking extends StatefulWidget {
  final String kamarName;
  final String selectedKamar;

  Booking({required this.kamarName, required this.selectedKamar});

  @override
  _BookingState createState() => _BookingState();
}

class _BookingState extends State<Booking> {
  TextEditingController fullNameController = TextEditingController();
  TextEditingController nikController = TextEditingController();
  TextEditingController jumlahOrangController = TextEditingController();
  TextEditingController phoneNumberController = TextEditingController();
  TextEditingController dateController = TextEditingController();

  bool orderAccepted = false;

  Future<void> submitBooking() async {
    final url = 'http://192.168.43.199/api_produk/hotel/create.php';

    final response = await http.post(
      Uri.parse(url),
      body: {
        'kamar': widget.selectedKamar,
        'nama': fullNameController.text,
        'nik': nikController.text,
        'orang': jumlahOrangController.text,
        'tgl': dateController.text,
        'hp': phoneNumberController.text,
      },
    );

    if (response.statusCode == 200) {
      setState(() {
        orderAccepted = true;
      });

      Future.delayed(Duration(seconds: 2), () {
        setState(() {
          orderAccepted = false;
        });
        Navigator.pop(context);
      });
    } else {
      print('Terjadi kesalahan: ${response.statusCode}');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Booking: ${widget.kamarName}'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: orderAccepted
              ? Center(
                  child: Text(
                    'Order Kami Terima',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                    ),
                  ),
                )
              : Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Pilihan Kamar: ${widget.kamarName}',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                      ),
                    ),
                    SizedBox(height: 16),
                    TextField(
                      controller: fullNameController,
                      decoration: InputDecoration(labelText: 'Nama Lengkap'),
                    ),
                    SizedBox(height: 16),
                    TextField(
                      controller: nikController,
                      decoration: InputDecoration(labelText: 'Nomor NIK'),
                    ),
                    SizedBox(height: 16),
                    TextField(
                      controller: jumlahOrangController,
                      decoration: InputDecoration(labelText: 'Jumlah Orang'),
                      keyboardType: TextInputType.number,
                    ),
                    SizedBox(height: 16),
                    TextField(
                      controller: dateController,
                      decoration: InputDecoration(labelText: 'Tanggal Booking'),
                      onTap: () async {
                        DateTime? pickedDate = await showDatePicker(
                          context: context,
                          initialDate: DateTime.now(),
                          firstDate: DateTime.now(),
                          lastDate: DateTime(2101),
                        );

                        if (pickedDate != null) {
                          dateController.text =
                              pickedDate.toLocal().toString().split(' ')[0];
                        }
                      },
                    ),
                    SizedBox(height: 16),
                    TextField(
                      controller: phoneNumberController,
                      decoration: InputDecoration(labelText: 'Nomor HP'),
                      keyboardType: TextInputType.phone,
                    ),
                    SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: () {
                        print(
                            'Submitting Booking for Kamar: ${widget.selectedKamar}');
                        submitBooking();
                      },
                      child: Text('Submit Booking'),
                    ),
                  ],
                ),
        ),
      ),
    );
  }
}
