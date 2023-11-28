import 'dart:ui';
import 'package:arsketch/widgets/nav_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'constants.dart';
import 'package:arsketch/pages/pages.dart';
import 'package:flutter/services.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        brightness: Brightness.dark,
        primaryColor: Color(0xFFAE37AE),
        // primaryContrastingColor: Color(0xFF5F257E),
        scaffoldBackgroundColor: Color(0xFF131421),
        // barBackgroundColor: Color(0xFF20213F)),
      ),
      home: Scaffold(body: MainPage()),
    );
  }
}

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int _curPage = 0;
  // final CupertinoTabController _controller =
  //     CupertinoTabController(initialIndex: 0);
  final List<Widget> _pages = [
    const HomePage(),
    const CreatePage(),
    const ProfilePage()
  ];

  // @override
  // void initState() {
  //   super.initState();
  //   _controller.addListener(() {
  //     setState(() => _curPage = _controller.index);
  //   });
  // }

  // @override
  // void dispose() {
  //   super.dispose();
  //   _controller.dispose();
  // }

  @override
  Widget build(BuildContext context) {
    final double quarter = (MediaQuery.of(context).size.width / 3);
    return HomePage();
    /*Stack(
      children: [
        _pages[_curPage],

        // Bottom Bar
        Positioned(
          bottom: 0,
          left: 0,
          child: Hero(
            tag: 'bnavb0001',
            child: ClipRRect(
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 30, sigmaY: 30),
                child: Container(
                  color: CupertinoTheme.of(context)
                      .scaffoldBackgroundColor
                      .withOpacity(0.9),
                  child: SafeArea(
                    bottom: true,
                    top: false,
                    child: Container(
                      alignment: Alignment.topCenter,
                      padding: const EdgeInsets.only(top: 7),
                      width: MediaQuery.of(context).size.width,
                      height: 25 + MediaQuery.of(context).padding.bottom,
                      child: Row(
                        children: [
                          Expanded(
                            child: GestureDetector(
                              onTap: () {
                                setState(() {
                                  _curPage = 0;
                                });
                              },
                              child: Icon(
                                CupertinoIcons.house_fill,
                                size: 30,
                                color: _curPage == 0
                                    ? Theme.of(context).primaryColor
                                    : Color(0xFF999999),
                              ),
                            ),
                          ),
                          Expanded(
                            child: GestureDetector(
                              onTap: () {
                                Navigator.push(context, _createRoute());
                              },
                              child: const Image(
                                image: AssetImage('assets/icons/plus_icon.png'),
                                width: 50,
                                height: 39,
                              ),
                            ),
                          ),
                          Expanded(
                            child: GestureDetector(
                              onTap: () {
                                setState(() {
                                  _curPage = 2;
                                });
                              },
                              child: Icon(
                                CupertinoIcons.person_alt_circle,
                                size: 30,
                                color: _curPage == 2
                                    ? Theme.of(context).primaryColor
                                    : Color(0xFF999999),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),

        AnimatedPositioned(
            curve: Curves.easeOutBack,
            bottom: 5 + MediaQuery.of(context).padding.bottom,
            left: (quarter / 2.1) + _curPage * quarter,
            duration: Duration(milliseconds: 250),
            child: Container(
              width: 7,
              height: 7,
              decoration: BoxDecoration(
                  color: Theme.of(context).primaryColor,
                  borderRadius: const BorderRadius.all(Radius.circular(20))),
            ))
      ],
    );*/
  }

  Route _createRoute() {
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) =>
          const CreatePage(),
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        const begin = Offset(0.0, 1.0);
        const end = Offset.zero;
        const curve = Curves.ease;

        var tween =
            Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

        return SlideTransition(
          position: animation.drive(tween),
          child: child,
        );
      },
    );
  }

  // @override
  // Widget build(BuildContext context) {
  //   return CupertinoTabScaffold(
  //       controller: _controller,
  //       tabBar: CupertinoTabBar(activeColor: kTheme.primaryColor, items: [
  //         BottomNavigationBarItem(
  //             icon: const Icon(
  //               CupertinoIcons.house_fill,
  //             ),
  //             label: _curPage == 0 ? "●" : ""),
  //         const BottomNavigationBarItem(
  //             icon: Icon(
  //           CupertinoIcons.plus_app,
  //         )),
  //         BottomNavigationBarItem(
  //             icon: const Icon(
  //               CupertinoIcons.person_crop_circle,
  //             ),
  //             label: _curPage == 2 ? "●" : ""),
  //       ]),
  //       tabBuilder: (content, index) {
  //         if (index == 1) {
  //           return const CupertinoPageScaffold(
  //               child: Center(
  //             child: Text("ge"),
  //           ));
  //           // Navigator.of(context, rootNavigator: false).pushReplacement(
  //           //     MaterialPageRoute(builder: (context) => new CreatePage()));
  //         }
  //         return CupertinoTabView(
  //           builder: (context) {
  //             return _pages[index];
  //           },
  //         );
  //       });
  // }
}
