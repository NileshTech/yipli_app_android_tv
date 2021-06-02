
import 'a_widgets_index.dart';
class UserProfileTile extends StatelessWidget {
  final String _email;
  final String _contactNo;
  final String _location;

  UserProfileTile(this._email, this._contactNo, this._location);

  factory UserProfileTile.fromUserModel(UserModel userProfileElements) {
    UserProfileTile newUserProfileTile = UserProfileTile(
        userProfileElements?.email ?? '',
        userProfileElements?.contactNo ?? '',
        userProfileElements?.location ?? '');
    return newUserProfileTile;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: Column(
        children: <Widget>[
          SingleChildScrollView(
            child: Card(
              color: Theme.of(context).primaryColorLight.withOpacity(.1),
              child: Column(
                children: <Widget>[
                  ListTile(
                    dense: true,
                    leading: Icon(
                      FontAwesomeIcons.at,
                      color: IconTheme.of(context).color.withOpacity(0.7),
                      size: 18.0,
                    ),
                    title: Text(
                      _email,
                      style: Theme.of(context).textTheme.subtitle1,
                    ),
                  ),
                  ListTile(
                    dense: true,
                    leading: Icon(
                      FontAwesomeIcons.phoneAlt,
                      color: IconTheme.of(context).color.withOpacity(0.6),
                      size: 18.0,
                    ),
                    title: Text(
                      _contactNo,
                      style: Theme.of(context).textTheme.subtitle1,
                    ),
                  ),
                  ListTile(
                    dense: true,
                    //contentPadding: EdgeInsets.only(left: 20.0, right: 0.0),
                    leading: Icon(
                      FontAwesomeIcons.mapMarkerAlt,
                      color: IconTheme.of(context).color.withOpacity(0.6),
                      size: 18.0,
                    ),

                    title: Text(
                      _location,
                      style: Theme.of(context).textTheme.subtitle1,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
