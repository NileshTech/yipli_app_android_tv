import 'a_pages_index.dart';

class ViewImage extends StatefulWidget {
  static const String routeName = "/image_view_screen";
  @override
  _ViewImageState createState() => _ViewImageState();
}

class _ViewImageState extends State<ViewImage> {
  @override
  Widget build(BuildContext context) {
    String profilePic = ModalRoute.of(context).settings.arguments;
    return YipliPageFrame(
      title: Text('Profile Photo'),
      child: Stack(
        children: <Widget>[
          Center(
            child: Container(
                height: MediaQuery.of(context).size.height / 1.7,
                width: MediaQuery.of(context).size.width,
                child: PhotoView(
                  backgroundDecoration:
                      BoxDecoration(color: Theme.of(context).primaryColorLight),
                  imageProvider: profilePic != null
                      ? FirebaseImage(
                          "${FirebaseStorageUtil.profilepics}/$profilePic")
                      : AssetImage(
                          'assets/images/default_image_placeholder.jpg'),
                )),
          ),
        ],
      ),
    );
  }
}
