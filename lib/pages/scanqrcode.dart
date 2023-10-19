import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:http/http.dart' as http;

class ScanQRPage extends StatefulWidget {
  const ScanQRPage({super.key});

  @override
  State<ScanQRPage> createState() => _ScanQRPageState();
}

class _ScanQRPageState extends State<ScanQRPage> {
  bool is_loading = false;

  Future<void> sendPostRequest(String? id) async {
    setState(() {
      is_loading = true;
    });
    final url = Uri.https('deti-azii.ru', 'api/ticket');
    final response = await http.post(
      url,
      headers: {
        'Accept': 'application/json',
      },
      body: {'id': id},
    );

    if (response.statusCode == 200) {
      is_loading = false;
      Fluttertoast.showToast(
        msg: "Билет подтвержден",
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.TOP,
        backgroundColor: Colors.green,
        textColor: Colors.white,
      );
    } else {
      is_loading = false;
      Fluttertoast.showToast(
        msg: "Билет не подтвержден",
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.TOP,
        backgroundColor: Colors.red,
        textColor: Colors.white,
      );
    }

    setState(() {
      is_loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Сканировать QR code",
          style: TextStyle(
            fontSize: 18,
            color: Colors.black,
            fontWeight: FontWeight.w900,
          ),
        ),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.white,
      ),
      body: StatefulBuilder(
        builder: (BuildContext context, StateSetter setState) {
          return is_loading
              ? Center(
                  child: CircularProgressIndicator(),
                )
              : SafeArea(
                  child: MobileScanner(
                    onDetect: (capture) {
                      final List<Barcode> barcodes = capture.barcodes;
                      for (final barcode in barcodes) {
                        debugPrint('Barcode found! ${barcode.rawValue}');
                        sendPostRequest(barcode.rawValue);
                      }
                    },
                  ),
                );
        },
      ),
    );
  }
}
