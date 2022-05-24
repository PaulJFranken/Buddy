import 'dart:io';
import 'dart:ui';

import 'package:buddy/helperfunctions/sharedpref_helper.dart';
import 'package:buddy/screens/home.dart';
import 'package:buddy/services/storage.dart';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:material_dialogs/material_dialogs.dart';
import 'package:material_dialogs/widgets/buttons/icon_button.dart';
import 'package:material_dialogs/widgets/buttons/icon_outline_button.dart';
import 'package:nfc_in_flutter/nfc_in_flutter.dart';

import '../services/database.dart';

class CreateProfile extends StatefulWidget {
  final Map<String, dynamic> userInfoMap;

  CreateProfile(this.userInfoMap);

  @override
  _CreateProfile createState() => _CreateProfile();
}

class _CreateProfile extends State<CreateProfile> {
  String profileImg = "";
  TextEditingController usernameController = TextEditingController();
  TextEditingController companyController = TextEditingController();
  TextEditingController experienceController1 = TextEditingController();
  TextEditingController experienceController2 = TextEditingController();
  TextEditingController experienceController3 = TextEditingController();
  TextEditingController experienceController4 = TextEditingController();
  List selectedMeetings = [];

  @override
  Widget build(BuildContext context) {
    companyController.addListener(() {
      setState(() {});
    });
    usernameController.addListener(() {
      setState(() {});
    });
    experienceController1.addListener(() {
      setState(() {});
    });
    experienceController2.addListener(() {
      setState(() {});
    });
    experienceController3.addListener(() {
      setState(() {});
    });
    experienceController4.addListener(() {
      setState(() {});
    });

    Size size = MediaQuery.of(context).size;
    return Scaffold(
        resizeToAvoidBottomInset: true,
        body: SafeArea(
            child: Stack(
          children: [
            ListView(children: [
              Center(
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          margin: EdgeInsets.symmetric(
                              horizontal: 15, vertical: 20),
                          child: Column(
                            children: [
                              Text("BUDDY",
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color:
                                          const Color.fromRGBO(229, 36, 39, 1),
                                      fontSize: 30,
                                      letterSpacing: size.width * 0.02),
                                  textAlign: TextAlign.left),
                              Text(
                                "Profil erstellen",
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black87,
                                    fontSize: 15,
                                    letterSpacing: size.width * 0.01),
                                // textAlign: TextAlign.left
                              ),
                            ],
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.symmetric(
                              horizontal: 15, vertical: 20),
                          child: Column(
                            children: [
                              Container(
                                child: Image.asset("assets/f_logo.png",
                                    width: size.width * 0.3),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    UserImage(
                      onFileChanged: (profileImg) {
                        setState(() {});
                        this.profileImg = profileImg;
                      },
                      name: widget.userInfoMap["name"],
                      userid: widget.userInfoMap["userid"],
                    ),
                    Container(
                      alignment: Alignment.center,
                      margin: EdgeInsets.symmetric(
                          horizontal: size.width * 0.1,
                          vertical: size.height * 0.01),
                      child: TextFormField(
                        maxLength: 18,
                        controller: usernameController,
                        decoration: InputDecoration(
                          counterText: usernameController.text.length < 10
                              ? ''
                              : '${usernameController.text.length}/18',
                          labelText: "Nutzername",
                          fillColor: Colors.white,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(25.0),
                            borderSide: BorderSide(),
                          ),
                          //fillColor: Colors.green
                        ),
                        style: TextStyle(
                          fontFamily: "Poppins",
                        ),
                      ),
                    ),
                    Container(
                      alignment: Alignment.center,
                      margin: EdgeInsets.symmetric(
                          horizontal: size.width * 0.1,
                          vertical: size.height * 0.01),
                      child: TextFormField(
                          maxLength: 30,
                          controller: companyController,
                          maxLengthEnforcement: MaxLengthEnforcement.enforced,
                          decoration: InputDecoration(
                            counterText: companyController.text.length < 20
                                ? ''
                                : '${companyController.text.length}/30',
                            labelText: "Unternehmen",
                            fillColor: Colors.white,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(25.0),
                              borderSide: BorderSide(),
                            ),
                            //fillColor: Colors.green
                          ),
                          style: TextStyle(
                            fontFamily: "Poppins",
                          )),
                    ),
                    Container(
                      margin: EdgeInsets.symmetric(
                          horizontal: size.width * 0.1,
                          vertical: size.height * 0.01),
                      child: Wrap(
                        spacing: 8.0, // gap between adjacent chips
                        runSpacing: 10.0, // gap between lines
                        children: [
                          Container(
                            width: size.width * 0.39,
                            child: TextFormField(
                                maxLength: 30,
                                controller: experienceController1,
                                maxLengthEnforcement:
                                    MaxLengthEnforcement.enforced,
                                decoration: InputDecoration(
                                  counterText: experienceController1
                                              .text.length <
                                          20
                                      ? ''
                                      : '${experienceController1.text.length}/30',
                                  labelText: "Erfahrungen",
                                  fillColor: Colors.white,
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(25.0),
                                    borderSide: BorderSide(),
                                  ),
                                  //fillColor: Colors.green
                                ),
                                style: TextStyle(
                                  fontFamily: "Poppins",
                                )),
                          ),
                          Container(
                            width: size.width * 0.39,
                            child: TextFormField(
                                maxLength: 30,
                                controller: experienceController2,
                                maxLengthEnforcement:
                                    MaxLengthEnforcement.enforced,
                                decoration: InputDecoration(
                                  counterText: experienceController2
                                              .text.length <
                                          20
                                      ? ''
                                      : '${experienceController2.text.length}/30',
                                  labelText: "Erfahrungen",
                                  fillColor: Colors.white,
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(25.0),
                                    borderSide: BorderSide(),
                                  ),
                                  //fillColor: Colors.green
                                ),
                                style: TextStyle(
                                  fontFamily: "Poppins",
                                )),
                          ),
                          Container(
                            width: size.width * 0.39,
                            child: TextFormField(
                                maxLength: 30,
                                controller: experienceController3,
                                maxLengthEnforcement:
                                    MaxLengthEnforcement.enforced,
                                decoration: InputDecoration(
                                  counterText: experienceController3
                                              .text.length <
                                          20
                                      ? ''
                                      : '${experienceController3.text.length}/30',
                                  labelText: "Erfahrungen",
                                  fillColor: Colors.white,
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(25.0),
                                    borderSide: BorderSide(),
                                  ),
                                  //fillColor: Colors.green
                                ),
                                style: TextStyle(
                                  fontFamily: "Poppins",
                                )),
                          ),
                          Container(
                            width: size.width * 0.39,
                            child: TextFormField(
                                maxLength: 30,
                                controller: experienceController4,
                                maxLengthEnforcement:
                                    MaxLengthEnforcement.enforced,
                                decoration: InputDecoration(
                                  counterText: experienceController4
                                              .text.length <
                                          20
                                      ? ''
                                      : '${experienceController4.text.length}/30',
                                  labelText: "Erfahrungen",
                                  fillColor: Colors.white,
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(25.0),
                                    borderSide: BorderSide(),
                                  ),
                                  //fillColor: Colors.green
                                ),
                                style: TextStyle(
                                  fontFamily: "Poppins",
                                )),
                          )
                        ],
                      ),
                    ),
                    Container(
                      margin:
                          EdgeInsets.symmetric(horizontal: size.width * 0.1),
                      alignment: Alignment.centerLeft,
                      color: Colors.transparent,
                      child: Wrap(
                        children: [
                          Container(
                            margin: EdgeInsets.only(right: 10),
                            child: OutlinedButton(
                              onPressed: () {
                                if (selectedMeetings.contains(0)) {
                                  selectedMeetings.remove(0);
                                } else {
                                  selectedMeetings.add(0);
                                }
                                setState(() {});
                              },
                              child: Text('Unternehmensführung'),
                              style: OutlinedButton.styleFrom(
                                backgroundColor: selectedMeetings.contains(0)
                                    ? Color.fromRGBO(211, 211, 211, 0.5)
                                    : Colors.transparent,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                            ),
                          ),
                          Container(
                            margin: EdgeInsets.only(right: 10),
                            child: OutlinedButton(
                              onPressed: () {
                                if (selectedMeetings.contains(1)) {
                                  selectedMeetings.remove(1);
                                } else {
                                  selectedMeetings.add(1);
                                }
                                setState(() {});
                              },
                              child: Text('Treffen'),
                              style: OutlinedButton.styleFrom(
                                backgroundColor: selectedMeetings.contains(1)
                                    ? Color.fromRGBO(211, 211, 211, 0.5)
                                    : Colors.transparent,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                            ),
                          ),
                          Container(
                            margin: EdgeInsets.only(right: 10),
                            child: OutlinedButton(
                              onPressed: () {
                                if (selectedMeetings.contains(2)) {
                                  selectedMeetings.remove(2);
                                } else {
                                  selectedMeetings.add(2);
                                }
                                setState(() {});
                              },
                              child: Text('Meet-Ups'),
                              style: OutlinedButton.styleFrom(
                                backgroundColor: selectedMeetings.contains(2)
                                    ? Color.fromRGBO(211, 211, 211, 0.5)
                                    : Colors.transparent,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                    Container(
                      alignment: Alignment.center,
                      margin:
                          EdgeInsets.only(top: size.height * 0.04, bottom: 300),
                      child: RaisedButton(
                        onPressed: () async {
                          DateTime now = new DateTime.now();
                          await SharedPreferencesHelper()
                              .saveUserName(usernameController.text);
                          await SharedPreferencesHelper().saveUserStartDate(now);
                          await SharedPreferencesHelper()
                              .saveUserCompany(companyController.text);
                          await SharedPreferencesHelper().saveUserGuide(
                              selectedMeetings.contains(0) ? "true" : "false");
                          await SharedPreferencesHelper().saveUserMeet(
                              selectedMeetings.contains(1) ? "true" : "false");
                          await SharedPreferencesHelper().saveUserMeetUp(
                              selectedMeetings.contains(2) ? "true" : "false");
                          await SharedPreferencesHelper().saveUserSkills(
                              experienceController1.text +
                                  "|" +
                                  experienceController2.text +
                                  "|" +
                                  experienceController3.text +
                                  "|" +
                                  experienceController4.text);
                          Map<String, dynamic> addInformation = {
                            "username": usernameController.text,
                            "startDate": now,
                            "company": companyController.text,
                            "skills": experienceController1.text +
                                "|" +
                                experienceController2.text +
                                "|" +
                                experienceController3.text +
                                "|" +
                                experienceController4.text,
                            "guide":
                                selectedMeetings.contains(0) ? "true" : "false",
                            "meet":
                                selectedMeetings.contains(1) ? "true" : "false",
                            "official_meet":
                                selectedMeetings.contains(2) ? "true" : "false"
                          };

                          Dialogs.bottomMaterialDialog(
                              msg:
                                  'Halte dein Handy jetzt in die Nähe deines Ankers um deinen Account mit deinem Anker zu verknüpfen. Falls du ihn gerade nicht in der Nähe hast, kannst du das später im Profil nachholen.',
                              title: 'Anker verknüpfen',
                              context: context,
                              actions: [
                                IconsOutlineButton(
                                  onPressed: () {
                                    DataBaseMethods()
                                        .addUserInfoToDB(
                                            widget.userInfoMap["userid"],
                                            widget.userInfoMap)
                                        .then((value) =>
                                            Navigator.pushReplacement(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                        Home())));
                                  },
                                  text: 'Später machen',
                                  iconData: Icons.cancel_outlined,
                                  textStyle: TextStyle(color: Colors.grey),
                                  iconColor: Colors.grey,
                                ),
                              ]);

                          widget.userInfoMap.addAll(addInformation);
                          List<NDEFRecord> messages =
                              List.empty(growable: true);
                          messages.add(
                              NDEFRecord.plain(widget.userInfoMap["userid"]));

                          NDEFMessage newMessage =
                              NDEFMessage.withRecords(messages);
                          Stream<NDEFTag> stream =
                              NFC.writeNDEF(newMessage, once: true);

                          stream.listen((NDEFTag tag) {
                            DataBaseMethods()
                                .addUserInfoToDB(widget.userInfoMap["userid"],
                                    widget.userInfoMap)
                                .then((value) => Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => Home())));
                          });
                        },
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(60.0)),
                        textColor: Colors.white,
                        padding: const EdgeInsets.all(0),
                        child: Container(
                          alignment: Alignment.center,
                          height: size.height * 0.07,
                          width: size.width * 0.5,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(60.0),
                              gradient: const LinearGradient(colors: [
                                Color.fromARGB(255, 255, 136, 34),
                                Color.fromARGB(255, 255, 177, 41)
                              ])
                              // LinearGradient
                              ),
                          // BoxDecoration
                          padding: const EdgeInsets.all(0),
                          child: const Text(
                            "Registrieren",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                fontWeight: FontWeight.bold), // TextStyle
                          ), // Text
                        ), // Container
                      ), // RaisedButton
                    )
                  ],
                ),
              ),
            ]),
            /*Align(
              alignment: Alignment.bottomCenter,
              child: Image.asset("assets/bottom2.png", width: size.width),
            ),
             */
          ],
        )));
  }
}

