

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:spotlog/logic/bloc/auth_bloc.dart';
import 'package:spotlog/logic/bloc/auth_event.dart';
import 'package:spotlog/logic/bloc/auth_state.dart';
import 'package:spotlog/presentation/screens/login_screen.dart';

class DashboardScreen extends StatelessWidget {
  final String token;

  DashboardScreen({required this.token});

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is AuthLoggedOut) {
          
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (_) => LoginScreen()),
            (route) => false,
          );
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text('Dashboard'),
          actions: [
            IconButton(
              icon: Icon(Icons.logout),
              onPressed: () {
                context.read<AuthBloc>().add(LogoutRequested(token));
              },
            )
          ],
        ),
        body: Center(
          child: Text('Welcome to Dashboard'),
        ),
      ),
    );
  }
}