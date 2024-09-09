import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:medq_sih/views/utils/bottom_bar.dart';
import 'package:pinput/pinput.dart';

class OtpScreen extends StatefulWidget {
  String verificationId;
  String phoneWithCountryCode;

  OtpScreen(
      {super.key,
        required this.verificationId,
        required this.phoneWithCountryCode});

  @override
  State<OtpScreen> createState() => _OtpScreenState();
}

class _OtpScreenState extends State<OtpScreen> {
  User? currentUser = FirebaseAuth.instance.currentUser;
  FirebaseAuth _auth = FirebaseAuth.instance;

  final GlobalKey<ScaffoldState> _scaffoldkey = GlobalKey<ScaffoldState>();
  String? _verificationCode;
  final TextEditingController _pinPutController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromRGBO(183, 244, 212, 1),
      body: Stack(
        children: [
          const Padding(
            padding: EdgeInsets.only(bottom: 20),
            child: Align(
                alignment: Alignment.bottomCenter,
                child: Image(
                  image: AssetImage("assets/images/doc_gif4.webp"),
                )),
          ),
          Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 80),
                child: Center(
                  child: Text(
                    "MedQ",
                    style: GoogleFonts.roboto(
                      fontSize: 44,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              Center(
                child: Text(
                  "Hospitals at your finger tips",
                  style: GoogleFonts.roboto(
                    fontSize: 16,
                  ),
                ),
              ),
              const SizedBox(
                height: 60,
              ),
              Center(
                child: Pinput(
                  closeKeyboardWhenCompleted: true,
                  length: 6,
                  defaultPinTheme: PinTheme(
                      height: 70,
                      width: 70,
                      margin: const EdgeInsets.all(4),
                      decoration: BoxDecoration(
                          color: Colors.white,
                          border: Border.all(color: Colors.black),
                          borderRadius: BorderRadius.circular(10))),
                  onCompleted: _verifyOtp,
                  onSubmitted: _verifyOtp,
                  keyboardType: TextInputType.number,
                  controller: _pinPutController,
                  hapticFeedbackType: HapticFeedbackType.mediumImpact,
                  keyboardAppearance: Brightness.dark,
                  pinAnimationType: PinAnimationType.slide,
                ),
              )
            ],
          )
        ],
      ),
    );
  }

  _verifyOtp(pin) async {
    ScaffoldMessenger.of(context)
        .showSnackBar(const SnackBar(
      content:
      Text('Checking Your OTP... Please Wait!!'),
      backgroundColor: Colors.green,
    ));
    try {
      PhoneAuthCredential credential =
      PhoneAuthProvider.credential(
          verificationId: widget.verificationId,
          smsCode: pin);

      // Sign the user in (or link) with the credential
      _auth
          .signInWithCredential(credential)
          .then((value) {
        Navigator.pushReplacement(
            context,
            MaterialPageRoute(
                builder: (context) =>
                const BottomBar()));
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(e.toString())));
    }
  }
}
