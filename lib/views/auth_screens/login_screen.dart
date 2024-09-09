import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:country_picker/country_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:medq_sih/views/auth_screens/otp_screen.dart';
import 'package:medq_sih/views/auth_screens/signup_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  static String verify = "";

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _phone = TextEditingController();

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Country countryCode = Country(
      phoneCode: "91",
      countryCode: "IN",
      e164Sc: 0,
      geographic: true,
      level: 1,
      name: "India",
      example: "India",
      displayName: "India",
      displayNameNoCountryCode: "IN",
      e164Key: "");

  late final String _phoneWithCountryCode =
      "+${countryCode.phoneCode}${_phone.text}";
  bool phoneNumberExists = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SingleChildScrollView(
      child: Column(
        children: [
          SizedBox(
            height: (MediaQuery.of(context).size / 2).height,
            child: const Image(image: AssetImage("assets/images/doc_anim.gif"), fit: BoxFit.fill,),
          ),
          Container(
            height: (MediaQuery.of(context).size / 2).height,
            decoration: BoxDecoration(
                color: Colors.blue[300],
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(18),
                    topRight: Radius.circular(18))),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  const SizedBox(
                    height: 33,
                  ),
                  Text(
                    "MedQ",
                    style: GoogleFonts.roboto(
                      fontSize: 44,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(
                    height: 50,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 18),
                    child: TextField(
                      style: const TextStyle(color: Colors.black),
                      controller: _phone,
                      keyboardType: TextInputType.number,
                      maxLength: 10,
                      decoration: InputDecoration(
                          prefixIcon: Container(
                            padding: const EdgeInsets.only(
                                top: 12, bottom: 10, right: 8, left: 10),
                            child: InkWell(
                              onTap: () {
                                showCountryPicker(
                                    context: context,
                                    countryListTheme:
                                    const CountryListThemeData(
                                      bottomSheetHeight: 450,
                                    ),
                                    onSelect: (value) {
                                      setState(() {
                                        countryCode = value;
                                      });
                                    });
                              },
                              child: Text(
                                "${countryCode.flagEmoji} + ${countryCode.phoneCode}",
                                style: const TextStyle(
                                    fontSize: 17,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black),
                              ),
                            ),
                          ),
                          suffixIcon: _phone.text.length != 10
                              ? null
                              : const Icon(
                            CupertinoIcons.check_mark_circled_solid,
                            color: Colors.green,
                          ),
                          hintText: 'Enter Phone',
                          hintStyle: const TextStyle(color: Colors.black),
                          filled: true,
                          fillColor: Colors.white,
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(50),
                              borderSide: const BorderSide(
                                  color: Colors.black,
                                  style: BorderStyle.solid))),
                    ),
                  ),
                  const SizedBox(
                    height: 35,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 18),
                    child: ElevatedButton(
                        onPressed: getOtpButton,
                        style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.black),
                        child: const Text(
                          "Get OTP",
                          style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 27),
                        )),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text("Don't have an account?",
                          style: GoogleFonts.roboto(
                              fontWeight: FontWeight.bold, fontSize: 13)),
                      TextButton(
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const SignupScreen()));
                        },
                        child: Text(
                          "Signup Now",
                          style: GoogleFonts.roboto(
                              fontWeight: FontWeight.bold, fontSize: 13),
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ),
          )
        ],
      ),
    ));
  }

  getOtpFunc() async {
    ScaffoldMessenger.of(context)
        .showSnackBar(const SnackBar(content: Text('Wait for OTP')));
    await _auth.verifyPhoneNumber(
      phoneNumber: _phoneWithCountryCode,
      verificationCompleted: (PhoneAuthCredential credential) {},
      verificationFailed: (FirebaseAuthException e) {
        if (e.code == 'invalid-phone-number') {
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
              content: Text("Please enter a valid phone number!!")));
        }
      },
      codeSent: (String verificationId, int? resendToken) {
        LoginScreen.verify = verificationId;
        Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => OtpScreen(
                  verificationId: verificationId,
                  phoneWithCountryCode: _phoneWithCountryCode.toString()),
            ));
      },
      timeout: const Duration(seconds: 60),
      codeAutoRetrievalTimeout: (String verificationId) {},
    );
  }

  getOtpButton() async {
    showDialog(
        context: context,
        builder: (context) => const Center(child: CircularProgressIndicator()));

    var collection = _firestore.collection('Users');
    var querySnapshot = await collection.get();
    for (var queryDocumentSnapshot in querySnapshot.docs) {
      Map<String, dynamic> data = queryDocumentSnapshot.data();
      var phone = data['Phone'];
      if (await phone == _phoneWithCountryCode) {
        phoneNumberExists = true;
      }
    }

    if (phoneNumberExists) {
      getOtpFunc();
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("You don't have any account yet!")));
      Navigator.push(context,
          MaterialPageRoute(builder: (context) => const SignupScreen()));
    }
  }
}
