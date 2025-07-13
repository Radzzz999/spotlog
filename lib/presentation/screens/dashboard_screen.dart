import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:spotlog/logic/bloc/auth_bloc.dart';
import 'package:spotlog/logic/bloc/auth_event.dart';
import 'package:spotlog/logic/bloc/auth_state.dart';
import 'package:spotlog/presentation/screens-task/assign_task_screen.dart';
import 'package:spotlog/presentation/screens/login_screen.dart';
import 'package:spotlog/presentation/screens-hasil-submit-task-/tasks_combined_screen.dart';

class DashboardScreen extends StatefulWidget {
  final String token;

  DashboardScreen({required this.token});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  int _selectedIndex = 0;

  late final List<Widget> _screens;

  @override
  void initState() {
    super.initState();
    _screens = [
      _buildHomeScreen(),
      AssignTaskScreen(token: widget.token),
      TasksCombinedScreen(token: widget.token),
    ];
  }

  Widget _buildHomeScreen() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text('Welcome to Dashboard'),
          const SizedBox(height: 20),
          ElevatedButton.icon(
            icon: Icon(Icons.task_alt),
            label: Text('Assign Task to Worker'),
            onPressed: () {
              setState(() {
                _selectedIndex = 1;
              });
            },
          ),
        ],
      ),
    );
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

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
                context.read<AuthBloc>().add(LogoutRequested(widget.token));
              },
            )
          ],
        ),
        body: _screens[_selectedIndex],
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: _selectedIndex,
          onTap: _onItemTapped,
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.assignment_ind),
              label: 'Assign Task',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.list_alt),
              label: 'Logs',
            ),
          ],
        ),
      ),
    );
  }
}
