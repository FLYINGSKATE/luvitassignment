import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:motion_tab_bar_v2/motion-tab-bar.dart';
import 'NavBar.dart';
import 'firebase_options.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Dark Mode Bottom Navigation',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: Colors.pink,
        brightness: Brightness.dark,
      ),
      home: MyBottomNavigation(),
    );
  }
}

class MyBottomNavigation extends StatefulWidget {
  @override
  _MyBottomNavigationState createState() => _MyBottomNavigationState();
}

class _MyBottomNavigationState extends State<MyBottomNavigation> {
  int _currentIndex = 0;


  final homeNavKey = GlobalKey<NavigatorState>();
  final searchNavKey = GlobalKey<NavigatorState>();
  final notificationNavKey = GlobalKey<NavigatorState>();
  final profileNavKey = GlobalKey<NavigatorState>();
  int selectedTab = 0;
  List<NavModel> items = [];

  @override
  void initState() {
    super.initState();
    items = [
      NavModel(
        page: const TabPage(tab: 1),
        navKey: homeNavKey,
      ),
      NavModel(
        page: const TabPage(tab: 2),
        navKey: searchNavKey,
      ),
      NavModel(
        page: const TabPage(tab: 3),
        navKey: notificationNavKey,
      ),
      NavModel(
        page: const TabPage(tab: 4),
        navKey: profileNavKey,
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        if (items[selectedTab].navKey.currentState?.canPop() ?? false) {
          items[selectedTab].navKey.currentState?.pop();
          return Future.value(false);
        } else {
          return Future.value(true);
        }
      },
      child: Scaffold(
        backgroundColor: Colors.black,
        appBar: AppBar(
          centerTitle: false,
          backgroundColor: Colors.black,
          leading: Row(
            children: [
              IconButton(
                icon: Image.asset("assets/locappbar.png"),
                onPressed: () {
                  // Add your location functionality here
                },
              ),
            ],
          ),
          titleSpacing: 0,
          title: Text(
            '목이길어슬픈기린님의 새로운 스팟',style: TextStyle(fontSize: 18),
          ),
          actions: [
            Container(
              margin: EdgeInsets.only(right: 12.0),
              child: Row(
                children: [
                  GestureDetector(
                    onTap: () {
                      // Add your action on the rounded container here
                    },
                    child: Container(
                      padding: EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.white24),
                        borderRadius: BorderRadius.circular(20.0),
                        color: Colors.black,
                      ),
                      child: Row(
                        children: [
                          Image.asset("assets/starfill.png"),
                          SizedBox(width: 4.0),
                          Text(
                            '323,233',
                            style: TextStyle(color: Colors.white),
                          ),
                          SizedBox(width: 4.0),
                        ],
                      ),
                    ),
                  ),
                  // Adjust spacing between rounded container and bell icon
                  IconButton(
                    icon: Image.asset("assets/bell.png"),
                    onPressed: () {
                      // Add your notification functionality here
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
        body: IndexedStack(
          index: selectedTab,
          children: items
              .map((page) => Navigator(
            key: page.navKey,
            onGenerateInitialRoutes: (navigator, initialRoute) {
              return [
                MaterialPageRoute(builder: (context) => page.page)
              ];
            },
          ))
              .toList(),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        floatingActionButton: Container(
          margin: const EdgeInsets.only(top: 10),
          height: 64,
          width: 64,
          child: FloatingActionButton(
            backgroundColor: Colors.black,
            elevation: 0,
            onPressed: () => debugPrint("Add Button pressed"),
            shape: RoundedRectangleBorder(
              side: const BorderSide(width: 0.5, color: Colors.grey),
              borderRadius: BorderRadius.circular(100),
            ),
            child: Image.asset("assets/center.png",scale: 0.1,),
          ),
        ),
        bottomNavigationBar: NavBar(
          pageIndex: selectedTab,
          onTap: (index) {
            if (index == selectedTab) {
              items[index]
                  .navKey
                  .currentState
                  ?.popUntil((route) => route.isFirst);
            } else {
              setState(() {
                selectedTab = index;
              });
            }
          },
        ),
      ),
    );
  }




  /*@override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        centerTitle: false,
        backgroundColor: Colors.black,
        leading: Row(
          children: [
            IconButton(
              icon: Image.asset("assets/locappbar.png"),
              onPressed: () {
                // Add your location functionality here
              },
            ),
          ],
        ),
        titleSpacing: 0,
        title: Text(
          '목이길어슬픈기린님의 새로운 스팟',style: TextStyle(fontSize: 18),
        ),
        actions: [
          Container(
            margin: EdgeInsets.only(right: 12.0),
            child: Row(
              children: [
                GestureDetector(
                  onTap: () {
                    // Add your action on the rounded container here
                  },
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.white24),
                      borderRadius: BorderRadius.circular(20.0),
                      color: Colors.black,
                    ),
                    child: Row(
                      children: [
                        Image.asset("assets/starfill.png"),
                        SizedBox(width: 4.0),
                        Text(
                          '323,233',
                          style: TextStyle(color: Colors.white),
                        ),
                        SizedBox(width: 4.0),
                      ],
                    ),
                  ),
                ),
                 // Adjust spacing between rounded container and bell icon
                IconButton(
                  icon: Icon(Icons.notifications),
                  onPressed: () {
                    // Add your notification functionality here
                  },
                ),
              ],
            ),
          ),
        ],
      ),
      body: _getBodyWidget(_currentIndex),
      bottomNavigationBar: MotionTabBar(
        tabBarColor: Colors.black,
        tabIconColor: Colors.grey,
        tabIconSelectedColor: Colors.pink,
        labels: ["홈", "스팟", "", "채팅", "마이"],
        icons: [Image.asset("assets/home.png"), Image.asset("assets/location.png"), Image.asset("assets/center.png"), Image.asset("assets/chats.png"), Image.asset("assets/profile.png")],
        initialSelectedTab: "홈",
        //tabAnimationCurve: Curves.easeInOut,
        // tabAnimationDuration: Duration(milliseconds: 600),
        onTabItemSelected: (int index) {
          setState(() {
            _currentIndex = index;
          });
        },
        textStyle: TextStyle(color: Colors.pink),
      ),

    );
  }*/

  Widget _getBodyWidget(int index) {
    switch (index) {
      case 0:
        return Center(child: Text('Home Page'));
      case 1:
        return Center(child: Text('Search Page'));
      case 2:
        return Center(child: MyScrollablePage());
      case 3:
        return Center(child: Text('Notifications Page'));
      case 4:
        return Center(child: Text('Profile Page'));
      default:
        return Container();
    }
  }

  Widget _buildCenterButton() {
    return FloatingActionButton(
      onPressed: () {
        // Add your action here for the center button
      },
      child: Icon(Icons.add),
      elevation: 5.0,
      backgroundColor: Colors.pink,
    );
  }
}


class MyScrollablePage extends StatefulWidget {
  @override
  _MyScrollablePageState createState() => _MyScrollablePageState();
}

class _MyScrollablePageState extends State<MyScrollablePage> {


  // List of User Profiles

  List<String> images = [
    'https://s3-alpha-sig.figma.com/img/5e20/5d73/086e98d6b549c3407b40a418953d499f?Expires=1715558400&Key-Pair-Id=APKAQ4GOSFWCVNEHN3O4&Signature=KexmnNvtzzbDu27mPckHo0yRCzf5GNc6kK8CpsAWnzJsYTvAb-aOeQgzoM~Vhpma70MEhZHC6SKNQJvTQhGFBkehfpnNFuEDCbcs862gx9xIVyqtqcuUVfjeaBF-wE17ObbOhjmGxPS1gFANV7MSHgRL1Y9Hm5d4CbLFC-hKanrG~XoF3lv4rCthLEZ-fJ-PklFOiR44LNeMPNoMUv1Addc3SHHseEAm8S-BNj4GE08hoeMo0JCB8aDuVitVM-a-ZAoxtgj39EWyzeOEt~Q8zrV8KWjKlYPO0d27uAVyoEvqZgLxZqyc3iAB6obh6wc6sPk-qsKKzphozdbcIkUE3A__',
    'https://s3-alpha-sig.figma.com/img/322c/b0c9/1a4b0445adcae15f1cf276d4de1eefa2?Expires=1715558400&Key-Pair-Id=APKAQ4GOSFWCVNEHN3O4&Signature=fS8aJOyQnLlzMxAA3jc9lDykvTlzq1cVSpKK-TKO7zcG6blEmKwp1wir4m0dNWnsWLhlndV1GNSR0gXbbrARDttDTD~kZoxDpH4h9sc-fUy4G--jYKD4rCFuGOZlJT4M-sGy2cEJ6DKbhgyFn7hfyGrfbAsbCOgMb7GkaUFep6ScrJJfOouQ1gt6dnttc5YaYoxcm~YVAZchrTbqFYkWXtDMoOKsfc2m3MY92YWEWsRnRayHGlgl0Cvb8mHuPVHavwq6yArnInV5Ez4Tfn-a6TjVSFmzybQX2WeWMQZuAWCHLrKiwFEjGu1JyuZG~8VOlF3twLj-HLvnb8FI3~49Uw__',
    'https://s3-alpha-sig.figma.com/img/4dd4/dcd9/79c8c50a1ffeaa63e0e8de84ce83a158?Expires=1715558400&Key-Pair-Id=APKAQ4GOSFWCVNEHN3O4&Signature=htMdm1gZDhp5Nn94vN5IMh49itkTxMcZCaak4dkpQx9W3eKNoFCnFhcQl37jHo~HmKWr37jW~lG6gwYxEDMQgsxyKtl-vrytTrVGGiWTXpeuq-j6R5hCCCcmQh9SYMvjmxaiJlKNTOGCXKs3QPtb3GDldSuV2T5shkPI5AGTBRy2pBpfmMEGsLEZnZcoqtv1OVITL1LtEhWcoj~mgNUAn4rnV-aWMxX7lagDuyhsTFslsUnQbTODDaRhUjNVB9G~2I0jQaa9nxONR4~LgEWPMmFpwEzA8MQVauU3DPpcuY5MBYzJ0JH-e4tIXSkx0cn5jSCpr9Z7reumYO48PrHBaA__',
  ];
  int currentImageIndex = 0;

  int makeVisible = 0;


  int _selectedIndex = -1;


  bool isFilled = false;

  Future<QuerySnapshot> fetchDataOnce() async {
    // Reference to the Firestore collection
    CollectionReference userDetailsCollection = FirebaseFirestore.instance.collection('Users');

    // Get all documents from the collection
    QuerySnapshot querySnapshot = await userDetailsCollection.get();

    //userDetailsCollection.add(querySnapshot.docs.first.data());

    return querySnapshot;
  }

  late Future<QuerySnapshot> myFutureUsersData;

  @override
  void initState() {
    // TODO: implement initState
    myFutureUsersData = fetchDataOnce();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body : FutureBuilder<QuerySnapshot>(
        future: myFutureUsersData,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator(
              color: Colors.pink,
            )); // Loading indicator while fetching data
          }

          if (snapshot.hasError) {
            print('Error: ${snapshot.error}');
            return Text('Error: ${snapshot.error}');
          }

          if (!snapshot.hasData) {
            return Text('No data available');
          }



          // Access the data from the snapshot
          List<DocumentSnapshot> users = snapshot.data!.docs;




          print(users.toList());

          // Display the fetched data
          return GestureDetector(
            onPanUpdate: (details) {
              if (details.delta.dx < 0) {
                // Swiped left

                //Increment the user



                /*setState(() {
                  currentImageIndex = (currentImageIndex + 1) % images.length;
                });*/
              }
            },
            child: Stack(
              children: [
                PageView.builder(
                  itemCount: users.length,
                  itemBuilder: (context, index) {

                    int imageIndex = 0;

                    return StatefulBuilder(
                        builder: (context,innerState) {
                          return GestureDetector(
                            onTapDown: (details) {
                              if (details.localPosition.dx < MediaQuery.of(context).size.width / 2) {
                                print("Tapped on the left side of text");

                                if(imageIndex>0){
                                  innerState(() {
                                    imageIndex--;
                                  });

                                }

                              } else {
                                print("Tapped on the right side of text");
                                if(imageIndex<users[index].get("imageUrls").length-1){
                                  innerState(() {
                                    imageIndex++;
                                  });
                                }
                              }
                            },
                            child: Container(
                              margin: EdgeInsets.all(20.0),
                              decoration: BoxDecoration(

                                borderRadius: BorderRadius.circular(20.0),
                                image: DecorationImage(
                                  image: NetworkImage(users[index].get("imageUrls")[imageIndex],),
                                  fit: BoxFit.cover,
                                ),
                              ),
                              child: Stack(
                                children: [
                                  Positioned.fill(
                                    child: IgnorePointer(
                                      ignoring: true,
                                      child: Container(

                                        decoration: BoxDecoration(
                                          border: Border.all(color: Colors.grey),
                                          borderRadius: BorderRadius.circular(20),
                                          gradient: LinearGradient(
                                            begin: Alignment.bottomCenter,
                                            end: Alignment.topCenter,
                                            colors: [
                                              Colors.black.withOpacity(0.8), // Black with opacity
                                              Colors.transparent, // Transparent
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),

                                  Align(
                                    alignment: Alignment.bottomLeft,
                                    child: GestureDetector(
                                      onTap: () {
                                        // users.first.data();
                                        setState(() {
                                          currentImageIndex =
                                              (currentImageIndex + 1) % images.length;
                                        });
                                      },
                                      child: SingleChildScrollView(
                                        child: Column(
                                          crossAxisAlignment:CrossAxisAlignment.start,
                                          children: [
                                            // Main content
                                            Container(
                                              margin:EdgeInsets.only(left:20,bottom: 10),
                                              padding: EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
                                              decoration: BoxDecoration(

                                                borderRadius: BorderRadius.circular(20.0),
                                                color: Colors.black,
                                              ),width: 100,
                                              child: Row(
                                                children: [
                                                  Image.asset("assets/star.png"),
                                                  SizedBox(width: 8.0),
                                                  Text(
                                                    '323,233',
                                                    style: TextStyle(color: Colors.white),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            Row(
                                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                                              children: [
                                                Column(
                                                  crossAxisAlignment:CrossAxisAlignment.start,
                                                  children: [
                                                    Row(
                                                      children: [
                                                        Text(users[index].get("name"),style: Theme.of(context).textTheme.headlineMedium,),
                                                        Text(" "+users[index].get("age"),style: Theme.of(context).textTheme.headlineMedium,),
                                                      ],
                                                    ),
                                                    Row(
                                                      children: [
                                                        Text(users[index].get("city")+" . "),
                                                        Text(users[index].get("distance")),
                                                      ],
                                                    ),
                                                  ],
                                                ),
                                                GestureDetector(
                                                  onTap: () {
                                                    setState(() {
                                                      isFilled = !isFilled;
                                                    });
                                                  },
                                                  child: Container(
                                                    width: 60,
                                                    height: 60,
                                                    decoration: BoxDecoration(
                                                      shape: BoxShape.circle,
                                                      border: Border.all(
                                                        color: isFilled ? Colors.transparent : Colors.red, // Border color
                                                        width: 2, // Border width
                                                      ),
                                                      color: isFilled ? Colors.red : Colors.transparent, // Fill color
                                                    ),
                                                    child: Center(
                                                      child: Icon(
                                                        Icons.favorite,
                                                        color: isFilled ? Colors.white : Colors.red, // Heart color
                                                        size: 25,
                                                      ),
                                                    ),
                                                  ),
                                                )
                                              ],
                                            ),
                                            // Hidden content
                                            AnimatedContainer(
                                              duration: Duration(milliseconds: 300),
                                              height: makeVisible==1 ? 200 : 0, // Set to 0 to hide initially
                                              child: Center(
                                                child: Padding(
                                                  padding: const EdgeInsets.all(20.0),
                                                  child: Text(
                                                    users[index].get("bio"),
                                                    style: TextStyle(fontSize: 20, color: Colors.white),
                                                  ),
                                                ),
                                              ),
                                            ),
                                            Visibility(
                                              visible: makeVisible==2,
                                              child: Padding(
                                                padding: const EdgeInsets.all(8.0),
                                                child: Wrap(
                                                  spacing: 8.0,
                                                  runSpacing: 8.0,
                                                  children: List.generate(
                                                    users[index].get("preferences").length, // Number of chips
                                                        (ink) => Chip(
                                                      label: Text(users[index].get("preferences")[ink]),
                                                          backgroundColor: null,
                                                      labelStyle: TextStyle(
                                                        color: ink == 0 ? Colors.pink : Colors.grey,
                                                      ),
                                                      shape: RoundedRectangleBorder(
                                                        borderRadius: BorderRadius.circular(100.0),
                                                        side: BorderSide(color: ink==0?Colors.pink:Colors.grey, width: 0.5),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                            // Expand button
                                            Center(
                                              child: GestureDetector(
                                                onTap: () {

                                                  if(makeVisible==2){
                                                    makeVisible=0;
                                                  }
                                                  else{
                                                    makeVisible++;
                                                  }

                                                  setState(() {

                                                  });
                                                },
                                                child: Container(
                                                  height: 50,

                                                  child: Icon(
                                                    makeVisible==0 ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down,
                                                    size: 20,
                                                    color: Colors.white,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                  Positioned(
                                    top: 14.0,
                                    left: 0,
                                    right: 0,
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: (users[index].get("imageUrls") as List<dynamic>).map((img) {
                                        int ind = users[index].get("imageUrls").indexOf(img);
                                        return Container(
                                          margin: EdgeInsets.symmetric(horizontal: 4.0),
                                          width: MediaQuery.of(context).size.width/(users[index].get("imageUrls").length*2),
                                          height: 4.0,
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(100),
                                            color: imageIndex == ind
                                                ? Colors.pink
                                                : Colors.grey,
                                          ),
                                        );
                                      }).toList(),
                                    ),
                                  ),

                                ],
                              ),
                            ),
                          );
                        }
                    );
                  },
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}


class TabPage extends StatelessWidget {
  final int tab;

  const TabPage({Key? key, required this.tab}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Tab $tab')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Tab $tab'),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => Page(tab: tab),
                  ),
                );
              },
              child: const Text('Go to page'),
            )
          ],
        ),
      ),
    );
  }
}

class Page extends StatelessWidget {
  final int tab;

  const Page({super.key, required this.tab});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Page Tab $tab')),
      body: Center(child: Text('Tab $tab')),
    );
  }
}