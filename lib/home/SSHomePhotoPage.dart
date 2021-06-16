/*
 * Author : Johnny Cheung
 * Page: 首页
 * 
 * 本页布局示例：https://api.flutter.dev/flutter/widgets/ListView-class.html
 * row + column示例： https://flutter.dev/docs/development/ui/layout
 */

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:saysth/models/SSHomePhotoModel.dart';
import 'package:saysth/utility/PublicColors.dart';
import 'package:saysth/network/SSHttpRequester.dart';
import 'package:saysth/utility/UnicodeFlags.dart';
import 'package:saysth/utility/TimeAgoUtil.dart';
import 'package:saysth/photo/SSPostCreatePage.dart';
import 'package:fluttertoast/fluttertoast.dart';

class SSHomePhotoPage extends StatefulWidget {
  @override
  _SSHomePhotoPage createState() => _SSHomePhotoPage();
}

class _SSHomePhotoPage extends State<SSHomePhotoPage> {
  List<SSHomePhotoModel> models = [];
  int pageIndex = 0;

  RefreshController _refreshController =
      RefreshController(initialRefresh: false);

  @override
  void initState() {
    super.initState();
    this._onRefreshFromHeader();
  }

  @override
  void dispose() {
    super.dispose();
    print("_SSHomePhotoPage has been deallocated!");
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      backgroundColor: PublicColors.pureWhite,
      navigationBar: CupertinoNavigationBar(
        backgroundColor: PublicColors.pureWhite, // PublicColors.mainPurple,
        padding: EdgeInsetsDirectional.fromSTEB(10, 5, 0, 10),
        border: Border(bottom: BorderSide.none),
        leading: Text(
          'DISCOVER',
          style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: PublicColors.pureBlack),
          textAlign: TextAlign.center,
        ),
        trailing: CupertinoButton(
          child: Icon(Icons.add_a_photo, color: PublicColors.pureBlack),
          padding: EdgeInsetsDirectional.zero,
          onPressed: () {
            // 类似iOS的present效果
            Navigator.of(context).push(
              CupertinoPageRoute(
                fullscreenDialog: true,
                builder: (context) => SSPostCreatePage(),
              ),
            );
            // 类似iOS的push效果
            //Navigator.pushNamed(context, '/postcreate');
          },
        ),
      ),
      child: SmartRefresher(
        enablePullDown: true,
        enablePullUp: true,
        header: WaterDropHeader(),
        controller: _refreshController,
        onRefresh: _onRefreshFromHeader,
        onLoading: _onRefreshFromFooter,
        child: ListView.separated(
          padding: const EdgeInsets.all(0),
          itemCount: models.length,
          itemBuilder: (BuildContext context, int index) {
            return Container(
              // height: 300, // 不写高度就是自动计算高度了
              color: PublicColors.pureWhite,
              child: Column(
                children: [
                  Row(
                    children: [
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Container(
                          height: 50,
                          width: 50,
                          alignment: Alignment.topLeft,
                          padding:
                              EdgeInsetsDirectional.only(start: 10, top: 10),
                          // color: Colors.red,
                          child: Container(
                            height: 36,
                            width: 36,
                            child: Align(
                              alignment: Alignment.centerLeft,
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(18.0),
                                child: CachedNetworkImage(
                                  fit: BoxFit.fill,
                                  imageUrl: models[index].userAvatar ?? "",
                                  placeholder: _loader,
                                  errorWidget: _error,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      Wrap(
                        direction: Axis.vertical,
                        children: [
                          Align(
                            alignment: Alignment.bottomLeft,
                            child: Container(
                              width: 100,
                              height: 27,
                              padding:
                                  EdgeInsetsDirectional.only(start: 5, top: 5),
                              // color: Colors.orange,
                              child: Align(
                                alignment: Alignment.centerLeft,
                                child: Text(
                                  "${models[index].nickname}  " +
                                      UnicodeFlags.getFlagWithCode(
                                          models[index].countryCode ?? "US"),
                                  style: TextStyle(
                                    color: PublicColors.pureBlack,
                                    fontSize: 17,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Align(
                            alignment: Alignment.bottomLeft,
                            child: Container(
                              height: 22,
                              // color: Colors.purple,
                              alignment: Alignment.bottomLeft,
                              margin: EdgeInsetsDirectional.only(top: 2),
                              child: Wrap(
                                direction: Axis.horizontal,
                                children: [
                                  Icon(
                                    models[index].gender
                                        ? Icons.male
                                        : Icons.female,
                                    size: 18,
                                    color: models[index].gender
                                        ? Colors.blue
                                        : Colors.red,
                                  ),
                                  Container(
                                    margin: EdgeInsetsDirectional.only(top: 2),
                                    child: Text(
                                      TimeAgoUtil.timeAgo(
                                          models[index].createTime),
                                      style: TextStyle(
                                        color: PublicColors.grayTitle,
                                        fontSize: 11,
                                      ),
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                      Spacer(),
                      GestureDetector(
                        onTap: () {
                          showCupertinoModalPopup<void>(
                            context: context,
                            builder: (BuildContext context) =>
                                CupertinoActionSheet(
                              title: null, //const Text('Title'),
                              message: null, //const Text('Message'),
                              actions: <CupertinoActionSheetAction>[
                                CupertinoActionSheetAction(
                                  child: const Text('Block this post'),
                                  onPressed: () {
                                    _toastWithMessage(
                                        "It will take effect soon! This function is in developing.",
                                        ToastGravity.TOP);
                                    Navigator.pop(context);
                                  },
                                ),
                                CupertinoActionSheetAction(
                                  child: const Text('Report this post'),
                                  onPressed: () {
                                    _toastWithMessage(
                                        "It will take effect soon! This function is in developing.",
                                        ToastGravity.CENTER);
                                    Navigator.pop(context);
                                  },
                                ),
                                CupertinoActionSheetAction(
                                  child: const Text('Report this user'),
                                  onPressed: () {
                                    _toastWithMessage(
                                        "It will take effect soon! This function is in developing.",
                                        ToastGravity.BOTTOM);
                                    Navigator.pop(context);
                                  },
                                ),
                                CupertinoActionSheetAction(
                                  isDestructiveAction: true,
                                  child: const Text('Cancel'),
                                  onPressed: () {
                                    Navigator.pop(context);
                                  },
                                ),
                              ],
                            ),
                          );
                        },
                        child: Container(
                          width: 35,
                          height: 35,
                          alignment: Alignment.centerRight,
                          margin: EdgeInsets.only(right: 10),
                          child: Icon(
                            Icons.more_horiz,
                            size: 30,
                            color: PublicColors.pureBlack,
                          ),
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Container(
                        width: MediaQuery.of(context).size.width,
                        padding: EdgeInsets.only(
                            left: 8, top: 3, right: 10, bottom: 10),
                        child: Text(
                          models[index].postText ?? "",
                          style: TextStyle(
                              color: PublicColors.pureBlack,
                              fontSize: 15,
                              fontWeight: FontWeight.w300),
                          maxLines: 3,
                        ),
                      )
                    ],
                  ),
                  Row(
                    children: [
                      Align(
                        alignment: Alignment.center,
                        child: Container(
                          width: MediaQuery.of(context).size.width,
                          height: 330,
                          child: CachedNetworkImage(
                            fit: BoxFit.cover,
                            imageUrl:
                                models[index].postPhoto?.elementAt(0) ?? "",
                            placeholder: _loader,
                            errorWidget: _error,
                          ),
                        ),
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Wrap(
                        direction: Axis.horizontal,
                        children: [
                          Container(
                            height: 35,
                            padding: EdgeInsets.only(
                                left: 10, top: 5, right: 5, bottom: 5),
                            child: Icon(
                              Icons.thumb_up,
                              size: 18,
                              color: PublicColors.grayTitle,
                            ),
                          ),
                          Container(
                            padding: EdgeInsets.only(
                                left: 0, top: 10, right: 10, bottom: 5),
                            child: Text(
                              "${models[index].likeCount}",
                              style: TextStyle(
                                color: PublicColors.grayTitle,
                                fontSize: 12,
                              ),
                            ),
                          ),
                          Container(
                            height: 35,
                            padding: EdgeInsets.only(
                                left: 10, top: 5, right: 5, bottom: 5),
                            child: Icon(
                              Icons.textsms,
                              size: 18,
                              color: PublicColors.grayTitle,
                            ),
                          ),
                          Container(
                            width: 100,
                            padding: EdgeInsets.only(
                                left: 0, top: 10, right: 10, bottom: 5),
                            child: Text(
                              "${models[index].commentCount}",
                              style: TextStyle(
                                color: PublicColors.grayTitle,
                                fontSize: 12,
                              ),
                            ),
                          ),
                        ],
                      )
                    ],
                  ),
                ],
              ),
            );
          },
          separatorBuilder: (BuildContext context, int index) => Divider(
            height: 5,
            thickness: 5,
            color: PublicColors.gray,
          ),
          scrollDirection: Axis.vertical,
        ),
      ),
    );
  }

  void _onRefreshFromHeader() {
    // print("_onRefreshFromHeader()==================");
    requestData(true);
    _refreshController.refreshCompleted();
  }

  void _onRefreshFromFooter() {
    // print("_onRefreshFromFooter()==================");
    requestData(false);
    // _refreshController.loadComplete();
    _refreshController.loadNoData();

    _toastWithMessage("No more data being loaded!", ToastGravity.SNACKBAR);
  }

  void requestData(bool isFromHeader) {
    SSHttpRequester().getWithType(SSHttpRequesterType.posts,
        "?type=hot&page_num=${isFromHeader ? 0 : this.pageIndex}",
        (result, error) {
      if (result == null) {
        return;
      }
      List<SSHomePhotoModel> _models = [];
      result.forEach((element) {
        _models.add(SSHomePhotoModel.fromJson(element));
      });
      // print("从底部刷新数据");
      setState(() {
        this.models = []; // 先把之前的数据清空
        if (isFromHeader) {
          this.models = _models;
        } else {
          this.models.addAll(_models);
        }
      });
      this.pageIndex++;
    });
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

  void _toastWithMessage(String message, ToastGravity gravity) {
    Fluttertoast.showToast(
        msg: message,
        toastLength: Toast.LENGTH_SHORT,
        gravity: gravity,
        timeInSecForIosWeb: 1,
        // backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 16.0);
  }
}
