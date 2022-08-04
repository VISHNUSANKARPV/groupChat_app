
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:groopie/helper/helper_function.dart';
import 'package:groopie/pages/chat_page.dart';
import 'package:groopie/service/database_services.dart';
import 'package:groopie/widgets/widgets.dart';

class SearcgPage extends StatefulWidget {
 const SearcgPage({Key? key}) : super(key: key);

  @override
  State<SearcgPage> createState() => _SearcgPageState();
}

class _SearcgPageState extends State<SearcgPage> {
  String userName = "";
  dynamic searchSnapshot;
  bool hasUsersearched = false;
  bool isLoading = false;
  TextEditingController searchController = TextEditingController();
  User? user;
  bool isJoined = false;

  @override
  void initState() {
    getCurrentUserIdandName();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kGreyLight,
      body: Container(
        color: kGreyLight,
        child: Column(
          children: [
            Container(
              height: 140,
              width: double.maxFinite,
              decoration: const BoxDecoration(
                  color: kPrimaryDark,
                  borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(30),
                      bottomRight: Radius.circular(30))),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  GestureDetector(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: const Icon(
                        Icons.arrow_back_ios_new,
                        color: Colors.white,
                      )),
                  Container(
                    width: MediaQuery.of(context).size.width / 1.2,
                    height: 55.0,
                    padding: const EdgeInsets.only(
                        top: 15.0, bottom: 0.0, left: 16, right: 16),
                    decoration: const BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(30)),
                        color: kPrimaryDark,
                        boxShadow: [
                          BoxShadow(color: kPrimary, blurRadius: 15.0)
                        ]),
                    child: Center(
                      child: TextField(
                        onChanged:(value){
                          initiateSearchMethod();
                        },
                        controller: searchController,
                        style: const TextStyle(color: Colors.white),
                        cursorColor: Colors.white,
                        decoration: InputDecoration(
                          border: const OutlineInputBorder(
                            borderSide: BorderSide.none,
                          ),
                          hintText: "Search...",
                          hintStyle: const TextStyle(color: Colors.white),
                          suffix: Container(
                            decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.4),
                                borderRadius: const BorderRadius.all(
                                    Radius.circular(50))),
                            child: IconButton(
                              onPressed: () {
                                // initiateSearchMethod();
                              },
                              icon: const Icon(
                                Icons.search,
                                color: Colors.white,
                                size: 18,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            isLoading
                ? const Center(
                    child: CircularProgressIndicator(
                      color: kPrimaryDark,
                    ),
                  )
                : groupList()
          ],
        ),
      ),
    );
  }

  initiateSearchMethod() {
    if (searchController.text.isNotEmpty) {
      setState(() {
        isLoading = true;
      });
       DatabaseService()
          .searchByName(searchController.text.trim())
          .then((snapshot) {
        setState(() {
          searchSnapshot = snapshot;
          isLoading = false;
          hasUsersearched = true;
        });
      });
    }
  }

  groupList() {
    return hasUsersearched
        ? ListView.builder(
            itemCount: searchSnapshot.length,
            shrinkWrap: true,
            itemBuilder: (context, index) {
              return Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: groupTile(
                  userName,
                  searchSnapshot[index]['groupId'],
                  searchSnapshot[index]['groupName'],
                  searchSnapshot[index]['admin'],
                ),
              );
            })
        : Container();
  }

  Widget groupTile(
      String userName, String groupId, String groupName, String admin) {
    //check whether user is alreadry exist the group
    joinedOrNot(userName, groupId, groupName, admin);
    return Padding(
      padding: const EdgeInsets.only(left: 10, right: 10),
      child: Container(
        decoration: const BoxDecoration(
            color: kPrimary,
            borderRadius: BorderRadius.all(Radius.circular(50))),
        child: ListTile(
          leading: CircleAvatar(
            radius: 30,
            backgroundColor: kPrimaryLight,
            child: Text(
              groupName.substring(0, 1).toUpperCase(),
              style: const TextStyle(color: kPrimaryDark, fontSize: 20),
            ),
          ),
          title: Text(
            groupName,
            style: const TextStyle(
                color: Colors.black, fontWeight: FontWeight.bold),
          ),
          subtitle: Text("Admin :${getName(admin)}"),
          trailing: InkWell(
              onTap: () async {
                await DatabaseService(uid: user!.uid)
                    .toggledGroupJoin(groupId, userName, groupName);

                if (isJoined) {
                  setState(() {
                    isJoined = !isJoined;
                    showSnackBar(
                        context, Colors.green, "SuccessFully joined the group");
                  });
                  // ignore: use_build_context_synchronously

                  Future.delayed(const Duration(seconds: 2), () {
                    nextScreenReplace(
                        context,
                        ChatPage(
                            groupId: groupId,
                            groupName: groupName,
                            userName: userName));
                  });
                } else {
                  setState(() {
                    isJoined = !isJoined;
                    showSnackBar(
                        context, Colors.red, "Left the group $groupName");
                  });
                }
              },
              child: isJoined
                  ? Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: kPrimaryLight,
                      ),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 15, vertical: 7),
                      child: const Text(
                        "Joined",
                        style: TextStyle(color: kPrimaryDark),
                      ),
                    )
                  : Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: kPrimaryDark,
                      ),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 15, vertical: 7),
                      child: const Text(
                        "Join now",
                        style: TextStyle(color: kPrimaryLight),
                      ),
                    )),
        ),
      ),
    );
  }

  void getCurrentUserIdandName() async {
    await HelperFunctions.getUserName().then((value) {
      setState(() {
        userName = value!;
      });
    });
    user = FirebaseAuth.instance.currentUser;
  }

  void joinedOrNot(
      String userName, String groupId, String groupname, String admin) async {
    await DatabaseService(uid: user!.uid)
        .isUserJoined(groupname, groupId, userName)
        .then((value) {
      setState(() {
        isJoined = value;
      });
    });
  }

  String getName(String r) {
    return r.substring(r.indexOf('_') + 1);
  }

  String getId(String res) {
    return res.substring(0, res.indexOf("_"));
  }
}
