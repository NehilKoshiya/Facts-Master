import 'dart:developer';
import 'dart:io';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:social_sharing_plus/social_sharing_plus.dart';

import '../../services/storage_service.dart';

class Constants {
  static const likedMessages = 'liked_messages';
  static const savedMessages = 'saved_messages';
  static const imagePath = 'imagePath';

  RxList<String> likedMessagesList = <String>[].obs;
  var imageList = [
    "https://firebasestorage.googleapis.com/v0/b/insta-saver-f4fda.appspot.com/o/FilrtImages%2Fa_akshar-dave-1GRvY9WUu08-unsplash.jpg?alt=media&token=ccec4411-1f86-4864-8bda-558dc66f8818",
    "https://firebasestorage.googleapis.com/v0/b/insta-saver-f4fda.appspot.com/o/FilrtImages%2Fa_chris-liu-raoGue01P-I-unsplash.jpg?alt=media&token=a597e992-0774-4136-aed4-4e6c1b609d1a",
    "https://firebasestorage.googleapis.com/v0/b/insta-saver-f4fda.appspot.com/o/FilrtImages%2Fa_el-salanzo-YuNl5xei5wA-unsplash.jpg?alt=media&token=faebe80b-74d7-405b-a72f-9ebdc7bc6052",
    "https://firebasestorage.googleapis.com/v0/b/insta-saver-f4fda.appspot.com/o/FilrtImages%2Fa_john-RzospqwES1o-unsplash.jpg?alt=media&token=b1b6ccd3-086d-4723-90ab-61ee8eda1130",
    "https://firebasestorage.googleapis.com/v0/b/insta-saver-f4fda.appspot.com/o/FilrtImages%2Fa_kelly-sikkema-4le7k9XVYjE-unsplash.jpg?alt=media&token=710c5b27-d1df-45f5-9e70-391ead8123e8",
    "https://firebasestorage.googleapis.com/v0/b/insta-saver-f4fda.appspot.com/o/FilrtImages%2Fa_kelly-sikkema-CynAjQl3ISk-unsplash.jpg?alt=media&token=d7d95425-9fc2-48da-90a7-739b51f653ea",
    "https://firebasestorage.googleapis.com/v0/b/insta-saver-f4fda.appspot.com/o/FilrtImages%2Fa_kelly-sikkema-mywUlDDkHiU-unsplash.jpg?alt=media&token=9734f712-2c2f-432c-a2db-56cb73b1c861",
    "https://firebasestorage.googleapis.com/v0/b/insta-saver-f4fda.appspot.com/o/FilrtImages%2Fa_leo_visions-hqUkno6qO9Q-unsplash.jpg?alt=media&token=940ba050-211f-4db1-b47d-a1aebf2f0885",
    "https://firebasestorage.googleapis.com/v0/b/insta-saver-f4fda.appspot.com/o/FilrtImages%2Fa_manuel-meurisse-EuCll-F5atI-unsplash.jpg?alt=media&token=30d941eb-f106-454c-9ad1-339ee89dcae5",
    "https://firebasestorage.googleapis.com/v0/b/insta-saver-f4fda.appspot.com/o/FilrtImages%2Fa_natalie-kinnear-dTSEIgv1Qtk-unsplash%20(1).jpg?alt=media&token=99c42a45-af6e-4202-90e1-885bb6fb221b",
    "https://firebasestorage.googleapis.com/v0/b/insta-saver-f4fda.appspot.com/o/FilrtImages%2Fa_pawel-czerwinski-IKZg31SuNqU-unsplash.jpg?alt=media&token=0069f7bb-fe86-4d06-a881-d5d23a7cec8f",
    "https://firebasestorage.googleapis.com/v0/b/insta-saver-f4fda.appspot.com/o/FilrtImages%2Fa_rishi-patel-2LsDVgkoLZs-unsplash.jpg?alt=media&token=fa4ba223-7734-4490-b17b-3a053bc5e769",
    "https://firebasestorage.googleapis.com/v0/b/insta-saver-f4fda.appspot.com/o/FilrtImages%2Fa_scott-broome-BcVvVvqiCGA-unsplash.jpg?alt=media&token=77b85b05-6f78-4a9d-855c-df00571e0a2d",
    "https://firebasestorage.googleapis.com/v0/b/insta-saver-f4fda.appspot.com/o/FilrtImages%2F360_F_1124870618_FeZt40kcU6xXMygrfhyQ6wiI9Gec6vNg.jpg?alt=media&token=147180fd-0b33-4646-b924-808687763b2b",
    "https://firebasestorage.googleapis.com/v0/b/insta-saver-f4fda.appspot.com/o/FilrtImages%2F360_F_584661359_CN18OI3yMmh8s154PUZYswxKzZjgLlFd.jpg?alt=media&token=1453f98a-b388-4ec9-9ee3-aa5933d4bd57",
    "https://firebasestorage.googleapis.com/v0/b/insta-saver-f4fda.appspot.com/o/FilrtImages%2Froses-2840743_1280.jpg?alt=media&token=7ccdcf5b-d8b7-4240-bf5d-0051b9afc184",
    "https://firebasestorage.googleapis.com/v0/b/insta-saver-f4fda.appspot.com/o/FilrtImages%2FHD-wallpaper-romantic-couple-sunset-scenic-landscape.jpg?alt=media&token=f35e98ee-4931-46e5-9338-8082d015f17d",
    "https://firebasestorage.googleapis.com/v0/b/insta-saver-f4fda.appspot.com/o/FilrtImages%2Falejandra-quiroz-F5hTTI4Hlv4-unsplash.jpg?alt=media&token=2ccabcdd-db0c-4449-8a13-793592fe8293",
    "https://firebasestorage.googleapis.com/v0/b/insta-saver-f4fda.appspot.com/o/FilrtImages%2Falexander-grey-J3m69BAg30s-unsplash.jpg?alt=media&token=7bc0e43c-66d7-474d-9d14-76369e7c5143",
    "https://firebasestorage.googleapis.com/v0/b/insta-saver-f4fda.appspot.com/o/FilrtImages%2Fallison-saeng-bqCJGbMmeTM-unsplash.jpg?alt=media&token=5133e3a3-40f6-46f0-88d7-a2e134513db1",
    "https://firebasestorage.googleapis.com/v0/b/insta-saver-f4fda.appspot.com/o/FilrtImages%2Fazrul-aziz-DsvY9NRykRg-unsplash.jpg?alt=media&token=8fbab9e2-8a2a-4b5e-9e1e-f61ae0df01c4",
    "https://firebasestorage.googleapis.com/v0/b/insta-saver-f4fda.appspot.com/o/FilrtImages%2Fcouple-embraces-tenderly-symbolizing-love-260nw-2566196413.webp?alt=media&token=dc08b7ae-8ff5-44e8-b476-f1457c66beb8",
    "https://firebasestorage.googleapis.com/v0/b/insta-saver-f4fda.appspot.com/o/FilrtImages%2Fdebby-hudson-jcc8sxK2Adw-unsplash.jpg?alt=media&token=106ac859-f064-47c2-9965-dc1648cac77d",
    "https://firebasestorage.googleapis.com/v0/b/insta-saver-f4fda.appspot.com/o/FilrtImages%2Ffreestocks-r_oV6smBBYk-unsplash.jpg?alt=media&token=3cdd63e7-76b3-4fd8-9b2d-5a5df656ebdf",
    "https://firebasestorage.googleapis.com/v0/b/insta-saver-f4fda.appspot.com/o/FilrtImages%2Fhenry-lai-Y4bTfD2Qrko-unsplash.jpg?alt=media&token=03b79b46-08a6-4b7b-bd9a-f9c102495248",
    "https://firebasestorage.googleapis.com/v0/b/insta-saver-f4fda.appspot.com/o/FilrtImages%2Fimages.jpeg?alt=media&token=c1acae12-b277-40cc-9d75-d5ac985bb763",
    "https://firebasestorage.googleapis.com/v0/b/insta-saver-f4fda.appspot.com/o/FilrtImages%2Fjoel-overbeck-fGPGd9PFd3w-unsplash.jpg?alt=media&token=f017f282-f179-45d3-b51e-fd4d02d64965",
    "https://firebasestorage.googleapis.com/v0/b/insta-saver-f4fda.appspot.com/o/FilrtImages%2Fistockphoto-615986180-612x612.jpg?alt=media&token=83c7028c-36f6-4bd4-bbe4-c348582a08c4",
    "https://firebasestorage.googleapis.com/v0/b/insta-saver-f4fda.appspot.com/o/FilrtImages%2Fkhamkeo-OcxlTBbb6SY-unsplash.jpg?alt=media&token=e1fd69f7-e125-45fd-ac5e-adca12f89acd",
    "https://firebasestorage.googleapis.com/v0/b/insta-saver-f4fda.appspot.com/o/FilrtImages%2Fkube-mad-masters-love-heart-romance-painting-aesthetic-7-mm-mdf-sparkal-lamination-full-hd-painting-digital-reprint-30-inch-x-48-inch-painting-wall-painting-for-living-room-bedroom-home-decor-hotel-office-with-frame-product-images-orv3sz8y.webp?alt=media&token=d5238d41-2aee-4b83-a25d-9e2be0f2130c",
    "https://firebasestorage.googleapis.com/v0/b/insta-saver-f4fda.appspot.com/o/FilrtImages%2Fwalls-io-0wEdUAEmphE-unsplash.jpg?alt=media&token=06057fd3-d909-4c6c-85f7-97de82345d14",
    "https://firebasestorage.googleapis.com/v0/b/insta-saver-f4fda.appspot.com/o/FilrtImages%2Fwooden-table-landscape-hearts-valentines-background-day-bokeh-love-red-empty-display-136718970.webp?alt=media&token=ddda78f2-e2d9-47aa-8214-6e0a77da6432",
    "https://firebasestorage.googleapis.com/v0/b/insta-saver-f4fda.appspot.com/o/FilrtImages%2Fpngtree-romantic-couple-kissing-at-candlelit-dinner-with-champagne-flutes-red-roses-image_20131683.webp?alt=media&token=72b5f857-16ab-4763-8846-bb64152860f3",
    "https://firebasestorage.googleapis.com/v0/b/insta-saver-f4fda.appspot.com/o/FilrtImages%2Fpao-dayag-IF9k1SPENe0-unsplash.jpg?alt=media&token=e6649131-cb96-47d4-9ac3-dd4242996b8a",
    "https://firebasestorage.googleapis.com/v0/b/insta-saver-f4fda.appspot.com/o/FilrtImages%2Fwalls-io-zXA_Lz_d_kg-unsplash.jpg?alt=media&token=a2a85018-0f93-442e-b152-e45b435ee201",
    "https://firebasestorage.googleapis.com/v0/b/insta-saver-f4fda.appspot.com/o/FilrtImages%2Fpexels-pixabay-36718.jpg?alt=media&token=f4a43d8c-7da0-4383-a782-70339c31fa53",
    "https://firebasestorage.googleapis.com/v0/b/insta-saver-f4fda.appspot.com/o/FilrtImages%2Fpexels-rosie-ann-115355-412295.jpg?alt=media&token=21bf939b-77cc-448b-ae36-893d5384999c",
    "https://firebasestorage.googleapis.com/v0/b/insta-saver-f4fda.appspot.com/o/FilrtImages%2Fpexels-pixabay-326612.jpg?alt=media&token=f21158d0-6b59-44ad-ab3a-3347b41654a8",
    "https://firebasestorage.googleapis.com/v0/b/insta-saver-f4fda.appspot.com/o/FilrtImages%2Fpexels-pixabay-269583.jpg?alt=media&token=531cd1bf-c963-4493-82c2-0553b4dc2d39",
    "https://firebasestorage.googleapis.com/v0/b/insta-saver-f4fda.appspot.com/o/FilrtImages%2Fpexels-jennifer-murray-402778-1067194.jpg?alt=media&token=33cd32cb-ed75-4a71-bda7-eeb41d8ebc06",
    "https://firebasestorage.googleapis.com/v0/b/insta-saver-f4fda.appspot.com/o/FilrtImages%2Fpexels-asadphoto-1024970.jpg?alt=media&token=0944eb93-0bc0-4123-9ef5-a52ff88fb179",
    "https://firebasestorage.googleapis.com/v0/b/insta-saver-f4fda.appspot.com/o/FilrtImages%2Fwooden-table-landscape-hearts-valentines-background-day-bokeh-love-red-empty-display-136718970.webp?alt=media&token=ddda78f2-e2d9-47aa-8214-6e0a77da6432",
    "https://firebasestorage.googleapis.com/v0/b/insta-saver-f4fda.appspot.com/o/FilrtImages%2Fannie-spratt-nGOF86liuBw-unsplash.jpg?alt=media&token=d61b7d55-4bf7-49c3-95d9-ad1fef3bc1ca",
    "https://firebasestorage.googleapis.com/v0/b/insta-saver-f4fda.appspot.com/o/FilrtImages%2Fartsy-vibes-EOV3X7r7ZFE-unsplash.jpg?alt=media&token=11b17967-ac73-4f09-8239-5a62e8a422ce",
    "https://firebasestorage.googleapis.com/v0/b/insta-saver-f4fda.appspot.com/o/FilrtImages%2Fnatalie-kinnear-PdfPghzF2Ug-unsplash.jpg?alt=media&token=01e01dab-20ca-4e58-9701-d130a043c38d",
  ];

