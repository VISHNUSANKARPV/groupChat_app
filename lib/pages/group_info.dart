import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:groopie/pages/home_page.dart';
import 'package:groopie/service/database_services.dart';
import 'package:groopie/widgets/widgets.dart';

class InfoPage extends StatefulWidget {
 final String groupId;
 final String groupName;
 final String adminName;
 const InfoPage(
      {Key? key,
      required this.groupId,
      required this.groupName,
      required this.adminName})
      : super(key: key);

  @override
  State<InfoPage> createState() => _InfoPageState();
}

class _InfoPageState extends State<InfoPage> {
  Stream? members;
  @override
  void initState() {
    getMembers();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: kPrimary,
        elevation: 0,
        leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: const Icon(
              Icons.arrow_back,
              color: Colors.white,
            )),
      ),
      backgroundColor: kPrimary,
      body: Column(
        children: [
          Container(
            height: 200,
            width: double.maxFinite,
            color: kPrimary,
            child: Column(
              children: [
                CircleAvatar(
                  radius: 50,
                  backgroundColor: kPrimaryDark,
                  child: Text(
                    widget.groupName.substring(0, 1).toUpperCase(),
                    style: const TextStyle(
                        color: Colors.white,
                        fontSize: 50,
                        fontWeight: FontWeight.bold),
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                Text(
                  "Group : ${widget.groupName}",
                  style: const TextStyle(color: Colors.white, fontSize: 22),
                ),
                Text(
                  "Admin : ${getName(widget.adminName)}",
                  style: const TextStyle(color: Colors.white, fontSize: 14),
                ),
                ElevatedButton.icon(
                    onPressed: () {
                      showDialog(
                          barrierDismissible: false,
                          context: context,
                          builder: (context) {
                            return AlertDialog(
                              title: const Text('Exit'),
                              content:
                                  const Text('Do you want to exit the app? '),
                              actions: [
                                IconButton(
                                    onPressed: () {
                                      Navigator.pop(context);
                                    },
                                    icon: const Icon(
                                      Icons.cancel,
                                      color: Colors.red,
                                    )),
                                IconButton(
                                    onPressed: () async {
                                       DatabaseService(
                                              uid: FirebaseAuth
                                                  .instance.currentUser!.uid)
                                          .toggledGroupJoin(
                                              widget.groupId,
                                              getName(widget.adminName),
                                              widget.groupName)
                                          .whenComplete(() {
                                        nextScreenReplace(context,const HomePage());
                                      });
                                    },
                                    icon: const Icon(
                                      Icons.done,
                                      color: Colors.green,
                                    ))
                              ],
                            );
                          });
                    },
                    icon: const Icon(Icons.logout),
                    label: const Text("Leave"))
              ],
            ),
          ),
          Expanded(
            child: Container(
              color: kPrimaryLight,
              width: double.maxFinite,
              child: memberList(),
            ),
          )
        ],
      ),
    );
  }

  //string manipulation

  getMembers() async {
    DatabaseService(uid: FirebaseAuth.instance.currentUser!.uid)
        .getGroupMembers(widget.groupId)
        .then((val) {
      setState(() {
        members = val;
      });
    });
  }

  memberList() {
    return StreamBuilder(
        stream: members,
        builder: (context, AsyncSnapshot snapshot) {
          if (snapshot.hasData) {
            if (snapshot.data['members'] != null) {
              if (snapshot.data['members'].length != 0) {
                return ListView.builder(
                  shrinkWrap: true,
                  itemCount: snapshot.data['members'].length,
                  itemBuilder: (BuildContext context, int index) {
                    return Padding(
                      padding: const EdgeInsets.only(top: 10),
                      child: ListTile(
                        leading: CircleAvatar(
                          radius: 30,
                          backgroundColor: Colors.deepOrange,
                          child: Text(
                            getName(snapshot.data['members'][index])
                                .substring(0, 1)
                                .toUpperCase(),
                            style: const TextStyle(
                                color: Colors.white,
                                fontSize: 22,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                        title: Text(
                          getName(snapshot.data['members'][index]),
                          style: const TextStyle(
                              color: Colors.black, fontWeight: FontWeight.bold),
                        ),
                        subtitle: Text(getId(snapshot.data['members'][index]),
                            style: const TextStyle(color: Colors.black54)),
                      ),
                    );
                  },
                );
              } else {
                return const Center(
                  child: Text(
                    'No Members!',
                    style: TextStyle(
                        color: kPrimaryDark,
                        fontSize: 25,
                        fontWeight: FontWeight.bold),
                  ),
                );
              }
            } else {
              return const Center(
                child: Text(
                  'No Members!',
                  style: TextStyle(
                      color: kPrimaryDark,
                      fontSize: 25,
                      fontWeight: FontWeight.bold),
                ),
              );
            }
          } else {
            return const Center(
              child: CircularProgressIndicator(
                color: kPrimaryDark,
              ),
            );
          }
        });
  }

  //string manipulation

  String getName(String r) {
    return r.substring(r.indexOf('_') + 1);
  }

  String getId(String res) {
    return res.substring(0, res.indexOf("_"));
  }
}
