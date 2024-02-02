import 'package:flutter/material.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';

class QRCodeScannerWidget extends StatefulWidget {
  const QRCodeScannerWidget({Key? key}) : super(key: key);

  @override
  _QRCodeScannerWidgetState createState() => _QRCodeScannerWidgetState();
}

class _QRCodeScannerWidgetState extends State<QRCodeScannerWidget> {
  final GlobalKey _qrKey = GlobalKey(debugLabel: 'QR');
  late QRViewController _controller;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Scan Pass sanitaire'),
        
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ),
      body: Stack(
        alignment: Alignment.center,
        children: [
          QRView(
            key: _qrKey,
            onQRViewCreated: _onQRViewCreated,
          ),
          Positioned(
            bottom: 20,
            child: ElevatedButton(
              onPressed: () {
                // Perform any action when the button is pressed
                // For example, you can handle the scanned QR code data
                if (_controller != null) {
                  _controller.toggleFlash();
                }
              },
              child: const Text('Toggle Flash'),
            ),
          ),
        ],
      ),
    );
  }

  void _onQRViewCreated(QRViewController controller) {
    setState(() {
      _controller = controller;
    });

    controller.scannedDataStream.listen((scanData) {
      // Handle the scanned QR code data
      print('Scanned data: $scanData');
      // Perform any additional action as needed
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
