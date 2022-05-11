import 'dart:io';
import 'package:flutter/material.dart';

// 상수

// 컬러
const kPrimaryColor = Color(0xFFFF8655);
const kSecondaryColor = Color(0xFFFE6D8E);
const kTextColor = Color(0xFF3F4168);
const kIconColor = Color(0xFF5E5E5E);
const kTextLightColor = Color(0xFF9A9BB2);
const kFillStarColor = Color(0xFFFCC419);
const kBackgroundColor = Color(0xFFFFF9F7); // 옅은 회색

// 기본 padding 값
const kDefaultPadding = 20.0;

// 새로운 컬러
const mainColor = Color(0xFFFF6F5E);
const subColor = Color(0xFFFFC45E);
const containerBackColor = Color(0xFFF7F4F4);
const normaltextColor = Color(0xFF363636);

// shadow => custom_bottom_navbar에서 쓰던데 무슨 용도일까나?
final kDefualtShadow = BoxShadow(
  offset: const Offset(5, 5),
  blurRadius: 10,
  color: const Color(0xFFE9E9E9).withOpacity(0.56),
);

const kDefaultShadow = BoxShadow(
  offset: Offset(0, 4),
  blurRadius: 4,
  color: Colors.black26,
);

// server
// final devServer = Platform.isAndroid
//     ? "https://febf-211-198-109-254.ngrok.io"
//     : "https://a0fa-175-223-33-165.ngrok.io";
final devServer =
    Platform.isAndroid ? "http://10.0.2.2:8080" : "http://localhost:8080";

const dankookEmail = "@dankook.ac.kr";

const appId = "1db42f592687465e9ad1564ae4b55221";
const channelId = "0511zamong";
var token =
    "0061db42f592687465e9ad1564ae4b55221IADrBc3Y2gVRycBcytvaTJDcoVDwF5fITr/MEp1QpZxpUZ3zKAQAAAAAEAD9FOMnk+Z7YgEAAQCT5nti";
