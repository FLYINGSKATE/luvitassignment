import 'dart:io';

import 'package:flutter/material.dart';

class NavBar extends StatelessWidget {
  final int pageIndex;
  final Function(int) onTap;

  const NavBar({
    super.key,
    required this.pageIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 120,
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
        color: Colors.black,
          borderRadius: BorderRadius.only(topLeft: Radius.circular(20),topRight: Radius.circular(20)),
          border: Border.all(color: Colors.grey,width: 0.5)
      ),
        //Image.asset("assets/home.png"), Image.asset("assets/location.png"), Image.asset("assets/center.png"), Image.asset("assets/chats.png"), Image.asset("assets/profile.png")


      child: Row(
        children: [
          navItem(
            Image.asset("assets/home.png"),
            "홈",
            pageIndex == 0,
            onTap: () => onTap(0),
          ),
          navItem(
            Image.asset("assets/location.png"),
            "스팟",
            pageIndex == 1,
            onTap: () => onTap(1),
          ),
          const SizedBox(width: 80),
          navItem(
            Image.asset("assets/chats.png"),
            "채팅",
            pageIndex == 2,
            onTap: () => onTap(2),
          ),
          navItem(
            Image.asset("assets/profile.png"),
            "마이",
            pageIndex == 3,
            onTap: () => onTap(3),
          ),
        ],
      ),
    );
  }

  Widget navItem(Widget icon,String label, bool selected, {Function()? onTap}) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Column(
          children: [
            SizedBox(height: 10,),
            icon,
            SizedBox(height: 10,),
            selected ?Text(label,style: TextStyle(color: Colors.pink),):Text(label,style: TextStyle(color: Colors.grey),)
          ],
        ),
      ),
    );
  }
}


class NavModel {
  final Widget page;
  final GlobalKey<NavigatorState> navKey;

  NavModel({required this.page, required this.navKey});
}