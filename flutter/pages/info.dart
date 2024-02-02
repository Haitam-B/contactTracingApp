import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:qr_flutter/qr_flutter.dart';

class UserInfo extends StatefulWidget {
  const UserInfo({Key? key});

  @override
  State<UserInfo> createState() => _UserInfoState();
}

class _UserInfoState extends State<UserInfo> {
  Future<Map<String, String>?> _getStoredUserInfo() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return {
      'username': prefs.getString('username') ?? '',
      'ID': prefs.getString('ID') ?? '',
      'email': prefs.getString('email') ?? '',
    };
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Map<String, String>?>(
      future: _getStoredUserInfo(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          if (snapshot.hasData) {
            return Scaffold(
              appBar: AppBar(
                title: const Text('User info'),
                leading: IconButton(
                  icon: const Icon(Icons.arrow_back),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ),
              body: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Welcome, ${snapshot.data!['username']}!', style: TextStyle(fontSize: 20)),
                    const SizedBox(height: 10),
                    Text('ID: ${snapshot.data!['ID']}'),
                    const SizedBox(height: 10),
                    Text('Email: ${snapshot.data!['email']}'),
                    const SizedBox(height: 20),
                    _buildQRCode(snapshot.data!['ID']!),
                  ],
                ),
              ),
            );
          } else {
            return Scaffold(
              appBar: AppBar(
                title: const Text('Error'),
              ),
              body: const Center(
                child: Text('Error retrieving user information'),
              ),
            );
          }
        } else {
          // Handle loading state or other scenarios
          return Scaffold(
            appBar: AppBar(
              title: const Text('Next Screen'),
            ),
            body: const Center(
              child: CircularProgressIndicator(),
            ),
          );
        }
      },
    );
  }

  Widget _buildQRCode(String data) {
    return QrImageView(
      data: data,
      version: QrVersions.auto,
      size: 200.0,
    );
  }
}
