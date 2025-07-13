import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:spotlog/logic/bloc/auth_bloc.dart';
import 'package:spotlog/logic/bloc/auth_event.dart';
import 'package:spotlog/logic/bloc/auth_state.dart';
import 'package:spotlog/logic/task-home-admin/bloc/task_admin_bloc.dart';
import 'package:spotlog/logic/task-home-admin/bloc/task_admin_event.dart';
import 'package:spotlog/logic/task-home-admin/bloc/task_admin_state.dart';
import 'package:spotlog/presentation/screens-task/assign_task_screen.dart';
import 'package:spotlog/presentation/screens/login_screen.dart';
import 'package:spotlog/presentation/screens-hasil-submit-task-/tasks_combined_screen.dart';

class DashboardScreen extends StatefulWidget {
  final String token;

  const DashboardScreen({Key? key, required this.token}) : super(key: key);

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  int _selectedIndex = 0;
  late final List<Widget> _screens;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<TaskBlocAdmin>().add(FetchTasksEvent(token: widget.token));
    });

    _screens = [
      _buildHomeScreen(),
      AssignTaskScreen(token: widget.token),
      TasksCombinedScreen(token: widget.token),
    ];
  }

  Widget _buildHomeScreen() {
    return BlocBuilder<TaskBlocAdmin, TaskState>(
      builder: (context, state) {
        if (state is TaskLoading) {
          return const Center(child: CircularProgressIndicator());
        } else if (state is TaskLoaded) {
          final tasks = state.tasks;

          if (tasks.isEmpty) {
            return const Center(child: Text('Tidak ada task yang tersedia.'));
          }

          return ListView.builder(
            padding: const EdgeInsets.all(12),
            itemCount: tasks.length,
            itemBuilder: (context, index) {
              final task = tasks[index];
              return Card(
                elevation: 2,
                margin: const EdgeInsets.only(bottom: 12),
                child: ListTile(
                  leading: const Icon(Icons.task_alt, color: Colors.blue),
                  title: Text(task.title),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (task.description != null)
                        Text(task.description!),
                      const SizedBox(height: 4),
                      Text(
                        'Status: ${task.status}',
                        style: TextStyle(
                          color: task.status == 'completed'
                              ? Colors.green
                              : Colors.orange,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        } else if (state is TaskError) {
          return Center(child: Text('Terjadi kesalahan: ${state.message}'));
        } else {
          return const Center(child: Text('Silakan tunggu...'));
        }
      },
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
          title: const Text('Dashboard'),
          actions: [
            IconButton(
              icon: const Icon(Icons.logout),
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