class UserImage extends StatefulWidget {
  final Function(String profileImg) onFileChanged;

  String name, userid;

  UserImage(
      {required this.onFileChanged, required this.name, required this.userid});

  @override
  _UserImageState createState() => _UserImageState();
}

class _UserImageState extends State<UserImage> {
  final ImagePicker imagePicker = ImagePicker();

  String? profileImg;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Container(
      alignment: Alignment.center,
      margin: EdgeInsets.symmetric(
          horizontal: size.width * 0.09, vertical: size.width * 0.05),
      child: Column(children: [
        if (profileImg == null)
          SizedBox(
              height: size.width * 0.2,
              width: size.width * 0.2,
              child: Stack(
                  clipBehavior: Clip.none,
                  fit: StackFit.expand,
                  children: [
                    CircleAvatar(
                      backgroundColor: Colors.black87,
                      child: Text(widget.name.substring(0, 1) +
                          widget.name.substring(
                              widget.name.lastIndexOf(' ') + 1,
                              widget.name.lastIndexOf(' ') + 2)),
                    ),
                    Positioned(
                        bottom: 0,
                        right: -35,
                        child: RawMaterialButton(
                          onPressed: () async {
                            _selectPhoto();
                          },
                          elevation: 2.0,
                          fillColor: const Color(0xFFF5F6F9),
                          child: const Icon(
                            Icons.camera_alt_outlined,
                            color: Colors.blue,
                          ),
                          padding: EdgeInsets.all(size.width * 0.02),
                          shape: const CircleBorder(),
                        )),
                  ])),
        if (profileImg != null)
          InkWell(
            splashColor: Colors.transparent,
            highlightColor: Colors.transparent,
            onTap: () => _selectPhoto(),
            child: SizedBox(
                height: size.width * 0.2,
                width: size.width * 0.2,
                child: Stack(
                    clipBehavior: Clip.none,
                    fit: StackFit.expand,
                    children: [
                      CircleAvatar(
                          backgroundColor: Colors.black87,
                          backgroundImage: Image.network(profileImg!).image),
                      Positioned(
                          bottom: 0,
                          right: -35,
                          child: RawMaterialButton(
                            onPressed: () async {
                              _selectPhoto();
                            },
                            elevation: 2.0,
                            fillColor: const Color(0xFFF5F6F9),
                            child: const Icon(
                              Icons.camera_alt_outlined,
                              color: Colors.blue,
                            ),
                            padding: EdgeInsets.all(size.width * 0.02),
                            shape: const CircleBorder(),
                          )),
                    ])), // AppRoundImage.url
          ),
      ]),
    );
  }

  Future _selectPhoto() async {
    await showModalBottomSheet(
        context: context,
        builder: (context) => BottomSheet(
              builder: (context) => Wrap(
                children: [
                  Column(
                    children: [
                      ListTile(
                        leading: const Icon(Icons.camera),
                        title: const Text("Kamara"),
                        onTap: () {
                          Navigator.of(context).pop();
                          pickImage(ImageSource.camera);
                        },
                      ),
                      ListTile(
                        leading: const Icon(Icons.browse_gallery),
                        title: const Text("Gallerie"),
                        onTap: () {
                          Navigator.of(context).pop();
                          pickImage(ImageSource.gallery);
                        },
                      )
                    ],
                  )
                ],
              ),
              onClosing: () {},
            ));
  }

  Future pickImage(ImageSource source) async {
    final pickedFile =
        await imagePicker.pickImage(source: source, imageQuality: 50);
    if (pickedFile == null) {
      return;
    }

    final File? imageFile = File(pickedFile.path);
    var downloadURL =  await StorageMethods().uploadFile(widget.userid, imageFile!);

    setState(() {
      profileImg = downloadURL;
    });
    widget.onFileChanged(profileImg!);
  }
}
