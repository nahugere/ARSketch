import 'dart:math' as math;
import 'package:arkit_plugin/arkit_plugin.dart';
import 'package:arsketch/constants.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:vector_math/vector_math_64.dart' as vector;

class ARPage extends StatefulWidget {
  final List<dynamic> images;

  const ARPage({super.key, required this.images});
  @override
  _ARPageState createState() => _ARPageState();
}

class _ARPageState extends State<ARPage> {
  late ARKitController arkitController;
  int step = 0;
  ARKitPlane? plane;
  ARKitNode? sketchNode;
  String? anchorId;
  ARKitPlaneAnchor? anchor;

  @override
  void dispose() {
    arkitController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        body: Stack(
          children: [
            // ARScene
            Positioned(
              child: Container(
                margin: EdgeInsets.only(
                    bottom: MediaQuery.of(context).size.height * 0.12),
                child: ARKitSceneView(
                  planeDetection: ARPlaneDetection.horizontal,
                  onARKitViewCreated: onARKitViewCreated,
                ),
              ),
            ),

            // ARNavOverlay
            const COverlay(),

            // ARNavs
            Positioned(
                top: MediaQuery.of(context).padding.top + 17,
                child: Container(
                  height: 95,
                  width: MediaQuery.of(context).size.width - 40,
                  margin: EdgeInsets.symmetric(horizontal: 20),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      GestureDetector(
                        child: const Icon(
                          CupertinoIcons.chevron_back,
                          size: 25,
                        ),
                        onTap: () => Navigator.of(context).pop(),
                      ),
                      Expanded(child: Container()),
                      Column(
                        children: [
                          GestureDetector(
                            child: const Icon(
                              CupertinoIcons.sun_min_fill,
                              size: 25,
                            ),
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          GestureDetector(
                            child: const Icon(
                              CupertinoIcons.info_circle,
                              size: 25,
                            ),
                          ),
                        ],
                      )
                    ],
                  ),
                )),

            // ProgressBar
            if (sketchNode != null)
              Positioned(
                  top: MediaQuery.of(context).size.height * 0.88,
                  child: Container(
                    width: MediaQuery.of(context).size.width,
                    height: 4,
                    alignment: Alignment.centerLeft,
                    color: Theme.of(context).primaryColor.withOpacity(0.37),
                    child: Container(
                      width: MediaQuery.of(context).size.width *
                          ((step + 1) / widget.images.length),
                      color: Theme.of(context).primaryColor,
                    ),
                  )),

            // ARControlls
            Positioned(
                bottom: 2,
                child: SafeArea(
                  bottom: true,
                  child: sketchNode == null
                      ? Container(
                          width: MediaQuery.of(context).size.width,
                          // height: MediaQuery.of(context).size.height * 0.12,
                          color: Theme.of(context).scaffoldBackgroundColor,
                          alignment: Alignment.center,
                          child: CustomButton(
                            fullWidth: true,
                            action: () {
                              addSketchNode();
                            },
                            icon: CupertinoIcons.play_arrow_solid,
                            text: "Start",
                            iconFirst: true,
                          ))
                      : Container(
                          width: MediaQuery.of(context).size.width - 34,
                          margin: EdgeInsets.symmetric(horizontal: 17),
                          child: Row(
                            children: [
                              CustomButton(
                                  fullWidth: false,
                                  icon: CupertinoIcons.back,
                                  text: "Previous",
                                  action: () {
                                    if (step != 0) {
                                      arkitController
                                          .remove("sketch ${step.toString()}");
                                      setState(() => step -= 1);
                                      addSketchNode();
                                    }
                                  },
                                  iconFirst: true),
                              Expanded(
                                  flex: 2,
                                  child: Text(
                                    "${(((step + 1) / widget.images.length) * 100).toInt()}%",
                                    textAlign: TextAlign.center,
                                  )),
                              CustomButton(
                                  fullWidth: false,
                                  icon: CupertinoIcons.forward,
                                  text: "Next",
                                  action: () {
                                    if (step < widget.images.length - 1) {
                                      arkitController
                                          .remove("sketch ${step.toString()}");
                                      setState(() => step += 1);
                                      addSketchNode();
                                    }
                                  },
                                  iconFirst: false),
                            ],
                          ),
                        ),
                )),
          ],
        ),
      );

  void addSketchNode() {
    final material = ARKitMaterial(
        transparency: 0.5,
        diffuse: ARKitMaterialImage("${kHost}${widget.images[step]}"));
    final plane = ARKitPlane(width: 0.2, height: 0.2, materials: [material]);
    final node = ARKitNode(
      name: "sketch ${step.toString()}",
      geometry: plane,
      position: vector.Vector3(0.0, -0.25, -0.2),
      rotation: vector.Vector4(1, 0, 0, -math.pi / 2),
    );
    this.arkitController.add(node);
    setState(() => sketchNode = node);
  }

  void addNode() {
    final material = ARKitMaterial(
      lightingModelName: ARKitLightingModel.physicallyBased,
      diffuse: ARKitMaterialProperty.color(
        Color((math.Random().nextDouble() * 0xFFFFFF).toInt() << 0)
            .withOpacity(1.0),
      ),
    );
    final box =
        ARKitBox(materials: [material], width: 0.1, height: 0.1, length: 0.1);
    var d;
    this.arkitController.getCameraEulerAngles().then((value) {
      setState(() {
        d = value;
      });
    });
    final node = ARKitNode(
      geometry: box,
      position: d,
    );
    arkitController.add(node);
  }

  void _handleAddAnchor(ARKitAnchor anchor) {
    if (!(anchor is ARKitPlaneAnchor)) {
      return;
    }
    if (this.anchor == null) {
      setState(() => this.anchor = anchor);
    }
  }

  void _handleUpdateAnchor(ARKitAnchor anchor) {
    if (!(anchor is ARKitPlaneAnchor)) {
      return;
    }
    // final anchorPosition = anchor.transform.getColumn(3);
    if (this.anchor == null) {
      setState(() => this.anchor = anchor);
    }
  }

  void onARKitViewCreated(ARKitController arkitController) {
    this.arkitController = arkitController;
    // var x = this.arkitController.getCameraEulerAngles();
    this.arkitController.addCoachingOverlay(CoachingOverlayGoal.anyPlane);
    this.arkitController.onAddNodeForAnchor = _handleAddAnchor;
    this.arkitController.onUpdateNodeForAnchor = _handleUpdateAnchor;
  }

  // void _handleAddAnchor(ARKitAnchor anchor) {
  //   if (!(anchor is ARKitPlaneAnchor)) {
  //     return;
  //   }
  //   _addPlane(arkitController, anchor);
  // }

  // void _handleUpdateAnchor(ARKitAnchor anchor) {
  //   if (anchor.identifier != anchorId || anchor is! ARKitPlaneAnchor) {
  //     return;
  //   }
  //   // node?.position = vector.Vector3(anchor.center.x, 0, anchor.center.z);
  //   // plane?.width.value = anchor.extent.x;
  //   // plane?.height.value = anchor.extent.z;
  // }

  // void _addPlane(ARKitController controller) {
  //   // anchorId = anchor.identifier;
  //   var plane2 = ARKitCylinder(
  //     radius: 20,
  //     height: 20.0,
  //     materials: [
  //       ARKitMaterial(
  //         // transparency: 0.5,
  //         diffuse: ARKitMaterialProperty.color(Colors.green),
  //       )
  //     ],
  //   );

  //   node = ARKitNode(
  //     geometry: plane2,
  //     position: vector.Vector3(0.0, 0.0, -1.0),
  //     rotation: vector.Vector4(0, 0, 0, 0),
  //   );
  //   arkitController.add(node!);
  // }
}

class COverlay extends StatelessWidget {
  const COverlay({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Positioned(
        top: 0,
        height: 85 + MediaQuery.of(context).padding.top,
        child: Container(
          width: MediaQuery.of(context).size.width,
          decoration: BoxDecoration(
              gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                Colors.black.withOpacity(0.5),
                Colors.black.withOpacity(0.0)
              ])),
        ));
  }
}
