import 'package:buddy/services/storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../helperfunctions/sharedpref_helper.dart';
import '../services/database.dart';
import 'chat.dart';

/**
 * Diese Klasse erzeugt die Chatübersicht.
 * Es wird sich sowohl um die grafische Darstellung,
 * als auch um die logischen Aufrufe der entsprechenden Methoden gekümmert.
 *
 * @author Paul Franken winf104387
 */
class ChatOverview extends StatefulWidget {
  @override
  _ChatOverview createState() => _ChatOverview();
}

class _ChatOverview extends State<ChatOverview> {
  //Gibt an ob die Suchfunktion gerede genutzt wird.
  bool isSearching = false;
  TextEditingController searchEditingController = TextEditingController();
  Stream? usersStream;
  Stream? chatStream;
  late String myName, myUserName, myEmail, myUserId;
  bool folded = false;

  /**
   * Die Methode die vom Frameowrk zum Start des Fensters aufgerufen wird.
   */
  @override
  void initState() {
    getMyInfoFormSharedPreferences();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
            margin: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              children: [
                Container(
                  margin: const EdgeInsets.symmetric(vertical: 16),
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  decoration: BoxDecoration(
                      border: Border.all(
                          color: Colors.grey,
                          width: 1.0,
                          style: BorderStyle.solid),
                      borderRadius: BorderRadius.circular(24)),
                  child: Row(
                    children: [
                      Expanded(
                          child: TextField(
                        onChanged: (text) {
                          if (text == "") {
                            isSearching = false;
                            searchEditingController.clear();
                            setState(() {});
                          } else {
                            onSearchBtnClick();
                          }
                        },
                        controller: searchEditingController,
                        decoration: const InputDecoration(
                            border: InputBorder.none, hintText: "Suchen..."),
                      )),
                      GestureDetector(child: const Icon(Icons.search))
                    ],
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                isSearching ? searchUsersList() : chatList()
              ],
            )));
  }

  Widget searchUsersList() {
    return StreamBuilder(
      stream: usersStream,
      builder: (context, snapshot) {
        return snapshot.hasData
            ? ListView.builder(
                itemCount: (snapshot.data! as QuerySnapshot).docs.length,
                shrinkWrap: true,
                itemBuilder: (context, index) {
                  if (snapshot.connectionState == ConnectionState.waiting)
                    return Container();
                  DocumentSnapshot ds =
                      (snapshot.data! as QuerySnapshot).docs[index];

                  return SearchListItem(
                    partnerUsername: ds.get("username"),
                    myUsername: myUserName,
                    myUserId: myUserId,
                  );
                },
              )
            : const Center(child: CircularProgressIndicator());
      },
    );
  }

  Widget chatList() {
    return StreamBuilder(
      stream: chatStream,
      builder: (context, snapshot) {
        return snapshot.hasData
            ? ListView.builder(
                itemCount: (snapshot.data! as QuerySnapshot).docs.length,
                shrinkWrap: true,
                itemBuilder: (context, index) {
                  DocumentSnapshot ds =
                      (snapshot.data! as QuerySnapshot).docs[index];
                  return ChatWidget(
                      partnerUsername: ds["users"][1] == myUserName
                          ? ds["users"][0]
                          : ds["users"][1],
                      myUserId: myUserId,
                      chatRoomId: ds.id);
                },
              )
            : const Center(child: CircularProgressIndicator());
      },
    );
  }

  /**
   * Bei dieser Methode werden einige Informationen von den Sharedpreferences geladen.
   */
  getMyInfoFormSharedPreferences() async {
    myName = (await SharedPreferencesHelper().getUserDisplayName())!;
    myUserName = (await SharedPreferencesHelper().getUserName())!;
    myEmail = (await SharedPreferencesHelper().getUserEmail())!;
    myUserId = (await SharedPreferencesHelper().getUserId())!;
    chatStream = await DataBaseMethods().getAllChats(myUserId);
    setState(() {});
  }

  /**
   * Diese Methode wird ausgeführt wenn eine Suche angefordert wird.
   * Mit der Datenbankmethode wird ein Nutzer nach dem Nutzernamen gesucht.
   */
  onSearchBtnClick() async {
    usersStream =
        await DataBaseMethods().getUserByUsername(searchEditingController.text);
    isSearching = true;
    setState(() {});
  }
}

