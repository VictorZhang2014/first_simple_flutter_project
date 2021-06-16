/*
 * Official Doc: https://flutter.dev/docs/cookbook/plugins/picture-using-camera
 */

import 'dart:io';
import 'package:camera/camera.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:saysth/utility/PublicColors.dart';
import 'package:fluttertoast/fluttertoast.dart';

// A screen that allows users to take a picture using a given camera.
class TakePictureScreen extends StatefulWidget {
  final CameraDescription camera;

  const TakePictureScreen({
    Key? key,
    required this.camera,
  }) : super(key: key);

  @override
  TakePictureScreenState createState() => TakePictureScreenState();
}

class TakePictureScreenState extends State<TakePictureScreen> {
  late CameraController _controller;
  late Future<void> _initializeControllerFuture;
  bool _selectedPhoto = true;

  @override
  void initState() {
    super.initState();
    // To display the current output from the Camera,
    // create a CameraController.
    _controller = CameraController(
      // Get a specific camera from the list of available cameras.
      widget.camera,
      // Define the resolution to use.
      ResolutionPreset.medium,
    );

    // Next, initialize the controller. This returns a Future.
    _initializeControllerFuture = _controller.initialize();
  }

  @override
  void dispose() {
    // Dispose of the controller when the widget is disposed.
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var screenHeight = MediaQuery.of(context).size.height;
    var statusBarHeight = MediaQuery.of(context).padding.top;
    var navBar = CupertinoNavigationBar(
      backgroundColor: PublicColors.pureWhite, // Color(0x00ffffff),
      padding: EdgeInsetsDirectional.only(start: 8),
      leading: GestureDetector(
        onTap: () {
          Navigator.pop(context);
        },
        child: Row(
          children: <Widget>[
            Icon(
              Icons.arrow_back,
              color: PublicColors.pureBlack,
            ),
          ],
        ),
      ),
    );
    var navBarHeight = navBar.preferredSize.height;
    return CupertinoPageScaffold(
      navigationBar: navBar,
      child: Column(
        children: [
          Stack(
            alignment: Alignment.center,
            children: [
              Container(
                // width: MediaQuery.of(context).size.width,
                height: screenHeight - statusBarHeight - navBarHeight - 120,
                child: FutureBuilder<void>(
                  future: _initializeControllerFuture,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.done) {
                      // If the Future is complete, display the preview.
                      return CameraPreview(_controller);
                    } else {
                      // Otherwise, display a loading indicator.
                      return const Center(child: CircularProgressIndicator());
                    }
                  },
                ),
              ),
              Positioned(
                bottom: 0,
                width: 160,
                height: 50,
                child: Container(
                  child: Row(
                    children: [
                      GestureDetector(
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(5.0),
                          child: Container(
                            width: 80,
                            height: 40,
                            alignment: Alignment.center,
                            color: _selectedPhoto
                                ? PublicColors.pureWhite
                                : PublicColors.clearColor,
                            child: Text(
                              "照片",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: _selectedPhoto
                                    ? PublicColors.pureBlack
                                    : PublicColors.pureWhite,
                                fontSize: 18,
                              ),
                            ),
                          ),
                        ),
                        onTap: () {
                          setState(() {
                            _selectedPhoto = true;
                          });
                        },
                      ),
                      GestureDetector(
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(5.0),
                          child: Container(
                            width: 80,
                            height: 40,
                            alignment: Alignment.center,
                            color: _selectedPhoto
                                ? PublicColors.clearColor
                                : PublicColors.pureWhite,
                            child: Text(
                              "视频",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: _selectedPhoto
                                    ? PublicColors.pureWhite
                                    : PublicColors.pureBlack,
                                fontSize: 18,
                              ),
                            ),
                          ),
                        ),
                        onTap: () {
                          setState(() {
                            _selectedPhoto = false;
                          });
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          Container(
            height: 120,
            child: Row(
              children: [
                Flexible(
                  flex: 2,
                  fit: FlexFit.tight,
                  child: Container(
                    width: 70,
                    height: 70,
                    child: Icon(
                      Icons.add_a_photo,
                      color: PublicColors.pureBlack,
                      size: 38,
                    ),
                  ),
                ),
                Flexible(
                  flex: 2,
                  fit: FlexFit.tight,
                  child: GestureDetector(
                    child: Container(
                      width: 90,
                      height: 90,
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(40.0),
                            child: Container(
                              color: PublicColors.gray,
                              width: 80,
                              height: 80,
                            ),
                          ),
                          ClipRRect(
                            borderRadius: BorderRadius.circular(28.0),
                            child: Container(
                              color: Colors.red,
                              width: 56,
                              height: 56,
                            ),
                          ),
                        ],
                      ),
                    ),
                    onTap: () async {
                      if (!_selectedPhoto) {
                        this._toastWithMessage(
                            "We'd expect you're gonna implement this functionality.");
                        return;
                      }
                      try {
                        // Ensure that the camera is initialized.
                        await _initializeControllerFuture;
                        // Attempt to take a picture and then get the location
                        // where the image file is saved.
                        final image = await _controller.takePicture();
                        print(image);
                        // If the picture was taken, display it on a new screen.
                        await Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => DisplayPictureScreen(
                              // Pass the automatically generated path to
                              // the DisplayPictureScreen widget.
                              imagePath: image.path,
                            ),
                          ),
                        );
                      } catch (e) {
                        // If an error occurs, log the error to the console.
                        print(e);
                      }
                    },
                  ),
                ),
                Flexible(
                  flex: 2,
                  fit: FlexFit.tight,
                  child: Container(
                    width: 70,
                    height: 70,
                    child: Icon(
                      Icons.schedule,
                      color: PublicColors.pureBlack,
                      size: 38,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _toastWithMessage(String message,
      {ToastGravity gravity = ToastGravity.CENTER}) {
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

// A widget that displays the picture taken by the user.
class DisplayPictureScreen extends StatelessWidget {
  final String imagePath;

  const DisplayPictureScreen({Key? key, required this.imagePath})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        middle: const Text('Display the Picture'),
      ),
      // The image is stored as a file on the device. Use the `Image.file`
      // constructor with the given path to display the image.
      child: Image.file(File(imagePath)),
    );
  }
}
