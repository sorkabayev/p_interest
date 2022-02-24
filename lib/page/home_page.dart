import 'dart:async';
import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:double_back_to_close_app/double_back_to_close_app.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:p_interest/model/model.dart';
import 'package:p_interest/page/chat_page.dart';
import 'package:p_interest/page/search_page.dart';
import 'package:p_interest/page/second_search.dart';
import 'package:p_interest/page/sliver_up.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:url_launcher/url_launcher.dart';

import '../model/model.dart';
import '../service/servics.dart';
import 'in_picture_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  static const String id = "home_page";

  @override
  _HomePageState createState() => _HomePageState();
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

class _HomePageState extends State<HomePage> {
  int currentIndex = 0;
  Timer? _timer;

  PageController controller = PageController();

  final List<String> menu = [
    "All",
    "Todays",
    "Recipes",
    "Followings",
    "Health",
  ];

  List<Post> unlash = [];
  List<UserLinks> unlash2 = [];

  int sellectedIndex = 0;

  int counter = 2;
  bool isDark = false;
  String searchStr = "";
  int pageNum = 0;
  double downloadPercent = 0;
  bool showDownloadIndicator = false;


  ScrollController scrollController = ScrollController();
  TextEditingController textEditingController = TextEditingController();


  ///#Get
  void apiUserList() {
    Network.GET(Network.API_LIST, Network.paramsEmpty())
        .then((response) => {if (response != null) _showResponse(response)});
  }

  ///#LoadMore
  void apiLoadList() {
    Network.GET(Network.API_LIST, Network.paramsPage(counter))
        .then((response) => {if (response != null) _showResponse2(response)});
  }

  /// loadMoreShow
  void _showResponse2(String response) {
    List<Post> post = Network.parsePostList(response);
    if (kDebugMode) {
      print(Post);
    }
    setState(() {
      unlash.addAll(post);
    });
  }

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
  void apiSearchList() async{
    if (searchStr.isEmpty) {
      searchStr = "All";
      textEditingController.text = "";}
    pageNum++;
    String? response = await Network.GET(Network.API_SEARCH, Network.paramsSearch(search: searchStr, pageNum : pageNum));
    unlash = Network.parseSearchList(response!);
    setState(() {
    });
  }
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
            debugPrint('downloadPercentage: ${downloaded / r.contentLength! * 100}');
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
    apiSearchList();
    // apiUserOne();
    scrollController.addListener(() {
      if (scrollController.position.pixels ==
          scrollController.position.maxScrollExtent) {
        setState(() {
          counter++;
        });
        apiLoadList();
      }
    });
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        flexibleSpace: SafeArea(
          top: true,
          bottom: true,
          child: SizedBox(
            height: 50,
            child: ListView.builder(
                itemCount: menu.length,
                scrollDirection: Axis.horizontal,
                itemBuilder: (context, index) => Padding(
                      padding: const EdgeInsets.only(left: 1, top: 5),
                      child: Container(
                        width: 100,
                        padding: (index == menu.length - 1)
                            ? EdgeInsets.only(left: 2)
                            : EdgeInsets.symmetric(horizontal: 10),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(30),
                            color: sellectedIndex == index
                                ? Colors.black
                                : Colors.white),
                        child: MaterialButton(
                          padding: EdgeInsets.zero,
                          elevation: 0,
                          onPressed: () {
                            setState(() {
                              sellectedIndex = index;
                              searchStr = menu[index];
                              unlash = [];
                            });
                            apiSearchList();
                          },
                          child: Text(
                            menu[index],
                            style: TextStyle(
                                fontSize: 15,
                                color: index == sellectedIndex
                                    ? Colors.white
                                    : Colors.black),
                          ),
                        ),
                      ),
                    )),
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
      ),

      ///#Page controller
      body: DoubleBackToCloseApp(
        snackBar:  SnackBar(
          shape: RoundedRectangleBorder(),
          backgroundColor: Colors.amber,
          elevation: 0,
          content: Text("Double tap to close App",style: TextStyle(color: Colors.black,fontSize: 17,fontWeight: FontWeight.bold),),
        ),
        child: Container(
          padding: EdgeInsets.only(left: 5, right: 5),
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
                                            setState(()  {
                                              downloadFile(e.urls.full, e.user.name);
                                              Navigator.of(context).pop();
                                            });
                                          },
                                          child: const Text(
                                            "Download image",
                                            style: TextStyle(fontSize: 20),
                                          ),
                                        ),
                                        MaterialButton(
                                          onPressed: () {
                                            // setState(() {
                                            //   unlash.remove(e);
                                            //   Navigator.of(context).pop();
                                            //});
                                          },
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
