import 'package:cached_network_image/cached_network_image.dart';
import 'package:double_back_to_close_app/double_back_to_close_app.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:p_interest/page/home_page.dart';
import 'package:p_interest/page/second_search.dart';
import 'package:p_interest/page/sliver_up.dart';

import '../model/model.dart';
import '../service/servics.dart';

class ChatPage extends StatefulWidget {
  const ChatPage({Key? key}) : super(key: key);

  static const String id = "chat_page";

  @override
  _ChatPageState createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  @override
  void dispose() {
    pageController.dispose();
    super.dispose();
  }

  int currentIndex = 2;
  int sellectedindex = 1;
  int sellectedIndex = 2;
  final PageController pageController = PageController();
  final PageController controller = PageController();

  List<Post> phot = [];
  TextEditingController textEditingController = TextEditingController();
  String searchStr = "";
  int pageNum = 0;
  bool typing = false;

  ///#Get
  void apiUserList() {
    Network.GET(Network.API_LIST, Network.paramsEmpty())
        .then((response) => {if (response != null) _showResponse(response)});
  }

  ///#Showing
  void _showResponse(String response) {
    List<Post> post = Network.parsePostList(response);
    if (kDebugMode) {
      print(Post);
    }
    setState(() {
      phot = post;
    });
  }

