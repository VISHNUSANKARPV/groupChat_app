

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:groopie/helper/helper_function.dart';
import 'package:groopie/pages/auth/login_page.dart';
import 'package:groopie/pages/search_page.dart';
import 'package:groopie/service/auth_services.dart';
import 'package:groopie/service/database_services.dart';
import 'package:groopie/widgets/group_tile.dart';
import 'package:groopie/widgets/widgets.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  static bool showCustomBox = false;
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String userName = "";
  String email = "";
  AuthService authService = AuthService();
  Stream? groups;
  bool _isLoading = false;
  String groupName = "";

  @override
  void initState() {
    gettingUserData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Scaffold(
          backgroundColor: kPrimaryDark,
          body: Column(
            children: [
              Container(
                width: double.infinity,
                height: 250,
                color: kPrimaryDark,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Padding(
                      padding:
                          const EdgeInsets.only(left: 20, right: 20, top: 40),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            "Chat with\nyour friends",
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 25,
                                fontWeight: FontWeight.bold),
                          ),
                          InkWell(
                            onTap: () {
                              setState(() {
                                HomePage.showCustomBox = true;
                              });
                            },
                            child: CircleAvatar(
                              backgroundColor: Colors.black,
                              radius: 25,
                              child: Image.asset(
                                "assets/921-9218037_person-icons-yellow-icone-amarelo-pessoa-png-removebg-preview.png",
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                    InkWell(
                      onTap: () {
                        nextScreen(context,const SearcgPage());
                      },
                      child: Container(
                        width: MediaQuery.of(context).size.width / 1.2,
                        height: 45.0,
                        padding: const EdgeInsets.only(
                            top: 15.0, bottom: 0.0, left: 16, right: 16),
                        decoration: const BoxDecoration(
                            borderRadius: BorderRadius.all(Radius.circular(30)),
                            color: kPrimaryDark,
                            boxShadow: [
                              BoxShadow(color: kPrimary, blurRadius: 15.0)
                            ]),
                        child: InkWell(
                          onTap: () {
                            nextScreen(context,const SearcgPage());
                          },
                          child:const Padding(
                            padding:  EdgeInsets.only(left: 15),
                            child:  Text('Search...',style: TextStyle(color: Colors.white,fontSize: 16)),
                          )
                        ),
                      ),
                    )
                  ],
                ),
              ),
              Expanded(
                child: Container(
                    width: double.maxFinite,
                    decoration: const BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(35),
                            topRight: Radius.circular(35))),
                    child: groupList()),
              ),
            ],
          ),
          floatingActionButton: FloatingActionButton(
            backgroundColor: kPrimaryDark,
            onPressed: () {
              popUpDailogue(context);
            },
            child: const Icon(
              Icons.add,
              color: Colors.white,
            ),
          ),
        ),
        Visibility(
          visible: HomePage.showCustomBox,
          child: Scaffold(
            backgroundColor: Colors.black38,
            body: Center(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(30),
                child: ColoredBox(
                  color: Colors.white,
                  child: SizedBox(
                    height: MediaQuery.of(context).size.height * 0.6,
                    width: MediaQuery.of(context).size.height * 0.40,
                    child: Center(
                      child: SizedBox(
                          height: 460,
                          width: 250,
                          child: Column(
                            children: [
                              Row(
                                children: [
                                  IconButton(
                                      onPressed: () {
                                        setState(() {
                                          HomePage.showCustomBox = false;
                                        });
                                      },
                                      icon: const Icon(Icons.arrow_back_ios)),
                                  Padding(
                                    padding:
                                        const EdgeInsets.only(left: 8, top: 20),
                                    child: CircleAvatar(
                                      backgroundColor: Colors.black,
                                      radius: 70,
                                      child: Image.asset(
                                        "assets/921-9218037_person-icons-yellow-icone-amarelo-pessoa-png-removebg-preview.png",
                                      ),
                                    ),
                                  )
                                ],
                              ),
                              Text(
                                userName,
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black),
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              Text(email),
                              const Divider(),
                              TextButton.icon(
                                  onPressed: () {},
                                  icon: const Icon(Icons.group),
                                  label: const Text("Groups")),
                              TextButton.icon(
                                  onPressed: () async {
                                    showDialog(
                                        barrierDismissible: false,
                                        context: context,
                                        builder: (context) {
                                          return AlertDialog(
                                            title: const Text('Logout'),
                                            content: const Text(
                                                'Are you sure, you want to logout? '),
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
                                                    await authService.signOut();
                                                    // ignore: use_build_context_synchronously
                                                    Navigator.of(context)
                                                        .pushAndRemoveUntil(
                                                            MaterialPageRoute(
                                                                builder:
                                                                    (context) =>
                                                                        const LoginPage()),
                                                            (route) => false);

                                                    setState(() {
                                                      HomePage.showCustomBox =
                                                          false;
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
                                  label: const Text("Log Out")),
                            ],
                          )),
                    ),
                  ),
                ),
              ),
            ),
          ),
        )
      ],
    );
  }

  gettingUserData() async {
    await HelperFunctions.getUserEmail().then((value) {
      setState(() {
        email = value!;
      });
    });
    await HelperFunctions.getUserName().then((val) {
      setState(() {
        userName = val!;
      });
    });

    //getting the list of snapshot in our stream
    await DatabaseService(uid: FirebaseAuth.instance.currentUser!.uid)
        .getUserGroups()
        .then((snapshot) {
      setState(() {
        groups = snapshot;
      });
    });
  }

  groupList() {
    return StreamBuilder(
      stream: groups,
      builder: (context, AsyncSnapshot snapshot) {
        if (snapshot.hasData) {
          if (snapshot.data['groups'] != null) {
            if (snapshot.data['groups'].length != 0) {
              return ListView.builder(
                  physics: const BouncingScrollPhysics(),
                  itemCount: snapshot.data['groups'].length,
                  itemBuilder: (context, index) {
                    int reverseIndex =
                        snapshot.data['groups'].length - index - 1;
                    return GroupTile(
                        groupId: getId(snapshot.data['groups'][reverseIndex]),
                        groupName:
                            getName(snapshot.data['groups'][reverseIndex]),
                        userName: snapshot.data['fullName']);
                  });
            } else {
              return noGroups();
            }
          } else {
            return noGroups();
          }
        } else {
          return const Center(
            child: CircularProgressIndicator(
              color: kPrimary,
            ),
          );
        }
      },
    );
  }

  //String Manipulation
  String getId(String res) {
    return res.substring(0, res.indexOf("_"));
  }

  String getName(String res) {
    return res.substring(res.indexOf("_") + 1);
  }

  void popUpDailogue(BuildContext context) {
    showDialog(
        context: context,
        builder: (context) {
          return StatefulBuilder(builder: (context, setState) {
            return AlertDialog(
              title: const Text(
                "Create a group",
                textAlign: TextAlign.left,
              ),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  _isLoading == true
                      ? const Center(
                          child: CircularProgressIndicator(
                            color: kPrimaryDark,
                          ),
                        )
                      : TextField(
                          onChanged: (val) {
                            setState(() {
                              groupName = val;
                            });
                          },
                          decoration: InputDecoration(
                              enabledBorder: OutlineInputBorder(
                                  borderSide:
                                      const BorderSide(color: kPrimaryDark),
                                  borderRadius: BorderRadius.circular(30)),
                              errorBorder: OutlineInputBorder(
                                  borderSide:
                                      const BorderSide(color: Colors.red),
                                  borderRadius: BorderRadius.circular(30)),
                              focusedBorder: OutlineInputBorder(
                                  borderSide:
                                      const BorderSide(color: kPrimaryDark),
                                  borderRadius: BorderRadius.circular(30))),
                        )
                ],
              ),
              actions: [
                ElevatedButton(
                    style: ElevatedButton.styleFrom(primary: kPrimary),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: const Text(
                      "Cancel",
                      style: TextStyle(color: Colors.white),
                    )),
                ElevatedButton(
                    style: ElevatedButton.styleFrom(primary: kPrimary),
                    onPressed: () async {
                      if (groupName.isNotEmpty) {
                        setState(() {
                          _isLoading = true;
                        });
                        DatabaseService(
                                uid: FirebaseAuth.instance.currentUser!.uid)
                            .createGroup(
                                userName,
                                FirebaseAuth.instance.currentUser!.uid,
                                groupName)
                            .whenComplete(() {
                          _isLoading = false;
                        });
                        Navigator.pop(context);
                        showSnackBar(context, Colors.green,
                            "Group created successfully");
                      }
                    },
                    child: const Text(
                      "Create",
                      style: TextStyle(color: Colors.white),
                    ))
              ],
            );
          });
        });
  }

  noGroups() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 25),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          GestureDetector(
            onTap: () {
              popUpDailogue(context);
            },
            child: const Icon(
              Icons.add_circle,
              size: 45,
              color: Colors.grey,
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          const Text(
            "You've not joined any groups, tap on the add button to create a group or also search groups",
            textAlign: TextAlign.center,
          )
        ],
      ),
    );
  }
}

// Center(
// child: ElevatedButton(
//     onPressed: () {
//       authService.signOut();
//     },
//     child: Text("log out"))),
