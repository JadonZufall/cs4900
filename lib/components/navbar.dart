import 'dart:developer';
import 'package:flutter/material.dart';


class NavbarComponent {
  static BottomAppBar construct() {

    BottomAppBar component = BottomAppBar(
      child: Row(
        children: [
          IconButton(
              icon: const Icon(Icons.home, size: 30),
              onPressed: () {}
          ),
          const Spacer(flex: 1),
          IconButton(
              icon: const Icon(Icons.search, size: 30),
              onPressed: () {}
          ),
          const Spacer(flex: 4),
          IconButton(
              icon: const Icon(Icons.notifications, size: 30),
              onPressed: () {}
          ),
          const Spacer(flex: 1),
          IconButton(
            icon: const Icon(Icons.person, size: 30),
            onPressed: () {},
          ),
        ],
      ),
    );

    return component;
  }
}

