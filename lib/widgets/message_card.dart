import 'dart:math' hide log;

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:like_button/like_button.dart';

import '../core/constants/constants.dart';
import '../generated/assets.dart';
import '../services/storage_service.dart';
import 'app_text.dart';

class MessageCardWidget extends StatelessWidget {
  final String text;
  final GlobalKey exportKey;

  const MessageCardWidget({
    super.key,
    required this.text,
    required this.exportKey,
  });

  @override
  Widget build(BuildContext context) {
    final randomImage =
        Constants().imageList[Random().nextInt(Constants().imageList.length)];
    List data = StorageService().read(Constants.likedMessages) ?? [];
    RxBool isLiked = data.contains(text).obs;
    return Container(
      margin: const EdgeInsets.only(bottom: 22),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(22),
        color: Theme.of(context).cardColor,
        boxShadow: [
          BoxShadow(
            color: Colors.black26,
            blurRadius: 12,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          // IMAGE + TEXT
          RepaintBoundary(
            key: exportKey,
            child: ClipRRect(
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(22),
              ),
              child: Stack(
                children: [
                  // Image
                  ClipRRect(
                    borderRadius: BorderRadius.circular(22),
                    child: CachedNetworkImage(
                      imageUrl: randomImage,
                      height: 260,
                      width: double.infinity,
                      fit: BoxFit.cover,
                    ),
                  ),

                  // Shadow Layer
                  Positioned.fill(
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.black54,
                        borderRadius: BorderRadius.circular(22),
                      ),
                    ),
                  ),

                  // TEXT LAYER
                  Positioned.fill(
                    child: Padding(
                      padding: const EdgeInsets.all(18),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            "“",
                            style: TextStyle(fontSize: 50, color: Colors.white),
                          ),
                          Expanded(
                            child: Align(
                              alignment: Alignment.centerLeft,
                              child: AppText(
                                text,
                                fontSize: 20,
                                color: Colors.white,
                                height: 1.3,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          const Align(
                            alignment: Alignment.bottomRight,
                            child: Text(
                              "”",
                              style: TextStyle(
                                fontSize: 50,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 10),

          Obx(
            () => Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                LikeButton(
                  size: 41,
                  isLiked: isLiked.value,
                  padding: EdgeInsets.zero,
                  onTap: (isLiked) async {
                    Constants().toggleLike(text);
                    // isLiked.value = data.contains(text);
                    return !isLiked;
                  },
                  likeBuilder: (bool isLiked) {
                    return Column(
                      children: [
                        Icon(
                          isLiked ? Icons.favorite : Icons.favorite_border,
                          color: isLiked ? Colors.red : Colors.grey,
                        ),
                        AppText("Like",fontSize: 12,),
                      ],
                    );
                  },
                  circleColor: CircleColor(
                    start: Color(0xff00ddff),
                    end: Color(0xff0099cc),
                  ),
                  bubblesColor: BubblesColor(
                    dotPrimaryColor: Color(0xff33b5e5),
                    dotSecondaryColor: Color(0xff0099cc),
                  ),
                ),
                // _iconButton(
                //   isLiked.value ? Icons.favorite : Icons.favorite_border,
                //   "Like",
                //   onTap: () {
                //     Constants().toggleLike(text);
                //     isLiked.value = data.contains(text);
                //   },
                //   color: isLiked.value ? Colors.red : Colors.grey,
                // ),
                _iconButton(
                  Icons.copy,
                  "Copy",
                  onTap: () {
                    Constants().copyText(text);
                  },
                ),
                _iconButton(
                  Icons.share,
                  widget: Image.asset(Assets.imagesWhatsapp, height: 23),
                  "Share",
                  onTap: () async {
                    Constants().shareToWhatsApp(text,exportKey:  exportKey);
                  },
                ),
                _iconButton(
                  Icons.share,
                  "Share",
                  onTap: () {
                    Constants().exportAndShare(text, context: context,exportKey:  exportKey);
                  },
                ),
              ],
            ),
          ),

          const SizedBox(height: 10),
        ],
      ),
    );
  }

  Widget _iconButton(
    IconData icon,
    String label, {
    Color color = Colors.grey,
    required VoidCallback onTap,
    Widget? widget,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          widget ?? Icon(icon, color: color),
          AppText(label, fontSize: 12,),
        ],
      ),
    );
  }
}
