import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:medq_sih/views/sub_screens/payment_success_screen.dart';

class PaymentScreen extends StatelessWidget {
  const PaymentScreen({super.key, required this.hospital});
  final String hospital;

  @override
  Widget build(BuildContext context) {
    bool _isGooglePaySelected = false;
    bool _isPaytmSelected = false;
    bool _isCardSelected = false;
    bool _isPhonePeSelected = false;
    bool _isMobikwikSelected = false;
    bool _isCredSelected = false;

    return Scaffold(
      body: Stack(
        children: [
          CustomPaint(
            size: Size(double.infinity, 200), // Adjust the size as needed
            painter: HalfCirclePainter(),
          ),
          SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    height: 70,
                  ),
                  Padding(
                    padding:
                    const EdgeInsets.symmetric(horizontal: 25, vertical: 30),
                    child: Container(
                      height: 70,
                      width: double.infinity,
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.5),
                              spreadRadius: 5,
                              blurRadius: 7,
                              offset: Offset(0, 3), // changes position of shadow
                            ),
                          ]),
                      child: Center(
                        child: Text(
                          'OPD Registration',
                          style: GoogleFonts.anton(
                            fontSize: 33,
                          ),
                        ),
                      ),
                    ),
                  ),
                  Text(
                    'Preferred Mode',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 16),
                  _PaymentOption(
                    icon: Image.asset('assets/images/gpay.webp', height: 40,),
                    title: 'Google Pay',
                    isSelected: true,
                    onPressed: () {},
                  ),
                  SizedBox(height: 16),
                  _PaymentOption(
                    icon: Image.asset('assets/images/paytm.png', height: 50,),
                    title: 'Paytm',
                    isSelected: false,
                    onPressed: () {},
                  ),
                  SizedBox(height: 16),
                  _PaymentOption(
                    icon: Icon(CupertinoIcons.creditcard, size: 40,),
                    title: 'Credit/Debit Card',
                    isSelected: false,
                    onPressed: () {},
                  ),
                  SizedBox(height: 16),
                  Text(
                    'UPI',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 16),
                  _PaymentOption(
                    icon: Image.asset('assets/images/phonepe.webp', height: 45,),
                    title: 'PhonePe UPI',
                    isSelected: false,
                    onPressed: () {},
                  ),
                  SizedBox(height: 16),
                  _PaymentOption(
                    icon: Image.asset('assets/images/mobikwick.webp', height: 38,),
                    title: 'Mobikwik',
                    isSelected: false,
                    onPressed: () {},
                  ),
                  SizedBox(height: 16),
                  _PaymentOption(
                    icon: Image.asset('assets/images/cred.png', height: 45,),
                    title: 'CRED pay',
                    isSelected: false,
                    onPressed: () {},
                  ),
                  SizedBox(height: 32),
                  Center(
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => PaymentSuccessScreen()));
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.lightBlue,
                        padding: EdgeInsets.symmetric(vertical: 16, horizontal: 32),
                        textStyle: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      child: Text('MAKE PAYMENT'),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );



      // Padding(
      //   padding: const EdgeInsets.all(20.0),
      //   child: Column(
      //     children: [
      //       Card(
      //         child: ListTile(
      //           leading: Image.asset("assets/images/paytm.png", height: 50,),
      //           title: Text('Paytm'),
      //           subtitle: Text('Pay using Paytm'),
      //         ),
      //       ),
      //       Card(
      //         child: ListTile(
      //           leading: Image.asset("assets/images/gpay.webp", height: 30,),
      //           title: Text('Google Pay'),
      //           subtitle: Text('Pay using Google Pay'),
      //         ),
      //       ),
      //       Card(
      //         child: ListTile(
      //           leading: Image.asset("assets/images/phonepe.webp", height: 40,),
      //           title: Text('PhonePe'),
      //           subtitle: Text('Pay using PhonePe'),
      //         ),
      //       ),
      //       Card(
      //         child: ListTile(
      //           leading: Icon(Icons.credit_card, size: 40,),
      //           title: Text('Debit/Credit Card'),
      //           subtitle: Text('Pay using Debit/Credit Card'),
      //         ),
      //       ),
      //       // Add more payment options as needed
      //     ],
      //   ),
      // ),
    // );
  }
}


class _PaymentOption extends StatelessWidget {
  final Widget icon;
  final String title;
  final bool isSelected;
  final VoidCallback onPressed;

  const _PaymentOption({
    required this.icon,
    required this.title,
    required this.isSelected,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onPressed,
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 16, horizontal: 6),
        decoration: BoxDecoration(
          border: Border.all(
            color: Colors.grey[300]!,
            width: 1,
          ),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          children: [
            icon,
            SizedBox(width: 16),
            Text(
              title,
              style: TextStyle(fontSize: 16),
            ),
            Spacer(),
            if (isSelected)
              Icon(
                Icons.check_circle,
                color: Colors.lightBlue,
              ),
          ],
        ),
      ),
    );
  }
}

class HalfCirclePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()
      ..color = Colors.blue // Set your desired color
      ..style = PaintingStyle.fill;

    canvas.drawArc(
      Rect.fromCircle(
        center: Offset(size.width / 2, -30),
        radius: size.height,
      ),
      0,
      3.14, // pi for half circle
      false,
      paint,
    );
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return false;
  }
}