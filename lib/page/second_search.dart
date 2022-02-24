import 'dart:async';
import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:double_back_to_close_app/double_back_to_close_app.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:p_interest/page/chat_page.dart';
import 'package:p_interest/page/home_page.dart';
import 'package:p_interest/page/search_page.dart';
import 'package:p_interest/page/sliver_up.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';
import '../model/model.dart';
import '../service/servics.dart';
import 'in_picture_page.dart';

class SecondSearch extends StatefulWidget {
  const SecondSearch({Key? key}) : super(key: key);

  static const String id = "second_search";

  @override
  _SecondSearchState createState() => _SecondSearchState();
}

class Share {
  String names;
  String logo;

  Share(this.names, this.logo);
}

class ShareList {
  static List<Share> shares = [
    Share('Facebook', 'asset/app/fc.png'),
    Share('Link ', 'asset/app/dot.png'),
    Share('Share ', 'asset/app/link.png'),
    Share('Gmail ', 'asset/app/mail.png'),
    Share('Messenger ', 'asset/app/mes.png'),
    Share('SMS ', 'asset/app/sm.png'),
    Share('Telegram ', 'asset/app/te.png'),
  ];
}

class _SecondSearchState extends State<SecondSearch> {
  int currentIndex = 1;

  PageController controller = PageController();

  List<Post> unlash = [];
  List<UserLinks> unlash2 = [];
  double downloadPercent = 0;
  bool showDownloadIndicator = false;
  int sellectedIndex = 1;
  Timer? _timer;
  bool isDark = false;
  String searchStr = "";
  int pageNum = 0;
  bool typing = false;
  TextEditingController textEditingController = TextEditingController();

  ScrollController scrollController = ScrollController();

  ///#Get
  void apiUserList() {
    Network.GET(Network.API_LIST, Network.paramsEmpty())
        .then((response) => {if (response != null) _showResponse(response)});
  }

  //
  // ///#LoadMore
  // void apiLoadList() {
  //   Network.GET(Network.API_LIST, Network.paramsPage())
  //       .then((response) => {if (response != null) _showResponse2(response)});
  // }
  //
  // /// loadMoreShow
  // void _showResponse2(String response) {
  //   List<Post> post = Network.parsePostList(response);
  //   if (kDebugMode) {
  //     print(Post);
  //   }
  //   setState(() {
  //     unlash.addAll(post);
  //   });
  // }

  ///#Showing
  void _showResponse(String response) {
    List<Post> post = Network.parsePostList(response);
    if (kDebugMode) {
      print(Post);
    }
    setState(() {
      unlash = post;
    });
  }

  ///#Search/Parse
  void apiSearchList() async {
    if (searchStr.isEmpty) {
      searchStr = "All";
      textEditingController.text = "";
    }
    pageNum++;
    String? response = await Network.GET(Network.API_SEARCH,
        Network.paramsSearch(search: searchStr, pageNum: pageNum));
    unlash = Network.parseSearchList(response!);
    setState(() {});
  }

