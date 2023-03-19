import 'package:flutter/material.dart';
import 'package:smart_home_pbl5/src/session/session.dart';

// Unused
Widget m () {
  return Drawer(
    child: ListView(
      children: <Widget>[
        const UserAccountsDrawerHeader(
          accountName: Text('Trần Đức Thắng'),
          accountEmail: Text('smart.home@example.com'),
          currentAccountPicture: CircleAvatar(
            backgroundImage: NetworkImage(
                'https://scontent.fdad3-5.fna.fbcdn.net/v/t39.30808-6/331395281_1341205049997897_3988877234948064249_n.jpg?_nc_cat=102&ccb=1-7&_nc_sid=09cbfe&_nc_ohc=RVcwrwqlCpgAX-ZXsCz&_nc_ht=scontent.fdad3-5.fna&oh=00_AfBVUUMhFa3edFGgifBomgN1jQrhC5dS-IOXgJff3nKESg&oe=640FD927'),
          ),
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
            print("Hello");
            // String s = await getUserLogin();
            // print(s);
            // Clear session
            clearSession();
            // Navigate to login page

          },
          onLongPress: () {
            print("hello");
          },
        ),
      ],
    ),
    // Drawer content goes here
  );

}