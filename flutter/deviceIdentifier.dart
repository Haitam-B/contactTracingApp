import 'package:flutter/material.dart';
import 'package:device_info/device_info.dart';

class DeviceIdentifierPage extends StatefulWidget {
  const DeviceIdentifierPage({Key? key}) : super(key: key);

  @override
  _DeviceIdentifierPageState createState() => _DeviceIdentifierPageState();
}

class _DeviceIdentifierPageState extends State<DeviceIdentifierPage> {
  late Future<String?> deviceId;

  @override
  void initState() {
    super.initState();
    deviceId = _getDeviceIdentifier();
  }

  Future<String?> _getDeviceIdentifier() async {
    DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
    try {
      if (Theme.of(context).platform == TargetPlatform.android) {
        AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
        if (androidInfo.androidId.isNotEmpty) {
          return androidInfo.androidId;
        } else {
          return 'Error: androidId is null or empty';
        }
      } else if (Theme.of(context).platform == TargetPlatform.iOS) {
        IosDeviceInfo iosInfo = await deviceInfo.iosInfo;
        if (iosInfo.identifierForVendor.isNotEmpty) {
          return iosInfo.identifierForVendor;
        } else {
          return 'Error: identifierForVendor is null or empty';
        }
      }
    } catch (e) {
      print('Error retrieving device identifier: $e');
      return 'Error: $e';
    }
    return 'Error: Unknown error';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Device Identifier'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Device ID:',
              style: TextStyle(fontSize: 18),
            ),
            const SizedBox(height: 10),
            FutureBuilder<String?>(
              future: deviceId,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.done) {
                  return Text(
                    snapshot.data ?? 'Unknown error',
                    style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  );
                } else {
                  return CircularProgressIndicator();
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
