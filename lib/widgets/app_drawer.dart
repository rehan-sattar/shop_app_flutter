import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/auth.dart';

class AppDrawer extends StatelessWidget {
  const AppDrawer({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Drawer(
        child: Column(
          children: <Widget>[
            AppBar(
              title: Text('Hellow friends!'),
              automaticallyImplyLeading: false,
            ),
            Divider(),
            ListTile(
              leading: Icon(Icons.shop),
              title: Text('Shop'),
              onTap: () {
                Navigator.pushReplacementNamed(context, "/");
              },
            ),
            ListTile(
              leading: Icon(Icons.payment),
              title: Text('Orders'),
              onTap: () {
                Navigator.pushReplacementNamed(context, "/orders");
              },
            ),
            ListTile(
              leading: Icon(Icons.shopping_basket),
              title: Text('Your Products'),
              onTap: () {
                Navigator.pushReplacementNamed(context, "/userProducts");
              },
            ),
            ListTile(
              leading: Icon(Icons.exit_to_app),
              title: Text('Logout'),
              onTap: () {
                Provider.of<Auth>(context, listen: false).logout();
              },
            )
          ],
        ),
      ),
    );
  }
}
