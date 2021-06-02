
import 'package:flutter_app/pages/a_pages_index.dart';
import 'a_widgets_index.dart';
class PlayerProfileTile extends StatelessWidget {
  final String _fullName;
  final String _gender;
  final String _dob;
  final String _height;
  final String _weight;

  PlayerProfileTile(
      this._fullName, this._gender, this._dob, this._height, this._weight);

  factory PlayerProfileTile.fromPlayerModel(PlayerModel playerModelElements) {
    PlayerProfileTile playerProfileTile = PlayerProfileTile(
      playerModelElements?.name ?? '',
      playerModelElements?.gender ?? '',
      playerModelElements?.dob ?? '',
      playerModelElements?.height ?? '',
      playerModelElements?.weight ?? '',
    );

    return playerProfileTile;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        decoration: BoxDecoration(
          color: yiplidarkblue.withOpacity(0.95),
          border: Border.all(
            color: yiplilightOrange,
            width: 2.0,
          ),
          borderRadius: BorderRadius.circular(40.0),
        ),
        padding: EdgeInsets.fromLTRB(5, 0, 5, 0),
        //height: screenSize.height / 2,
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                ListTile(
                  dense: true,
                  contentPadding: EdgeInsets.only(
                    left: 20.0,
                    right: 20.0,
                  ),
                  leading: Icon(
                    Icons.account_circle,
                    color: yipliWhite,
                    size: 35.0,
                  ),
                  title: Text(
                    'Name',
                    style: Theme.of(context).textTheme.bodyText2,
                  ),
                  subtitle: Text(
                    _fullName,
                    style: Theme.of(context).textTheme.bodyText2,
                  ),
                ),
                ListTile(
                  dense: true,
                  contentPadding: EdgeInsets.only(left: 20.0, right: 0.0),
                  leading: Icon(
                    Icons.wc,
                    color: yipliWhite,
                    size: 35.0,
                  ),
                  title: Text(
                    'Gender',
                    style: Theme.of(context).textTheme.bodyText2,
                  ),
                  subtitle: Text(
                    _gender,
                    style: Theme.of(context).textTheme.subtitle1,
                  ),
                ),
                ListTile(
                  dense: true,
                  contentPadding: EdgeInsets.only(left: 20.0, right: 0.0),
                  leading: Icon(
                    Icons.assignment_ind,
                    color: yipliWhite,
                    size: 35.0,
                  ),
                  title: Text(
                    'Date of Birth',
                    style: Theme.of(context).textTheme.bodyText2,
                  ),
                  subtitle: Text(
                    _dob,
                    style: Theme.of(context).textTheme.subtitle1,
                  ),
                ),
                ListTile(
                  dense: true,
                  contentPadding: EdgeInsets.only(left: 20.0, right: 0.0),
                  leading: Icon(
                    Icons.call_to_action,
                    color: yipliWhite,
                    size: 35.0,
                  ),
                  title: Text(
                    'Weight (kg)',
                    style: Theme.of(context).textTheme.bodyText2,
                  ),
                  subtitle: Text(
                    _weight,
                    style: Theme.of(context).textTheme.subtitle1,
                  ),
                ),
                ListTile(
                  dense: true,
                  contentPadding: EdgeInsets.only(left: 20.0, right: 0.0),
                  leading: Icon(
                    Icons.equalizer,
                    color: yipliWhite,
                    size: 35.0,
                  ),
                  title: Text(
                    'Height (cms)',
                    style: Theme.of(context).textTheme.bodyText2,
                  ),
                  subtitle: Text(
                    _height,
                    style: Theme.of(context).textTheme.subtitle1,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
