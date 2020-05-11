import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/orders.dart' show Orders;
import '../widgets/order_item.dart';
import '../widgets/app_drawer.dart';

class OrdersScreen extends StatefulWidget {
  const OrdersScreen({Key key}) : super(key: key);
  static const routeName = '/orders';

  @override
  _OrdersScreenState createState() => _OrdersScreenState();
}

class _OrdersScreenState extends State<OrdersScreen> {
  @override
  void initState() {
    /**
     * 
     * POSSIBLE WORK AROUND BUT NOT THE BEST AND RECOOMENDED WAY!
     */
    /*
      Future.delayed(Duration.zero).then(
        (_) async {
          setState(() {
            _isLoading = true;
          });
          await Provider.of<Orders>(context, listen: false)
              .getAndSetAllOrders()
              .then(
            (_) {
              setState(() {
                _isLoading = false;
              });
            },
          );
        },
      );
    */
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Your Orders')),
      drawer: AppDrawer(),
      body: FutureBuilder(
        future: Provider.of<Orders>(
          context,
          listen: false,
        ).getAndSetAllOrders(),
        builder: (ctx, snapshotData) {
          if (snapshotData.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else {
            if (snapshotData.error != null) {
              return Center(
                child: Text(
                  'An error occured',
                  style: TextStyle(color: Theme.of(context).errorColor),
                ),
              );
            } else {
              return Consumer<Orders>(
                builder: (ctx, orderData, child) {
                  return ListView.builder(
                    itemBuilder: (ctx, index) {
                      return OrderItem(
                        orderItem: orderData.getOrders[index],
                      );
                    },
                    itemCount: orderData.getOrdersCount,
                  );
                },
              );
            }
          }
        },
      ),
    );
  }
}
