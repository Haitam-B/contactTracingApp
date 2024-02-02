import 'package:flutter/material.dart';

class ReportTestPage extends StatefulWidget {
  const ReportTestPage({super.key});

  @override
  State<ReportTestPage> createState() => _ReportTestPageState();
}

class _ReportTestPageState extends State<ReportTestPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
              appBar: AppBar(
                title: const Text('Report positive Test'),
                
                leading: IconButton(
                  icon: const Icon(Icons.arrow_back),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ),
              body: const Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('Welcome, dont panic it is what it is!'),
                    SizedBox(height: 10),
                    
                  ],
                ),
              ),
            );;
  }
}