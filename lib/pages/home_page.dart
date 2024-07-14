import 'package:flutter/material.dart';
import 'package:ongea_chat_app/components/my_drawer.dart';
import 'package:ongea_chat_app/components/user_tile.dart';
import 'package:ongea_chat_app/pages/chat_page.dart';
import 'package:ongea_chat_app/services/auth/auth_service.dart';
import 'package:ongea_chat_app/services/chat/chart_service.dart';

class HomePage extends StatelessWidget {
  HomePage({super.key});

  // chart and auth service
  final ChartService _chartService = ChartService();
  final AuthService _authService = AuthService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Home"),
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.grey,
        elevation: 0,
      ),
      drawer: MyDrawer(),
      body: _buildUserList(),
    );
  }

  // build a list of users except for currently logged in users
  Widget _buildUserList() {
    return StreamBuilder<List<Map<String, dynamic>>>(
      stream: _chartService.getUserStream(),
      builder: (context, snapshot) {
        // error
        if (snapshot.hasError) {
          return const Center(child: Text("Error"));
        }
        // loading
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        // return list view
        if (snapshot.hasData && snapshot.data!.isNotEmpty) {
          var currentUserEmail = _authService.getCurrentUser()?.email;

          var users = snapshot.data!.where((user) {
            return user["email"] != currentUserEmail;
          }).toList();

          return ListView.builder(
            itemCount: users.length,
            itemBuilder: (context, index) {
              return _buildUserListItem(users[index], context);
            },
          );
        } else {
          return const Center(
              child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.hourglass_empty,
                size: 40,
                color: Colors.grey,
              ),
              Text("No users available")
            ],
          ));
        }
      },
    );
  }

// build indiidual list tile for user
  Widget _buildUserListItem(
      Map<String, dynamic> userData, BuildContext context) {
    // display all users except for the current user
    if (userData["email"] != _authService.getCurrentUser()!.email) {
      return UserTile(
        text: userData['email'],
        onTap: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => ChatPage(
                        receiverEmail: userData['email'],
                        receiverID: userData["uid"],
                      )));
        },
      );
    } else {
      return Container();
    }
  }
}
