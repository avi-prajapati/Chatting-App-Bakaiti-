import 'dart:io';

import 'package:bakaiti_app/main.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:image_picker/image_picker.dart';
import '../api/apis.dart';
import '../helper/dialogs.dart';
import '../models/user_chat.dart';
import 'auth/login_screen.dart';

//Profile Screen to show the user Profile.
class ProfileScreen extends StatefulWidget {
  final UserChat user;

  const ProfileScreen({super.key, required this.user});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  //To Store Form Key State.
  final _formKey = GlobalKey<FormState>();

  //To Store the image from gallery and camera of device.
  String? _image;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        //App bar of a App.
        appBar: AppBar(
          iconTheme: const IconThemeData(color: Colors.white),
          elevation: 10,
          centerTitle: true,
          title: const Text('Profile Screen'),
        ),

        //Floating button In the App.
        floatingActionButton: Padding(
          padding: const EdgeInsets.only(bottom: 10),
          child: FloatingActionButton.extended(
            elevation: 10,
            backgroundColor: const Color(0xFFFF7701),
            onPressed: () async {
              //To show Progress bar while logout.
              Dialogs.showProgressBar(context);

              //for Sign out
              await APIs.auth.signOut().then(
                (value) async {
                  await GoogleSignIn().signOut().then(
                    (value) {
                      //To hide Progressbar.
                      Navigator.pop(context);

                      //For Replaceing from home screen to login screen.
                      Navigator.pop(context);

                      //To change the Screen after logout.
                      Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const LoginScreen(),
                          ));
                    },
                  );
                },
              );

              //Move to Login Screen after Sign out.
            },
            label: const Text(
              'Logout',
              style: TextStyle(fontWeight: FontWeight.w700),
            ),
            icon: const Icon(
              Icons.logout,
              color: Colors.white,
            ),
          ),
        ),

        //Body of the Profile screen.
        body: Form(
          key: _formKey,
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: mq.width * .03),

            //To make Scrollable Profile screen.
            child: SingleChildScrollView(
              child: Column(
                children: [
                  //Circle icon in the profile screen.
                  SizedBox(width: mq.width, height: mq.height * .05),
                  Stack(
                    children: [
                      //Here we are using Terinory operator to show the dp of user.
                      _image != null
                          ?

                          //Local Image / Image from gallery.
                          ClipRRect(
                              borderRadius:
                                  BorderRadius.circular(mq.height * .1),
                              child: Image.file(
                                File(_image!),
                                height: mq.height * .19,
                                width: mq.height * .19,
                                fit: BoxFit.cover,
                              ),
                            )
                          :

                          //Image from Server.
                          ClipRRect(
                              borderRadius:
                                  BorderRadius.circular(mq.height * .1),
                              child: CachedNetworkImage(
                                height: mq.height * .19,
                                width: mq.height * .19,
                                fit: BoxFit.cover,
                                imageUrl: '${widget.user.image}',
                                errorWidget: (context, url, error) =>
                                    const CircleAvatar(
                                  backgroundColor: Color(0xF42A3145),
                                  child: Icon(
                                    CupertinoIcons.person_alt,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ),

                      //To change profile image means dp of user.
                      Positioned(
                        bottom: -5,
                        right: -9,
                        child: MaterialButton(
                          onPressed: () {
                            _showBottomSheet();
                          },
                          shape: const CircleBorder(),
                          color: const Color(0xFFFF7701),
                          child: const Icon(Icons.edit),
                        ),
                      )
                    ],
                  ),

                  //Text to show the email of the admin.
                  SizedBox(width: mq.width, height: mq.height * .03),
                  Text('${widget.user.email}',
                      style: const TextStyle(
                          color: Colors.black,
                          fontSize: 18,
                          fontWeight: FontWeight.w700)),

                  //TextFormField to show the name of the admin.
                  SizedBox(width: mq.width, height: mq.height * .03),
                  TextFormField(
                    //To Show user updated value.
                    onSaved: (newValue) =>
                        APIs.loggined_user.name = newValue ?? '',

                    //To Validate the texbox.
                    validator: (newValue) =>
                        newValue != null && newValue.isNotEmpty
                            ? null
                            : 'Required field',

                    //To Show Default Value which data present in the email.
                    initialValue: widget.user.name,
                    decoration: InputDecoration(
                        prefixIcon: const Icon(Icons.person),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12)),
                        label: const Text('Name'),
                        hintText: 'Ex. Avinash Prajapati'),
                  ),

                  //TextFormField to show about the admin.
                  SizedBox(width: mq.width, height: mq.height * .03),
                  TextFormField(
                    //To Show user updated value.
                    onSaved: (newValue) =>
                        APIs.loggined_user.about = newValue ?? '',

                    //To Validate the texbox.
                    validator: (newValue) =>
                        newValue != null && newValue.isNotEmpty
                            ? null
                            : 'Required field',

                    //To Show Default Value which data present in the email.
                    initialValue: widget.user.about,
                    decoration: InputDecoration(
                        prefixIcon: const Icon(Icons.info),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12)),
                        label: const Text('About'),
                        hintText: 'Ex. Developer'),
                  ),

                  //Elevated buttton to update.
                  SizedBox(width: mq.width, height: mq.height * .04),
                  ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                        shape: const StadiumBorder(),
                        minimumSize: Size(mq.width * .3, mq.height * .065),
                        backgroundColor: const Color(0xF42A3145)),
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        //To Save the Data.
                        _formKey.currentState!.save();

                        //To save that data in Firebase.
                        APIs.storeUpdatedDataOfProfile();

                        //To Show Snack Bar.
                        Dialogs.showSnackBar(context, 'Updated Successfully');
                      }
                    },
                    icon: const Icon(
                      Icons.edit,
                      color: Colors.white,
                    ),
                    label: const Text(
                      'Update',
                      style: TextStyle(color: Colors.white, fontSize: 18),
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  //Bottom sheet to pick a picture from it.
  void _showBottomSheet() {
    showModalBottomSheet(
        context: context,
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        )),
        builder: (context) {
          return ListView(
            shrinkWrap: true,
            padding:
                EdgeInsets.only(top: mq.height * .03, bottom: mq.height * .03),

            //TextView of Bottom Sheet Picker.
            children: [
              const Text(
                'Pick Profile Picture',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontWeight: FontWeight.w700,
                  fontSize: 18,
                ),
              ),

              //For space between text and button.
              SizedBox(
                height: mq.height * .02,
              ),

              //Two Elevated button of gallery and camera.
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  //Gallery button to pick image.
                  ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          shape: const CircleBorder(),
                          fixedSize: Size(mq.width * .3, mq.height * .13)),

                      //Logic of the button.
                      onPressed: () async {
                        final ImagePicker picker = ImagePicker();

                        //pick an image.
                        final XFile? image =
                            await picker.pickImage(source: ImageSource.gallery);
                        if (image != null) {
                          //To hide a bottom sheet picker.
                          Navigator.pop(context);

                          //To update state and get image url.
                          setState(() {
                            _image = image.path;
                          });
                        }
                      },
                      child: Image.asset('images/image-gallery.png')),

                  //Camera to click a picture.
                  ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          shape: const CircleBorder(),
                          fixedSize: Size(mq.width * .3, mq.height * .13)),
                      onPressed: () async {
                        final ImagePicker picker = ImagePicker();

                        //pick an image.
                        final XFile? image =
                            await picker.pickImage(source: ImageSource.camera);
                        if (image != null) {
                          //To hide a bottom sheet picker.
                          Navigator.pop(context);

                          //To update state and get image url.
                          setState(() {
                            _image = image.path;
                          });
                        }
                      },
                      child: Image.asset('images/3d-camera.png')),
                ],
              )
            ],
          );
        });
  }
}
