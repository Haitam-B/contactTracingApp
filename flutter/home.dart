import 'package:flutter/material.dart';
import 'package:flutter_application_1/pages/info.dart';
import 'package:flutter_application_1/pages/qrScaner.dart';
import 'package:flutter_application_1/pages/reportTest.dart';
import 'package:shared_preferences/shared_preferences.dart';


class Home extends StatelessWidget {
  const Home({Key? key});

  Future<String?> _getStoredUsername() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('username');
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<String?>(
      future: _getStoredUsername(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          return MaterialApp(
            routes: {
              '/report_test': (context) =>  const ReportTestPage(), // Define your ReportTestPage route
              '/scan_qr_code': (context) =>  const QRCodeScannerWidget(), // Define your ScanQRCodePage route
              '/info': (context) =>  const UserInfo(), // Define your ScanQRCodePage route
            },
            home: Scaffold(
              appBar: AppBar(
                title: Text('Welcome, ${snapshot.data}'),
                leading: const Icon(Icons.person),
              ),
              body: Column(
                children: [
                  _buildContainer(
                    "Personal Info",
                    const Color.fromARGB(255, 74, 207, 97),
                    () {
                      print('Navigating to /report_test');
                      Navigator.pushNamed(context, '/info');
                    },
                  ),
                  _buildContainer(
                    "Report Test",
                    const Color.fromARGB(255, 194, 68, 30),
                    () {
                      Navigator.pushNamed(context, '/report_test');
                    },
                  ),
                  _buildContainer(
                    "Scan QR code",
                    Colors.blue,
                    () {
                      Navigator.pushNamed(context, '/scan_qr_code');
                    },
                  ),
                ],
              ),
            ),
            
          );
        } else {
          return MaterialApp(
            home: Scaffold(
              appBar: AppBar(
                title: const Text('Home'),
              ),
              body: const Center(
                child: CircularProgressIndicator(),
              ),
            ),
          );
        }
      },
    );
  }

  Widget _buildContainer(String title, Color color, [VoidCallback? onTap]) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 100,
        width: double.infinity,
        margin: const EdgeInsets.only(top: 20, bottom: 0, left: 10, right: 10),
        padding: const EdgeInsets.all(30),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          border: Border.all(color: color, width: 3),
          borderRadius: const BorderRadius.all(Radius.circular(20)),
          color: color,
        ),
        child: Text(
          title,
          style: const TextStyle(fontSize: 20, color: Colors.white),
        ),
      ),
    );
  }
}