/**
 * Diese Klasse stellt ein Widget zur Verfügung, welches einen Chat darstellt.
 * Es werden Informationen zum Namen, zur letzten Nachricht und zum letztem Sendezeitpunkt angezeigt.
 *
 */
class ChatWidget extends StatefulWidget {
  String partnerUsername, myUserId, chatRoomId;

  ChatWidget(
      {required this.partnerUsername,
      required this.myUserId,
      required this.chatRoomId});

  @override
  _ChatState createState() => _ChatState();
}

class _ChatState extends State<ChatWidget> {
  String? profileImg;
  String lastMessage = "";
  String lastTimeStamp = "";
  String partnerUserId = "";

  /**
   * Die Methode die vom Frameowrk zum Start des Fensters aufgerufen wird.
   */
  @override
  void initState() {
    getLastMessage();
    super.initState();
  }

  /**
   * Diese Methode lädt die letze Nachricht aus einem Chat herunter.
   * Ebenfalls wird der Zeitstempel der letzten Nachricht heruntergeladen.
   * Ist eine Nachricht älter als 24 Stunden wird der Text "Gestern" oder das Datum angezeigt.
   */
  getLastMessage() async {
    Map<String, dynamic> lastInfo =
        await DataBaseMethods().getLastMessageOfChatRoom(widget.chatRoomId);
    lastMessage = lastInfo["message"];
    Timestamp t = lastInfo["time"];

    if (t != null) {
      DateTime yesterday = DateTime.now().subtract(const Duration(days: 1));
      if (t
          .toDate()
          .day == yesterday.day) {
        lastTimeStamp = "Gestern";
      } else if (t
          .toDate()
          .day == yesterday
          .add(const Duration(days: 1))
          .day) {
        var format = DateFormat('HH:mm');
        lastTimeStamp = format.format(t.toDate());
      } else {
        var format = DateFormat('dd.MM.yy');
        lastTimeStamp = format.format(t.toDate());
      }
      setState(() {});
    }
  }

  /**
   * Diese Methode baut das Widget.
   */
  @override
  Widget build(BuildContext context) {
    return InkWell(
      //Bei einem Klick wird das Chatfenster geöffnet.
      onTap: () async {
        Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => Chat(widget.partnerUsername)))
            .then((value) => {getLastMessage(), setState(() {})});
      },
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              UserImage(
                  onFileChanged: (profileImg) {
                    setState(() {});
                    this.profileImg = profileImg;
                  },
                  partnerUsername: widget.partnerUsername),
              const SizedBox(width: 12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.partnerUsername,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                      fontSize: 18,
                    ),
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  Text(
                    lastMessage != null
                        ? lastMessage.length > 25
                            ? lastMessage.substring(0, 25) + '...'
                            : lastMessage
                        : "",
                    style: const TextStyle(
                      fontWeight: FontWeight.normal,
                      color: Color.fromRGBO(52, 95, 104, 1),
                      fontSize: 16,
                    ),
                  )
                ],
              ),
            ],
          ),
          Column(crossAxisAlignment: CrossAxisAlignment.center, children: [
            Text(
              lastTimeStamp,
              style: const TextStyle(
                fontWeight: FontWeight.normal,
                color: Color.fromRGBO(52, 95, 104, 1),
                fontSize: 16,
              ),
            ),
            /*const Icon(
              Icons.new_releases_rounded,
              color: Color(0xFF198BAA),
              size: 35,
            )
             */
          ]),
        ],
      ),
    );
  }
}

/**
 * Diese Klasse sorgt für die gesamte Darstellung eines Profilbildes.
 */
class UserImage extends StatefulWidget {
  final Function(String profileImg) onFileChanged;

