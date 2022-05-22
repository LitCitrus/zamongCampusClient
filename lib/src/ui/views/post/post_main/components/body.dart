import 'package:flutter/material.dart';
import 'package:zamongcampus/src/business_logic/view_models/post_main_screen_viewmodel.dart';
import 'package:zamongcampus/src/ui/common_widgets/center_sentence.dart';
import 'package:zamongcampus/src/ui/common_widgets/isLoading.dart';
import 'package:zamongcampus/src/ui/views/post/post_main/components/post_tab_btns.dart';
import 'post_list_tile.dart';

//예전 버전
class Body extends StatelessWidget {
  final PostMainScreenViewModel vm;
  const Body({Key? key, required this.vm}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: [
        SliverAppBar(
          title: const Text('피드',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.black,
              )),
          actions: [
            IconButton(
              onPressed: () {
                Navigator.pushNamed(context, '/postCreate');
              },
              icon: const Icon(Icons.edit_outlined),
              color: Colors.black,
            ),
            IconButton(
              onPressed: () => {},
              icon: const Icon(Icons.notifications_outlined),
              color: Colors.black,
            ),
          ],
          elevation: 0.0,
          backgroundColor: const Color(0xfff8f8f8),
          pinned: false,
          floating: true,
        ),
        SliverPersistentHeader(
          delegate: PostTabBtns(vm: vm),
          pinned: true,
        ),
        vm.busy
            ? SliverList(
                // Use a delegate to build items as they're scrolled on screen.
                delegate: SliverChildBuilderDelegate(
                  // The builder function returns a ListTile with a title that
                  // displays the index of the current item.
                  (context, index) => const IsLoading(),
                  // Builds 1000 ListTiles
                  childCount: 1,
                ),
              )
            : (vm.posts.isEmpty)
                ? SliverList(
                    // Use a delegate to build items as they're scrolled on screen.
                    delegate: SliverChildBuilderDelegate(
                      // The builder function returns a ListTile with a title that
                      // displays the index of the current item.
                      (context, index) => const CenterSentence(
                        sentence: "등록된 게시글이 없습니다.",
                        verticalSpace: 50,
                      ),
                      // Builds 1000 ListTiles
                      childCount: 1,
                    ),
                  )
                : SliverList(
                    delegate: SliverChildBuilderDelegate(
                        (context, index) => PostListTile(post: vm.posts[index]),
                        childCount: vm.posts.length),
                  )
      ],
    );
  }
}
