import 'dart:ffi';

import 'package:arsketch/constants.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:camera/camera.dart';

class CreatePage extends StatefulWidget {
  const CreatePage({super.key});

  @override
  State<CreatePage> createState() => _CreatePageState();
}

class _CreatePageState extends State<CreatePage> {
  late List<CameraDescription> cameras;
  CameraController? cameraController;
  List<XFile>? files = [];

  @override
  void initState() {
    startCamera();
    super.initState();
  }

  void startCamera() async {
    cameras = await availableCameras();
    cameraController = CameraController(cameras[0], ResolutionPreset.ultraHigh,
        enableAudio: false);

    await cameraController!.initialize().then((value) {
      cameraController!.setFlashMode(FlashMode.off);
      if (!mounted) {
        return;
      }
      setState(() {});
    }).catchError((e) {
      debugPrint(e.toString());
    });
  }

  @override
  void dispose() {
    cameraController!.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      backgroundColor: Colors.black,
      child: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: Stack(
          children: [
            Positioned(
                child: Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height -
                  (75 + MediaQuery.of(context).padding.bottom),
              child: cameraController!.value.isInitialized
                  ? CameraPreview(cameraController!)
                  : const Center(
                      child: Text("Loading..."),
                    ),
            )),

            Positioned(
                child: Container(
              height: 100,
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                  gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                    Colors.black.withOpacity(0.7),
                    Colors.black.withOpacity(0)
                  ])),
            )),

            Positioned(
              top: 10,
              left: 15,
              child: SafeArea(
                child: GestureDetector(
                  onTap: (() => Navigator.pop(context)),
                  child: const Icon(
                    CupertinoIcons.xmark,
                    color: Colors.white,
                  ),
                ),
              ),
            ),

            // Controlls
            Positioned(
                bottom: 0,
                left: 0,
                child: Column(
                  children: [
                    if (files!.length != 0)
                      Container(
                        width: MediaQuery.of(context).size.width,
                        color: Colors.black,
                        alignment: Alignment.center,
                        height: 55,
                        padding: EdgeInsets.only(top: 10),
                        child: Row(
                          // scrollDirection: Axis.horizontal,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            for (var file in files!)
                              Container(
                                margin: EdgeInsets.only(left: 5, right: 5),
                                width: 37,
                                height: 40,
                                decoration: BoxDecoration(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(5)),
                                    color: CupertinoTheme.of(context)
                                        .scaffoldBackgroundColor,
                                    image: DecorationImage(
                                        image: AssetImage(file.path),
                                        fit: BoxFit.cover)),
                              ),
                          ],
                        ),
                      ),
                    Container(
                      padding: EdgeInsets.only(top: 10),
                      width: MediaQuery.of(context).size.width,
                      color: Colors.black,
                      child: Container(
                          width: MediaQuery.of(context).size.width - 100,
                          height: 60 + MediaQuery.of(context).padding.bottom,
                          alignment: Alignment.topCenter,
                          margin:
                              EdgeInsets.only(bottom: 50, left: 50, right: 50),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              // Expanded(
                              //   flex: 1,
                              //   child: Container(),
                              // ),
                              Expanded(
                                child: GestureDetector(
                                  onTap: () {
                                    print(files);
                                  },
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      const Icon(
                                        CupertinoIcons
                                            .person_2_square_stack_fill,
                                        color: Colors.white,
                                      ),
                                      const Padding(
                                          padding: EdgeInsets.only(top: 5)),
                                      Text(
                                        "Upload",
                                        style: CupertinoTheme.of(context)
                                            .textTheme
                                            .tabLabelTextStyle
                                            .copyWith(color: Colors.white),
                                      )
                                    ],
                                  ),
                                ),
                              ),
                              Expanded(
                                child: GestureDetector(
                                  onTap: () {
                                    cameraController!
                                        .takePicture()
                                        .then((XFile? file) {
                                      if (mounted) {
                                        if (file != null) {
                                          setState(() {
                                            files!.add(file);
                                          });
                                          print(
                                              "Saved to ${file.path}; with name ${file.name}");
                                        }
                                      }
                                    });
                                  },
                                  child: Container(
                                    padding: EdgeInsets.all(3),
                                    width: 100,
                                    height: 100,
                                    decoration: BoxDecoration(
                                        border: Border.all(
                                            color: CupertinoTheme.of(context)
                                                .primaryContrastingColor,
                                            width: 8),
                                        shape: BoxShape.circle),
                                    child: Container(
                                      width: MediaQuery.of(context).size.width,
                                      height:
                                          MediaQuery.of(context).size.height,
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: CupertinoTheme.of(context)
                                            .primaryColor,
                                      ),
                                      // child: files!.length != 0
                                      //     ? Icon(
                                      //         CupertinoIcons.add,
                                      //         color: Colors.black,
                                      //         size: 38,
                                      //       )
                                      //     : Container(),
                                    ),
                                  ),
                                ),
                              ),
                              Expanded(
                                child: GestureDetector(
                                  child: Container(
                                    alignment: Alignment.center,
                                    decoration: BoxDecoration(
                                        color: CupertinoTheme.of(context)
                                            .scaffoldBackgroundColor,
                                        shape: BoxShape.circle),
                                    width: 40,
                                    height: 40,
                                    padding: EdgeInsets.only(left: 2),
                                    child: Text(
                                      String.fromCharCode(CupertinoIcons
                                          .chevron_right.codePoint),
                                      style: TextStyle(
                                        inherit: false,
                                        color: Colors.white,
                                        fontSize: 22.0,
                                        fontWeight: FontWeight.w900,
                                        fontFamily: CupertinoIcons
                                            .chevron_right.fontFamily,
                                        package: CupertinoIcons
                                            .chevron_right.fontPackage,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              // Expanded(
                              //   flex: 1,
                              //   child: files!.length != 0
                              //       ? GestureDetector(
                              //           child: Container(
                              //             padding: EdgeInsets.only(right: 8),
                              //             child: Icon(
                              //               CupertinoIcons.delete_left_fill,
                              //               size: 25,
                              //               color: Colors.white,
                              //             ),
                              //           ),
                              //         )
                              //       : Container(),
                              // ),
                            ],
                          )),
                    ),
                  ],
                )),
          ],
        ),
      ),
    );
  }
}
