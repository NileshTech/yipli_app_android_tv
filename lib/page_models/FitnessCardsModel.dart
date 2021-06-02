import 'package:flutter_app/database_models/adventure-gaming/fitness_cards.dart';
import 'package:flutter_app/page_models/page_model_index.dart';

class FitnessCardsModel extends ChangeNotifier {
  static String refName = "fitness_cards";
  static DatabaseReference getFitnessCardsDatabaseRefName() {
    return FirebaseDatabaseUtil().fitnessCardsRef;
  }

  List<FitnessCard> allFitnessCards;

  StreamTransformer fitnessCardsModelTransformer;

  FitnessCardsModel() {
    allFitnessCards = new List<FitnessCard>();
  }

  void handleFitnessCardsDataStreamTransform(
      Event event, EventSink<FitnessCardsModel> sink) {
    // print("Adding handler for stream transformation in faq model");
    FitnessCardsModel changedFitnessCardsModel =
        FitnessCardsModel.fromSnapshotValue(event.snapshot);
    sink.add(changedFitnessCardsModel);
  }

  void initialize() {
    print("Creating the stream transformer for FitnessCard model");
    fitnessCardsModelTransformer =
        StreamTransformer<Event, FitnessCardsModel>.fromHandlers(
            handleData: handleFitnessCardsDataStreamTransform);
    //print("Adding faq listener");
    FirebaseDatabaseUtil()
        .getModelStreamFromDbReference(
            getFitnessCardsDatabaseRefName(), fitnessCardsModelTransformer)
        .listen((changedData) {
      setChangedFitnessCardsData(changedData);
      notifyListeners();
      // print("Listeners notified in faq model!!");
    });
  }

  void setChangedFitnessCardsData(FitnessCardsModel changedFitnessCardsData) {
    allFitnessCards = changedFitnessCardsData.allFitnessCards;
  }

  FitnessCardsModel.fromSnapshotValue(DataSnapshot fitnessCardsSnapshot) {
    allFitnessCards = new List<FitnessCard>();
    List<dynamic> fetchedFitnessCardsMap = fitnessCardsSnapshot.value;
    if (fetchedFitnessCardsMap != null) {
      for (var fitnessCard in fetchedFitnessCardsMap.sublist(0)) {
        FitnessCard currentFitnessCard = new FitnessCard(fitnessCard['ImgUrl'],
            fitnessCard['MuscleGroup'], fitnessCard['CardName']);
        allFitnessCards.add(currentFitnessCard);
      }
    } else
      print('fitness cards list null');
  }
}
