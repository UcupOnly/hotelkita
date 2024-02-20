import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class BookingPageList extends StatefulWidget {
  @override
  _BookingPageListState createState() => _BookingPageListState();
}

class _BookingPageListState extends State<BookingPageList> {
  List<Map<String, dynamic>> bookings = [];

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  Future<void> fetchData() async {
    final url = 'http://192.168.1.106/api_produk/hotel/read.php';

    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);

      setState(() {
        bookings = List<Map<String, dynamic>>.from(data);
      });
    } else {
      // Handle error
      print('Failed to load data: ${response.statusCode}');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Booking List'),
      ),
      body: ListView.builder(
        itemCount: bookings.length,
        itemBuilder: (context, index) {
          final booking = bookings[index];
          return ListTile(
            title: Text('Kamar: ${booking['kamar']}'),
            subtitle: Text('Nama: ${booking['nama']}\nTgl: ${booking['tgl']}'),
          );
        },
      ),
    );
  }
}
