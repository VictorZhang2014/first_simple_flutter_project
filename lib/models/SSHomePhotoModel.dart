class SSHomePhotoModel {
  SSHomePhotoModel();

  int userId = 0;
  String? nickname;
  String? userAvatar;
  bool gender = false;
  String? countryCode;
  int? userLevel;
  String? postType;
  String? postText;
  List<String>? postPhoto;
  String? postVideo;
  String? platform;
  int likeCount = 0;
  int likeStatus = 0;
  int commentCount = 0;
  int createTime = 0;

  // 示例
  //   "post_uuid":"3db67f75-cc4d-4975-b42c-67f90bb29fa8",
  // "user_id":8365,
  // "post_text":"Hi",
  // "post_type":"image",
  // "post_photo":[
  //     "https://static.cdn.aws.saysth.top/postsphoto/2021-05-29/0C8E6436-7743-49EA-B650-97C906498379.jpg"
  // ],
  // "post_video":"https://static.cdn.aws.saysth.top/",
  // "location_address":"The United States",
  // "platform":"iOS",
  // "src_language":null,
  // "tgt_language":null,
  // "create_time":1622301750,
  // "nickname":"33",
  // "country_code":"CN",
  // "user_avatar":"https://static.cdn.aws.saysth.top/useravatar/2021-05-29/E0A4F762-E055-435D-A5F7-67A462DDD759.jpg",
  // "gender":"0",
  // "user_level":null,
  // "like_count":12,
  // "like_status":0,
  // "comment_count":4

  SSHomePhotoModel.fromJson(Map<String, dynamic> jsonMap)
      : userId = jsonMap["user_id"],
        nickname = jsonMap["nickname"],
        userAvatar = jsonMap["user_avatar"],
        gender = jsonMap["gender"] == "1",
        countryCode = jsonMap["country_code"],
        userLevel = jsonMap["user_level"],
        postType = jsonMap["post_type"],
        postText = jsonMap["post_text"],
        postPhoto = jsonMap["post_photo"].cast<String>(),
        postVideo = jsonMap["post_video"],
        platform = jsonMap["platform"],
        likeCount = jsonMap["like_count"],
        likeStatus = jsonMap["like_status"],
        commentCount = jsonMap["comment_count"],
        createTime = jsonMap["create_time"];
}