  void toggleLike(String message) {
    List data = StorageService().read(Constants.likedMessages) ?? [];
    if (data.contains(message)) {
      data.remove(message);
    } else {
      data.add(message);
    }
    StorageService().write(Constants.likedMessages, data);
  }

  Future<String?> exportToImage(GlobalKey boundaryKey) async {
    try {
      final boundary = boundaryKey.currentContext?.findRenderObject();
      if (boundary == null || boundary is! RenderRepaintBoundary) return null;

      final image = await boundary.toImage(pixelRatio: 3.0);
      final byteData = await image.toByteData(format: ImageByteFormat.png);
      if (byteData == null) return null;
      final pngBytes = byteData.buffer.asUint8List();

      final tempDir = await getTemporaryDirectory();
      final file = File(
        '${tempDir.path}/pickup_${DateTime.now().millisecondsSinceEpoch}.png',
      );
      await file.writeAsBytes(pngBytes);
      return file.path;
    } catch (e) {
      debugPrint('Export error: $e');
      return null;
    }
  }

  Future<void> shareToWhatsApp(
    String message, {
    final GlobalKey? exportKey,
  }) async {
    try {
      // final path = await Constants().exportToImage(exportKey);
      // if (path == null) {
      //   Get.snackbar('Error', 'Unable to export image');
      //   return;
      // }
      await SocialSharingPlus.shareToSocialMedia(
        SocialPlatform.whatsapp,
        message,
        // media:path,
      );
    } catch (e) {
      print("WhatsApp Share Error: $e");
    }
  }

  Future<void> shareOther(String message) async {
    await SharePlus.instance.share(
      ShareParams(text: message, subject: 'Facts'),
    );
  }

  Future<void> copyMessage(String message) async {
    try {
      await Clipboard.setData(ClipboardData(text: message));
      // Optional: show a toast/snackbar
      log("Message copied to clipboard");
    } catch (e) {
      log("Copy Error: $e");
    }
  }

  Future<void> exportAndShare(
    String message, {
    BuildContext? context,
    final GlobalKey? exportKey,
  }) async {
    // final path = await Constants().exportToImage(exportKey!);
    // if (path == null) {
    //   Get.snackbar('Error', 'Unable to export image');
    //   return;
    // }
    await SharePlus.instance.share(
      // ShareParams(text: message, files: [XFile(path)]),
      ShareParams(text: message),
    );
  }

  void copyText(String text) {
    Clipboard.setData(ClipboardData(text: text));
    // Get.snackbar("Copied", "Message copied!");
  }
}
