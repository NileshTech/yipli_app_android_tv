import 'a_widgets_index.dart';

class MatListItem extends StatefulWidget {
  MatListItem({
    this.matName,
    this.matMacAddress,
    this.isSelected,
    this.matId,
  }) : super();
  final String matId;
  final String matName;
  final String matMacAddress;
  final bool isSelected;

  @override
  _MatListItemState createState() => _MatListItemState();
}

class _MatListItemState extends State<MatListItem>
    with TickerProviderStateMixin {
  bool isOpen = true;

  @override
  Widget build(BuildContext context) {
    final Size _screenSize = MediaQuery.of(context).size;
    return Column(
      children: <Widget>[
        GestureDetector(
          onTap: () => setState(() {
            isOpen = !isOpen;
          }),
          child: Consumer<UserModel>(builder: (context, user, child) {
            return Stack(
              children: <Widget>[
                Container(
                  padding: EdgeInsets.all(6.0),
                  width: _screenSize.width,
                  height: ((MediaQuery.of(context).size.height - 112) / 7),
                  decoration: new BoxDecoration(
                    color: widget.isSelected
                        ? Theme.of(context).accentColor
                        : Theme.of(context).primaryColor,
                    border: (widget.matId == user.currentMatId)
                        ? Border.all(
                            width: 2, color: Theme.of(context).accentColor)
                        : null,
                    borderRadius: new BorderRadius.all(Radius.circular(10.0)),
                  ),
                  child: Row(
                    children: <Widget>[
                      Expanded(
                        flex: 1,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8.0),
                          child: Image.asset(
                            YipliConstants.matIconFile,
                            fit: BoxFit.contain,
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 5,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Expanded(
                              flex: 1,
                              child: Padding(
                                  padding: const EdgeInsets.all(2.0),
                                  child: Text(
                                    widget.matName == null
                                        ? ""
                                        : widget.matName,
                                    style: Theme.of(context)
                                        .textTheme
                                        .headline6
                                        .copyWith(
                                          fontWeight: FontWeight.bold,
                                          color: widget.isSelected
                                              ? Theme.of(context)
                                                  .primaryColorLight
                                              : Theme.of(context).accentColor,
                                        ),
                                  )),
                            ),
                            Expanded(
                              flex: 1,
                              child: Padding(
                                padding: const EdgeInsets.all(6.0),
                                child: Text(
                                  widget.matMacAddress == null
                                      ? ""
                                      : widget.matMacAddress,
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyText2
                                      .copyWith(
                                          color: widget.isSelected
                                              ? yipliGray
                                              : yipliGray),
                                  //TODO - @Ameet-Roopa  - Make changes in the color above, this is grey, needs to be from a theme color.
                                ),
                              ),
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
                Container(
                  child: widget.matId == user.currentMatId
                      ? Stack(
                          children: [
                            Container(
                              height: _screenSize.height / 8,
                              width: _screenSize.width,
                              decoration: BoxDecoration(
                                borderRadius:
                                    new BorderRadius.all(Radius.circular(10.0)),
                                color: yipliWhite.withOpacity(0.1),
                              ),
                            ),
                            Positioned(
                              top: 10,
                              right: 20,
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: [
                                  Icon(
                                    Icons.trip_origin,
                                    color: yipliLogoOrange,
                                    size: _screenSize.width / 30,
                                  ),
                                  SizedBox(
                                    width: _screenSize.width / 60,
                                  ),
                                  Text(
                                    "Active",
                                    style: Theme.of(context)
                                        .textTheme
                                        .caption
                                        .copyWith(
                                          fontWeight: FontWeight.bold,
                                          color: yipliLogoOrange,
                                        ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        )
                      : null,
                ),
              ],
            );
          }),
        ),
        Consumer<UserModel>(builder: (context, user, child) {
          return _buildAnimatedContainer(false, context, user);
        })
      ],
    );
  }

  Future<void> makeDefaultMat(String currentMatId) async {
    print("Make Default Mat Pressed!");
    try {
      await Users.changeCurrentMat(currentMatId);
      //Utils.goToHomeScreen();
    } catch (error) {
      print(error);
      print('Error : Make Default Mat');
    }
  }

  Widget _buildSelectButton() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        FlatButton(
          focusColor: androidTVFocusColor,
          child: Text(
            'Activate',
            style: Theme.of(context).textTheme.subtitle1,
          ),
          onPressed: () {
            //Todo: Write to get matid from backend.
            Navigator.pop(context);
            YipliUtils.showNotification(
                context: context,
                msg: "${widget.matName} is default Mat.",
                type: SnackbarMessageTypes.SUCCESS);
            makeDefaultMat(widget.matId);
          },
        ),
      ],
    );
  }

  Widget _buildEditMatButton(BuildContext context) {
    return Column(
      children: <Widget>[
        FlatButton(
          focusColor: androidTVFocusColor,
          child: Text(
            'Edit',
            style: Theme.of(context).textTheme.subtitle1,
          ),
          onPressed: () {
            //@TODO AMEET: Edit mat nickname logic

            YipliUtils.inputDialogAsync(context, "Yipli", "Edit mat nickname",
                    "e.g. My Yipli Mat", "Save")
                .then((newNickName) {
              if (newNickName != null) {
                MatModel.updateMatNickName(widget.matId, newNickName).then((_) {
                  print("Setting state!");
                  YipliUtils.showNotification(
                      context: context,
                      msg: "Your mat has been updated!",
                      type: SnackbarMessageTypes.SUCCESS);
                  setState(() {
                    isOpen = !isOpen;
                  });
                });
              }
            });
          },
        ),
      ],
    );
  }

  Widget _buildDeleteButton(BuildContext context) {
    return Column(
      children: <Widget>[
        FlatButton(
          focusColor: androidTVFocusColor,
          child: Text(
            'Remove',
            style: Theme.of(context).textTheme.subtitle1,
          ),
          onPressed: () {
            print('remove mat - ${widget.matId}');
            //@TODO AMEET: Delete mat logic
            YipliUtils.asyncConfirmDialog(context,
                    'Are you sure?\n\nYou will need to add the mat again.')
                .then((confirmation) {
              if (confirmation == ConfirmAction.YES) {
                FirebaseDatabaseUtil()
                    .rootRef
                    .child(MatModel.getModelRef(widget.matId))
                    .remove()
                    .then((_) {
                  YipliUtils.showNotification(
                      context: context,
                      msg: "Your mat has been removed!",
                      type: SnackbarMessageTypes.INFO);
                });
              }
            });
          },
        ),
      ],
    );
  }

  Widget _buildAnimatedContainer(bool isSelected, BuildContext context, user) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: AnimatedSize(
        vsync: this,
        duration: const Duration(milliseconds: 120),
        child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.vertical(
                  bottom: Radius.circular(10), top: Radius.circular(10)),
              color: Theme.of(context).accentColor,
              boxShadow: [
                BoxShadow(
                  color: Colors.black12,
                  blurRadius: 2.0, // soften the shadow
                  spreadRadius: 1.0, //extend the shadow
                  offset: Offset(
                    0.0, // Move to right 10  horizontally
                    0.1, // Move to bottom 10 Vertically
                  ),
                )
              ],
            ),
            constraints: isOpen
                ? BoxConstraints(
                    maxHeight: 0.0,
                  )
                : BoxConstraints(
                    maxHeight: double.infinity,
                  ),
            child: (widget.matId != user.currentMatId)
                ? Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      _buildSelectButton(),
                      Container(
                        width: 1,
                        height: 20,
                        color: Theme.of(context).primaryColorLight,
                      ),
                      _buildEditMatButton(context),
                      // Container(
                      //   width: 1,
                      //   height: 20,
                      //   color: Theme.of(context).primaryColorLight,
                      // ),
                      // _buildDeleteButton(context)
                    ],
                  )
                : Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      _buildEditMatButton(context),
                      // Container(
                      //   width: 1,
                      //   height: 20,
                      //   color: Theme.of(context).primaryColorLight,
                      // ),
                      // _buildDeleteButton(context)
                    ],
                  )),
      ),
    );
  }
}