  ///===================================================== Dawnload
  void downloadFile(String url, String filename) async {
    var permission = await _getPermission(Permission.storage);
    try {
      if (permission != false) {
        var httpClient = http.Client();
        var request = http.Request('GET', Uri.parse(url));
        var res = httpClient.send(request);
        final response = await get(Uri.parse(url));
        Directory generalDownloadDir =
            Directory('/storage/emulated/0/DCIM/Camera');
        EasyLoading.show(status: 'loading...');
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
            debugPrint(
                'downloadPercentage: ${downloaded / r.contentLength! * 100}');
            EasyLoading.showSuccess('Successfull loaded');
            EasyLoading.dismiss();
            setState(() {
              downloadPercent = 0;
              showDownloadIndicator = true;
              // showToast();
            });
            // Save the file
            File imageFile = File("${generalDownloadDir.path}/$filename.jpg");
            if (kDebugMode) {
              print(generalDownloadDir.path);
            }
            await imageFile.writeAsBytes(response.bodyBytes);
            return;
          });
        });
      } else {
        if (kDebugMode) {
          print("Permission Denied");
        }
      }
    } catch (e) {
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
        if (kDebugMode) {
          print(result.toString());
        }
        return false;
      }
    }
  }

  ///========================================================

  ///#Initstate
  @override
  void initState() {
    super.initState();
    EasyLoading.addStatusCallback((status) {
      if (kDebugMode) {
        print('EasyLoading Status $status');
      }
      if (status == EasyLoadingStatus.dismiss) {
        _timer?.cancel();
      }
    });
    apiUserList();
    scrollController.addListener(() {
      if (scrollController.position.pixels ==
          scrollController.position.maxScrollExtent) {
        setState(() {});
        apiSearchList();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: const Icon(
          Icons.arrow_left,
          color: Colors.transparent,
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        flexibleSpace: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: Colors.grey.shade200),
              height: 45,
              child: TextField(
                controller: textEditingController,
                onTap: () {
                  setState(() {
                    typing = true;
                  });
                },
                onEditingComplete: () {
                   FocusScope.of(context).requestFocus(FocusNode());
                  if (kDebugMode) {
                    print('complate******************************');
                  }
                  setState(() {
                    if (searchStr != textEditingController.text.trim())
                      pageNum = 0;
                    searchStr = textEditingController.text.trim();
                  });
                  apiSearchList();
                },
                decoration: InputDecoration(
                    border: InputBorder.none,
                    hintText: "Search Idea",
                    hintStyle: const TextStyle(color: Colors.grey),
                    prefixIcon: IconButton(
                      onPressed: () {},
                      icon: const Icon(
                        CupertinoIcons.search,
                        color: Colors.black,
                      ),
                    ),
                    suffixIcon: IconButton(
                      onPressed: () {},
                      icon: const Icon(
                        CupertinoIcons.photo_camera_solid,
                        color: Colors.black,
                      ),
                    )),
              ),
            ),
          ),
        ),
      ),
      body: DoubleBackToCloseApp(
        snackBar: SnackBar(
          shape: RoundedRectangleBorder(),
          backgroundColor: Colors.amber,
          elevation: 0,
          content: Text("Double tap to close App",style: TextStyle(color: Colors.black,fontSize: 17,fontWeight: FontWeight.bold),),
        ),
        child: Container(
          padding: const EdgeInsets.only(left: 5, right: 5),
          child: MasonryGridView.count(
            controller: scrollController,
            itemCount: unlash.length,
            crossAxisCount: 2,
            mainAxisSpacing: 4,
            crossAxisSpacing: 4,
            itemBuilder: (context, index) {
              return buildImageCard(unlash[index]);
            },
          ),
        ),
      ),

    );
  }

  Column buildImageCard(Post e) => Column(
        children: [
          Card(
              margin: EdgeInsets.zero,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(25)),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(25),
                child: GestureDetector(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => InPicturePage(imag: e)));
                  },
                  child: CachedNetworkImage(
                    imageUrl: e.urls.small.toString(),
                    fit: BoxFit.cover,
                    placeholder: (context, url) => AspectRatio(
                      aspectRatio: e.width / e.height,
                      child: Container(
                        color: Paint.getColorFromMix(e.color),
                      ),
                    ),
                    errorWidget: (context, url, error) =>
                        const Icon(Icons.error),
                  ),
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
                                        Row(
                                          children: [
                                            IconButton(
                                                onPressed: () {},
                                                icon: Icon(
                                                  CupertinoIcons.clear,
                                                  color: isDark
                                                      ? Colors.white
                                                      : Colors.black,
                                                )),
                                            MaterialButton(
                                              onPressed: () {},
                                              child: const Text(
                                                "Share",
                                                style: TextStyle(fontSize: 20),
                                              ),
                                            )
                                          ],
                                        ),
                                        SizedBox(
                                            height: 100,
                                            child: ListView.builder(
                                                scrollDirection:
                                                    Axis.horizontal,
                                                itemCount:
                                                    ShareList.shares.length,
                                                itemBuilder: (context, index) {
                                                  return buildContainer(
                                                      ShareList.shares[index]);
                                                })),
                                        const SizedBox(
                                          height: 15,
                                        ),
                                        const Divider(
                                          height: 10,
                                        ),
                                        MaterialButton(
                                          onPressed: () {
                                            setState(() {
                                              downloadFile(
                                                  e.urls.full, e.user.name);
                                              Navigator.of(context).pop();
                                            });
                                          },
                                          child: const Text(
                                            "Download image",
                                            style: TextStyle(fontSize: 20),
                                          ),
                                        ),
                                        MaterialButton(
                                          onPressed: () {},
                                          child: const Text(
                                            "Tear up the pin",
                                            style: TextStyle(fontSize: 20),
                                          ),
                                        ),
                                        MaterialButton(
                                          onPressed: () {},
                                          child: const Text(
                                            "Complaint to the pin",
                                            style: TextStyle(fontSize: 20),
                                          ),
                                        ),
                                        const Divider(
                                          height: 20,
                                        ),
                                        MaterialButton(
                                          onPressed: () {},
                                          child: const Text(
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

  Column buildContainer(Share elem) => Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          GestureDetector(
            onTap: () {},
            child: Container(
              margin: EdgeInsets.all(15),
              height: 50,
              width: 50,
              decoration: BoxDecoration(
                  image: DecorationImage(
                      image: AssetImage(elem.logo), fit: BoxFit.cover)),
            ),
          ),
          Text(elem.names)
        ],
      );
}
