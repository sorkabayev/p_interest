import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:double_back_to_close_app/double_back_to_close_app.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:p_interest/page/chat_page.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';
import 'package:p_interest/page/home_page.dart';
import 'package:p_interest/page/search_page.dart';
import 'package:p_interest/page/second_search.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:url_launcher/url_launcher.dart';

import '../model/model.dart';
import '../service/servics.dart';

class SliverPage extends StatefulWidget {
  const SliverPage({Key? key}) : super(key: key);

  static const String id = "sliver_page";

  @override
  _SliverPageState createState() => _SliverPageState();
}

class _SliverPageState extends State<SliverPage> {
  List<Post> phot = [];
  int currentIndex = 3;
  bool isDark = false;
  double downloadPercent = 0;
  bool showDownloadIndicator = false;
  int sellectedIndex = 3;
  List<Post> selectedPin = [];

  ///===================================================== Dawnload
  void downloadFile(String url,String filename) async {
    var permission = await _getPermission(Permission.storage);
    try{
      if(permission != false){

        var httpClient = http.Client();
        var request = http.Request('GET', Uri.parse(url));
        var res = httpClient.send(request);
        final response = await get(Uri.parse(url));
        Directory generalDownloadDir = Directory('/storage/emulated/0/DCIM/Camera');
        List<List<int>> chunks = [];
        int downloaded = 0;

        res.asStream().listen((http.StreamedResponse r) {
          r.stream.listen((List<int> chunk) {
            // Display percentage of completion

            setState(() {
              chunks.add(chunk);
              downloaded += chunk.length;
              showDownloadIndicator = true;
              downloadPercent = downloaded / r.contentLength!;
              debugPrint(downloadPercent.toString());

            });
          }, onDone: () async {
            // Display percentage of completion
            debugPrint('downloadPercentage: ${downloaded / r.contentLength! * 100}');

            setState(() {
              downloadPercent = 0;
              showDownloadIndicator = false;
              // showToast();
            });
            // Save the file
            File imageFile = File("${generalDownloadDir.path}/$filename.jpg");
            print(generalDownloadDir.path);
            await imageFile.writeAsBytes(response.bodyBytes);
            return;
          });
        });
      }
      else {
        if (kDebugMode) {
          print("Permission Denied");
        }
      }
    }
    catch(e){
      if (kDebugMode) {
        print(e.toString());
      }
    }
  }

