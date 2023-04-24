import 'package:flutter/material.dart';

class DemoNavDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            // DrawerHeader(
            //   child: Text(
            //     'Side menu',
            //     style: TextStyle(color: Colors.white, fontSize: 25),
            //   ),
            //   decoration: BoxDecoration(
            //       color: Colors.green,
            //       image: DecorationImage(
            //           fit: BoxFit.fill,
            //           image: AssetImage('assets/images/cover.jpg'))),
            // ),
            ListTile(
              leading: Icon(Icons.input),
              title: Text('Lot Management'),
              onTap: () => {
                Navigator.pushNamed(context, '/second')
              },
            ),
            ListTile(
              leading: Icon(Icons.border_color),
              title: Text('Create lot'),
              onTap: () => {
                Navigator.pushNamed(context, '/create_lot')
              },
            ),
            ListTile(
              leading: Icon(Icons.verified_user),
              title: Text('About'),
              onTap: () => {Navigator.of(context).pop()},
            ),
            ListTile(
              leading: Icon(Icons.settings),
              title: Text('Settings'),
              onTap: () => {Navigator.of(context).pop()},
            ),
            ListTile(
              leading: Icon(Icons.exit_to_app),
              title: Text('Logout'),
              onTap: () => {
                // Navigator.of(context).pop()
                Navigator.pushNamed(context, '/')
              },
            ),
          ],
        ),
      ),
    );
  }
}