// class PostList{
//   late List<Post> postList;
//
//   PostList({required this.postList});
//
//   PostList.fromJson(List json) {
//     postList = json.map((e) => Post.fromJson(e)).toList();
//   }
//
//   List toJson() {
//     List list;
//     list = postList.map((e) => e.toJson()).toList();
//     return list;
//   }
// }

import 'dart:convert';

import 'package:flutter/material.dart';


class Post {
  Post({
    required this.id,
    required this.createdAt,
    required this.updatedAt,
    this.promotedAt,
    required this.width,
    required this.height,
    required this.color,
    required this.blurHash,
    required this.description,
    this.altDescription,
    required this.urls,
    required this.links,
    required this.categories,
    required this.likes,
    required this.likedByUser,
    required this.currentUserCollections,
    this.sponsorship,
    required this.topicSubmissions,
    required this.user,
  });

  String id;
  late DateTime createdAt;
  late DateTime updatedAt;
  DateTime? promotedAt;
  late int width;
  late int height;
  late String color;
  late String blurHash;
  late String description;
  String? altDescription;
  late Urls urls;
  late PostLinks links;
  late List<dynamic> categories;
  late int likes;
  late bool likedByUser;
  late List<dynamic> currentUserCollections;
  Sponsorship? sponsorship;
  TopicSubmissions? topicSubmissions;
  late User user;