  Future<bool> _getPermission(Permission permission) async {
    if (await permission.isGranted) {
      return true;
    } else {
      var result = await permission.request();

      if (result == PermissionStatus.granted) {
        return true;
      } else {
        print(result.toString());
        return false;
      }
    }
  }
  ///========================================================

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
///===================================================================
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: Icon(
          Icons.arrow_back,
          color: Colors.transparent,
        ),
        centerTitle: true,
        title: const Text(
          "Javlon",
          style: TextStyle(color: Colors.black),
        ),
        elevation: 0,
        backgroundColor: Colors.white,
        actions: [
          IconButton(
              onPressed: () {
                showModalBottomSheet(
                  context: context,
                  builder: (context) => Container(
                    decoration: const BoxDecoration(
                        borderRadius: BorderRadius.only(
                            topRight: Radius.circular(40),
                            topLeft: Radius.circular(40))),
                    height: 200,
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          IconButton(
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              icon: Icon(
                                CupertinoIcons.clear,
                                color: isDark ? Colors.white : Colors.black,
                              )),
                          Container(
                            padding: const EdgeInsets.only(left: 15),
                              height: 60,
                              child: ListView(
                                scrollDirection: Axis.horizontal,
                                children: [
                                  GestureDetector(
                                    onTap: () {
                                      Navigator.pop(context);
                                      launch("https://mail.google.com/");
                                    },
                                    child: Container(
                                      height: 60,
                                      width: 60,
                                      decoration: BoxDecoration(
                                          image: const DecorationImage(
                                              image: AssetImage(
                                                  "asset/app/mail.png"),
                                              fit: BoxFit.cover),
                                          borderRadius:
                                              BorderRadius.circular(60)),
                                    ),
                                  ),
                                  const SizedBox(width: 20),
                                  GestureDetector(
                                    onTap: () {
                                      launch("smsto:");
                                    },
                                    child: Container(
                                      height: 60,
                                      width: 60,
                                      decoration: BoxDecoration(
                                          image: const DecorationImage(
                                              image: AssetImage(
                                                  "asset/app/sm.png"),
                                              fit: BoxFit.cover),
                                          borderRadius:
                                              BorderRadius.circular(60)),
                                    ),
                                  ),
                                  const SizedBox(width: 20),
                                  GestureDetector(
                                    onTap: () {
                                      launch("tel:");
                                    },
                                    child: Container(
                                      height: 60,
                                      width: 60,
                                      decoration: BoxDecoration(
                                          image: const DecorationImage(
                                              image: AssetImage(
                                                  "asset/app/tel.png"),
                                              fit: BoxFit.cover),
                                          borderRadius:
                                              BorderRadius.circular(60)),
                                    ),
                                  ),
                                  const SizedBox(width: 20),
                                  GestureDetector(
                                    onTap: () {
                                      launch("https://t.me/");
                                    },
                                    child: Container(
                                      height: 60,
                                      width: 60,
                                      decoration: BoxDecoration(
                                          image: const DecorationImage(
                                              image: AssetImage(
                                                  "asset/app/te.png"),
                                              fit: BoxFit.cover),
                                          borderRadius:
                                              BorderRadius.circular(60)),
                                    ),
                                  ),
                                ],
                              )),
                        ]),
                  ),
                );
              },
              icon: const Icon(
                Icons.share_outlined,
                color: Colors.black,
              )),
          IconButton(
              onPressed: () {
                showModalBottomSheet(
                    context: context,
                    builder: (context) => Container(
                      height: 100,
                      child: Center(child: Text("Jarayonda>>>...",style: TextStyle(fontSize: 25,fontWeight: FontWeight.bold),))
                    ));
              },
              icon: const Icon(
                Icons.more_horiz,
                color: Colors.black,
              )),
        ],
      ),
      body: DoubleBackToCloseApp(
        snackBar: SnackBar(
          shape: RoundedRectangleBorder(),
          backgroundColor: Colors.amber,
          elevation: 0,
          content: Text("Double tap to close App",style: TextStyle(color: Colors.black,fontSize: 17,fontWeight: FontWeight.bold),),
        ),
        child: SafeArea(
          child: CustomScrollView(
            slivers: [
              SliverAppBar(
                pinned: true,
                floating: true,
                expandedHeight: 340,
                backgroundColor: Colors.white,
                flexibleSpace: FlexibleSpaceBar(
                  background: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                         Container(
                           height: 140,
                           width: 140,
                           alignment: Alignment.center,
                           child: ClipRRect(
                             borderRadius: BorderRadius.circular(70),
                             child: CircleAvatar(
                              radius: 70,
                              backgroundColor: Colors.amber.shade100,
                              child: Image.asset("asset/app/ja.jpg",fit: BoxFit.cover,),
                        ),
                           ),
                         ),
                        const SizedBox(
                          height: 10,
                        ),
                        const Align(
                            alignment: Alignment.center,
                            child: Text(
                              "Javlon",
                              style: TextStyle(fontSize: 25),
                            )),
                        const SizedBox(
                          height: 10,
                        ),
                        const Align(
                            alignment: Alignment.center,
                            child: Text(
                              "@sorkabayev",
                              style: TextStyle(fontSize: 17),
                            )),
                        const SizedBox(
                          height: 20,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            MaterialButton(
                              onPressed: () {},
                              child: const Text(
                                "Followers  0",
                                style:
                                    TextStyle(color: Colors.grey, fontSize: 17),
                              ),
                            ),
                            const SizedBox(
                              width: 20,
                            ),
                            const CircleAvatar(
                              radius: 2,
                              backgroundColor: Colors.grey,
                            ),
                            const SizedBox(
                              width: 20,
                            ),
                            MaterialButton(
                              onPressed: () {},
                              child: const Text(
                                "Follows  0",
                                style:
                                    TextStyle(color: Colors.grey, fontSize: 17),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 50,
                        ),
                      ]),
                  centerTitle: true,
                  title: Container(
                    height: 30,
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          margin: EdgeInsets.only(left: 10),
                          width: 240,
                          decoration: BoxDecoration(
                              color: Colors.grey.shade300,
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(color: Colors.grey)),
                          child: const TextField(
                            textAlignVertical: TextAlignVertical.center,
                            decoration: InputDecoration(
                              border: InputBorder.none,
                              hintText: "Search Pins",
                              hintStyle: TextStyle(fontSize: 14),
                              prefixIcon: Icon(
                                CupertinoIcons.search,
                                size: 17,
                              ),
                            ),
                          ),
                        ),
                        Flexible(
                            child: IconButton(
                                onPressed: () {
                                  BottomSheet(
                                    builder: (BuildContext context) {
                                      return Container(
                                        height: 300,
                                        color: Colors.white,
                                      );
                                    },
                                    onClosing: () {
                                    },
                                  );
                                },
                                icon: const Icon(
                                  CupertinoIcons.add,
                                  size: 17,
                                ))),
                      ],
                    ),
                  ),
                ),
              ),
              SliverList(
                delegate: SliverChildBuilderDelegate(
                  (context, index) {
                    return Padding(
                      padding: EdgeInsets.symmetric(horizontal: 5, vertical: 5),
                      child: MasonryGridView.count(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: phot.length,
                        crossAxisCount: 2,
                        mainAxisSpacing: 10,
                        crossAxisSpacing: 10,
                        itemBuilder: (context, index) {
                          return buildImageCard(phot[index]);
                        },
                      ),
                    );
                  },
                  childCount: 5,
                ),
              ),
            ],
          ),
        ),
      ),

    );
  }

  Widget buildImageCard(Post e) {
    return Column(
      children: [
        Card(
            margin: EdgeInsets.zero,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(25),
              child: CachedNetworkImage(
                imageUrl: e.urls.small.toString(),
                fit: BoxFit.cover,
                placeholder: (context, url) => CircularProgressIndicator(),
                errorWidget: (context, url, error) => const Icon(Icons.error),
              ),
            )),
        SizedBox(
            height: 35,
            child: Row(
              children: [
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.4,
                  child: Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(top: 8.0),
                        child: CircleAvatar(
                          radius: 20,
                          backgroundImage:
                          NetworkImage(e.user.profileImage.medium),
                        ),
                      ),
                      Flexible(
                        child: Text(
                          "${e.description.toString()}\n ${e.likes.toString()} likes",
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  width: 30,
                  child: IconButton(
                      onPressed: () {
                        showModalBottomSheet(
                            context: context,
                            builder: (context) => Container(
                              decoration: const BoxDecoration(
                                  borderRadius: BorderRadius.only(
                                      topRight: Radius.circular(40),
                                      topLeft: Radius.circular(40))),
                              height: 500,
                              child: Column(
                                crossAxisAlignment:
                                CrossAxisAlignment.start,
                                children: [
                                  IconButton(
                                      onPressed: () {
                                        Navigator.pop(context);
                                      },
                                      icon: Icon(
                                        CupertinoIcons.clear,
                                        color: isDark
                                            ? Colors.white
                                            : Colors.black,
                                      )),
                                  SizedBox(
                                      height: 60,
                                      child: ListView(
                                        scrollDirection:
                                        Axis.horizontal,
                                        children: [
                                          GestureDetector(
                                            onTap: () {
                                              Navigator.pop(context);
                                              launch("https://mail.google.com/");
                                            },
                                            child: Container(
                                              height: 60,
                                              width: 60,
                                              decoration: BoxDecoration(
                                                  image: DecorationImage(
                                                      image: AssetImage(
                                                          "asset/app/mail.png"),
                                                      fit: BoxFit.cover),
                                                  borderRadius:
                                                  BorderRadius.circular(
                                                      60)),
                                            ),
                                          ),
                                          const SizedBox(width: 20),
                                          GestureDetector(
                                            onTap: () {
                                              launch("smsto:");
                                            },
                                            child: Container(
                                              height: 60,
                                              width: 60,
                                              decoration: BoxDecoration(
                                                  image: DecorationImage(
                                                      image: AssetImage(
                                                          "asset/app/sm.png"),
                                                      fit: BoxFit.cover),
                                                  borderRadius:
                                                  BorderRadius.circular(
                                                      60)),
                                            ),
                                          ),
                                          const SizedBox(width: 20),
                                          GestureDetector(
                                            onTap: () {
                                              launch("tel:");
                                            },
                                            child: Container(
                                              height: 60,
                                              width: 60,
                                              decoration: BoxDecoration(
                                                  image: const DecorationImage(
                                                      image: AssetImage(
                                                          "asset/app/tel.png"),
                                                      fit: BoxFit.cover),
                                                  borderRadius:
                                                  BorderRadius.circular(
                                                      60)),
                                            ),
                                          ),
                                          const SizedBox(width: 20),
                                          GestureDetector(
                                            onTap: () {
                                              launch("https://t.me/");
                                            },
                                            child: Container(
                                              height: 60,
                                              width: 60,
                                              decoration: BoxDecoration(
                                                  image: const DecorationImage(
                                                      image: AssetImage(
                                                          "asset/app/te.png"),
                                                      fit: BoxFit.cover),
                                                  borderRadius:
                                                  BorderRadius.circular(
                                                      60)),
                                            ),
                                          ),
                                        ],
                                      )),
                                  const SizedBox(
                                    height: 15,
                                  ),
                                  const Divider(
                                    height: 10,
                                  ),
                                  MaterialButton(
                                    onPressed: () {
                                      setState(() {
                                        downloadFile(e.urls.full, e.user.name);
                                        Navigator.of(context).pop();
                                      });
                                    },
                                    child: Text(
                                      "Download image",
                                      style: TextStyle(fontSize: 20),
                                    ),
                                  ),
                                  MaterialButton(
                                    onPressed: () {},
                                    child: Text(
                                      "Tear up the pin",
                                      style: TextStyle(fontSize: 20),
                                    ),
                                  ),
                                  MaterialButton(
                                    onPressed: () {},
                                    child: Text(
                                      "Complaint to the pin",
                                      style: TextStyle(fontSize: 20),
                                    ),
                                  ),
                                  const Divider(
                                    height: 20,
                                  ),
                                  MaterialButton(
                                    onPressed: () {},
                                    child: Text(
                                      "Download image",
                                      style: TextStyle(fontSize: 20),
                                    ),
                                  ),
                                ],
                              ),
                            ));
                      },
                      icon: const Icon(Icons.more_horiz)),
                )
              ],
            ))
      ],
    );
  }
}
