import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hub/service/globas_service.dart';
import 'package:hub/widgets/appbar_widgets.dart';

import '../model/cust_order_model.dart';

class CustomerOrders extends StatelessWidget {
  const CustomerOrders({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        centerTitle: true,
        leading: const AppBarBackButton(),
        title: const AppbarTitle(title: 'Orders'),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: store
            .collection('orders')
            .where('cid', isEqualTo: auth.currentUser!.uid)
            .snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) {
            return const Text('Something went wrong');
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          if (snapshot.data!.docs.isEmpty) {
            return Center(
              child: Text(
                'You hove not \n\n active orders !',
                textAlign: TextAlign.center,
                style: GoogleFonts.acme(
                  color: Colors.blueGrey,
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                ),
              ),
            );
          }
          return ListView.builder(
              itemCount: snapshot.data!.docs.length,
              itemBuilder: (context, index) {
                return CustomerOrderModel(
                  order: snapshot.data!.docs[index],
                );
              });
        },
      ),
    );
  }
}
