import 'dart:async';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:p_interest/page/home_page.dart';
import 'package:p_interest/page/sliver_up.dart';
import 'package:permission_handler/permission_handler.dart';
import '../model/model.dart';
import '../service/servics.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({Key? key}) : super(key: key);

  static const String id = "search_page";

  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  double downloadPercent = 0;
  bool showDownloadIndicator = false;
  Timer? _timer;
  List<Post> phot = [];
  int currentIndex = 1;
  PageController controller = PageController();
  TextEditingController textEditingController = TextEditingController();
  String searchStr = "";
  int pageNum = 0;
  bool typing = false;

  ///#Get
  void apiUserList() {
    Network.GET(Network.API_LIST, Network.paramsEmpty())
        .then((response) => {if (response != null) _showResponse(response)});
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
    List<Post> newPost = Network.parseSearchList(response!);
    setState(() {
      if (pageNum == 1) {
        phot = newPost;
      } else {
        phot.addAll(newPost);
      }
    });
  }

  ///#Showing
  void _showResponse2(String response) {
    List<Post> post = Network.parsePostList(response);
    print(Post);
    setState(() {
      phot = post;
    });
  }

  ///#Showing
  void _showResponse(String response) {
    List<Post> post = Network.parsePostList(response);
    print(Post);
    setState(() {
      phot = post;
    });
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
            print(generalDownloadDir.path);
            await imageFile.writeAsBytes(response.bodyBytes);
            return;
          });
        });
      } else {
        print("Permission Denied");
      }
    } catch (e) {
      print(e.toString());
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

  ///#Initstate
  @override
  void initState() {
    super.initState();
    EasyLoading.addStatusCallback((status) {
      print('EasyLoading Status $status');
      if (status == EasyLoadingStatus.dismiss) {
        _timer?.cancel();
      }
    });
    apiUserList();
    apiSearchList();
    // apiUserOne();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: Icon(
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
                onTap: () {
                  typing = true;
                },
                onEditingComplete: () {
                  FocusScope.of(context).requestFocus(FocusNode());
                  setState(() {
                    if (searchStr != textEditingController.text.trim())
                      pageNum = 0;
                    searchStr = textEditingController.text.trim();
                  });
                  apiSearchList();
                },
                controller: textEditingController,
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
      body: SingleChildScrollView(
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
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
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
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
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
      bottomNavigationBar: Container(
        margin: const EdgeInsets.only(left: 60, right: 60),
        child: BottomNavigationBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          showUnselectedLabels: false,
          showSelectedLabels: false,
          selectedItemColor: Colors.black,
          unselectedItemColor: Colors.grey,
          selectedIconTheme: const IconThemeData(color: Colors.black),
          unselectedIconTheme: IconThemeData(color: Colors.grey),
          selectedLabelStyle: TextStyle(color: Colors.black, fontSize: 13),
          //unselectedFontSize: 10,
          iconSize: 30,
          type: BottomNavigationBarType.fixed,
          currentIndex: currentIndex,
          onTap: (index) => setState(() => currentIndex = index),
          items: [
            BottomNavigationBarItem(
                icon: GestureDetector(
                    onTap: () {
                      Navigator.pop(context, HomePage.id);
                    },
                    child: Icon(CupertinoIcons.home)),
                label: "Home"),
            const BottomNavigationBarItem(
              icon: Icon(CupertinoIcons.search),
              label: "Search",
            ),
            const BottomNavigationBarItem(
              icon: Icon(CupertinoIcons.chat_bubble),
              label: "chat",
            ),
            BottomNavigationBarItem(
              icon: GestureDetector(
                  onTap: () {
                    Navigator.pushReplacementNamed(context, SliverPage.id);
                  },
                  child: Icon(CupertinoIcons.person_alt)),
              label: "Accaunt",
            ),
          ],
        ),
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
