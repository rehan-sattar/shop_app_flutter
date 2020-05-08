import 'package:flutter/material.dart';

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
            )
          ],
        ),
      ),
    );
  }
}
