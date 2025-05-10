import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../api/apis.dart';
import '../main.dart';
import '../models/user_chat.dart';
import '../widgets/user_chat_card.dart';
import 'profile_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  //This list Store the data of all user.
  List<UserChat> _list = [];

  //For Storing Search item.
  final List<UserChat> _searchList = [];

  //for storing search status.
  bool _isSearching = false;

  @override
  void initState() {
    super.initState();
    APIs.getLoginUserInfo();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      //To remove keyboard from screen.
      onTap: () => FocusScope.of(context).unfocus(),

      //if search is on & back button is pressed then close search.
      //and if again back envoked then close the home screen.
      child: WillPopScope(
        onWillPop: () {
          if (_isSearching) {
            setState(() {
              _isSearching = !_isSearching;
            });
            return Future.value(false);
          } else {
            return Future.value(true);
          }
        },

        //Scaffold of the App.
        child: Scaffold(
          //App bar of a App.
          appBar: AppBar(
            elevation: 10,
            title: _isSearching
                ? TextField(
                    style: const TextStyle(color: Colors.white, fontSize: 18),
                    decoration: const InputDecoration(
                      hintText: 'Name, Email....',
                      hintStyle: TextStyle(color: Colors.white, fontSize: 15),

                      //for changing color of underline of textfield.
                      focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Color(0xFFFFFFFF)),
                      ),
                    ),

                    //Logic of Searching in onchange method.
                    onChanged: (value) {
                      _searchList.clear();

                      for (var i in _list) {
                        if (i.name!
                                .toLowerCase()
                                .contains(value.toLowerCase()) ||
                            i.email!
                                .toLowerCase()
                                .contains(value.toLowerCase())) {
                          _searchList.add(i);
                        }
                        setState(() {
                          _searchList;
                        });
                      }
                    },
                  )
                : const Text('BaKaiTi'),

            //Three icon of the App Bar.
            actions: [
              //Search Button of the App bar.
              IconButton(
                  onPressed: () {
                    setState(() {
                      _isSearching = !_isSearching;
                    });
                  },
                  icon: Icon(
                    _isSearching ? Icons.cancel_rounded : Icons.search,
                    color: Colors.white,
                  )),

              //Home button of the app Bar.
              IconButton(
                  onPressed: () {},
                  icon: const Icon(
                    Icons.home_outlined,
                    color: Colors.white,
                  )),

              //Three Dot of the App Bar.
              IconButton(
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => ProfileScreen(
                                  user: APIs.loggined_user,
                                )));
                  },
                  icon: const Icon(
                    Icons.more_vert,
                    color: Colors.white,
                  )),
            ],
          ),

          //Floating button In the App.
          floatingActionButton: Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: FloatingActionButton(
              elevation: 10,
              backgroundColor: const Color(0xFFFF7701),
              onPressed: () {},
              child: const Icon(
                Icons.add_comment_rounded,
                color: Colors.white,
              ),
            ),
          ),

          //Body of the home screen.
          body: StreamBuilder(
            stream: APIs.getAllUsers(),
            builder: (context, snapshot) {
              switch (snapshot.connectionState) {
                //If data is loading.
                case ConnectionState.waiting:
                case ConnectionState.none:
                  return const Center(child: CircularProgressIndicator());

                //After loading Data
                case ConnectionState.active:
                case ConnectionState.done:
                  final data = snapshot.data?.docs;

                  /*If data is not null, convert each item into a UserChat 
                  object using its JSON data, and return the list. Otherwise,
                  return an empty list.*/
                  _list =
                      data?.map((e) => UserChat.fromJson(e.data())).toList() ??
                          [];

                  return ListView.builder(
                      padding: EdgeInsets.only(top: mq.height * .01),
                      itemCount:
                          _isSearching ? _searchList.length : _list.length,
                      physics: const BouncingScrollPhysics(),
                      itemBuilder: (context, index) {
                        return UserChatCard(
                            user: _isSearching
                                ? _searchList[index]
                                : _list[index]);
                      });
              }
            },
          ),
        ),
      ),
    );
  }
}
