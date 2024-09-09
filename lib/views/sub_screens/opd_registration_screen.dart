import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:medq_sih/views/sub_screens/payment_screen.dart';

class OpdRegistrationScreen extends StatefulWidget {
  const OpdRegistrationScreen({super.key, required this.hospital});
  final String hospital;

  @override
  State<OpdRegistrationScreen> createState() => _OpdRegistrationScreenState();
}

class _OpdRegistrationScreenState extends State<OpdRegistrationScreen> {
  final currentUser = FirebaseAuth.instance.currentUser;

  final TextEditingController _timeController = TextEditingController();
  final TextEditingController _concernController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _ageController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _pincodeController = TextEditingController();
  String _date = DateTime.now().day.toString() +
      '/' +
      DateTime.now().month.toString() +
      '/' +
      DateTime.now().year.toString();

  @override
  Widget build(BuildContext context) {
    final String hospital = widget.hospital.toString();
    return Scaffold(
      body: Stack(
        children: [
          CustomPaint(
            size: Size(double.infinity, 200), // Adjust the size as needed
            painter: HalfCirclePainter(),
          ),
          // Add other widgets here
          SingleChildScrollView(
            child: Column(
              children: [
                SizedBox(
                  height: 70,
                ),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 40, vertical: 30),
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
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: [
                        _timeSlotSelector(
                            "09:00 - 11:00 AM", Colors.red, () {}),
                        _timeSlotSelector(
                            "11:00 - 01:00 PM", Colors.red, () {}),
                        _timeSlotSelector("01:00 - 03:00 PM", Colors.green, () {
                          setState(() {
                            _timeController.text = "01:00 - 03:00 PM";
                          });
                        }),
                        _timeSlotSelector(
                            "03:00 - 05:00 PM", Colors.red, () {}),
                        _timeSlotSelector(
                            "05:00 - 07:00 PM", Colors.red, () {}),
                        _timeSlotSelector("07:00 - 09:00 PM", Colors.green, () {
                          setState(() {
                            _timeController.text = "07:30 - 09:00 PM";
                          });
                        }),
                        // _timeSlotSelector("12:30 - 01:00 PM", Colors.red, () {}),
                        // _timeSlotSelector("01:00 - 01:30 PM", Colors.red, () {}),
                        // _timeSlotSelector("01:30 - 02:00 PM", Colors.red, () {}),
                        // _timeSlotSelector("02:00 - 02:30 PM", Colors.green, () {
                        //   setState(() {
                        //     _timeController.text = "02:00 - 02:30 PM";
                        //   });
                        // }),
                        // _timeSlotSelector("02:30 - 03:00 PM", Colors.green, () {
                        //   setState(() {
                        //     _timeController.text = "02:30 - 03:00 PM";
                        //   });
                        // }),
                        // _timeSlotSelector("03:00 - 03:30 PM", Colors.green, () {
                        //   setState(() {
                        //     _timeController.text = "03:00 - 03:30 PM";
                        //   });
                        // }),
                        // _timeSlotSelector("03:30 - 04:00 PM", Colors.red, () {}),
                        // _timeSlotSelector("04:00 - 04:30 PM", Colors.red, () {}),
                        // _timeSlotSelector("04:30 - 05:00 PM", Colors.red, () {}),
                        // _timeSlotSelector("05:00 - 05:30 PM", Colors.red, () {}),
                        // _timeSlotSelector("05:30 - 06:00 PM", Colors.red, () {}),
                        // _timeSlotSelector("06:00 - 06:30 PM", Colors.green, () {
                        //   setState(() {
                        //     _timeController.text = "06:00 - 06:30 PM";
                        //   });
                        // }),
                        // _timeSlotSelector("06:30 - 07:00 PM", Colors.red, () {}),
                        // _timeSlotSelector("07:00 - 07:30 PM", Colors.red, () {}),
                        // _timeSlotSelector("07:30 - 08:00 PM", Colors.red, () {}),
                      ],
                    ),
                  ),
                ),
                _formField('Name', TextInputType.name, _nameController),
                _formField('Age', TextInputType.number, _ageController),
                _formField(
                    'Phone Number', TextInputType.phone, _phoneController),
                _formField(
                    'Email', TextInputType.emailAddress, _emailController),
                _formField(
                    'Address', TextInputType.streetAddress, _addressController),
                _formField('Pincode', TextInputType.number, _pincodeController),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                  child: TextField(
                    readOnly: true,
                    keyboardType: TextInputType.datetime,
                    decoration: InputDecoration(
                        border: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.black),
                            borderRadius: BorderRadius.circular(10)),
                        hintText: DateTime.now().day.toString() +
                            '/' +
                            DateTime.now().month.toString() +
                            '/' +
                            DateTime.now().year.toString()),
                  ),
                ),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                  child: TextField(
                    controller: _timeController,
                    readOnly: true,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.black),
                          borderRadius: BorderRadius.circular(10)),
                      hintText: 'Select Time',
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                  child: ListTile(
                    title: Text('Select Concern'),
                    trailing: Icon(Icons.arrow_drop_down),
                    onTap: () {
                      showModalBottomSheet(
                          context: context,
                          builder: (context) {
                            return Padding(
                              padding: const EdgeInsets.symmetric(vertical: 20),
                              child: GridView(
                                gridDelegate:
                                    SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 3,
                                ),
                                children: [
                                  _customConcernBtn('Allergy'),
                                  _customConcernBtn('Ayurveda'),
                                  _customConcernBtn('Bladder'),
                                  _customConcernBtn('Brain'),
                                  _customConcernBtn('Breast-Cancer'),
                                  _customConcernBtn('Corona Virus'),
                                  _customConcernBtn('Diet'),
                                  _customConcernBtn('Floss'),
                                  _customConcernBtn('Heart-Attack'),
                                  _customConcernBtn('Homeopathy'),
                                  _customConcernBtn('Kidney'),
                                  _customConcernBtn('Lungs'),
                                  _customConcernBtn('Mental-Health'),
                                  _customConcernBtn('Ophtalmology'),
                                  _customConcernBtn('Pain in Joints'),
                                  _customConcernBtn('Physical-Therapy'),
                                  _customConcernBtn('Plastic-Surgery'),
                                  _customConcernBtn('Sore-Throat'),
                                  _customConcernBtn('Specialist'),
                                  _customConcernBtn('STD'),
                                  _customConcernBtn('Stethoscope'),
                                  _customConcernBtn('Veterinary'),
                                  _customConcernBtn('Woman'),
                                ],
                              ),
                            );
                          });
                    },
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                ElevatedButton(
                  onPressed: () {
                    createRecord();
                    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => PaymentScreen(hospital: hospital,)));
                  },
                  child: Text(
                    'Submit',
                    style: TextStyle(
                        color: Colors.white, fontWeight: FontWeight.bold),
                  ),
                  style: ButtonStyle(
                      backgroundColor: WidgetStatePropertyAll(Colors.blue)),
                )
              ],
            ),
          )
        ],
      ),
    );
  }

  _formField(String title, TextInputType keyboardType,
      TextEditingController controller) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
      child: TextField(
        controller: controller,
        keyboardType: keyboardType,
        decoration: InputDecoration(
            border: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.black),
                borderRadius: BorderRadius.circular(10)),
            labelText: title),
      ),
    );
  }

  _customConcernBtn(String title) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: InkWell(
        onTap: () {
          setState(() {
            _concernController.text = title;
          });
        },
        child: Container(
          color: Colors.red[100],
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Center(
                  child: Image.asset(
                "assets/images/concerns/${title.toLowerCase().replaceAll(' ', '')}.png",
                height: 40,
                width: 40,
              )),
              Center(child: Text(title)),
            ],
          ),
        ),
      ),
    );
  }

  _timeSlotSelector(String timeSlot, Color color, Function()? onTap) {
    return InkWell(
      onTap: onTap,
      child: Container(
        height: 90,
        width: 70,
        decoration: BoxDecoration(border: Border.all(color: Colors.black)),
        child: Column(
          children: [
            Container(
              height: 60,
              width: 70,
              color: color,
            ),
            Text(
              timeSlot,
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 10),
            ),
          ],
        ),
      ),
    );
  }

  // Function for storing data in Realtime Database

  void createRecord() {
    DatabaseReference databaseReference = FirebaseDatabase.instance
        .ref('opd_registrations')
        .child(widget.hospital.toString());

    databaseReference.push().set({
      'name': _nameController.text,
      'age': _ageController.text,
      'phone': _phoneController.text,
      'email': _emailController.text,
      'address': _addressController.text,
      'pincode': _pincodeController.text,
      'concern': _concernController.text,
      'date': _date,
      'time': _timeController.text,
      'hospital': widget.hospital.toString(),
    });
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
