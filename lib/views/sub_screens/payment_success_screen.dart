import 'package:flutter/material.dart';

class PaymentSuccessScreen extends StatelessWidget {
  const PaymentSuccessScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            height: 170,
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(color: Colors.blue, borderRadius: BorderRadius.vertical(bottom: Radius.circular(50))),
            child: Center(
              child: Text(
                'Payment Success',
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 30,
                    fontWeight: FontWeight.bold
                ),
              ),
            ),
          ),

          SizedBox(height: 130,),
          Center(
            child: Image.asset("assets/images/tick.gif", height: 200),
          ),

          SizedBox(height: 100,),

          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text("Thank you for your payment. Your health is our concern.", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),),
          ),

          SizedBox(height: 20,),

          ElevatedButton(onPressed: () {
            Navigator.pop(context);
          }, child: Text("Go to HomePage"))
        ],
      ),
    );
  }
}