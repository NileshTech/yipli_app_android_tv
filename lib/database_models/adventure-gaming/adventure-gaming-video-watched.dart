import 'package:flutter_app/pages/a_pages_index.dart';

import '../database_model_index.dart';
import 'database-interface.dart';

class AdventureGamingVideoWatchedValidator extends StatefulWidget {
  final AsyncWidgetBuilder<bool> builder;

  final PlayerModel playerModel;

  const AdventureGamingVideoWatchedValidator({
    Key key,
    @required this.builder,
    @required this.playerModel,
  }) : super(key: key);

  @override
  _AdventureGamingVideoWatchedValidatorState createState() =>
      _AdventureGamingVideoWatchedValidatorState();
}

class _AdventureGamingVideoWatchedValidatorState
    extends State<AdventureGamingVideoWatchedValidator> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<bool>(
        stream: Stream.value(true),
        //@TODO: Adventure Gaming Fix - Check video
        //        stream: PlayerProgressDatabaseHandler(playerModel: widget.playerModel)
        //    .getHasPlayerWatchedVideoStream(),

        builder: widget.builder);
  }
}
