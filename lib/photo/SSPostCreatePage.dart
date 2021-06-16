/*
 * Author : Johnny Cheung
 * Page: 帖子发布页
 */

// import 'package:custom_image_picker/custom_image_picker.dart';
// import 'package:photo_manager/photo_manager.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:saysth/core/CupertinoPageRouteWithoutAnimation.dart';
import 'package:saysth/utility/PublicColors.dart';
import 'package:image_picker/image_picker.dart';
import 'package:camera/camera.dart';
import 'package:saysth/photo/views/TakePictureScreen.dart';

class SSPostCreatePage extends StatefulWidget {
  @override
  _SSPostCreatePage createState() => _SSPostCreatePage();
}

class _SSPostCreatePage extends State<SSPostCreatePage> {
  FocusNode _textFieldFocusNode = FocusNode();
  TextEditingController _textController = TextEditingController();
  final _imagePicker = ImagePicker();

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration(milliseconds: 500), () {
      _textFieldFocusNode.requestFocus();
    });
  }

  @override
  Widget build(BuildContext context) {
    var pageScaffold = CupertinoPageScaffold(
      backgroundColor: PublicColors.pureWhite,
      navigationBar: CupertinoNavigationBar(
        backgroundColor: PublicColors.pureWhite,
        padding: EdgeInsetsDirectional.only(start: 8, end: 8),
        leading: GestureDetector(
          onTap: () {
            Navigator.pop(context);
          },
          child: Row(
            children: <Widget>[
              Icon(
                Icons.close,
                color: PublicColors.mainBlack,
              ),
            ],
          ),
        ),
        middle: Text(''),
        trailing: GestureDetector(
          onTap: () {
            _onClickToSubmit();
          },
          child: Image.asset(
            'assets/images/black-send-plane-icon.png',
            width: 25,
            height: 25,
          ),
        ),
        border: Border(bottom: BorderSide.none),
      ),
      child: Column(
        children: [
          Container(
            // color: Colors.amber,
            margin: EdgeInsets.only(top: 15),
            padding: EdgeInsets.only(left: 5, top: 5, right: 0, bottom: 5),
            height: 180,
            child: Scrollbar(
              child: _createTextField(),
            ),
          ),
          Align(
            alignment: Alignment.centerLeft,
            child: GestureDetector(
              child: Container(
                width: 150,
                height: 150,
                margin: EdgeInsets.only(left: 20),
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  border: Border.all(
                    color: PublicColors.graySubtitle,
                    width: 1,
                  ),
                ),
                child: Icon(
                  Icons.add,
                  color: PublicColors.graySubtitle,
                  size: 50,
                ),
              ),
              onTap: () {
                _choosePhoto();
              },
            ),
          ),
        ],
      ),
    );
    return pageScaffold;
  }

  CupertinoTextField _createTextField() {
    var textField = CupertinoTextField(
      controller: _textController,
      keyboardType: TextInputType.multiline,
      minLines: 1,
      maxLines: 8,
      placeholder: 'Write something you want to share...',
      decoration: BoxDecoration(),
      textAlignVertical: TextAlignVertical.top,
      focusNode: _textFieldFocusNode,
    );
    return textField;
  }

  void _choosePhoto() {
    _textFieldFocusNode.unfocus();

    showCupertinoModalPopup<void>(
      context: context,
      builder: (BuildContext context) => CupertinoActionSheet(
        title: null, //const Text('Title'),
        message: null, //const Text('Message'),
        actions: <CupertinoActionSheetAction>[
          CupertinoActionSheetAction(
            child: const Text('Take a photo'),
            onPressed: () {
              _takePhoto();
              Navigator.pop(context);
            },
          ),
          CupertinoActionSheetAction(
            child: const Text('Choose from Photo Library'),
            onPressed: () {
              _chooseFromPhotoLibrary();
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
  }

  void _onClickToSubmit() {
    var text = _textController.text;
    print(text);
    _toastWithMessage("Implement it yourself", ToastGravity.TOP);
  }

  Future<void> _takePhoto() async {
    // WidgetsFlutterBinding.ensureInitialized();
    final cameras = await availableCameras();
    print(cameras);

    Navigator.of(context).push(
      CupertinoPageRouteWithoutAnimation(
        fullscreenDialog: true,
        builder: (context) => TakePictureScreen(camera: cameras.last),
      ),
    );
  }

  void _chooseFromPhotoLibrary() async {
    // ImageSource.camera 打开系统默认相机，默认UI界面
    // ImageSource.gallery 打开系统默认相册，默认UI界面
    // doc : https://github.com/flutter/plugins/tree/master/packages/image_picker/image_picker
    final pickedFile = await _imagePicker.getImage(source: ImageSource.gallery);
    setState(() {
      if (pickedFile != null) {
        // _image = File(pickedFile.path);
        print(pickedFile.path);
        _toastWithMessage("Implement it yourself", ToastGravity.CENTER);
      } else {
        print('No image selected.');
      }
    });
    // List<PhoneAlbum> albums = [];
    // final customImagePicker = CustomImagePicker();
    // customImagePicker.getAlbums(callback: (retrievedAlbums) {
    //   albums = retrievedAlbums;
    //   print("==============================================");
    //   print(albums.length);
    // });
    // customImagePicker.getAllImages(callback: (retrievedAlbums) {
    //   albums = retrievedAlbums;
    //   print("==============================================");
    //   print(albums.length);
    // for (var i = 0; i < albums.length; i++) {
    //   var name = albums[i].name;
    //   print(name);
    //   if (name.endsWith(".mov")
    //       // ||
    //       // name.endsWith(".MOV") ||
    //       // name.endsWith(".mp4") ||
    //       // name.endsWith(".MP4")
    //       ) {
    //     print(albums[i].name);
    //   }
    //   break;
    // }
    // });

    // List<AssetPathEntity> list = await PhotoManager.getAssetPathList();
    // for (var path in list) {
    //   final assetList = await path.getAssetListPaged(0, 10);
    //   print(assetList.length);
    //   print(assetList);
    //   break;
    // }
    // print(list.length);
    // print(list);
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
