import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:zamongcampus/src/business_logic/utils/constants.dart';
import 'package:zamongcampus/src/business_logic/view_models/mypage_viewmodel.dart';
import 'package:zamongcampus/src/config/size_config.dart';
import 'package:zamongcampus/src/ui/views/mypage/mypage_edit_info/components/body.dart';

class EditImage extends StatefulWidget {
  MypageViewModel vm;
  EditImage({Key? key, required this.vm}) : super(key: key);

  @override
  _EditImageState createState() => _EditImageState();
}

class _EditImageState extends State<EditImage> {
  final ImagePicker _picker = ImagePicker();
  XFile? _pickedImg;

  @override
  Widget build(BuildContext context) {
    BodyState? body = context.findAncestorStateOfType<
        BodyState>(); //부모state 접근 가능. 여기서는 body의 pickedImgPath에 접근하기 위해 사용.
    return Padding(
      padding: EdgeInsets.symmetric(
          vertical: getProportionateScreenHeight(10),
          horizontal: getProportionateScreenWidth(20)),
      child: Stack(
        children: [
          CircleAvatar(
              radius: getProportionateScreenHeight(50),
              backgroundImage: (_pickedImg == null)
                  ? AssetImage(widget.vm.myInfo.imageUrl)
                  : AssetImage(_pickedImg!.path)),
          Positioned(
              bottom: 1,
              right: -1,
              child: InkWell(
                onTap: () async {
                  final XFile? image =
                      await _picker.pickImage(source: ImageSource.gallery);
                  if (image != null) {
                    setState(() {
                      _pickedImg = image;
                    });
                    body!.setState(() {
                      body.pickedImgPath = image.path;
                    });
                  }
                },
                child: Container(
                  width: getProportionateScreenWidth(30),
                  height: getProportionateScreenHeight(30),
                  decoration: BoxDecoration(
                    color: mainColor,
                    shape: BoxShape.circle,
                    border: Border.all(
                        color: Colors.white,
                        width: 3.0,
                        style: BorderStyle.solid),
                  ),
                  child: Icon(
                    Icons.add,
                    color: Colors.white,
                    size: getProportionateScreenHeight(15),
                  ),
                ),
              ))
        ],
      ),
    );
  }
}
