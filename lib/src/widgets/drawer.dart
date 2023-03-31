import 'package:flutter/material.dart';

import '../session/session.dart';

// Sidebar drawer
class SidebarDrawer extends StatelessWidget {
  final String username;

  const SidebarDrawer({Key? key, required this.username}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        children: <Widget>[
          UserAccountsDrawerHeader(
            accountName: Text(username),
            currentAccountPicture: CircleAvatar(
              child: Text(
                username[0].toUpperCase(),
                style: const TextStyle(
                  fontSize: 50,
                ),
              ),
            ),
            accountEmail: null,
          ),
          ListTile(
            title: const Text('Home'),
            onTap: () {
              // Handle home button tap
            },
          ),
          ListTile(
            title: const Text('Settings'),
            onTap: () {
              // Handle settings button tap
            },
          ),
          ListTile(
            title: const Text('Log out'),
            onTap: () {
              // Clear session
              clearSession();
            },
          ),
        ],
      ),
      // Drawer content goes here
    );
  }
}