  factory Post.fromJson(Map<String, dynamic> json) =>
      Post(
        id: json["id"],
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: DateTime.parse(json["updated_at"]),
        promotedAt: json["promoted_at"] == null
            ? null
            : DateTime.parse(json["promoted_at"]),
        width: json["width"],
        height: json["height"],
        color: json["color"],
        blurHash: json["blur_hash"],
        description: json["description"] ?? "",
        altDescription:
            json["alt_description"] == null ? "" : json["alt_description"],
        urls: Urls.fromJson(json["urls"]),
        links: PostLinks.fromJson(json["links"]),
        categories: List<dynamic>.from(json["categories"].map((x) => x)),
        likes: json["likes"],
        likedByUser: json["liked_by_user"],
        currentUserCollections:
            List<dynamic>.from(json["current_user_collections"].map((x) => x)),
        sponsorship: json["sponsorship"] == null
            ? null
            : Sponsorship.fromJson(json["sponsorship"]),
        topicSubmissions: json["topic_submissions"] == null
            ? null
            : TopicSubmissions.fromJson(json["topic_submissions"]),
        user: User.fromJson(json["user"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "created_at": createdAt.toIso8601String(),
        "updated_at": updatedAt.toIso8601String(),
        "promoted_at":
            promotedAt == null ? null : promotedAt!.toIso8601String(),
        "width": width,
        "height": height,
        "color": color,
        "blur_hash": blurHash,
        "description": description == null ? null : description,
        "alt_description": altDescription == null ? null : altDescription,
        "urls": urls.toJson(),
        "links": links.toJson(),
        "categories": List<dynamic>.from(categories.map((x) => x)),
        "likes": likes,
        "liked_by_user": likedByUser,
        "current_user_collections":
            List<dynamic>.from(currentUserCollections.map((x) => x)),
        "sponsorship": sponsorship == null ? null : sponsorship!.toJson(),
        "topic_submissions":
            topicSubmissions == null ? null : topicSubmissions!.toJson(),
        "user": user.toJson(),
      };

  static List<Post> postFromJson(String str) =>
      List<Post>.from(jsonDecode(str).map((x) => Post.fromJson(x)));

  static String postToJson(List<Post> data) =>
      jsonEncode(List<dynamic>.from(data.map((x) => x.toJson())));
}

class PostLinks {
  PostLinks({
    required this.self,
    required this.html,
    required this.download,
    required this.downloadLocation,
  });

  late String self;
  late String html;
  late String download;
  late String downloadLocation;

  factory PostLinks.fromJson(Map<String, dynamic> json) => PostLinks(
        self: json["self"],
        html: json["html"],
        download: json["download"],
        downloadLocation: json["download_location"],
      );

  Map<String, dynamic> toJson() => {
        "self": self,
        "html": html,
        "download": download,
        "download_location": downloadLocation,
      };
}

class Sponsorship {
  Sponsorship({
    required this.impressionUrls,
    required this.tagline,
    required this.taglineUrl,
    required this.sponsor,
  });

  late List<String> impressionUrls;
  late String tagline;
  late String taglineUrl;
  late User sponsor;

  factory Sponsorship.fromJson(Map<String, dynamic> json) => Sponsorship(
        impressionUrls:
            List<String>.from(json["impression_urls"].map((x) => x)),
        tagline: json["tagline"],
        taglineUrl: json["tagline_url"],
        sponsor: User.fromJson(json["sponsor"]),
      );

  Map<String, dynamic> toJson() => {
        "impression_urls": List<dynamic>.from(impressionUrls.map((x) => x)),
        "tagline": tagline,
        "tagline_url": taglineUrl,
        "sponsor": sponsor.toJson(),
      };
}

class User {
  User({
    required this.id,
    required this.updatedAt,
    required this.username,
    required this.name,
    required this.firstName,
    this.lastName,
    this.twitterUsername,
    this.portfolioUrl,
    this.bio,
    this.location,
    required this.links,
    required this.profileImage,
    this.instagramUsername,
    required this.totalCollections,
    required this.totalLikes,
    required this.totalPhotos,
    required this.acceptedTos,
    required this.forHire,
    required this.social,
  });

  late String id;
  late DateTime updatedAt;
  late String username;
  late String name;
  late String firstName;
  String? lastName;
  String? twitterUsername;
  String? portfolioUrl;
  String? bio;
  String? location;
  late UserLinks links;
  late ProfileImage profileImage;
  String? instagramUsername;
  late int totalCollections;
  late int totalLikes;
  late int totalPhotos;
  late bool acceptedTos;
  late bool forHire;
  late Social social;

  factory User.fromJson(Map<String, dynamic> json) => User(
        id: json["id"],
        updatedAt: DateTime.parse(json["updated_at"]),
        username: json["username"],
        name: json["name"],
        firstName: json["first_name"],
        lastName: json["last_name"] == null ? null : json["last_name"],
        twitterUsername:
            json["twitter_username"] == null ? null : json["twitter_username"],
        portfolioUrl:
            json["portfolio_url"] == null ? null : json["portfolio_url"],
        bio: json["bio"] == null ? null : json["bio"],
        location: json["location"] == null ? null : json["location"],
        links: UserLinks.fromJson(json["links"]),
        profileImage: ProfileImage.fromJson(json["profile_image"]),
        instagramUsername: json["instagram_username"] == null
            ? null
            : json["instagram_username"],
        totalCollections: json["total_collections"],
        totalLikes: json["total_likes"],
        totalPhotos: json["total_photos"],
        acceptedTos: json["accepted_tos"],
        forHire: json["for_hire"],
        social: Social.fromJson(json["social"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "updated_at": updatedAt.toIso8601String(),
        "username": username,
        "name": name,
        "first_name": firstName,
        "last_name": lastName == null ? null : lastName,
        "twitter_username": twitterUsername == null ? null : twitterUsername,
        "portfolio_url": portfolioUrl == null ? null : portfolioUrl,
        "bio": bio == null ? null : bio,
        "location": location == null ? null : location,
        "links": links.toJson(),
        "profile_image": profileImage.toJson(),
        "instagram_username":
            instagramUsername == null ? null : instagramUsername,
        "total_collections": totalCollections,
        "total_likes": totalLikes,
        "total_photos": totalPhotos,
        "accepted_tos": acceptedTos,
        "for_hire": forHire,
        "social": social.toJson(),
      };
}

class UserLinks {
  UserLinks({
    required this.self,
    required this.html,
    required this.photos,
    required this.likes,
    required this.portfolio,
    required this.following,
    required this.followers,
  });

  late String self;
  late String html;
  late String photos;
  late String likes;
  late String portfolio;
  late String following;
  late String followers;

  factory UserLinks.fromJson(Map<String, dynamic> json) => UserLinks(
        self: json["self"]== null ? null : json['self'],
        html: json["html"],
        photos: json["photos"]== null ? null : json["photos"],
        likes: json["likes"],
        portfolio: json["portfolio"],
        following: json["following"],
        followers: json["followers"],
      );

  Map<String, dynamic> toJson() => {
        "self": self == null ? null : self,
        "html": html,
        "photos": photos == null ? null : photos,
        "likes": likes,
        "portfolio": portfolio,
        "following": following,
        "followers": followers,
      };

  static List<UserLinks> userLinkFromJson(String str) =>
      List<UserLinks>.from(json.decode(str).map((x) => UserLinks.fromJson(x)));

  static String userLinkToJson(List<UserLinks> data) =>
      json.encode(List<dynamic>.from(data.map((x) => x.toJson())));
}


class ProfileImage {
  ProfileImage({
    required this.small,
    required this.medium,
    required this.large,
  });

  late String small;
  late String medium;
  late String large;

  factory ProfileImage.fromJson(Map<String, dynamic> json) => ProfileImage(
        small: json["small"],
        medium: json["medium"],
        large: json["large"],
      );

  Map<String, dynamic> toJson() => {
        "small": small,
        "medium": medium,
        "large": large,
      };
}

class Social {
  Social({
    this.instagramUsername,
    this.portfolioUrl,
    this.twitterUsername,
    this.paypalEmail,
  });

  String? instagramUsername;
  String? portfolioUrl;
  String? twitterUsername;
  String? paypalEmail;

  factory Social.fromJson(Map<String, dynamic> json) => Social(
        instagramUsername: json["instagram_username"] ?? null,
        portfolioUrl:
            json["portfolio_url"] == null ? null : json["portfolio_url"],
        twitterUsername:
            json["twitter_username"] == null ? null : json["twitter_username"],
        paypalEmail: json["paypal_email"] == null ? null : json["paypal_email"],
      );

  Map<String, dynamic> toJson() => {
        "instagram_username":
            instagramUsername == null ? null : instagramUsername,
        "portfolio_url": portfolioUrl == null ? null : portfolioUrl,
        "twitter_username": twitterUsername == null ? null : twitterUsername,
        "paypal_email": paypalEmail == null ? null : paypalEmail,
      };
}

class TopicSubmissions {
  TopicSubmissions({
    this.health,
    this.businessWork,
  });

  BusinessWork? health;
  BusinessWork? businessWork;

  factory TopicSubmissions.fromJson(Map<String, dynamic> json) =>
      TopicSubmissions(
        health: json["health"] == null
            ? null
            : BusinessWork.fromJson(json["health"]),
        businessWork: json["business-work"] == null
            ? null
            : BusinessWork.fromJson(json["business-work"]),
      );

  Map<String, dynamic> toJson() => {
        "health": health == null ? null : health?.toJson(),
        "business-work": businessWork == null ? null : businessWork!.toJson(),
      };
}

class BusinessWork {
  BusinessWork({
    required this.status,
    required this.approvedOn,
  });

   String? status;
   DateTime? approvedOn;

  factory BusinessWork.fromJson(Map<String, dynamic> json) => BusinessWork(
        status: json["status"] == null ? null : json["status"],
        approvedOn: json["approved_on"] == null ? null :  DateTime.parse(json["approved_on"]),
      );

  Map<String, dynamic> toJson() => {
        "status": status == null ? null : status,
        "approved_on": approvedOn == null ? null : approvedOn?.toIso8601String(),
      };
}

class Urls {
  Urls({
    required this.raw,
    required this.full,
    required this.regular,
    required this.small,
    required this.thumb,
    required this.smallS3,
  });

  late String raw;
  late String full;
  late String regular;
  late String small;
  late String thumb;
  late String smallS3;

  factory Urls.fromJson(Map<String, dynamic> json) => Urls(
        raw: json["raw"],
        full: json["full"],
        regular: json["regular"],
        small: json["small"],
        thumb: json["thumb"],
        smallS3: json["small_s3"],
      );

  Map<String, dynamic> toJson() => {
        "raw": raw,
        "full": full,
        "regular": regular,
        "small": small,
        "thumb": thumb,
        "small_s3": smallS3,
      };
}

/// imagePlacePainter
class Paint {
  static Color getColorFromMix(String mixColor){
    mixColor = mixColor.replaceAll("#", "");
    if(mixColor.length == 6){
      mixColor == "ff" + mixColor;
    }
    if(mixColor.length == 8){
      return Color(int.parse("0x$mixColor"));
    }
    return Colors.grey.shade300;
  }
}