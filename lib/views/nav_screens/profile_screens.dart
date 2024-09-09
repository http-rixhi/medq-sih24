import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:line_icons/line_icons.dart';
import 'package:medq_sih/views/sub_screens/terms_conditions.dart';

enum ImageSourceType { gallery, camera }

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  FirebaseFirestore _firestore = FirebaseFirestore.instance;
  FirebaseAuth _auth = FirebaseAuth.instance;
  final currentUser = FirebaseAuth.instance.currentUser;
  File? _image;

  get data => null;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: _firestore
            .collection('Users')
            .doc(_auth.currentUser!.phoneNumber)
            .snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          } else {
            var imageUrl = snapshot.data!['Image'].toString();
            return Scaffold(
              floatingActionButton: FloatingActionButton(
                onPressed: () {},
                child: const Icon(
                  LineIcons.robot,
                  size: 35,
                ),
              ),
              appBar: AppBar(
                title: const Text("Profile"),
                leading: const Icon(CupertinoIcons.profile_circled),
              ),
              body: SingleChildScrollView(
                child: Column(
                  children: [
                    Center(
                      child: Padding(
                        padding: const EdgeInsets.only(top: 30, bottom: 10),
                        child: GestureDetector(
                          onTap: () async {
                            final image = await ImagePicker()
                                .pickImage(source: ImageSource.gallery);
                            if (image != null) {
                              setState(() {
                                _image = File(image.path);
                              });
                            }

                            var downloadUrl;
                            var imageName = snapshot.data!['Phone'];
                            var storageRef = FirebaseStorage.instance
                                .ref()
                                .child('user_images/$imageName.jpg');
                            var uploadTask = storageRef.putFile(_image!);
                            downloadUrl =
                                await (await uploadTask).ref.getDownloadURL();

                            // Storing data in Firestore
                            await _firestore
                                .collection("Users")
                                .doc(_auth.currentUser!.phoneNumber)
                                .update({"Image": downloadUrl.toString()});
                          },
                          child: Container(
                            height: 100,
                            width: 100,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(100),
                                border: Border.all(color: Colors.black),
                                image: DecorationImage(
                                    image: NetworkImage(imageUrl == ""
                                        ? "https://cdn.pixabay.com/photo/2015/10/05/22/37/blank-profile-picture-973460_1280.png"
                                        : imageUrl),
                                    fit: BoxFit.cover)),
                          ),
                        ),
                      ),
                    ),
                    Text(
                      snapshot.data!['Name'],
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                    ),
                    Text(snapshot.data!['Phone']),
                    const SizedBox(
                      height: 20,
                    ),
                    _customList("Medical Information", CupertinoIcons.person,
                        () => print("dyuwqgdyu")),
                    _customList("Past Reports",
                        CupertinoIcons.rectangle_paperclip, _myOnTapFunction),
                    _customList("Subscriptions and Plans",
                        CupertinoIcons.money_dollar, _myOnTapFunction),
                    _customList(
                        "Help & Support", Icons.support, _myOnTapFunction),
                    _customList("Terms & Conditions", Icons.newspaper, () {Navigator.push(context, MaterialPageRoute(builder: (context) => const TermsConditionsPage()));}),
                    _customList("Logout", Icons.logout, signOut),
                  ],
                ),
              ),
            );
          }
        });
  }

  _customList(String title, IconData icon, Function()? onTap) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
      child: ListTile(
        tileColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        leading: Icon(icon),
        title: Text(title),
        trailing: const Icon(Icons.arrow_forward_ios),
        onTap: onTap,
      ),
    );
  }

  void _myOnTapFunction() {
    // Do something when the ListTile is tapped, e.g., navigate to another screen
    print('ListTile tapped!');
  }

  signOut() async {
    await _auth.signOut();
  }
}