  String partnerUsername;

  UserImage({required this.onFileChanged, required this.partnerUsername});

  @override
  _UserImageState createState() => _UserImageState();
}

class _UserImageState extends State<UserImage> {
  String? profileImg;
  String partnerId = "";

  @override
  void initState() {
    getPartnerUserIdAndDownloadImage();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      child: Column(children: [
        if (profileImg == null)
          SizedBox(
              height: 60,
              width: 60,
              child: Stack(
                  clipBehavior: Clip.none,
                  fit: StackFit.expand,
                  children: [
                    CircleAvatar(
                      backgroundColor: Color.fromRGBO(52, 95, 104, 1),
                      child: Text(widget.partnerUsername.substring(0, widget.partnerUsername.contains(" ") ? widget.partnerUsername.indexOf(" "): widget.partnerUsername.length))
                    ),
                  ])),
        if (profileImg != null)
          InkWell(
            splashColor: Colors.transparent,
            highlightColor: Colors.transparent,
            child: SizedBox(
                height: 60,
                width: 60,
                child: Stack(
                    clipBehavior: Clip.none,
                    fit: StackFit.expand,
                    children: [
                      CircleAvatar(
                          backgroundColor: Color.fromRGBO(52, 95, 104, 1),
                          backgroundImage: Image.network(profileImg!).image),
                    ])), // AppRoundImage.url
          ),
      ]),
    );
  }

  /**
   * Diese Methode sorgt dafür, dass das Profilbild des Partners angezeigt werden kann
   */
  void getPartnerUserIdAndDownloadImage() async {
    partnerId =
        await DataBaseMethods().getUserIdByUserName(widget.partnerUsername);
    var downloadURL = await StorageMethods().getProfileImg(partnerId);

    if (downloadURL != "") {
      setState(() {
        profileImg = downloadURL;
      });
      widget.onFileChanged(profileImg!);
    }
  }
}

class SearchListItem extends StatefulWidget {
  String partnerUsername, myUserId, myUsername;

  SearchListItem(
      {required this.partnerUsername,
        required this.myUserId,
        required this.myUsername});

  @override
  _SearchListItemState createState() => _SearchListItemState();
}

/**
 * Diese Klasse stellt die Ergebnisse der Such nach einem utzer dar.
 *
 * @author Paul Franken winf104387
 */
class _SearchListItemState extends State<SearchListItem> {
  String? profileImg;
  String partnerUserId = "";

  String partnerCompany ="";

  /**
   * Diese Methode lädt das Unternehmens des Partners aus der Datenbank.
   */
  getPartnersCompany() async {
    partnerCompany =
    await DataBaseMethods().getPartnersCompany(widget.partnerUsername);
    setState(() {});
  }

  doBeforeInit() async {
    partnerUserId =
        await DataBaseMethods().getUserIdByUserName(widget.partnerUsername);
    await getPartnersCompany();
  }

  @override
  void initState() {
    doBeforeInit();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        Map<String, dynamic> chatRoomInfoMap = {
          "users": [widget.myUsername, widget.partnerUsername]
        };
        if (await DataBaseMethods().getChatRoomIdByUsernames(
                widget.partnerUsername, widget.myUsername, widget.myUserId) ==
            "") {
          DataBaseMethods()
              .createChatRoom(chatRoomInfoMap, widget.myUserId, partnerUserId);
        }
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => Chat(widget.partnerUsername)));
      },
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              UserImage(
                  onFileChanged: (profileImg) {
                    setState(() {});
                    this.profileImg = profileImg;
                  },
                  partnerUsername: widget.partnerUsername),
              const SizedBox(width: 12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.partnerUsername,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Color.fromRGBO(52, 95, 104, 1),
                      fontSize: 18,
                    ),
                  ),
                  SizedBox(
                    height: 4,
                  ),
                  Text(
                    partnerCompany,
                    style: TextStyle(
                        color: Color.fromRGBO(95, 152, 161, 1), fontSize: 13),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
