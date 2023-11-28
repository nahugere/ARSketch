import 'dart:ui';
import 'package:arsketch/services/web_services.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/src/rendering/sliver_persistent_header.dart';
import 'package:arsketch/constants.dart';

import 'ar_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final webservice = WebService();

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      child: CustomScrollView(
        slivers: [
          CupertinoSliverNavigationBar(
            backgroundColor: CupertinoTheme.of(context)
                .scaffoldBackgroundColor
                .withOpacity(0.9),
            largeTitle: Text(
              "Home",
              style: TextStyle(color: Colors.white),
            ),
            trailing: GestureDetector(
                onTap: (() => print("hello")),
                child: Icon(
                  CupertinoIcons.paintbrush_fill,
                  color: Theme.of(context).primaryColor,
                  size: 26,
                )),
          ),
          SliverList(
            delegate: SliverChildBuilderDelegate(
              (context, index) {
                return Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 14),
                      child: CupertinoSearchTextField(),
                    ),
                    FutureBuilder(
                      future: webservice.getSketches(),
                      builder: (context, snapshot) {
                        // for (var snap in snapshot.data) {
                        //   print(snap);
                        // }
                        return Column(
                          children: [
                            for (var snap in snapshot.data)
                              GestureDetector(
                                onTap: () => Navigator.push(context,
                                    MaterialPageRoute(builder: (builder) {
                                  return ARPage(
                                    images: snap["images"],
                                  );
                                })),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Container(
                                      height: 200,
                                      margin: const EdgeInsets.only(
                                          top: 20, left: 20, right: 20),
                                      alignment: Alignment.center,
                                      decoration: BoxDecoration(
                                          image: DecorationImage(
                                              image: NetworkImage(
                                                  kHost + snap["thumbnail"]),
                                              fit: BoxFit.cover),
                                          color: const Color.fromARGB(
                                                  255, 34, 36, 59)
                                              .withOpacity(0.5),
                                          borderRadius: const BorderRadius.all(
                                              Radius.circular(10))),
                                    ),
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.only(
                                              left: 30.0, top: 10),
                                          child: Text(
                                            snap["name"],
                                            style: TextStyle(
                                              fontSize: 17,
                                              fontWeight: FontWeight.w700,
                                            ),
                                          ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.only(
                                              left: 30.0, top: 4),
                                          child: Text(
                                            snap["date"],
                                            style: TextStyle(
                                                fontSize: 13,
                                                color: Colors.white
                                                    .withOpacity(0.5)),
                                          ),
                                        ),
                                      ],
                                    )
                                  ],
                                ),
                              )
                          ],
                        );
                      },
                    ),
                    const Padding(padding: EdgeInsets.only(top: 100)),
                  ],
                );
              },
              childCount: 1,
            ),
          )
        ],
      ),
    );
  }
}

class HomePageHeader implements SliverPersistentHeaderDelegate {
  final double minExtent;
  final double maxExtent;
  HomePageHeader({required this.minExtent, required this.maxExtent});

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return Stack(
      children: [
        Positioned(
          child: ClipRRect(
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
              child: Container(
                height: 45,
                width: MediaQuery.of(context).size.width,
              ),
            ),
          ),
        )
      ],
    );
  }

  @override
  bool shouldRebuild(covariant SliverPersistentHeaderDelegate oldDelegate) {
    return true;
  }

  @override
  PersistentHeaderShowOnScreenConfiguration? get showOnScreenConfiguration =>
      throw UnimplementedError();

  @override
  FloatingHeaderSnapConfiguration? get snapConfiguration =>
      throw UnimplementedError();

  @override
  OverScrollHeaderStretchConfiguration? get stretchConfiguration =>
      throw UnimplementedError();

  @override
  TickerProvider? get vsync => throw UnimplementedError();
}
