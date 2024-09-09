import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class TermsConditionsPage extends StatelessWidget {
  const TermsConditionsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          CustomPaint(
            size: Size(double.infinity, 200), // Adjust the size as needed
            painter: HalfCirclePainter(),
          ),

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
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
                        'Terms & Conditions',
                        style: GoogleFonts.anton(
                          fontSize: 29,
                        ),
                      ),
                    ),
                  ),
                ),

                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.black),
                    ),
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          _heading("AGREEMENT TO OUR LEGAL TERMS"),
                          SizedBox(height: 8,),
                          Text('''
We are MedQ ("Company," "we," "us," "our"), a company registered in India at MedQ headquarter, ABC Colony, Delhi, Delhi 202020.

We operate the mobile application MedQ (the "App"), as well as any other related products and services that refer or link to these legal terms (the "Legal Terms") (collectively, the "Services").

The MedQ App is a hospital-based solution designed to bring healthcare services directly to user's fingertips.

You can contact us by phone at 8764493962, email at rishiraj11a+medq@gmail.com, or by mail to MedQ headquarter, ABC Colony, Delhi, Delhi 202020, India.

These Legal Terms constitute a legally binding agreement made between you, whether personally or on behalf of an entity ("you"), and MedQ, concerning your access to and use of the Services. You agree that by accessing the Services, you have read, understood, and agreed to be bound by all of these Legal Terms. IF YOU DO NOT AGREE WITH ALL OF THESE LEGAL TERMS, THEN YOU ARE EXPRESSLY PROHIBITED FROM USING THE SERVICES AND YOU MUST DISCONTINUE USE IMMEDIATELY.

Supplemental terms and conditions or documents that may be posted on the Services from time to time are hereby expressly incorporated herein by reference. We reserve the right, in our sole discretion, to make changes or modifications to these Legal Terms at any time and for any reason. We will alert you about any changes by updating the "Last updated" date of these Legal Terms, and you waive any right to receive specific notice of each such change. It is your responsibility to periodically review these Legal Terms to stay informed of updates. You will be subject to, and will be deemed to have been made aware of and to have accepted, the changes in any revised Legal Terms by your continued use of the Services after the date such revised Legal Terms are posted.

All users who are minors in the jurisdiction in which they reside (generally under the age of 18) must have the permission of, and be directly supervised by, their parent or guardian to use the Services. If you are a minor, you must have your parent or guardian read and agree to these Legal Terms prior to you using the Services.

We recommend that you print a copy of these Legal Terms for your records.
                          '''),
                          SizedBox(height: 12,),
                          _heading("TABLE OF CONTENTS"),
                          SizedBox(height: 8,),
                          Text('''
1. OUR SERVICES
2. INTELLECTUAL PROPERTY RIGHTS
3. USER REPRESENTATIONS
4. USER REGISTRATION
5. SUBSCRIPTIONS
6. PROHIBITED ACTIVITIES
7. USER GENERATED CONTRIBUTIONS
8. CONTRIBUTION LICENSE
9. MOBILE APPLICATION LICENSE
10. SERVICES MANAGEMENT
11. PRIVACY POLICY
12. TERM AND TERMINATION
13. MODIFICATIONS AND INTERRUPTIONS
14. GOVERNING LAW
15. DISPUTE RESOLUTION
16. CORRECTIONS
17. DISCLAIMER
18. LIMITATIONS OF LIABILITY
19. INDEMNIFICATION
20. USER DATA
21. ELECTRONIC COMMUNICATIONS, TRANSACTIONS, AND SIGNATURES
22. MISCELLANEOUS
23. CONTACT US
                          '''),
                          SizedBox(height: 20,),
                          _heading("1. OUR SERVICES"),
                          SizedBox(height: 8,),
                          Text('''
The information provided when using the Services is not intended for distribution to or use by any person or entity in any jurisdiction or country where such distribution or use would be contrary to law or regulation or which would subject us to any registration requirement within such jurisdiction or country. Accordingly, those persons who choose to access the Services from other locations do so on their own initiative and are solely responsible for compliance with local laws, if and to the extent local laws are applicable.
                          '''),
                          SizedBox(height: 15,),
                          _heading("2. INTELLECTUAL PROPERTY RIGHTS"),
                          SizedBox(height: 8,),
                          Text('''
Our intellectual property

We are the owner or the licensee of all intellectual property rights in our Services, including all source code, databases, functionality, software, website designs, audio, video, text, photographs, and graphics in the Services (collectively, the "Content"), as well as the trademarks, service marks, and logos contained therein (the "Marks").

Our Content and Marks are protected by copyright and trademark laws (and various other intellectual property rights and unfair competition laws) and treaties in the United States and around the world.

The Content and Marks are provided in or through the Services "AS IS" for your personal, non-commercial use or internal business purpose only.

Your use of our Services

Subject to your compliance with these Legal Terms, including the "PROHIBITED ACTIVITIES" section below, we grant you a non-exclusive, non-transferable, revocable license to:
access the Services; and
download or print a copy of any portion of the Content to which you have properly gained access.
solely for your personal, non-commercial use or internal business purpose.

Except as set out in this section or elsewhere in our Legal Terms, no part of the Services and no Content or Marks may be copied, reproduced, aggregated, republished, uploaded, posted, publicly displayed, encoded, translated, transmitted, distributed, sold, licensed, or otherwise exploited for any commercial purpose whatsoever, without our express prior written permission.

If you wish to make any use of the Services, Content, or Marks other than as set out in this section or elsewhere in our Legal Terms, please address your request to: rishiraj11a+medq@gmail.com. If we ever grant you the permission to post, reproduce, or publicly display any part of our Services or Content, you must identify us as the owners or licensors of the Services, Content, or Marks and ensure that any copyright or proprietary notice appears or is visible on posting, reproducing, or displaying our Content.

We reserve all rights not expressly granted to you in and to the Services, Content, and Marks.

Any breach of these Intellectual Property Rights will constitute a material breach of our Legal Terms and your right to use our Services will terminate immediately.

Your submissions

Please review this section and the "PROHIBITED ACTIVITIES" section carefully prior to using our Services to understand the (a) rights you give us and (b) obligations you have when you post or upload any content through the Services.

Submissions: By directly sending us any question, comment, suggestion, idea, feedback, or other information about the Services ("Submissions"), you agree to assign to us all intellectual property rights in such Submission. You agree that we shall own this Submission and be entitled to its unrestricted use and dissemination for any lawful purpose, commercial or otherwise, without acknowledgment or compensation to you.

You are responsible for what you post or upload: By sending us Submissions through any part of the Services you:
confirm that you have read and agree with our "PROHIBITED ACTIVITIES" and will not post, send, publish, upload, or transmit through the Services any Submission that is illegal, harassing, hateful, harmful, defamatory, obscene, bullying, abusive, discriminatory, threatening to any person or group, sexually explicit, false, inaccurate, deceitful, or misleading;
to the extent permissible by applicable law, waive any and all moral rights to any such Submission;
warrant that any such Submission are original to you or that you have the necessary rights and licenses to submit such Submissions and that you have full authority to grant us the above-mentioned rights in relation to your Submissions; and
warrant and represent that your Submissions do not constitute confidential information.
You are solely responsible for your Submissions and you expressly agree to reimburse us for any and all losses that we may suffer because of your breach of (a) this section, (b) any third party’s intellectual property rights, or (c) applicable law.
                          ''')
                        ],
                      ),
                    ),
                  ),
                )
              ],
            ),
          )
        ],
      ),
    );
  }

  _heading(String text) {
    return Text(text, style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),);
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
