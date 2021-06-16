/*
 * Author : Johnny Cheung
 * Page: 消息页
 * 
 * 本页布局示例：https://flutter-widget.live/widgets/ListTile
 */

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:saysth/models/SSHomePhotoModel.dart';
import 'package:saysth/network/SSHttpRequester.dart';
import 'package:saysth/utility/PublicColors.dart';

class SSMessagePage extends StatefulWidget {
  @override
  _SSMessagePage createState() => _SSMessagePage();
}

class _SSMessagePage extends State<SSMessagePage> {
  List<SSHomePhotoModel> models = [];

  @override
  void initState() {
    super.initState();
    requestData();
  }

  @override
  void dispose() {
    super.dispose();
    print("_SSMessagePage has been deallocated!");
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      backgroundColor: PublicColors.pureWhite,
      navigationBar: CupertinoNavigationBar(
        backgroundColor: PublicColors.mainGreen,
        middle: Text(
          'Message',
          style: TextStyle(fontSize: 18, color: PublicColors.pureWhite),
          textAlign: TextAlign.center,
        ),
      ),
      child: ListView.separated(
          itemBuilder: (BuildContext context, int index) {
            String postText = models[index].postText ?? "";
            if (postText.length > 40) {
              postText = postText.substring(0, 40);
            }
            return Container(
              child: GestureDetector(
                child: Card(
                  elevation: 0,
                  child: ListTile(
                    leading: Container(
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(5.0),
                        child: CachedNetworkImage(
                          fit: BoxFit.fill,
                          imageUrl: models[index].userAvatar ?? "",
                          placeholder: _loader,
                          errorWidget: _error,
                        ),
                      ),
                    ),
                    title: Text(models[index].nickname ?? ""),
                    subtitle: Text(postText),
                    trailing: Icon(Icons.chevron_right),
                    // isThreeLine: true,
                  ),
                ),
                onTap: () {
                  this._toastWithMessage(
                      "We'd expect you're gonna implement this functionality.");
                },
              ),
            );
          },
          separatorBuilder: (BuildContext context, int index) => Divider(
                height: 1,
                thickness: 1,
                color: PublicColors.gray,
              ),
          scrollDirection: Axis.vertical,
          itemCount: models.length),
    );
  }

  Widget _loader(BuildContext context, String url) {
    return Center(
      child: CircularProgressIndicator(
        backgroundColor: PublicColors.mainGreen,
        color: PublicColors.mainPurple,
      ),
    );
  }

  Widget _error(BuildContext context, String url, dynamic error) {
    print("加载图片，发生了错误.....");
    print(error);
    return const Center(child: Icon(Icons.error));
  }

  void requestData() {
    SSHttpRequester().getWithType(SSHttpRequesterType.posts, "",
        (result, error) {
      if (result == null) {
        return;
      }
      List<SSHomePhotoModel> _models = [];
      for (var i = 0; i < 5; i++) {
        _models.add(SSHomePhotoModel.fromJson(result[i]));
      }
      // print("从底部刷新数据");
      setState(() {
        this.models = _models;
      });
    });
  }

  void _toastWithMessage(String message,
      {ToastGravity gravity = ToastGravity.CENTER}) {
    Fluttertoast.showToast(
        msg: message,
        toastLength: Toast.LENGTH_SHORT,
        gravity: gravity,
        timeInSecForIosWeb: 1,
        textColor: Colors.white,
        fontSize: 16.0);
  }
}
