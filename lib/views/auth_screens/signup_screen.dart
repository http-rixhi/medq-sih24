import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:country_picker/country_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:medq_sih/views/auth_screens/login_screen.dart';

import 'otp_screen.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final TextEditingController _phone =TextEditingController();
  final TextEditingController _name =TextEditingController();
  final TextEditingController _email =TextEditingController();

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  get data => null;
  final currentUser = FirebaseAuth.instance.currentUser;

  @override
  void dispose() {
    super.dispose();
    _name.dispose();
    _phone.dispose();
    _email.dispose();
  }

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
  late final phoneNumberExists;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(
                height: (MediaQuery.of(context).size/2.5).height,
                child: const Image(image: AssetImage("assets/images/doc_anim2.gif"), fit: BoxFit.fill,),
              ),
              Container(
                // height: (MediaQuery.of(context).size/2).height,
                decoration: const BoxDecoration(
                    color: Colors.blue,
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(18),
                        topRight: Radius.circular(18)
                    )
                ),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    children: [
                      const SizedBox(height: 43,),
                      Text("MedQ", style: GoogleFonts.roboto(
                        fontSize: 44,
                        fontWeight: FontWeight.bold,

                      ),),
                      const SizedBox(height: 60,),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 18),
                        child: TextField(
                          controller: _name,
                          keyboardType: TextInputType.name,
                          style: const TextStyle(color: Colors.black),
                          decoration: InputDecoration(
                              prefixIcon: const Icon(Icons.person),
                              hintText: 'Enter Name',
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
                      const SizedBox(height: 15,),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 18),
                        child: TextField(
                          controller: _email,
                          keyboardType: TextInputType.emailAddress,
                          style: const TextStyle(color: Colors.black),
                          decoration: InputDecoration(
                              prefixIcon: const Icon(Icons.email),
                              hintText: 'Enter Email',
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
                      const SizedBox(height: 15,),
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
                      const SizedBox(height: 35,),
                      Padding(padding: const EdgeInsets.symmetric(horizontal: 18),
                        child: ElevatedButton(onPressed: signUpButton, style: ElevatedButton.styleFrom(
                            backgroundColor: CupertinoColors.black
                        ), child: const Text("Sign Up", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold,fontSize: 24),)),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text("Already have an account?", style: GoogleFonts.roboto(
                              fontWeight: FontWeight.bold,
                              fontSize: 13
                          )),
                          TextButton(onPressed: () {
                            Navigator.push(context, MaterialPageRoute(builder: (context) => const LoginScreen()));
                          }, child: Text("Login Now", style: GoogleFonts.roboto(
                              fontWeight: FontWeight.bold,
                              fontSize: 13
                          ),),),
                        ],
                      )
                    ],
                  ),
                ),
              )
            ],
          ),
        )
    );
  }

  signUpButton() async {
    var collection = _firestore.collection('Users');
    var querySnapshot = await collection.get();
    for (var queryDocumentSnapshot in querySnapshot.docs) {
      Map<String, dynamic> data = queryDocumentSnapshot.data();
      var phone = data['Phone'];

      if (phone == _phoneWithCountryCode) {
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("You already have an account!")));
        Navigator.push(context,
            MaterialPageRoute(builder: (context) => const LoginScreen()));
      } else {
        signUpFunc();
      }
    }
  }

  signUpFunc() async {
    if (_name.text.isNotEmpty &&
        _phone.text.isNotEmpty &&
        _email.text.isNotEmpty) {
      await _auth.verifyPhoneNumber(
        phoneNumber: _phoneWithCountryCode,
        verificationCompleted: (PhoneAuthCredential credential) async {
          await _auth.signInWithCredential(credential);
        },
        verificationFailed: (FirebaseAuthException e) {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text(e.toString()),
            backgroundColor: Colors.blue[300],
          ));
          if (e.code == 'invalid-phone-number') {
            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                content: Text("Please enter a valid phone number!!")));
          }
        },
        codeSent: (String verificationId, int? resendToken) async {
          LoginScreen.verify = verificationId;
          Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => OtpScreen(
                    verificationId: verificationId,
                    phoneWithCountryCode: _phoneWithCountryCode.toString()),
              ));

          // Storing data in Firestore
          await _firestore
              .collection("Users")
              .doc(_phoneWithCountryCode.toString())
              .set({
            "Date": DateTime.now(),
            "Name": _name.text,
            "Phone": _phoneWithCountryCode,
            "Email": _email.text
          });
        },
        timeout: const Duration(seconds: 60),
        codeAutoRetrievalTimeout: (String verificationId) {},
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('Fill all Details'),
        backgroundColor: Colors.blue,
      ));
    }
  }
}
