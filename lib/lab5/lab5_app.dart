import 'package:flutter/material.dart';
import 'package:labprm393/lab5/Pages/Aboutpage.dart';
import 'package:labprm393/lab5/Pages/Homepage.dart';
import 'package:labprm393/lab5/Pages/Productdetail.dart';

// Day la root app cho Lab 5.
// Nhiem vu chinh:
// 1. Khoi tao MaterialApp.
// 2. Dang ky named routes de Navigator.pushNamed co the dieu huong.
// 3. Chon trang mac dinh la HomePage.
class Lab5App extends StatelessWidget {
  const Lab5App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'PRM392 Lab 5',
      // Theme duoc dung chung cho toan bo app de giao dien dong nhat.
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.orange),
        scaffoldBackgroundColor: const Color(0xFFFFFBF5),
        useMaterial3: true,
      ),
      // Khi app mo len, route '/' se duoc goi truoc.
      initialRoute: HomePage.routeName,
      routes: {
        // Bang route trung tam cho cac trang cua bai lab.
        HomePage.routeName: (context) => const HomePage(),
        AboutPage.routeName: (context) => const AboutPage(),
        ProductDetailPage.routeName: (context) => const ProductDetailPage(),
      },
    );
  }
}
