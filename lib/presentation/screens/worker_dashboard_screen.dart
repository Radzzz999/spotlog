import 'package:flutter/material.dart';

class WorkerDashboardScreen extends StatelessWidget {
  final String token;

  WorkerDashboardScreen({required this.token});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Worker Dashboard')),
      body: Center(child: Text('Welcome, Worker!')),
    );
  }
}