  ///#Initstate
  @override
  void initState() {
    super.initState();
    apiUserList();
    // apiUserOne();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(),
      body: DoubleBackToCloseApp(
        snackBar: SnackBar(
          shape: RoundedRectangleBorder(),
          backgroundColor: Colors.amber,
          elevation: 0,
          content: Text("Double tap to close App",style: TextStyle(color: Colors.black,fontSize: 17,fontWeight: FontWeight.bold),),
        ),
        child: SafeArea(
            child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  MaterialButton(
                    color: sellectedindex == 0 ? Colors.black : Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    onPressed: () {
                      if (pageController.hasClients) {
                        pageController.animateToPage(
                          0,
                          duration: const Duration(milliseconds: 400),
                          curve: Curves.easeInOut,
                        );
                      }
                    },
                    child: Text(
                      "Updates",
                      style: TextStyle(
                        color: sellectedindex == 1 ? Colors.black : Colors.white,
                      ),
                    ),
                  ),
                  MaterialButton(
                    color: sellectedindex == 1 ? Colors.black : Colors.white,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20)),
                    onPressed: () {
                      if (pageController.hasClients) {
                        pageController.animateToPage(
                          1,
                          duration: const Duration(milliseconds: 400),
                          curve: Curves.easeInOut,
                        );
                      }
                    },
                    child: Text(
                      "Messege",
                      style: TextStyle(
                        color: sellectedindex == 1 ? Colors.white : Colors.black,
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.8,
                child: PageView(
                  onPageChanged: (page) {
                    setState(() {
                      sellectedindex = page;
                    });
                  },
                  controller: pageController,
                  scrollDirection: Axis.horizontal,
                  children: <Widget>[
                    SingleChildScrollView(
                      scrollDirection: Axis.vertical,
                      child: Padding(
                        padding: const EdgeInsets.all(10),
                        child: Column(
                          children: [
                            const Center(
                                child: Text(
                              "Idea for you",
                              style: TextStyle(fontSize: 21),
                            )),
                            const SizedBox(
                              height: 10,
                            ),
                            SizedBox(
                              height: 322,
                              child: GridView.builder(
                                scrollDirection: Axis.vertical,
                                itemCount: phot.length,
                                gridDelegate:
                                    const SliverGridDelegateWithFixedCrossAxisCount(
                                        crossAxisCount: 2,
                                        mainAxisExtent: 100,
                                        mainAxisSpacing: 8,
                                        crossAxisSpacing: 8),
                                itemBuilder: (context, index) {
                                  return buildContainer(phot[index]);
                                },
                              ),
                            ),
                            const Text("Popular in Pinterest",
                                style: TextStyle(fontSize: 21)),
                            const SizedBox(
                              height: 10,
                            ),
                            SizedBox(
                              height: 322,
                              child: GridView.builder(
                                scrollDirection: Axis.vertical,
                                itemCount: phot.length,
                                gridDelegate:
                                    const SliverGridDelegateWithFixedCrossAxisCount(
                                        crossAxisCount: 2,
                                        mainAxisExtent: 100,
                                        mainAxisSpacing: 8,
                                        crossAxisSpacing: 8),
                                itemBuilder: (context, index) {
                                  return buildContainer(phot[index]);
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Expanded(
                            flex: 11,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                // #content
                                const Text(
                                  "Share ideas with \nyour friends",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      fontSize: 30, fontWeight: FontWeight.w700),
                                ),
                                const SizedBox(
                                  height: 20,
                                ),

                                // #textField
                                Padding(
                                  padding:
                                      const EdgeInsets.symmetric(horizontal: 30),
                                  child: GestureDetector(
                                    onTap: () {
                                      if (kDebugMode) {
                                        print("Hello => TextField");
                                      }
                                    },
                                    child: Container(
                                        height: 38,
                                        decoration: BoxDecoration(
                                          color: Colors.grey[300],
                                          borderRadius: BorderRadius.circular(19),
                                        ),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: const [
                                            Padding(
                                              padding: EdgeInsets.only(left: 8),
                                              child: Icon(
                                                Icons.search,
                                                color: Colors.black54,
                                              ),
                                            ),
                                            SizedBox(
                                              width: 7,
                                            ),
                                            Text(
                                              "Search by name or email",
                                              style: TextStyle(
                                                  fontWeight: FontWeight.w600,
                                                  color: Colors.black54),
                                            ),
                                          ],
                                        )),
                                  ),
                                ),
                                const SizedBox(
                                  height: 10,
                                ),

                                // #contact message
                                Padding(
                                  padding:
                                      const EdgeInsets.symmetric(horizontal: 10),
                                  child: SizedBox(
                                    height: 65,
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        SizedBox(
                                          width: 65,
                                          height: 65,
                                          child: Align(
                                            alignment: Alignment.center,
                                            child: phot.isNotEmpty
                                                ? CircleAvatar(
                                                    radius: 25,
                                                    foregroundImage: NetworkImage(
                                                        phot[0]
                                                            .user
                                                            .profileImage
                                                            .large),
                                                  )
                                                : const CircleAvatar(
                                                    radius: 25,
                                                    foregroundImage: NetworkImage(
                                                        "https://www.pngitem.com/pimgs/m/35-350426_profile-icon-png-default-profile-picture-png-transparent.png"),
                                                  ),
                                          ),
                                        ),
                                        const SizedBox(
                                          width: 10,
                                        ),
                                        Expanded(
                                          flex: 17,
                                          child: Text(
                                            phot.isNotEmpty
                                                ? phot[1].user.name
                                                : "User",
                                            style: const TextStyle(
                                                fontSize: 18,
                                                fontWeight: FontWeight.w600),
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ),
                                        Expanded(
                                          flex: 10,
                                          child: MaterialButton(
                                            elevation: 0,
                                            onPressed: () {},
                                            color: Colors.red.shade700,
                                            height: 45,
                                            shape: const StadiumBorder(),
                                            child: const Text(
                                              'Message',
                                              style:
                                                  TextStyle(color: Colors.white),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),

                                const SizedBox(
                                  height: 5,
                                ),

                                // #sync contact
                                Padding(
                                  padding:
                                      const EdgeInsets.symmetric(horizontal: 10),
                                  child: GestureDetector(
                                    onTap: () {
                                      if (kDebugMode) {
                                        print("Alert dialog");
                                      }
                                    },
                                    child: SizedBox(
                                      height: 65,
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          SizedBox(
                                            width: 65,
                                            height: 65,
                                            child: Align(
                                                alignment: Alignment.center,
                                                child: CircleAvatar(
                                                  backgroundColor:
                                                      Colors.red.shade700,
                                                  radius: 25,
                                                  child: const Icon(
                                                    Icons.people_alt,
                                                    color: Colors.white,
                                                  ),
                                                )),
                                          ),
                                          const SizedBox(
                                            width: 8,
                                          ),
                                          const Text(
                                            "Sync contacts",
                                            style: TextStyle(
                                                fontSize: 18,
                                                fontWeight: FontWeight.w600),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                )
                              ],
                            )),
                        Expanded(
                            flex: 2,
                            child: Align(
                              alignment: Alignment.center,
                              child: CircleAvatar(
                                radius: 30,
                                backgroundColor: Colors.black,
                                child: Padding(
                                  padding: const EdgeInsets.only(bottom: 8),
                                  child: IconButton(
                                    onPressed: () {},
                                    icon: const Icon(
                                      Icons.person,
                                      size: 35,
                                    ),
                                  ),
                                ),
                              ),
                            ))
                      ],
                    )
                  ],
                ),
              ),
            ],
          ),
        )),
      ),
    );
  }

  Card buildContainer(Post e) => Card(
        margin: EdgeInsets.zero,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
        child: Stack(children: [
          Container(
            width: MediaQuery.of(context).size.width,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(25),

              ///# Image Catcher
              child: CachedNetworkImage(
                imageUrl: e.urls.small.toString(),
                fit: BoxFit.cover,
                placeholder: (context, url) => AspectRatio(
                  aspectRatio: e.width / e.height,
                  child: Container(
                    color: Paint.getColorFromMix(e.color),
                  ),
                ),
                errorWidget: (context, url, error) => AspectRatio(
                  aspectRatio: e.width / e.height,
                  child: Container(
                    color: Paint.getColorFromMix(e.color),
                  ),
                ),
              ),
            ),
          ),
          Align(
              alignment: Alignment.center,
              child: Text(
                e.color,
                style:
                    TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
              ))
        ]),
      );
}
